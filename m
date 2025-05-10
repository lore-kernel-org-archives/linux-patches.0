Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5F2CCC5;
	Sat, 10 May 2025 01:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746840272; cv=none; b=Omz3xOPTJhUhEp36ThSOriwGMiv6EYnhj6u+oYRyb2SvY/SDBL8w9b4vo36zZh/kDARyqK8MyWJ5C6EixvrIU8b/b6xKY8Y1i1atZVGCQ3zyso5ZyOAAbB5M2F1BLLZYeIcWPebrS1zJNuFTBVSn2SsF9C99NqdItwsNTJK6SP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746840272; c=relaxed/simple;
	bh=OXyvStXyWT9QVR/lqb24WJsPCQVbmjx9JphtTcaNWWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LG1g5WsczHhQUIa0McTevzdbmYpX1rRNt1ql0IgmSzwkAQ0N6hdNjYMGHGU43gIB/psSbtwXOKL13bMJZU058Y8e2UHeJzDqbns1i6mw1+mlEQV++7pB7LKBKIV7nv1chC/8sdKv2LyoVBXFKdUG6Gy7HMIljnLtJ6oyz7GOQEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jyEq0mEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jyEq0mEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B491BC4CEE4;
	Sat, 10 May 2025 01:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746840271;
	bh=OXyvStXyWT9QVR/lqb24WJsPCQVbmjx9JphtTcaNWWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jyEq0mEnFMcXVRqXaM/mREBJkPzq8NpTzauraynEUQ9Ln26bvQZGrsiwLhKZUvV7M
	 a9d5LDEgQmgttZRPK0RU29VGZyVqFwlipcMBa0BU63V120k+q/NqI5RyU6xXLT97gV
	 WCJlNcwhMcMxhaZRlSPaWkNrIY1S4yvBCnR+sMgbV02AsViLbVDiZuJD2X5KR45uGI
	 CtyvZ//ZDN4JTCL0J6uO4cf6bYu+clGR+V1qs180kR/Ttig4fcn3tc1BpOPgc0eqwH
	 /gd3qIFakCnKOrib3j+2y4OV0QEUSXtssNxylKXZZONocVHmI96buJavfv7yJojvMv
	 DTEOKp3mM0tiQ==
Date: Sat, 10 May 2025 10:24:28 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc2 review
Message-ID: <aB6qzJxxyPSa6gPS@finisterre.sirena.org.uk>
References: <20250508112618.875786933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="50O+UGwiy2Q6jXgH"
Content-Disposition: inline
In-Reply-To: <20250508112618.875786933@linuxfoundation.org>
X-Cookie: Well begun is half done.


--50O+UGwiy2Q6jXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2025 at 01:30:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--50O+UGwiy2Q6jXgH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgeqssACgkQJNaLcl1U
h9A4fgf/XDEoyxqozEz0QcLVFnZgV1jrnrVMB64bO7uRkW03+9qvBOB9G8UAObLR
P+bSEnRyw2RBLJxQuwY9JxbXAhtALd0a5h02TFk6SDIFqaF+rq5BU0WZnu8ADwju
d4hJpBYcB6t+F+nYGO0Pj6Uo9B8c2XKZ3FJVf5pp0+quM6fix270cGLkAq//kybv
CW9vCvzYwuSK04NldifMX2BBcXT9FbDjmryfV2owBV+iE2CNMq1EoHVK3/IYZ8Yo
6xY1SOlXMG1WKh2JYQ0oonrqpWaKD/AprHLcWo0sm9VWDjd5p5kmdYo/aW5gQi4e
fBQfeISQEfd0Ts9945UK8W6aDEgTtA==
=o8UX
-----END PGP SIGNATURE-----

--50O+UGwiy2Q6jXgH--
