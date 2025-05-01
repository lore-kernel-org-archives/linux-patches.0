Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E746223708;
	Thu,  1 May 2025 20:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131211; cv=none; b=ZloLuIApXhUMNqbalxgq0eCOiU3Snd11sk44EzWAwRvxRS5478EpHhHvfpCRnM0qdpg5yXfAp+JBXTolybfsARqd+VJwle5bXPnbq1vOP7PuEslfrkLuj+ZnCVAtOoHmnH+Pfb/F3kh9n59+ZagbZHYi836Y2m2HLaHCKQ8NXg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131211; c=relaxed/simple;
	bh=N47OIBLWM8HdRTemfGGEtkB85okSNuTuiHOz1LjQw24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9BhZj7xy7L2wN94JuDTOZZ9YITJ1LlBNITzDecqqY4TMtXwijCP3kiKMDCeRyUKamKmOk/pPh7L1lI1pmxFu3PvpE7sz0QtdReqFKXyBmfWYZkTj/tvN6JAC1HR5am7yu4VzY9FZsXZlmgpjRMQ0nGbCq4fbJn9DhJaM63auwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H48gR9MK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H48gR9MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5A1C4CEE3;
	Thu,  1 May 2025 20:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746131210;
	bh=N47OIBLWM8HdRTemfGGEtkB85okSNuTuiHOz1LjQw24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H48gR9MKq0/pQw08d493vuhF+GMXOsfKchRDhsR18VN2mr2+DCKBsvb6BpJ/Rdy26
	 VNgUGJFWcKlUFrSMY6VETw5cxyhiUrvKxAd5r/1RKSRY4xSnN4uKY6skLgLMztKV0T
	 OTYzYjO1rkvDyA7Emf79QJp0nW6ZuZXiCJfdrr4vDn7CguqBFTNm+gWZUNaEDdTbsD
	 G8uXVizsnqvC2Hic/TdAcScWt3QB4PH8uaBF/e8nrfFuvHPBBCWcdeqjahV8nboONh
	 Ga0lNrdn8CW9jKdq3eZir1mWU4J7lCbFuX4HETIkhM7XACgoTpTjO1BFaElNjANfjI
	 ybqMwGrlckWNA==
Date: Fri, 2 May 2025 05:26:48 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/157] 6.1.136-rc2 review
Message-ID: <aBPZCDc5apFWgYJ1@finisterre.sirena.org.uk>
References: <20250501080849.930068482@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="857pqWXWOyQp/Jh1"
Content-Disposition: inline
In-Reply-To: <20250501080849.930068482@linuxfoundation.org>
X-Cookie: Well begun is half done.


--857pqWXWOyQp/Jh1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2025 at 10:14:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--857pqWXWOyQp/Jh1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgT2QcACgkQJNaLcl1U
h9CMbQf/TPO+XMQnXcYCnXVk4tgX/8Ymmlsd5HnUD6S+yymrsNAmEr/o4DI4WRaL
BsdYp1X2KMiOCmPz/WzQUt3XNHkNXjyITAVxqOnDmBJtbI43wmwFoOmkFAH3OQvv
sfzSOAY4+EGkciUSbyHQRKhm5UsW4/a/NNTOaCE0eTAn3Z2BXpX9tY3jhSDxkMGD
IdwkV3G2HkZ+j4gY8H47OR3EynEXQ/hNiDKNGBqMPuAs7N0/IeEo2dcjik2y+VLf
up1er7LMOUpQ7P0og9lCpIMJGEk948S6BJl6PvLg7hF/HlryPAxkCsSOJUFz5pDJ
Ybsrr4gVjngYQg0aW58/hHLexBzhOw==
=A4MC
-----END PGP SIGNATURE-----

--857pqWXWOyQp/Jh1--
