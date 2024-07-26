Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D2C17B410;
	Fri, 26 Jul 2024 11:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721993840; cv=none; b=gI6w1MNNtQtstVudFF/htaVPsFeGaihPNJEkzn5B7+AXKOGYy+LT6/y7aEo633kQgI1MmFyyWm1RXA2EDfvcYg8sSAR6tH6DyQ0W4etmMkkNK1MponMccoChHz3zMRYeKIyh8ZQBYUFUULL8pWokGmnmvlqrkhj59OY7pmV/tb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721993840; c=relaxed/simple;
	bh=AFQUatNogF7II+eKqo/M4jNHA3WUHMx9h8lDDCGgEkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i69gGA62tbZev2IBx/j+h1KA34vMreNS+eZNNeNh5rx57rnaTcfE5GAfY1QPXafvk9WdBZUoFMnj6TYYF3p8UG4Xhp4NzuqxhvRhdyupU1fzgCQQINkfW7X5PLdztfYGx1RHO3xK28IzElmQJiyEgFRW7Xs5VtXQiVtZgzVfGMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlSE47yQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlSE47yQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7A3C4AF09;
	Fri, 26 Jul 2024 11:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721993839;
	bh=AFQUatNogF7II+eKqo/M4jNHA3WUHMx9h8lDDCGgEkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KlSE47yQYKYazcVjP2HO2HhvZOQ9J6Op/LBVrdpB5+pk/0JXCKUHfRmpord+8puTM
	 00WwfNNzNfY0ht+eaXPSm4+vv1sYDIZQVoVVTTFHy+1cuhKHxu/vP+O3PIuMDJKBef
	 pyCBGZoryq/StvntruH+v6JlHtNFCWk6Rf7VuIpADO29AZQA2VKKj/WjrE4EM+bjlC
	 FJItbKTFZYl3DTtMRNQaDYQDKhXPvt0CIikTfyiIfNyRavy+BhT0q6pHayew+q/QVM
	 btcpEofayrUjhIKZRlj0tLLdqMFOgS+Bq3FYs5LvG++ap4KMVLj1EijNHRoCNR9qrb
	 t5X1/LEKkD8YQ==
Date: Fri, 26 Jul 2024 12:37:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
Message-ID: <6447e2c4-931e-454f-8d22-857f61342746@sirena.org.uk>
References: <20240725142731.678993846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GpwBAc0YB30yqoiu"
Content-Disposition: inline
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
X-Cookie: It is your destiny.


--GpwBAc0YB30yqoiu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2024 at 04:37:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--GpwBAc0YB30yqoiu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmajimgACgkQJNaLcl1U
h9CvTAgAg9E/LOpHI5npFIh/fL94p+YgzdBbVygCmbZ8zyWKFf3C/mR7pq/r1/g1
aewoF3TyxQiUegCIslkVguij5fR4LkF/PN9ss7lt0CS2ydSrji0wLJABB2UaObZ5
W4liI2/vWGtSc9L8gRkRsTBuPk5Jt7TWjPcAU+MKikRMsZvRX1PRb+p2/h31oGzY
BStPzt3/twQl4GrcZnUpHjdQoLhmFS+WHGGodNGxLwEBBOo86gvD0l5UYU8CQjLH
9P8VWFf/UBWTO1wOOWPeep1JfoeUK5t/ZJyro+6oDKUbFXWFro+sX8eQ52/tN95o
iYRCYo3cycAYqiGv/nzE9jbcC5QBPw==
=XesE
-----END PGP SIGNATURE-----

--GpwBAc0YB30yqoiu--
