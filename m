Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6F978F59;
	Sun,  5 Oct 2025 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759681588; cv=none; b=uiLANw4RqbYFEbksD9hFnJgqkJldKVnPOd9whDLEvPU1IZCbjarJYzxDXHDBLYYA/NCmxuLimoFWEpwtOP27bldRIZscJzMQVpNheRFDUxI7NH+bvpEPKDLyB86C5uTeIQOewVMOSwWOJpTaQprjCM3RcTzrNdxx8Gi4lH521b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759681588; c=relaxed/simple;
	bh=WSjuL+0NNGrAXGFdKzGmGTo2GcrIfkaJCb0YosqURHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+e7jqy7gHhQyISL7lB6HQ9RkCPz8YtiRHUUVdQ4j5vMG8FvK4ebsNKttJmOHBfuGBWKBVYuOO6ael0Xgi/buwEUXRduGcWwlUvqFA1/WOrztcrbiCqpAE9Uq1ssuanzqheJ7A6DLm/pI8lkeB4koJNhi8VXAEhodzBN8fwyBs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsDbcRAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsDbcRAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24BBC4CEF4;
	Sun,  5 Oct 2025 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759681588;
	bh=WSjuL+0NNGrAXGFdKzGmGTo2GcrIfkaJCb0YosqURHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BsDbcRAGvvuaLY6HMgpa83J21O14FntYmmoGRB2jccJNc5LvaCJgaAynxmHF6DvV9
	 fx7fugHeDNGbWIhdeZSce1V570YT9CDbIB2bFZSJvcFUbjh9I8tpCoqNziYbaz6ECn
	 xzgwqCPqOfWj3rrc2xdyQN7DlvyvELtxr126Yq9C7byDdPTXbLf1Q/7lXVSu+Okz2t
	 KNfMrYa5AE5DbkiMb4CqcuwarEGtIDQyfXU+CNkr6YjlP5S3pg2x6fIPwuT2WcsNis
	 X/qKCQKIlwPCQ36W0PWzE23eyrGceVBNUcNe7WVraSHKb2Q2e8c53Iac0MivT61oBT
	 Uv3Zlaj0QsPAg==
Date: Sun, 5 Oct 2025 17:26:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 0/7] 6.6.110-rc1 review
Message-ID: <aOKcMMfneWhanSR4@finisterre.sirena.org.uk>
References: <20251003160331.487313415@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TzuM5WaqdEf7KgzW"
Content-Disposition: inline
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--TzuM5WaqdEf7KgzW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2025 at 06:06:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.110 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TzuM5WaqdEf7KgzW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjinC8ACgkQJNaLcl1U
h9Amvgf/X1nj8bOfJo8mSOklNQBp7HbUgEKtDztQKBFxYnEiJp4s9LMBvc0uUPQO
9sdVOmEc0OiTcWA0MCTFexFW8qNrMwFgg5gi+ueh/9zLk7lBFaeEk6+HZaMOfdMk
/qFOAjfFsWqt3aBbfzllnz9PQDaY8eikZXbA2uVGZg0mlVdYH4rG5KzDybhkmpaV
HrOriYz6FHBk8Ah8Q9iGziFik80dWUMvB+dafp3xnfK+a/DM/Q2RA6fym1DC9fb3
TBx8weDC2DJr/zoDi1eKjfVCZMFeuaxbpRlJXWA0STQZEatQHFPxAbA2auyRDEpc
SU/FkXFySTmPvQgXnjHUK4nBUBNNyQ==
=gzxH
-----END PGP SIGNATURE-----

--TzuM5WaqdEf7KgzW--
