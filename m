Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E180A1A7259;
	Wed, 20 Nov 2024 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732121142; cv=none; b=YL0qaF34o4JeNGDlRWOZ3ZqS0A/9wmitKexHwvpbusnC50qowLk9wv8iWjQjY/KI5qr46XemIxn0l7RzWaJiDRvLmyfoWjYNKAggPyEpWSp34Sl22Aaw4fGZrF+jwovmyxxeLLM/0kv5nHxK7t4EFILg7S8IHGvB3ZpoWkAwJoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732121142; c=relaxed/simple;
	bh=0r2J8WgdWUhG4IT9F2lOMz6mi+pnP8ZIMe+lwiC3+3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mbEvK41cvhifgJiD2jtVDkZo3fJert4FB2KmbcAcD4g9j2D2GzzIlEhdQY8LQnRgIhghzn4/YPnxLBLqlDgb+LM+HxVFcsmX+qa3b5+dQQuyKzNtDOkYIpNnPn8mQMXb4c3SrV9mJbIcRTP+UfifiJMfNMRmb+fVAlv9kOTXmIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amYWY7e2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amYWY7e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EE9C4CECD;
	Wed, 20 Nov 2024 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732121140;
	bh=0r2J8WgdWUhG4IT9F2lOMz6mi+pnP8ZIMe+lwiC3+3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=amYWY7e2dq3QkINYeENpkRuacGLgkJYuZufSXDzghBip782fVlfry19OBzKjhKEKu
	 nnJtMS6ZlOEYa8Ls9b/6n99UOJp/SITvuunLHxSJjJJ8mFvhSQ35rQ07ONTM7mcIsd
	 s8r4wU7loOJFgHkMcE4g8D56+ZnCmYFdwAhniwUs1jgqdP7XdXd9MMCGmOJX/IO6TN
	 pTdazDPnVMN7crVR3N3EYmwVEClRHX8VAwV3zwlJrGpYegYmGWmNGhnvES6hmRETtW
	 Ejmwh4aFQP4A9gmq+BfWV0y4M54yc1IzU6U6F+lSHWl0nHSEgp8/49/QZxfoeYXic7
	 3tdRl5ilxt/rg==
Date: Wed, 20 Nov 2024 16:45:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Message-ID: <efe6cd2c-773a-4c00-8575-c54bb70291d0@sirena.org.uk>
References: <20241120125809.623237564@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EYHwgQANbxFBoSse"
Content-Disposition: inline
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
X-Cookie: Place stamp here.


--EYHwgQANbxFBoSse
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2024 at 01:57:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--EYHwgQANbxFBoSse
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc+Ei0ACgkQJNaLcl1U
h9AKvAf/bRIZ980frqsxhK85BKG3GZTZP0JDC2IufVvpHwom9bcwNNe4SVgQOmv4
PnIYPeyQGQUEYNbMu/AYHozkeRCDIxLGBzm9DMkHL8FvCfGLy8PbYuT3lA7Afe15
qkuviOjwLhBLatSSzh3ERZFLLb0KnQndGScJRbNiXwQnzl9h3hBW5DXbjp93iz/p
G9CWjoM76rndJMmRe+9tMFoUk1Jev0boyhc9WKYPtrJNnDsCIH9qRKpTe0Z3DRGR
BgdSdnCRhseiYvlVxkFe3mu5WQgF6PuLjJSMJDE9accK0vyuPt/mvU8tva6t/2EI
6kQ0zkSI7nRajYRUevKKjOCDdu56KA==
=qljV
-----END PGP SIGNATURE-----

--EYHwgQANbxFBoSse--
