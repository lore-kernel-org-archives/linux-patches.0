Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80177212164
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730989696; cv=none; b=AVAvIJ/HhUjNGASceHwDd0zfWVmjm9KTUU36eqJ1DMel6US1l9j8fZc34DgJffd5W2r1kwtDRgOUGc4ZAHiOg8UcaFL4fEgEld8pg6ZYGh9FZ6ImPhO362LZwQBzXfaxQDR0Qqz09I3+fhwOKQFYqyC2y7Z05eYE4IbRbeaaQaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730989696; c=relaxed/simple;
	bh=F010ownv3bBnqIQ8ilTKry8FD6vEzGw6XQJgHJD1qU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngZFHtWvrqh1vucRAskDMf4tD2g43Cq+SJ5g5uJROxxU/tCGsoGiqAUM8GOqCLnTAW2jYRqgX+T7F1RQeyrQEOUu0kMLB2E8eaoJvhJtU3Jf9ZEBOAL3b8lFub0CZWw6RmvJcIgJum/SgIE/3+nlW1mKnEN94Q3n3Yy+eSJeDvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 89CDC1C00A0; Thu,  7 Nov 2024 15:28:12 +0100 (CET)
Date: Thu, 7 Nov 2024 15:28:12 +0100
From: Pavel Machek <pavel@denx.de>
To: Mark Brown <broonie@kernel.org>
Cc: Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, chris.paterson2@renesas.com
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
Message-ID: <ZyzOfIPHTEjq5W1+@duo.ucw.cz>
References: <20241107064547.006019150@linuxfoundation.org>
 <Zyy4mfTry2gNQBH+@duo.ucw.cz>
 <7a791358-63ff-41e1-b7f0-e687df21047b@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hYyuC9AgkQKiubg2"
Content-Disposition: inline
In-Reply-To: <7a791358-63ff-41e1-b7f0-e687df21047b@sirena.org.uk>


--hYyuC9AgkQKiubg2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 6.11.7 release.
> > > There are 249 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > CIP testing has problem with BeagleBone Black on 6.11:
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/li=
nux-6.11.y
>=20
> My Beaglebone Black jobs ran fairly happily, eg:
>=20
>    https://lava.sirena.org.uk/scheduler/job/951530
>=20
> Looking at your logs:
>=20
>    https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/8=
295477303
>=20
> you seem to be seeing an infrastructure issue:
>=20
> * lava.pdu-reboot [pass]
> * lava.bootloader-commands [fail]
> * lava.uboot-commands [fail]
> * lava.uboot-action [fail]
> * lava.power-off [pass]
> * lava.job [fail]
>=20
> The job is failing in the bootloader:
>=20
>    https://lava.ciplatform.org/scheduler/job/1218595
>=20
> shows:
>=20
> | =3D> bootz 0x82000000 - 0x88000000
> | zimage: Bad magic!
>=20
> I didn't check but this almost always indicates that the download to the
> board was corrupted due to some image size having grown large enough to
> overwrite the adjacent image, you'll need to adjust the load addresses.

Yep, thanks, it does not seem to be kernel issue. People from our Q&A
team are investigating.

Best regards,
								Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--hYyuC9AgkQKiubg2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyzOfAAKCRAw5/Bqldv6
8gR9AJ0cLQIcPjjUH2FMKyyHT0t1aa95WgCeI0Cvrur4op9pQlGunOhuhRZLt8E=
=E2Fh
-----END PGP SIGNATURE-----

--hYyuC9AgkQKiubg2--
