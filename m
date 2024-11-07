Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F6321263B;
	Thu,  7 Nov 2024 13:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730986117; cv=none; b=RVDbt3BFtSuUApPANpJ/vDx1orRj95aDC/N20ro9HL5GLKoEGKL1YvDMcV8GtmPYNx39JW+0MmPNNklAGBhH8DQyC457yzdflUCr3ERzMShX9jLmppIIrw8O1zy/lPAg1DHhN7lXUREACAB5oGd5TOXYgQ28P31bg6k9oCzdiko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730986117; c=relaxed/simple;
	bh=2RAOkOtx/XBod3JHE2lakxJkE+9T16g9xaMC6BRX4co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAm2Rv7WjwQ+ZzFJZOTOXXa/j02V9ADaS2O/XQdvFk1lqR6IVuZotrUdTndLnNhf1mEmF9pLwnFgV+DEHeKwHMnuz54snPDbl8f6jeldnTgYkym5FzZhG6VRloUzQxaqKL69zdIBaQhn3yAMFcbpx1M19xl7CjPYwE5yZZxUFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mY0nfKNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mY0nfKNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23E9C4CECC;
	Thu,  7 Nov 2024 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730986117;
	bh=2RAOkOtx/XBod3JHE2lakxJkE+9T16g9xaMC6BRX4co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mY0nfKNymB/WReNI2oBhlEzK7AoxSEYZfc2NYMj+HWKA2a+2FQCpKi98Pr1H5tzYS
	 vDHNZO482Y822JtaEafGVaJwKpriEVD+tNa63IMEGH9ZymM2s2qzRWsZOvRW00xw0d
	 z4ZsD9VzhqphDiSGyqGaCHX3bhSpJ+UctmtZMhnd49m6L2CGMM9FstJJFJGvecvJ9O
	 N1bITDe9mho5EWrFkmSClYRBOilyyAlBKPHT6cqY0SiG9r5blnL6HkgxlNuOioG/Gn
	 iBudpSHeaUiICKPUAysfAc3owi8EkCuROXqgj7xGg69InjJv9g6k0SsUoJlv/Ix8Qg
	 yV8mt6BaTRVrw==
Date: Thu, 7 Nov 2024 13:28:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hagar@microsoft.com, chris.paterson2@renesas.com
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
Message-ID: <7a791358-63ff-41e1-b7f0-e687df21047b@sirena.org.uk>
References: <20241107064547.006019150@linuxfoundation.org>
 <Zyy4mfTry2gNQBH+@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sfWKd7weCYNoidnb"
Content-Disposition: inline
In-Reply-To: <Zyy4mfTry2gNQBH+@duo.ucw.cz>
X-Cookie: Professional driver on closed track.


--sfWKd7weCYNoidnb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2024 at 01:54:49PM +0100, Pavel Machek wrote:
> Hi!
>=20
> > This is the start of the stable review cycle for the 6.11.7 release.
> > There are 249 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> CIP testing has problem with BeagleBone Black on 6.11:
>=20
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linu=
x-6.11.y

My Beaglebone Black jobs ran fairly happily, eg:

   https://lava.sirena.org.uk/scheduler/job/951530

Looking at your logs:

   https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/829=
5477303

you seem to be seeing an infrastructure issue:

* lava.pdu-reboot [pass]
* lava.bootloader-commands [fail]
* lava.uboot-commands [fail]
* lava.uboot-action [fail]
* lava.power-off [pass]
* lava.job [fail]

The job is failing in the bootloader:

   https://lava.ciplatform.org/scheduler/job/1218595

shows:

| =3D> bootz 0x82000000 - 0x88000000
| zimage: Bad magic!

I didn't check but this almost always indicates that the download to the
board was corrupted due to some image size having grown large enough to
overwrite the adjacent image, you'll need to adjust the load addresses.

--sfWKd7weCYNoidnb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcswH4ACgkQJNaLcl1U
h9BTXgf/Qp1HWuz+6JhL02Q+Qyah6EQftFxlkp0Pkpf2JGMlXKeMLOK/HbkilDo+
diu7v2Y3TUrI35cxUQt19AgvrXkJn/Qz+RvoFmozjlONamTnYD47c/thpvr8BYV9
OqnfKDUQGazNYLEl7M0q3E1yAlpzw2qZhzjdDmpoI0gtk11p/RkK5r44sCG5RhJE
M0ikqZE4MRwFZTLLTIyssLmMl7zUUpYF3IMUGODUz/hAh8DFhesSN+JpcG2+2vv9
2qwKXjKazKhgTfOgdVx8LA8b5LrqZpXbhQK7H/iroBhTKw3N7FU84hepU2IFyvX4
LaxHUWKQoP9gp211zOKBP1RgBnK8vw==
=bZFp
-----END PGP SIGNATURE-----

--sfWKd7weCYNoidnb--
