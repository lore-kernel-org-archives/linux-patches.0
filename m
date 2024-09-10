Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F408B2AE69;
	Tue, 10 Sep 2024 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985264; cv=none; b=b4JqlWHx/i4joWmJLM3oHv0ve3cFP+mzLlZkdYTSnuJxPOKkVb0bCoxSjpC1A7LMBXUe7/EnYAMyFnKf1YlcEqgsT4ZebW5BBx+q0F9RoxQRwrukaILhHB7bF2TRMsNwERThgL74310ZduB4Bd2eh4SktZgxnsIGsQsyWchTqOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985264; c=relaxed/simple;
	bh=n2/Gy+qHm8w2K7V0ozom/cyardgewtVWUCqsx5HiEHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYEidk+6SKcmnoNTrqn3cUeoYUsGdFvfxX2olw6Z8GMH528vj4crXTlvCcz9CqiIoe8BKZAF02PsdYXnZ2xqXfJ9qO7j/RJhkgQpxR5Lk6diwZnrbNMdAF0RiUxcZT9GYUfLcrWg9tfRgSeysKqTNmLneDLhgLchUBHyWiXWUpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRkHSmZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRkHSmZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09867C4CEC3;
	Tue, 10 Sep 2024 16:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725985263;
	bh=n2/Gy+qHm8w2K7V0ozom/cyardgewtVWUCqsx5HiEHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nRkHSmZWRQoptxGP5UzyxO2ywgBGzeRqewWWgE5Sm9H6G9Tdq9wXds0mAS8OTLM0x
	 LWt3Vap2Nt61Xk/Iy2VVvcQK0XiBUh4atVvhlSGkWZXZzq/h7zi4ggfca7FnLdT/3G
	 CEZrLStoujkUbWA+h8pwg2yhDq7o5ZMrk+4l3hOX+V8NFx1GLEj5PtbvFrAmTcRCnV
	 eq6/tYIpbxQALUyLkxGezXIgt0S/f4ipRC2fy+sUe7UZEMyMqnc+pENDaT0astLfig
	 JmhJjvpkWnz2mCLsSbb+HDAmHYKAPnHrcoS/Wg8J5FFLml8ezQ0oBt6S8T99riaE4H
	 QyPj5ce6lGGWw==
Date: Tue, 10 Sep 2024 17:20:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/214] 5.15.167-rc1 review
Message-ID: <a7d6949c-fd1a-42e2-bf5b-9cca34a680a2@sirena.org.uk>
References: <20240910092558.714365667@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o+joFcAd0/MUrjNu"
Content-Disposition: inline
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
X-Cookie: You're not Dave.  Who are you?


--o+joFcAd0/MUrjNu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2024 at 11:30:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.167 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--o+joFcAd0/MUrjNu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbgcegACgkQJNaLcl1U
h9CYzQf9Fznt5eM8GrbiC9QBSNUf5uhyHpERn2Yh1+h3CngZP9/jQ3lrjQuDEhy3
Am4rgiBoU+m66sWEIvC2zoQv+PBpdozEGDKgtdJc/O1ifG3bXrxPrZQXXjRj6JLV
YW9SjTekrD+kPKm1Is7dtWIHsg4gKs5Z4Sv0Y5rS2NSlTIIUGM2q9NdwMwSt4QI7
TvCIB7qSN07foV1K5FQbPzxLO5i8qAJ+uAr09ruLBQm/e5CC4+5qfWGc6yuYWHT4
LrRYDlfwku5O3+OUw/Phpfo9U1N5sgXpCRdMK3hHdytucAc3wV/WG5XjMn45gMAq
A4mME1BNBKCbt8urHUoPuNuJc4TyPA==
=owi7
-----END PGP SIGNATURE-----

--o+joFcAd0/MUrjNu--
