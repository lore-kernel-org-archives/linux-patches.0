Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0A18E1F;
	Sat, 17 Jan 2026 12:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768652922; cv=none; b=uoGaBSYdEQfcHdMZ5aKFhGB2dcbzcSS+L9piSBL341TFaKbTlyo4Cvx4fh4RncYJqrdLZRmdoQaoWrb4fiN4pa9/3BjuejmIwAn097Wc/PjkH0usJnIdY0rGDsdvnR1IqPA4rb7DWpwFlWQiO5G9Ty2AtbyYDDLQOHzRR/EPyw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768652922; c=relaxed/simple;
	bh=PCh1UWNiFTG4DnKb//t91d869ClclbU05mKBDJnL+zU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oOYvX65VL4j2Hi3lrX9EUg+fi2sRC79gbaQPvG8+4EsNtPN9XgS9TDwbkj9ZVp8Z+0Ju/Al6TnydSnGoj7M2gDkz2fqP53gl6upVPdUzCf3Uii5aM9T8mDGd3rPgXYFFinTv0tmcDqrqpWjFJHd5NBCAxwTx9o6Ulefg9rLxF2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh5Pz-000yUc-0O;
	Sat, 17 Jan 2026 12:28:37 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh5Pw-00000000epg-2Kdi;
	Sat, 17 Jan 2026 13:28:36 +0100
Message-ID: <fd91b4ae9640cfaf47fa96b97c58f410245c5358.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 048/451] i3c: remove i2c board info from
 i2c_dev_desc
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alexandre Belloni
 <alexandre.belloni@bootlin.com>,  Jamie Iles <quic_jiles@quicinc.com>,
 Sasha Levin <sashal@kernel.org>
Date: Sat, 17 Jan 2026 13:28:31 +0100
In-Reply-To: <20260115164232.636822339@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164232.636822339@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iV6NcxMaKwMo+LBsEPgx"
User-Agent: Evolution 3.56.2-8 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-iV6NcxMaKwMo+LBsEPgx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:44 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jamie Iles <quic_jiles@quicinc.com>
>=20
> [ Upstream commit 31b9887c7258ca47d9c665a80f19f006c86756b1 ]
>=20
> I2C board info is only required during adapter setup so there is no
> requirement to keeping a pointer to it once running.  To support dynamic
> device addition we can't rely on board info - user-space creation
> through sysfs won't have a boardinfo.
>=20
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Link: https://lore.kernel.org/r/20220117174816.1963463-2-quic_jiles@quici=
nc.com
> Stable-dep-of: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_mast=
er_register")
[...]

Commit 9d4f219807d5 is a legitimate fix, but it does *not* depend on any
of these other i3c changes.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-iV6NcxMaKwMo+LBsEPgx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlrgG8ACgkQ57/I7JWG
EQnKXg//WCkVPhU7h6G97XdLUUXSaZrnZyd0cqOKFAfa2o7KXP2Re9RggwvJyL9z
Tl8eSib23GyBT8xhz0ORf8N6S+LomNvN6D2MwN7BqeXmubWIs22O/zX5QI8SaCLg
KYH2cD1ftcbEp8tXdidbouYoolSzy30rgKqPih9NOlN8QTZXr+dIBurtLY7ernzG
LeLC/Cw7phNY2SM3jlbmmv55CxOjMnhjjuUgTeiMATwiWqApYBcQRVsxq8jwxJv2
9AwfPSxXcVQSGb9fISpl6E133ni2yjKJA9LfPhIIJ7DXvbO4YjfLFADROsDzM8uV
LDmK6JnTiqAXO1ODngueCaKc73EnwBTC7V5w63HrGmhKErpb5IRJpWWoF1aRgxp/
keB7y4m1LxpA2x2ateP/Z4FiTUzcex2yG0DuuqkwAm8ZWqswhSwZ/JfdVy4hxt8K
QcckH/f3lS6486abfd8VvhZXuYwIPqnXJdmGIHvcaNUedehDeRfH+DLxWAsj1g4n
Y8+MDEWLbrI/hLhczJRVIJU4zq6uDHL/0WmWmwx8of7PM+bLywstbwO5gX39lCCo
68xci8DsYD2CVHB95YyUDoM3l+0xCSEiZdD9/Lb1dLfLLDTZWa/vbmrGQTU12C2h
9uKhiIIpGcaDIFFvFPIhtei3mujvtzjaZ1zh5aNB8YuSYQgfLBY=
=GUVi
-----END PGP SIGNATURE-----

--=-iV6NcxMaKwMo+LBsEPgx--
