Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F362623C4E0;
	Tue, 13 May 2025 09:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129737; cv=none; b=GBOaZJGzUfzAoIExFbeOVUUq1PEQRV982TmOyfkTrtFi3TGqpNqjMi7zK5dtpRmu9JSbISDWJ7adPShO27n2YvIm7XL5J7sBQSCg3hlpaCVlYjBopTSbdAgUOYghsv5Snr3ss/GQBKGw848X1HnT/D8aOfb5woAa5NQRK4Wheec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129737; c=relaxed/simple;
	bh=uKwYnFuHz7TTvcxRA2Fcqy3gQzrtdstyxl3+kZeaQ+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWxSBXnJvBAeRvR3SjGzWpVrcz8pva2aD10l1IrqRIt3BcShnuuHf6zXLjBNScCjV3y1lVPaJFwgsYxROhFcA3MkHDTytG+uN+iTRz7pjPpVYsOCtbVqkmDIjgjWCunTm5ndqUZEOHFGuH00DA3MttdSu9FYeA0cq5uW33JOFhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YtyLN6eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtyLN6eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EBDC4CEEF;
	Tue, 13 May 2025 09:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747129736;
	bh=uKwYnFuHz7TTvcxRA2Fcqy3gQzrtdstyxl3+kZeaQ+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YtyLN6eoSjRcb4WRQiDx8FhIFGv8Ueblqwszk5bHIbduvEJMX/H9HsTD6lpKP6E8W
	 F+JnVLT6K4AcvjQ3w9vFH+JZHkSwGx/tNbt5L63cOc1j0xVKn781r0xY97mUwy8RaL
	 P/gFalMgcl3g+9WCyJzPr/fo2wLIlyaCCkffIg7UEncmSZe4XCv/9INL67AADc68N+
	 d6OAP2uggs+baDjQC/KBhYWski0J7xw6wFnMC1MN8FOd/HGiQ8Wm6N+HwWQ795ABtt
	 GnVR+cldpJ2uOh6rkREwUjJZsE4Hl1uL76ZwpRHK46ytCQnzEhE2O8/CtKk1JMgxH0
	 gnF4v1N33Vm5A==
Date: Tue, 13 May 2025 11:48:50 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/54] 5.15.183-rc1 review
Message-ID: <aCMVgh9S881so98S@finisterre.sirena.org.uk>
References: <20250512172015.643809034@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t8BDZHYXv9Q7SgfL"
Content-Disposition: inline
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
X-Cookie: Well begun is half done.


--t8BDZHYXv9Q7SgfL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 12, 2025 at 07:29:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.183 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--t8BDZHYXv9Q7SgfL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgjFYEACgkQJNaLcl1U
h9BHMAf8Cde+H1Dv5PUTEO7jJKG4AHRo4dOH4c3DRiyxocNVy/G7HJTdUXU+78o5
UmV6wupcOIwLesU+4JCw1J6c2zTuDXevw/Mr0iY1Gd2ojVhfbWFTedXI9ev/ISyh
FcwyrS8lfctI/6IL7GLhEqRcMV2nzVEhAe/qMP2b5uplODblmR/b5sENTw1wq7e4
PoKqRqPGh6zuzH5qPESNN1rFEbP8sCjsiQJHg6gQWhZGSA9VyNj4Md0hdWm4wxkt
xm4GDstIRklcFsNjEiQHds+LbJG6CvuC5nODiBV+YgBkrgf9+xxdNxaP334CIBbI
rlVK+oloQ7gLhMTVoQ5l5OB2hzbfcA==
=ckCS
-----END PGP SIGNATURE-----

--t8BDZHYXv9Q7SgfL--
