Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0E12DF3F2;
	Thu, 18 Dec 2025 09:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050864; cv=none; b=jQ5uhqYDYjNHX07kTqwlWCDJxNq3JEDaawLcAFsHOzQt4NuBr4TeeFtvul38sX7qZvalgRNsbUpdMFksIi3UmibBcYz8XvdZaEMko1LSOuhYY0uLZry2npVWcvye6/lRhnlxKoSBWqUoD5XSYgfE77hePFnmSFSLgTRCT/lfSeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050864; c=relaxed/simple;
	bh=Phiwdua5mlL/uFeXTiqSdyvsSW5qub/7/Q4tEAFWqts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2mokrFGNLSu3VYfxLGfCBjp0UtS1g7OopKPJ4yrCLF/dY8SfpxTpzRhQ8hRDj0I8208XgbQgSaTXF4O1QEEpVIzC1gNgUtWNdiYYPQFJGhAof9gva1pi7Qbda6KmdXO26WHzUL7q13z9oJ/1YOv/uBx+z21LjeKWPmtt6wCQOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBWESEI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBWESEI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203E9C4CEFB;
	Thu, 18 Dec 2025 09:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766050863;
	bh=Phiwdua5mlL/uFeXTiqSdyvsSW5qub/7/Q4tEAFWqts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pBWESEI4T7poyCx6Wc9YRG4BoBF88vqjZsH2ufh6TfvtSKz1ZQ1Mgqbd5OTaF2hfm
	 6ltRvH/hzLLyyYt8u8zTdDu+iA1a2VciPuq8t+puMhaLdg+lljShQw4Jbll8+lrdCl
	 lSmo92nm1MlXCdydquV9sruP69QuBxgVJahQwwZMILzCzmu66Ap3mv27sm2LopjZ3W
	 Qy4yUG+9c5WwwkcWc9igm3wABLPjxGgCYKRFrgcbNmHSk7om9KVnjCJStUvXz2ojOy
	 CkDH2pPbWZHfdibMw6ux2SQOQZDaXP8Q4hhBrzJweb+whPBf9WOierWNBhY1OnV5NR
	 B0mQdkjJJLsZw==
Date: Thu, 18 Dec 2025 09:40:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
Message-ID: <8cc9b53a-a85a-45d4-a0b0-fb8cf6d872d6@sirena.org.uk>
References: <20251216111947.723989795@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jKXeu2YAPQQuYgpM"
Content-Disposition: inline
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
X-Cookie: Close cover before striking.


--jKXeu2YAPQQuYgpM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 16, 2025 at 12:20:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--jKXeu2YAPQQuYgpM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlDzCgACgkQJNaLcl1U
h9BAogf+O51w9C7FWQuDa6Adwv5lCgm33HWkGhYF1qSLlS6AzrCbz2c5WIRHUfhZ
8CfSpyPn/GNrF0IOX0XVQ9Xx+zD9CoMlXQDdbaZcjVcvRjnIJaPAPHAAgNiq4zDy
m7dG6GUvh9g2kgZuPoHFAM7k23LkLxa1LSBYJh3Nlcdjv21MrC7GdP9SqsSsA9Ew
jLNLQI23CCwJcyek4E6Eai8nA1zYVc2umi6XY+CIjcE+ZVh8+I1YOiwD0+y1SIoP
0dnEikcIzch0Z8bqXNSM7yHuuhDGzz9LrpULv7J+AVkDWuUUOE2WxCKC2tPyMwdO
UJ0ZA8ZA8bRkUMZXT+67xb9rex4b0g==
=15rK
-----END PGP SIGNATURE-----

--jKXeu2YAPQQuYgpM--
