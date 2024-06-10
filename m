Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078B81729;
	Mon, 10 Jun 2024 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718029255; cv=none; b=vDDXyH0z9X67oi4vAgODaaY4rZI99mDHZMmD694/dAxuP5XZ245+HKJYQOjvhXDF9/HafBs7BUPMJKJ7SXVFVh3cyQ0sV9MEYz4GgIZYmyqW24QsdJmMZu0znL8OewF6CXH3zSLFkRica5BgagmY+GizL7lIlw7+nAvzNFyqgpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718029255; c=relaxed/simple;
	bh=315qDCBMaMQn10AHNIuet+zY2ECWefh8cTY3/fuynrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWJ235s2AqLOUGXSBQNux6BL2KgZI8Lfq+RAR16z+6XAmGfy3FgyEqlgVpwPo48000G5x0RkdT6i/J/oDr80ryw0EnH6CD+qCq3MujrBrooMQUx9MVh6KCr7BhpQ+4zOl7GaqpNQx+xeptfnqLfBVZ7VCs8YhzalV7jWCWpAUrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hASSoHHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hASSoHHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEE2C32786;
	Mon, 10 Jun 2024 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718029255;
	bh=315qDCBMaMQn10AHNIuet+zY2ECWefh8cTY3/fuynrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hASSoHHk31FMyQuqMfxv1auhcYihr6srOL+ODauBRTcftnxE555mSQfk+fRyojcaC
	 AoD0LKbMtqmjIH3VFYrdaaIPpC+bTBimLwo5aweitKRjsTN1ZDJCpYItZ5FGqhPe5b
	 zsIc8WVL2PQtYgudwBmgzFZ4zwL2JHOoTH7b3Kz4tjoUDnGUvFRpjm+5k/toKfs8yP
	 Sv/j084v/fwjK7FvIPwUkKI+g/PsbdS1qkPB/R9CWnRUS1L7PF5h976olXTeJywe/p
	 4bm7V2FQfZjomDctBESxyxSSP42ykN1MRNVBB/b6lbpWNuksLw7c0S0YnaCl95CX/n
	 DMmhM8thAIwUw==
Date: Mon, 10 Jun 2024 15:20:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <ZmcLqJV3A4BQhNf-@finisterre.sirena.org.uk>
References: <20240609113903.732882729@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9BIbkzX9JQzMk3wv"
Content-Disposition: inline
In-Reply-To: <20240609113903.732882729@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--9BIbkzX9JQzMk3wv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 09, 2024 at 01:41:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 741 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--9BIbkzX9JQzMk3wv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZnC6UACgkQJNaLcl1U
h9CESwf/Rlwwzj9B5hinYnNnOYXQKn9eac+Q9Xzq8k+6jBicZRXdNCZV7DkOg8b0
EHUavMQfBLAlA81PX5VtKnaJ8EX9ToRrtfe1BrlxxV5FL1ro6z22fk1UB0ezVL3W
9dnsuLqa1Ybhh8Ko6S5VHttuxumUyMk93ITVEQ5TorbYV6+eMCh3avPze+xb1COe
DJjlbDplnSAbjeaj0vXnkIggR/X+7jbiEWGnIH/0U6cVoWrGvuQy9PxMOjbSVgC2
SveoPDZ+PltystjPkFj2UsxDm7zYJPXjDJpTEET1rG2j/CqCKHZlU/zfrtT98ocX
Qpf66rMxgvzPJzDk+ucVzfW5b4aYEw==
=tnPB
-----END PGP SIGNATURE-----

--9BIbkzX9JQzMk3wv--
