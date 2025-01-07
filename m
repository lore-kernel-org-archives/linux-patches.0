Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4A11F239B;
	Tue,  7 Jan 2025 15:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736262769; cv=none; b=JElYFMd7w7x8DXm7f4jQUfBofq3syErE6AYqzvJKmoI4aZ6+ZQfud5qrLMGYOuN7ZmNl9vh+h7kylfrNnSYNRAepKl6JIbD39ng4V0tFG14QT2Tx0e01NnrheaIDXEc9uwvxOXO9p446SpsuhCMLSwPt+760RWywLlfoNUy7Wtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736262769; c=relaxed/simple;
	bh=Tu++ARHHFawTlAMse9oy2GTih5vkbNagKBwvFfUEccQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkL1z/w2jCi23P9dTh0poeDYMIzo44oWv3gfnAlb6DpsZf1wtXoLdBRVo0PkZI6DiawoIN/sI+9bmAb+BQWtVw6ATKDbK6qm9WT7RUbsEQvCycD5uHI/+H9X4VHhO0f/2MEsE12KLTcmVVwLHox0sbdioBzpepA+pAHxFeki4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEnbym8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEnbym8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3F9C4CED6;
	Tue,  7 Jan 2025 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736262769;
	bh=Tu++ARHHFawTlAMse9oy2GTih5vkbNagKBwvFfUEccQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LEnbym8DGDKKtLWb4U7p4XG404W9GH8fW3eXxsraO4mHIw+lflOuB8MNBvq+ekIPJ
	 K7TfR3sIOJpELZPHR/9LqLwF6quLMImbhrqc0DTH6FXYEN0T26kdSX24UkiBSqnNWg
	 YxGPxiDP3qaICPBRsRjX6higxlV61bWU0ojJqbu3maHmgd+JNAGE+gJW6wb0R2WwEW
	 wJ03OBQ0z6efkDtNK3DUNmz89GqJQr2zk9juuMgLg9pC1SYpCl8dEaaBYf4M6Kx7sk
	 2ucJEYxDgnCloJeaMexxEVPzYMD5WzhGCO24WH+OU4HIgxaNVZIZYuWzpn6eod6Tqq
	 hOCGgj6GiP29Q==
Date: Tue, 7 Jan 2025 15:12:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
Message-ID: <16198382-f6ee-4e45-b4d0-6307f9f95643@sirena.org.uk>
References: <20250106151141.738050441@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eRE/2fHzYuoehYV7"
Content-Disposition: inline
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
X-Cookie: PIZZA!!


--eRE/2fHzYuoehYV7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2025 at 04:14:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--eRE/2fHzYuoehYV7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd9RGoACgkQJNaLcl1U
h9B2QQf/UKik7mXSLUM4bFFraqvgwng36tsUB8yu2H/2vQHbVgHYSrVEPLsSPZBJ
VCh0jmgSai7zboVuO1P7+tf4fKjKHD3KmNhi2dkvjsOnfWwnsKsMpLSaX1MeEmOt
CPh4MJu1tNG9OWTcBgVcvjIMohl00UyZrfYcUmWbcMxNNhNEPA0d72+gas5oZrj6
+BSSw6Kur1oKb29V6wsFU7hIQROY7MxBYi8PgXf8/g4wm8WGW+m8Jq2Vv4P4hQTG
LoG9egOcIJSPDr4JvUl/MNrNygF4c2g1jTKm9T4k/5AI3IAG4dEqLrq6hHyfv9iK
D0HJWcHa7W7xlA+gYXjVoRIURgRZEg==
=DJsS
-----END PGP SIGNATURE-----

--eRE/2fHzYuoehYV7--
