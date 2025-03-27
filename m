Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EF42135CF;
	Thu, 27 Mar 2025 11:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743075798; cv=none; b=lAJcnNSQGW8mlFAtHzaDsdRED0DgOKu0XyEbX8JUpVw7HsNhu7s0sY7+lnTJY5nUbnvM+GcsTYFDot1NEmwlYXWRU7vTmM+lg5L2CvEYENyxxnzygKH+lc7m32CJdKsmk3qI70OlEyRMngBz28loR2TOL9lS3d5iuTD4T178/x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743075798; c=relaxed/simple;
	bh=N9fiOT2qCHps6OIB3uTC1sIuTQsv+OckRQ/04tIMado=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIPPPtpj5tkg50B+aBeDenYIFzr3Elnhd+p7B7pu+eC0Q+1ubuYN4kOKSk4HxtzkVFseKuD6iHISDU6Okvc1PqrnUjxMhduGmF6VH1OnQKkWJepN8V0hRb1hQmcC9V1UWwdiVN9Ux/StcqiYgTUZGligmLRdDP1mFUwiWQwWE2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pp7ByAOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pp7ByAOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2276C4CEDD;
	Thu, 27 Mar 2025 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743075797;
	bh=N9fiOT2qCHps6OIB3uTC1sIuTQsv+OckRQ/04tIMado=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pp7ByAOCDJDq0nivwm107H06bBmgYXxp4PvpmYwAZDNDe8uo4tHJJauqRu1uC7sWZ
	 0leAdhV7x4v5h5ngShstl2P4PvQLickJ9dJFONxlKQJGP6KUTj1Xpq5fUzZ6F7PWQY
	 kToKTkmbC2zpJY5RZA2c+K791T9bcR0Gud6QrFaXiwEB7r2Y8ew5F6sHMYXdKnhjuh
	 4Cno/FFtIbZa/dJRURQUmYmk/cjcD+NMqApfxN/81UMKZAv3OA1kMM5UsxdF6vBh1T
	 m+drFXWGMC+FUHvXdQ6EdxWC0bW6vMSoN9Mryq4/LLEgXRI4KxpuLsgHwvGwvJnQca
	 SiljulivhhxbA==
Date: Thu, 27 Mar 2025 11:43:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
Message-ID: <59fd1354-2f2b-4cca-814b-b8d3e5f8ab74@sirena.org.uk>
References: <20250326154346.820929475@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iho6y+5l47QAZFVI"
Content-Disposition: inline
In-Reply-To: <20250326154346.820929475@linuxfoundation.org>
X-Cookie: Multics is security spelled sideways.


--iho6y+5l47QAZFVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 26, 2025 at 11:44:35AM -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--iho6y+5l47QAZFVI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmflOc4ACgkQJNaLcl1U
h9Agswf+JwIUxV3yIXIKePlD/4Ba+CcVUP1IVMCG4yNwlWhIForOsqYCUhG8l3uQ
ytbprdJwDhv5KzvktjtAQPHJx90T4wopQZICmpzCd96HkM1vCUq8ptjVg9/d2cJS
FwvkHqenfpKOIPvzL3rcwx6U2C8xdHpXeefAZ+qw8fqmw5PfklFAztgr/Z+MA1fd
r9N+jSqLnZSje1wJO7tj8HnBDoiBBJByxaGCWHEQrkY655crfQRDGQJ/g6olNG6F
GgxXxvtsO2rk2NCAuIfIDAk/PU2bbAKYaIXjSaIRWRTOjmDUj9EOGXJ/dblD3QzL
0hR6PUzsLuPS7hvp3xX7kXpg0tLlBw==
=8G6M
-----END PGP SIGNATURE-----

--iho6y+5l47QAZFVI--
