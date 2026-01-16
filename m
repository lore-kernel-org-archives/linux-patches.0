Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86712D73B4;
	Fri, 16 Jan 2026 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768591215; cv=none; b=HC8aaUb01MFRI2ujtqRxRrSF5uHiTALY3BSCWysKxtRa7G6yC/tKTkmQxWaBz+MHlUMmxzxpxSAH/Yj6wZWzeiqsn9FeAlnnTFJOI03cqlqcYRLIZkPj4ao6wIbGQ96M76l2tzajYcXqqLTlZ146SXhPmP31rf0akrxO0PvBPug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768591215; c=relaxed/simple;
	bh=9GJlFKDj25eyLBJ6m9IXJVlmzRKKscOk7ybf8Q8/Od4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zot6yhrIOKwEYQ33GA/wRPOa2MG/yULR0VG7Yt7MgMNR56Vzh0QNyOkAGlbIs+UiesyaIQDn6QwIamf/rDyqfCDNGp7uHSGsnOraRLFExqoLRjPxCEy/IeDaX7LN8xfx4oqDFN3jdlEmg7gNH3U+vukO6C8yXyTgA3zrr/Nmljo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JymyUtko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JymyUtko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02610C116C6;
	Fri, 16 Jan 2026 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768591215;
	bh=9GJlFKDj25eyLBJ6m9IXJVlmzRKKscOk7ybf8Q8/Od4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JymyUtko4366L6VORAWvy+A7vQ9SuLHuSH1A4X8Qw+q3V6uuEU9gpXZH5YKfIw8E/
	 RWKh94lyu67kxd8m+fuIJuGZPBFUzNcIDN5hJFSbcAuVgCu/wIF8nuJG0ldNpk371n
	 BunuxrdZ+RTjlytDRhGcRUVG6Tcvvkdu/oUtIN8hy0gz8pOQOs6yKLCy/JjQcSANAh
	 TdE6Py6NVCuQuYuaCUnRzxcqprxbYk1UmI+EJEdocEV0HauAvG2IfJ92ZQ83SpRoZ+
	 U1iEh/M2eAAMAfitc8RccAp9EheF3JTVvO/q1igXrAMJxfqF9cr/l9KdJI+vzwovuu
	 VEf75wx8QNi4w==
Date: Fri, 16 Jan 2026 19:20:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/451] 5.10.248-rc1 review
Message-ID: <8fe0cc3d-f820-4ad4-ba2e-c1f66f0da7ae@sirena.org.uk>
References: <20260115164230.864985076@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h6YaXf0iGS4XrDia"
Content-Disposition: inline
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
X-Cookie: I've only got 12 cards.


--h6YaXf0iGS4XrDia
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2026 at 05:43:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.248 release.
> There are 451 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--h6YaXf0iGS4XrDia
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlqj2gACgkQJNaLcl1U
h9C/Pwf/VAJj15d4yLALQvwOS95AUTe0sbMpJkCKxfsZJMWbLF77cqGHkJ97P43k
U3w/q2fln3R2whIYuVeCr00fhHXtv7HdQtFnYK4fmRHVRQA9HWKC8CWTxqEK2VFc
7EEjRjNQCS3tE7zdA+Ls+fkVQqaLKdXF/fBTthS9F4YoL/wYzo2WSiP0F981iYTG
hitqihMpjrluYaLYE/Qc55jIAanKmA/T29tkE9MKjrdH5bbBu4kg+zqCRTQ1vbPb
y+pTb9ZgJLMOKdnYFYUD/uPFROWyEYqWsz+UJ3OCuUk4lO6W4GIACGCjUzmO9vJO
rZhlc1yh3i9uOF189PCQZG+ZkcGiKA==
=8mSc
-----END PGP SIGNATURE-----

--h6YaXf0iGS4XrDia--
