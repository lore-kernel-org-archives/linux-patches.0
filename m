Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE661190685;
	Mon, 24 Feb 2025 19:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426461; cv=none; b=hNnki2KjvgpT6EtFFc/HdtRnMtQnqeIYanEvK9kEJVl+EaOKqQHrE+ZzCiXpv8fesP6QZFY4kIBAGIg+XC+tqSnUjsiSDTjOPrGZ5JSiNPn2h9P61uwXTybhaaXpRQFNHOtPxRz0/fH2d8vR8oIPskbsLFkxwFqaSyQEUqcvKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426461; c=relaxed/simple;
	bh=uk4ZnwzpCcvqjJp8mODsUiXNLKEjWRn17UcAQmsONTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWxMFYYwESf4MqInRzYrw4EolsqpbAl+TVYU2IVMiFKEJ7mMZ8ktHlKLQ0k84vu5tJjO3+yUXfVrahViTZ9wSDCDQ6wpc90Q/j1WqXbUV6n0E7VitSc3LIFgqPQw22rYpLmL8Ih0MT3oemlAsczADkCXXDFRdIzLHCM+fahrCVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=on10SJcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="on10SJcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D19FC4CED6;
	Mon, 24 Feb 2025 19:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740426461;
	bh=uk4ZnwzpCcvqjJp8mODsUiXNLKEjWRn17UcAQmsONTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=on10SJcPyD4LiSzidqKzoGjpiyvKv6mc5NKPEJHY3zS7tCKhL2hBcOS6tlR26AE+i
	 8fAq10HIdXcNN8YV5giIeMmGfW7ABdAXstr0Y54Y7dNa+xowXMpLeS22Rf0Bnxqqmr
	 68YPSfr4VUTvz3r4z/lOwyDEeVCn3CXxAgZqwkAxb41mUTRMbKx7a1+CPa4M189zmP
	 C497ea6wh2sAelRT7j7PZw7QoqihLJcwa1IR5lIoxyTXv9Rxtx9LzfFOm1kzGEYtye
	 9B6IUcMOKAi0opDhcjAEHWIq3jpCBzH0kfa6WiiWh0QNN9Hro7XskkjiSlCnIJcae2
	 KAmG07XZpuNDg==
Date: Mon, 24 Feb 2025 19:47:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/140] 6.6.80-rc1 review
Message-ID: <f0208188-2e24-4305-b08a-a0fa64757a21@sirena.org.uk>
References: <20250224142602.998423469@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+a/20m1bmPWMgmub"
Content-Disposition: inline
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
X-Cookie: Phone call for chucky-pooh.


--+a/20m1bmPWMgmub
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2025 at 03:33:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.80 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--+a/20m1bmPWMgmub
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme8zNUACgkQJNaLcl1U
h9A2yQf+PqQtjtACNYvy3nHMPPxXlwOV0u1MIrzqJsj2NN2lnOQa/DUsv2vPmrl4
d90SdZ1w03IEXb/c4X4mmzzbDwCdGX+fUIxEkh0ru9xCrGA9O+A/coe9wxy87AJj
JQry6NOeCKSNtkl9yRHdaqLcmTxLFdbftf6HaAZzWC3DqHN++jCsYhL36kdF9/5X
VQWK7J08D5XTEfm1Q7nU6oXwvGXiNSn1sQQuLGixOUo1ofplVugxMZ0Js+Uu8yOG
yNe/OajIJyyrIG1syb2vYmVPjJUlm+3u2pbJtRJE//GyPR5eWIZsY9D+gbGYwlZr
WTZWstS6VJnqJEfVqBtK3f/uTXVAcw==
=vKm3
-----END PGP SIGNATURE-----

--+a/20m1bmPWMgmub--
