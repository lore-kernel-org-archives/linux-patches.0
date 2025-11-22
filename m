Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE5121FF35
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763801498; cv=none; b=cNN/s0CHjjxfYiQdzwV/fpa7KQ7iguiZowSIFQvP6PWIDgLHbzu9NqgPkG7AzL8yY9EJeojBCKNI6FklnWFQdIAc9GBKQznRkdlcZUSNaBzAxoSRilan0fLywjCCowNzp2iDfAxC1WyrpudY+wIgWi7tjX+sow2ZyPURk++37gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763801498; c=relaxed/simple;
	bh=X8+JR7O5KXx8fLy47r0+hlC+cJiz5P16mOHBuY4LyM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJtUOiQxu4lJZ7ko0tds30poYSbOeBU+XKrPql5wGv80p6xLJP5YfW0Bp2LIGXH8k/Jc87xDLmVPjrmblP1lfZ04Oqb7LmBbx5NL4ASS1lCbJB+FufSqNveHVpYD4Y+fLNq1tPQgA6LHEIhqDSFQ9fBV1yRcuUL3qXXcMzInDuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=d6Tzomv8; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="d6Tzomv8"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AF77B1007D768;
	Sat, 22 Nov 2025 09:51:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1763801481; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=9WJ2lpUdvAmwb2FICTgAUQQPGJQLW/ttnQSWgGHJTFo=;
	b=d6Tzomv8xRKI1IrCuebDmXuNhPQ7doIJ6CUNzlSCVxKx5DdAEnAxH/a8zt13HMdPcwTKT7
	9GED4TgIPDbG7ZGoJxMzL/b/ElGz7jNbRGQRhhsjYjEjh2bj//xRmr/i/v+Vej9iNHs7t0
	qtsuwZQ1xFA8S1AUKndS5FzPlI/Bk63CdJOUG4FpNHxbX6E4pzUom21e3yuUdzyUO2ALvl
	T+nyJolWkQAtse568vj273/Q14Xt6g5OLbD6phsyZcQZNOSVLwXuPLk3kIaBIBA9/F7Drl
	PnS1f2fGy6vF7ZsGIjzbgay+xdKYcop+EbjcirCe3LhUIvUGm1K7Lt+Cmpot5Q==
Date: Sat, 22 Nov 2025 09:51:14 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
Message-ID: <aSF5gt4RNLG29eWn@duo.ucw.cz>
References: <20251121130143.857798067@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gsp4cJv8LWfzt6IK"
Content-Disposition: inline
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Gsp4cJv8LWfzt6IK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Gsp4cJv8LWfzt6IK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaSF5ggAKCRAw5/Bqldv6
8hyPAJ9AfA4J+7a4lpfBPwUseGudj8l+9wCggG2gnbZ1aoD1/OLadQZFfPVUDrY=
=MCOz
-----END PGP SIGNATURE-----

--Gsp4cJv8LWfzt6IK--
