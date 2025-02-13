Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6AD2753F0;
	Thu, 13 Feb 2025 23:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739491152; cv=none; b=fupahHpPsCoHB0v1yZR9JNjs8SMk2j5eVFocFca6lPQRTCqX5cBXc+IXnxZ+2EIRgnQmnYhlwuNMKGko+3E25Gn1EeCKnzkmOIWY20T2O/LPN8vLCfpCppq+Enn6MsUOR+kgsjKkEDAA3rjrx8Hx9Xicbl2pm8wdmqyZ+oVmIxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739491152; c=relaxed/simple;
	bh=sUHVA2nY8+ITLRoi+MguHXHoe82ZwGPnIQhZwZxKM8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fc0U0XilcTq3Mbss5k/TQ9fJ7hrP4tRXz+LQUaU/BsteL/YZONCIHFzIGywp5TufbHFDqcAv0WcWBV/ToJPu38neM2l+6nRd6gglu5vgtWrcEfSjN3uAeAEc21tfJ8Nz9dgvkB51pXUkORjhLEWstbze2WI1SfsawL7LbFWV8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDYl/EER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDYl/EER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A136C4CED1;
	Thu, 13 Feb 2025 23:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739491152;
	bh=sUHVA2nY8+ITLRoi+MguHXHoe82ZwGPnIQhZwZxKM8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WDYl/EER6cu3XMN4SMIwU9scPhoCL0HmwRAw5gJjOBgTbAQCtVZHw+umr8q65Duks
	 HXTPcb4K5KohXtK7W4TSoqw0BAEaBBUGL7PSxQ/tWI+L184VKViuZ2+I9J6XJ5OWc+
	 0TX5YLmi7d1tz3V8r/pVkJvsxE+Vj/Xi1OdHkCaU+Jme2IDWjqcENWKG76KcnBW4IN
	 mLjGMvxCQeV4kZCtiERXTss/lQU3dLT5ainvdCUEmBWEk6MRsajWc6gCjENzF/63w0
	 +QtWQKFSqhH6m48SEpw5qKOBPxsNom8osrnlzgh0Jb6eby8zFpGGyLhOxs+7UKgK/v
	 6uNAWmgQaCGOg==
Date: Thu, 13 Feb 2025 23:59:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
Message-ID: <350fa7e1-6dea-4291-b8c5-d894bb2e38c1@sirena.org.uk>
References: <20250213142440.609878115@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="apwGAp47mVAPB5+a"
Content-Disposition: inline
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
X-Cookie: Take it easy, we're in a hurry.


--apwGAp47mVAPB5+a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2025 at 03:22:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--apwGAp47mVAPB5+a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeuh0kACgkQJNaLcl1U
h9BKCgf/RhI1+B9R6dvEx3euy6bE/y7SAfcxzTsoyZchHyhaUF86Mrg2M9AEQn5s
+vBDlg7OLilfHaxDIB4VoWkXR8sOCwRHgW9Qj9BdHI3KFyx4hncKJ+9SEA3ofIeI
uiQK1BiwAVod7Iym2fFdg4zdidj+333TwtLivpZ62DouJuiw1loND9GnyuBYBfOc
r++N0xDFf18fBDJ6RFrH1RkThDVWlSPPiTOR19oJqeZQC4bWU2WUd4LSbdI+1eGY
P1sltud19TsYzzxhf4kxPh9CeILJie/dORT2+WdjxzcD/6hcpaZH0Y00jSd/NR9o
Xl1EW5EBnJFrZtIrqgyql91cOPKD+g==
=HeoF
-----END PGP SIGNATURE-----

--apwGAp47mVAPB5+a--
