Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3291534EC;
	Wed, 18 Dec 2024 12:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734525161; cv=none; b=N3TMmIrO6LmcrC1Ll1ghJzZR53ulefmJnOMnsG+2RGuG6hTTwRqlLaOH+tZvPtJ/yqer94wG3PwNrNz5ZYOJJr2vgh+AawtgRP+mESKp5Iy+rbUeF7M/P4QFUsS1WTDEp81thBpeyqdHHKEciAUDr5bGJzoyAEy9IJsWvXB8kF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734525161; c=relaxed/simple;
	bh=nlLcpVnsMzknOGs4ZcZgwyPLFz/EkTpBOPhtgOXOooM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktXcJC70PFRyhwOnmuzjuNdlGlACtYubQizvBzCVlTz5/OjABcUMLwFu6o23J70Tf8Dyx8yyLEEWBQmKNbfqpbENLgdltCfUjiggOQR/tjJQyOiwssey3BNtzGsW//FCGACgBnaXOI8KpETDVrrlQ7lkWBbf0FILvWrmuJep6tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLOhb3kc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLOhb3kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C92C4CECE;
	Wed, 18 Dec 2024 12:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734525160;
	bh=nlLcpVnsMzknOGs4ZcZgwyPLFz/EkTpBOPhtgOXOooM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iLOhb3kc6qy9c8QOb28Jd5t9xQIRIwIHuKnZhtklah3U5+RXQjxOKTGjk1rXRkPcU
	 635nKTU7QPNSJVXRDQ61FgymOtpIKoRXDz0sdFIDZdjXmFeXYuyqNfjKlC4nsIEg4I
	 TXnhbs4iieT64cLkxNKWEyNp+w4x9XaFZy9duhuRwl6TTtA+rqazMI/pJTI5ez4Qb8
	 hd3+yLqJjdssZc9mzU9+Z/WnRJ5Aw3gnpvCxt9WCf/qgwImJYB26Dr/b0LwEFkHjk7
	 Ypsb4EJrcJYqQKCZLfZUk9COFBX65urvPPRo0mDabILCAKR9u9U5ZI0kSfI5IUW5HC
	 Gpmu0eGkhGruA==
Date: Wed, 18 Dec 2024 12:32:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
Message-ID: <a8af5a3e-eb05-427a-b827-a4ee2a6c4e46@sirena.org.uk>
References: <20241217170546.209657098@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Bz6qmUltEC3slryo"
Content-Disposition: inline
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
X-Cookie: The heart is wiser than the intellect.


--Bz6qmUltEC3slryo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2024 at 06:05:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Bz6qmUltEC3slryo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdiwOEACgkQJNaLcl1U
h9Bd4Af/Qv7L7/SjenIgMWnRU3tqcfg+xKmb8o7AtZjRBZhLofx+a5DZXTz7Sr0g
eOSkH/7hYB2/3i4weH4eK4rCfiHJzT75gtWVCrV1a0a4qu5OShViOAEi1gh97jXj
6ZML/JtlIYSve/6QkySt93ssCGZWdZGaYkQXVMbTnAGmn5T+ejrCzvt1uv5fSPOs
qEZ9058slUE8a/R+8u8O+4Nrba48ptdjzNJPIgVDbmMz8FFw7j+Lb0OHD7yZCoq1
KdGOa0doJTVottvvDDpgYu1ezIFc6404sqeHoQYOrHGb+1Fn4uQyDmvd2lK6i5Uk
FYoFa7TedgoQL7JPe1/q++F0tPdF+g==
=RHYz
-----END PGP SIGNATURE-----

--Bz6qmUltEC3slryo--
