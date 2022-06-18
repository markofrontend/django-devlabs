# SQL

Date su sledeće relacione šeme:

- **Grad** (Naziv, Drzava, BrojStanovnika)
- **Bioskop** (BID, Ime, Naziv references Grad)
- **Sala** (Broj, BID references Bioskop, Kapacitet)
- **Film** (FID, Naslov, Trajanje)
- **Projekcija** (PID, FID references Film, Broj references Sala, BID references Sala,
BrojGledalaca)

> **Napomena.** Primarni ključevi su podvučeni. Atribut Naziv u relacionoj šemi Bioskop je spoljnji
ključ na relacionu šemu Grad i označava u kom gradu se nalazi bioskopo. Atribut BID u
relacionoj šemi Sala je spoljnji ključ na relacionu šemu Bioskop i označava u kom bioskopu
se sala nalazi. U relacionoj šemi Projekcija, atribut FID je spoljnji ključ na relacionu šemu Film
i označava koji film je prikazan u toku te projekcije, dok atributi Broj i BID u istoj šemi kao u
paru predstavljaju spoljni ključ na relaciju Sala i označavaju u kojoj sali je održana projekcija.

---

## 1. zadatak
- [x] a) Izlistati naslove filmova, zajedno sa brojem različitih gradova u kojima su projektovani,
pod uslovom da je taj broj veći od 5.

```
SELECT f.naslov, COUNT(DISTINCT b.naziv) br_prikaza_vecih_5_u_razlicitim_gradovima
FROM film f
LEFT JOIN projekcija p ON f.fid = p.fid
LEFT JOIN sala s ON (p.broj, p.bid) = (s.broj, s.bid)
LEFT JOIN bioskop b ON s.bid = b.bid
GROUP BY naslov
HAVING COUNT(DISTINCT b.naziv) > 5;
```

- [x] b) Naći film koji je imao najveći broj projekcija.
```
SELECT f.naslov
FROM film f
LEFT JOIN projekcija p ON f.fid = p.fid
GROUP BY f.fid
HAVING COUNT(p.fid) = (
	SELECT MAX(br_projekcija)
	FROM (
		SELECT COUNT(p.fid) br_projekcija
		FROM projekcija p
		RIGHT JOIN film f ON p.fid = f.fid
		GROUP BY f.fid
	) t
);
```

- [x] c) Naći filmove koji su projektovani u svakom bioskopu.
```
SELECT f.naslov 
FROM film f
WHERE NOT EXISTS (
	SELECT * FROM bioskop b
	LEFT JOIN
	(
		SELECT DISTINCT(p.bid)
		FROM projekcija p
		WHERE p.fid = f.fid 
	) t ON b.bid = t.bid
	WHERE t.bid IS NULL
);
```

- [ ] d) Izlistati parove filmova koji su projektovani u istim salama.
```
```

- [x] e) Naći gradove u kojima se prikazivao film koji je do sada imao najveći broj projekcija.
```
SELECT DISTINCT(g.naziv)
FROM film f
JOIN projekcija p ON f.fid = p.fid
JOIN sala s ON (p.broj, p.bid) = (s.broj, s.bid)
JOIN bioskop b ON s.bid = b.bid
JOIN grad g ON b.naziv = g.naziv
WHERE f.fid IN (
	SELECT f.fid
	FROM film f
	LEFT JOIN projekcija p ON f.fid = p.fid
	GROUP BY f.fid
	HAVING COUNT(p.fid) = (
		SELECT MAX(br_projekcija)
		FROM (
			SELECT COUNT(p.fid) br_projekcija
			FROM projekcija p
			RIGHT JOIN film f ON p.fid = f.fid
			GROUP BY f.fid
		) t
	)
);
```

- [x] f) Naći parove FID, BID tako da je film sa ključem FID bar 3 puta prikazan u bioskopu sa ključem BID.
```
SELECT DISTINCT p1.fid, p1.bid
FROM projekcija p1
WHERE EXISTS (
	SELECT COUNT(*)
	FROM projekcija p2
	WHERE (p1.fid, p1.bid) = (p2.fid, p2.bid)
	HAVING COUNT(*) >= 3
);
```

- [x] g) Naći grad u kom je održana najposjećenija projekcija nekog filma.
```
SELECT g.naziv
FROM projekcija p
JOIN sala s ON (p.broj, p.bid) = (s.broj, s.bid)
JOIN bioskop b ON s.bid = b.bid
JOIN grad g ON b.naziv = g.naziv
WHERE p.broj_gledalaca = (
	SELECT MAX(p.broj_gledalaca) 
	FROM projekcija p
);
```

- [x] h) Naći film koji je u svakoj sali projektovan bar 2 puta.
```
SELECT f.naslov
FROM film f
WHERE NOT EXISTS (
	SELECT *
	FROM (
		SELECT DISTINCT p.fid, p.broj, p.bid
		FROM projekcija p
		WHERE p.fid = f.fid
		GROUP BY p.fid, p.broj, p.bid
		HAVING COUNT(p.fid) >= 2
	) t
	RIGHT JOIN sala s ON (t.broj, t.bid) = (s.broj, s.bid)
	WHERE t.fid IS NULL
);
```

- [ ] i) Naći gradove u kojima su prikazani svi filmovi.
```
```

- [x] j) Odrediti u kom bioskopu se nalazi najposjećenija sala. Napomena: najposjećenija sala je ona u kojoj je bio najveći broj gledalaca, gledano ukupno po svim projekcijama u njoj.
```
SELECT b.bid, b.ime
FROM projekcija p
JOIN sala s ON (p.broj, p.bid) = (s.broj, s.bid)
JOIN bioskop b ON s.bid = b.bid
GROUP BY p.broj, p.bid
HAVING SUM(p.broj_gledalaca) = (
	SELECT MAX(posjecenost_sale)
	FROM (
		SELECT SUM(p.broj_gledalaca) posjecenost_sale
		FROM projekcija p
		GROUP BY p.broj, p.bid
	) t
);
```


## 2. zadatak
- [x] a) Naći sale koje imaju kapacitet veći od 50 mjesta.
```
SELECT * FROM sala s WHERE kapacitet > 50;
```

- [x] b) Naći najveću salu.
```
SELECT *
FROM sala
WHERE kapacitet = (SELECT MAX(kapacitet) FROM sala);
```

- [x] c) Naći bioskope koji imaju više od jedne sale.
```
SELECT *
FROM bioskop b
WHERE bid IN (
	SELECT bid
	FROM sala s
	GROUP BY bid
	HAVING COUNT(bid) > 1
);
```

- [x] d) Naći bioskope u kojima je svaka projekcija imala više od 50 gledalaca.
```
SELECT *
FROM bioskop b
WHERE NOT EXISTS (
	SELECT *
	FROM projekcija p
	WHERE p.bid = b.bid AND p.broj_gledalaca <= 50
);
```

- [x] e) Naći film koji je makar jednom projektovan u svakom bioskopu.
```
SELECT *
FROM film f
WHERE NOT EXISTS (
	SELECT *
	FROM (
		SELECT p.fid, p.bid
		FROM projekcija p
		WHERE p.fid = f.fid
		GROUP BY p.bid
		HAVING COUNT(p.bid) >= 1
	) t
	RIGHT JOIN bioskop b ON t.bid = b.bid
	WHERE t.bid IS NULL
);
```
