Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC99B33507C;
	Wed, 18 Feb 2026 23:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771458139; cv=none; b=IJSqbFzrzS508BVJ1QXCsZpPVqHm8o4Ow1DaTNm8nFaOeLeV201tLhhYXpGWd3HdI+abKFjT9f1TGUbNjbZhPKv0mP3aGxZnrW86zFGLfB9VZrlE1t2U3WwgenqnDf5DHWLAOmVC9FknmyDwXLJU8Z9TJH8JpXlbIZm44yWb8f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771458139; c=relaxed/simple;
	bh=i9jKs2aAeKSMFBfW1T6QujLPx5Y6UqJmQV+ejEgbujY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRAzYx1QFeSebhkytdutvR1JDeIgYbHG0UZ0XlBOsqSCCUhtl/Zx7lCeRubUGUEnjLARugsGtBmPkKtu/k6uoK44HNjQDCMiVT953YyrDBCmAVHk4D8wh+0O5pi61LvuExHAJgf4ko93JzFixey9RczUcXrp2crDIljRrgAPXbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DU/wl53u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DU/wl53u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D2BC19421;
	Wed, 18 Feb 2026 23:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771458139;
	bh=i9jKs2aAeKSMFBfW1T6QujLPx5Y6UqJmQV+ejEgbujY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DU/wl53u7IyIxDll41yZbrcxGu7A+eAMxR0I3L348MWEGRoSWrluJWWlrIJ4nMhVK
	 XBDUiXwXFH0PMtSShZ6Dw45fGExTGmmAt44baU5OEOV1NCXDyqf7ZkzXt0W7GIUb5g
	 84/L8z1c11aBIk5bTHyXm/bYgW6wA5aS2839J54oshGsO4ZEz9WSoST/8kvJThHys2
	 cbmx5uaIwCsSD65yPQPLTcejILHEeJ2rDG1p9YtR6QJAL6DICQUyZpKsnNV7QbBjQX
	 4ywErnPUAjgEe0pWYQSmFbEaziDL9w7dXlkUP8qa6exfDORG0UBRIQhQsDMJfEOff/
	 25Guyxp72bSVQ==
Date: Wed, 18 Feb 2026 23:42:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
Message-ID: <14708717-74ab-45cb-b5fa-421ddc26272b@sirena.org.uk>
References: <20260217200006.470920131@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/3AZewUcWLgPmCfh"
Content-Disposition: inline
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
X-Cookie: Avoid contact with eyes.


--/3AZewUcWLgPmCfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 17, 2026 at 09:31:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--/3AZewUcWLgPmCfh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmWTlQACgkQJNaLcl1U
h9BsLwf/UGOBg+6fgkNs0Pc7oC32GkyjrBFf+5pk56E/vlo6HTjAC7pY8X4rkUuf
t/NRtWdCLFJtDbzHtD4LA/IJa4tpMt6v3IrWUUdbohYOHnd4otw9Qx8x2nN/+0xu
DBuoYHtUlpdRymG6rRkWOQwV+cG1QT05T4qf1v7cCGGTZX0x27BOe+9C9Gg3rgwS
rWChUgqBZlfJQtqaJdAH0oIlz2qTf8TOGZNF7/e/7iNqgKgBD02eUdk1WedaIVuX
FdVjKOOTysHFZrbWRm9fLnAofjwf7TgOreBBoj1LveN6lgiab2CXQ/mbiQC5euTM
TbX47QT+s3sCTsfzGQRYSC6fqhRtcQ==
=HsVB
-----END PGP SIGNATURE-----

--/3AZewUcWLgPmCfh--
