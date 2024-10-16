Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD11FDF81
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 09:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729071202; cv=none; b=XEzg7PKQ9S+sNNH4opdG4ka2MP8tfeDSKWw0WVZeMMpIZ3cC47L3OksWpOfsgTeAnYxPIfebijUgGMsUHE7OM2PpO1xVFAfVojALKmpOGjx+3tyYSocHzf8VGs/O81BjCPXs96WTtuPZ1/53dwKoU1WQRYTZ0xtVPpTLRKCpbWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729071202; c=relaxed/simple;
	bh=TC2Xr1Dj8wZrxBTTuaPiRC9xkv4np/YM/jZU+C538bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUxMjY1tJODB4Ddt0wslXFq5SK937LypxHdeDQOi1damA1yaRusIPktS63Pn+UTn9K7ZwrfIDsUYA44Xl/cSWBMUhfJBS6DHhnQ6/hxNH3CrF5Co3Aas7c6f5BYn7dXoN5uEVERHCnYLj3Nfflzs1RU4yPDU/yJC4aoBoOe31MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AF1DE1C00A2; Wed, 16 Oct 2024 11:33:18 +0200 (CEST)
Date: Wed, 16 Oct 2024 11:33:18 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	chris.paterson2@renesas.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [PATCH 6.11 000/212] 6.11.4-rc2 review
Message-ID: <Zw+IXqfj5IA1KXj+@duo.ucw.cz>
References: <20241015112329.364617631@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tooKZzb11AbSRnMj"
Content-Disposition: inline
In-Reply-To: <20241015112329.364617631@linuxfoundation.org>


--tooKZzb11AbSRnMj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.11.4 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

What went wrong with the release announcement? It has patch appended at the=
 end.

https://lore.kernel.org/all/20241015112329.364617631@linuxfoundation.org/

According to our testing, it breaks boot on de0-nano-soc.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
497863060

Same problem with 6.6. Quoting from Chris Paterson:

# Interesting.
# The de0-nano-soc device seems to be working from a LAVA point of view, it=
's just
# the kernel that isn't loading.

# If you look at the job history [0] for one of the de0-nano-soc devices yo=
u can
# see that it's booting okay for various kernels, but not all of them.
# multi_v7_defconfig seemed to boot okay with 6.12.0-rc2_d3d155669 [1], but=
 not
# since 6.12.0-rc3_6485cf5ea [2].

# [0] https://lava.ciplatform.org/scheduler/device/de0-nano-soc-03?recent_s=
earch=3D&recent_length=3D100#recent_
# [1] https://lava.ciplatform.org/scheduler/job/1205245
# [2] https://lava.ciplatform.org/scheduler/job/1206169

Quick test showed that 5.10-cip kernel still works on that target, so
it seems to be real issue.

Best regards,
								Pavel

>=20
>=20
> From gregkh@linuxfoundation.org Tue Oct 15 13:23:29 2024
> Message-ID: <20241015112329.430115421@linuxfoundation.org>
> User-Agent: quilt/0.67
> Date: Tue, 15 Oct 2024 13:23:30 +0200
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> To: stable@vger.kernel.org
> Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux=
-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kerne=
l.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, j=
onathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@=
sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, b=
roonie@kernel.org,
>  Gabriel Krisman Bertazi <krisman@suse.de>
> X-stable: review
> X-Patchwork-Hint: ignore
> Subject: [PATCH 6.11 001/212] unicode: Dont special case ignorable code p=
oints
> MIME-Version: 1.0
>=20
> 6.11-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Gabriel Krisman Bertazi <krisman@suse.de>
>=20
> commit 5c26d2f1d3f5e4be3e196526bead29ecb139cf91 upstream.

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--tooKZzb11AbSRnMj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZw+IXgAKCRAw5/Bqldv6
8rQLAJ9fqRyreYw/IRsbBCXz6PS8nNGQnQCgiiBGce3hnS8LIgoBBcr+zFFT/FY=
=xuOl
-----END PGP SIGNATURE-----

--tooKZzb11AbSRnMj--
