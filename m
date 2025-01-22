Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824261E526;
	Wed, 22 Jan 2025 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737565423; cv=none; b=hDEeRos0GRlBQ5iDdQi9dXgAhoeOej4s8zON1A78F42EHbYOj6tDcW+Lg8zafsXzwnN91PYNyLlO750v9CMUi329aiFpE9IcyOpueUoHNlH4LRZCOKUBavBN8zTD7OC/qoKLdyU9Amn8tbhzPFGNZ0b3J32mpTf+a+xgKURUfok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737565423; c=relaxed/simple;
	bh=Pru5SnnI5194jaj3Okdg0dKkiNk4plO1atIOku43cZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iv4ECb0AOQBA0ZYNbLQV2qjg7fZLlq5N+/LUrQnoWhwgCjrFekWRu+CtHCmAMqbsc99S1KIfZelWgzUYwhPSJsILrhHMH91q3bGzoXbYYixQjmovwwxosKgvbb9RsJayeXlpBhT6LZumJt7Br8i160RwKF+TzXTSXw3lE9lBdrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzKYPeO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzKYPeO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655BEC4CED6;
	Wed, 22 Jan 2025 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737565422;
	bh=Pru5SnnI5194jaj3Okdg0dKkiNk4plO1atIOku43cZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fzKYPeO3erDrRmk3ikrHavsZAtEQnuov4+b9hF9Wj60YPe6BdkK03P+/HM92yAoLn
	 cjCn0iEzCNF/O1hgT5hxacceitcyV7v2deVJ2w0WGAee9DJFNKBxGFfI1gx2AWVhH/
	 nbnOHYB8l4JHsDj//hH2z6t66tBEo/eXJmeEUz+PAOVz7uQGW1V3+0H3jcjx4FhsDe
	 JGUgUx3zz2ef3wZeSQx+3gsE+f3q3L+ELSM8xEIvL6W8OyWrUdROabyWOhys+tWOmh
	 tZZaOMnt+mbyEZHisFSR9Wmi4S+o5rAiflPOaBMwMnauqT8RLXKFqlPTLJssvGHg+C
	 zGQN/kjlcUGCg==
Date: Wed, 22 Jan 2025 17:03:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
Message-ID: <5959e0c5-87df-41cc-bbe5-7ad69e6f16a7@sirena.org.uk>
References: <20250122093007.141759421@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GR2bJgNPshUi6iKz"
Content-Disposition: inline
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
X-Cookie: Star Trek Lives!


--GR2bJgNPshUi6iKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2025 at 10:30:49AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--GR2bJgNPshUi6iKz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeRJOcACgkQJNaLcl1U
h9DEgAf/c3fOrX/HdA42Io0Uoz5mz7vulvhCJLmEX6sXoP9OQZXaE+z2ETd7NGKi
o5bp+bwiezjZqR22P4aSrqivYK7x6dvIV8PsHj+DPfn8vKkwHQhVSHu55FiVHyv4
n/nwuvJeC10FzZEdIV9BCfAoD4RqIPQ6TMbKzKjneZxDYvAh+mD45W+3dWSquL9U
DLw21EB7jn3LKdH8TWA8QlVs88gjoQTJtoVNbtW6e0lsK3d1jNxR1PnEfiwwEidR
+uGniUKkT8xde1JTchYJYwBJiNqjPxV9KEHhgSbPqwzGTVuHSBgGfHUKV4P0tk0/
oPNJHFOZtzVBo28+Ps7vdx5rZGIk2Q==
=xo27
-----END PGP SIGNATURE-----

--GR2bJgNPshUi6iKz--
