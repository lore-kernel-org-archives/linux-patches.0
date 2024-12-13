Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5771B6D0C;
	Fri, 13 Dec 2024 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734095802; cv=none; b=Wc/U/3QVrYXgzYJFP9rAwxSCQ8tJArsAAKGnZMBvyUh0cCq8febF60n+bVpWWIb9kYPGnRAan3voGQO6bBqYjpuIynrDs5q5Llkz2C8P3d3+hrblm7bYYVPxe+SIPczy+kSn2Q+n3Ppe7ax+nQRJaM0CTfzpgh0fpDLAZ9r94Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734095802; c=relaxed/simple;
	bh=MAS2+ko6nWOc71+lCgdTPTI7JEo9EO/y5ORPLCyfNVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soVGI0u/yCHvgdDzDYY7MYLBb7kfqzNShNGWyxgwa8R49tWcMx8ILwrfZVyi0Bgpos2sTfKEn+NFQaMClMI7nosEPKVLGJyOMg96T4CNez4Z7uF65h+dcY4/VarNOsq3+ftQndSM0zv0BrCtRdE25mPecerdLTUjdCYefN+/PVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tH7JHCgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tH7JHCgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3D9C4CED0;
	Fri, 13 Dec 2024 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734095802;
	bh=MAS2+ko6nWOc71+lCgdTPTI7JEo9EO/y5ORPLCyfNVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tH7JHCgnJbPr/oRz2+4E7TeEYCDhd+6/piatIvkjj/QIMtNnIFP+tTYCZI/H6D2I8
	 p2uCwWiXp9wKKcoLLgrJ6u+waaWU5ZjF1uJY7TVhuBEzTlIGQtCPoaTuI4NByVyGpk
	 VzONYcBLS7pn2N6cnJP8fiNHRmElxPSJ+IvDpbssZWc8ZK62bZRIItPidAokS3caHQ
	 oqNndEC7/VOHwe6NZiI/jhIsUkWpuR8XFabWcEaODxAUvgS7Nf0i04pymQtCw7+vqG
	 Xm8ukGGdVjLyRidl55A0SXWeRpPtoXCmEhKoI0+UKAbP2JbSHO+Oe+jhhd/hV4ZWIZ
	 dbReRmud1WTHQ==
Date: Fri, 13 Dec 2024 13:16:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
Message-ID: <5009f1af-6adb-4866-9ab4-da22727ab102@sirena.org.uk>
References: <20241212144311.432886635@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vOmofaHEBnRAVzdI"
Content-Disposition: inline
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
X-Cookie: Not for human consumption.


--vOmofaHEBnRAVzdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2024 at 03:53:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--vOmofaHEBnRAVzdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdcM7MACgkQJNaLcl1U
h9D1XQf/f/yWXc3q5moPRhluiJw3RwnT0KHYQSQKnyI7VAiSPXlkrVWYlc03R+Jn
2YWcuIR+oG6OuxwZ7LxQcE5wscEoRQH67L2MEq8vBHcTPKNXXRBIIEJm2R2R9KVt
duLY9OFMrT4tlVscK5m+P0qTKX4U1p/fNA/VzQHsNNiqqBSY8yHnOR10UlpljN7u
iCVbdVXhjpUw9HuI2fwfE6Q93qGmM2McwtKP11EcEmgX8E/ifRZYq0NUQUWdqMXc
YOo9hdKG/302GmkNaMIgkDywl+LPxSIxNr2dvqRh54hj53plLuRcsAD5eFy4bNZm
Nof2bjWNuLpcdGlLkO97A8a4dkpO/Q==
=Lgc6
-----END PGP SIGNATURE-----

--vOmofaHEBnRAVzdI--
