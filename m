Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66D724B29;
	Wed, 21 May 2025 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747851429; cv=none; b=GQvyCYeh1tLlWnC8Z7PdcOb+oQCEBOWlteYMYwYBD4tm4Z6gPKpIVG/I5V6jGeuP6rP3ELTfRZlKNOAyTTD3/Bj5CmCqdHnqDM69z4f6wAguSKCKO0P5anPwGDUImA4bsx1JMWFIBLk5XPjbKmZqDgSq2c+TcyBLFqhqxqQghvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747851429; c=relaxed/simple;
	bh=QPOD/k7ZGgTLcCX7nbf2iUvEVEml167I/zYkRLJHbdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMav7wXfRXYFp2+gpGjEGD7gxWoQy7mD6aGJPKSAjKfLzxmZ3DNyUqYOojbFk57RQ0K+tsqfptl6xL0GTMq3LVx9gYnr6t5TJwYLqJZuIBe4n3VowG9dwwPbd7N44L/1QnxTm5/YuvLeJSjLbzt35rdMv9E1cdtr4OD6TNPd2AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1LUyO5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1LUyO5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0359C4CEE4;
	Wed, 21 May 2025 18:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747851429;
	bh=QPOD/k7ZGgTLcCX7nbf2iUvEVEml167I/zYkRLJHbdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O1LUyO5fedC90ekI/gOFp8bV70LDdvAUI78cjU2EqEc6iCQgH7OcO+ta3UCbfmjc6
	 cvRLsjjMIwSISnqmLKb6E9aApvBzLcFtgnsc26v8ac9kLhWGgIMyRpahk8Mm1HUJas
	 +tUoprnCekhmWMy9/QkBFhdUvG/vNcHPB7rPCwa/Bz1ekMMflD9dqf6tpk4NA2xjwR
	 RlHmV3GvK0ROLrLW4P7uwgdXHeC8i4HjiuVf4KSqYaHDRVTM6WZsPE14b8KTqyJ/ef
	 dewoJTl0fxCQQ9SgaOj/aCoHbgmfT1UZLcZ2edQDrBaCl1slQqc341AL2dYokxub6r
	 L46ggwR4ghrMw==
Date: Wed, 21 May 2025 19:17:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
Message-ID: <92c895fe-3b87-44b7-b971-94798902d6c2@sirena.org.uk>
References: <20250520125810.036375422@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YSBd01xVWeKxFraD"
Content-Disposition: inline
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
X-Cookie: 42


--YSBd01xVWeKxFraD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2025 at 03:49:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--YSBd01xVWeKxFraD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmguGJ4ACgkQJNaLcl1U
h9A2tQf+Pm0sj5N70nmhaVhJ0Zaq8Jq1Xquusz8zQDv6C4yU/Z/Xo+F/kjiQwFHB
LdvTqnzgCF/McE35GoGxQqyQm256HWPEUmaQp/lLE7C2ww1jvsEioxK+ZeQYOS5r
OhlpH1IzGgTNIVLGokgscrQxnpvsojTtdCPAEOEK/NLmS/LWaHNu0hoeYDuPNGQw
p7uzPazYbPOjx63GXfQCjGxprEMhzDhMo+GlbgqR40IzUEifOS9kMJGx39T+RA2J
2tZxBDNmwm/Zbdn52ZBmRFtmPUzyJrTjLFW+ruN3kfpIs7tH/YtK5NpWR2DcwiTi
v8ZRPnfraNxiVYgIeYSAtIue7X8fKg==
=iadD
-----END PGP SIGNATURE-----

--YSBd01xVWeKxFraD--
