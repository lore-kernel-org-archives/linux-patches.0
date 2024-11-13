Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7ED1E048F;
	Wed, 13 Nov 2024 13:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504486; cv=none; b=Ofj7+JdXp7jrppIwKhYx78+U1Mpup7ZPkZu5MbhKZA2F+dB/Xy2A686U3UwzS40WalQhK7AwPidxWyUzI2c3uHxPGyQtB5d7N0GWhF8H+ioi3ccghVidobMZxk2WhzF6V2/CR5zXKICNiisjQmpMN5nJEE2ZzQDcseL9oS2eCsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504486; c=relaxed/simple;
	bh=elX+ZHmOcEeivade5jXD1KIVyZS9cWV5j7qwFXSgjzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnqcnP0rB8c5XtcfGC4a4ZOUIvmU0GJB9UL359a8Z117ciK1JyCMZts9cwygJCPKdJ+Ek0bnaeuYk3FIWRRlhMgjE45a/e/g58Ip7MTR5vgp2H9nhKFoPc6WzGWGBQRtgctHidd5B8Z+dXkQqJc/lqc1DChjXsuNv7+jaLcO9aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lV/FIheQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lV/FIheQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D2AC4CECD;
	Wed, 13 Nov 2024 13:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731504485;
	bh=elX+ZHmOcEeivade5jXD1KIVyZS9cWV5j7qwFXSgjzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lV/FIheQxNj+lJvsSNfmcYJLiSCWj+ZUa9nD6eBbqpeqyIbexlDOfikRIHZkCPu2a
	 90hMuKsU75gsUlA7QavMoXmFr8XwQRke12H1lqbxaDfOeTfHhz0qwtNDLvwqv8DSRq
	 SIHm6Cqojp4u5Y4VbnI5neDQYsz90qM4he5OxrWcxLWqIp/7f6CUxnKaMo/O7cc5ZE
	 qKwk3dlal67bPa9KVyBv2EPQIJ8SDc46gt2rFdKf94CU9rBoeinoxDIR3UMOXZMp0+
	 HrvkcGeM+927Oebm5SObrCZ8BlphcmzhjtJSLRpNAuym2WTqtYJEgDmdvaNwzdaR3x
	 jZlEaBH99Qx4Q==
Date: Wed, 13 Nov 2024 13:28:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.11 000/184] 6.11.8-rc1 review
Message-ID: <ZzSpYbIWGFAGlE5M@finisterre.sirena.org.uk>
References: <20241112101900.865487674@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vVLSGE5mh4uJUqpU"
Content-Disposition: inline
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--vVLSGE5mh4uJUqpU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2024 at 11:19:18AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.8 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--vVLSGE5mh4uJUqpU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc0qWEACgkQJNaLcl1U
h9APnQf+PRH6hVTgMs8VPCESgoAbAA8YCBsePTKfeKAsOA/0vK6OR0HLlyVRT+Hu
r+HWtuI9IuF/EkbI8/g4ou571hU1fPDioFwBw9YEPdgtu/UORY+5lIZGcKufbWb7
hpMTs3yybJ/WAvSlicLyxN4Vd9Z7lXj81rZ7XF4Me/B8mccdRQTDopniBP/y12vB
aH8/bkwdRSKqkXnkxdNtyaAfNiGoMq9oJpE5SajA665O3pl619RN3/c37TGDboMA
J7Mw5Bct2tDO1EYGVxT5RwoE/IMUy6gsbISAkFACePepZoYRiZlzFGcLsKPQfeRI
fbMnBqIe/Db+NrgPOyhAvFyD8FujEw==
=5vWv
-----END PGP SIGNATURE-----

--vVLSGE5mh4uJUqpU--
