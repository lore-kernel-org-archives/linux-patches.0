Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0041B12CE;
	Tue,  3 Sep 2024 11:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725363844; cv=none; b=V1hF+Jai+wBxLzmdCe+4KNY5fjdknRXVf3ZKp9+031DsnDIUbeFchLtzWHyLE+EN+bsfquDvMFAA1ud2mzY67IrLJKNTke79r8hBFnBXhH7Eri6SOjIEPtN8nyEst1YRut0E+Xdm52mBze2Z8e0tQ9f684vCys5Mhb1wwa1sLbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725363844; c=relaxed/simple;
	bh=q79yt1vCbieo63jMKZOcahbbHNsy9AItiEqrN8NnYpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiQhSvHidL2p4RwASvUC7ok6FVSVVG8kKzYqSTHC02dGF9qIWv7Q7d5JmWRrYqBjsLSYx5HlVLt52z+ZivbP7QSDiA1ZcZhaeX0XJc7jUV2B2frG4L+MlZ3LwlcK1eVb5mVKqcIq4aoBdo5+BV5kWAX0nJL+P4EEZ2BTaEk3xB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2ujrWrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2ujrWrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA53C4CEC5;
	Tue,  3 Sep 2024 11:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725363844;
	bh=q79yt1vCbieo63jMKZOcahbbHNsy9AItiEqrN8NnYpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2ujrWrjv67HFP7SQS8QKdDv99l9/xjyUL5yaNfKCrYrbU5Wdi+Er5vP/oeOmloJO
	 AmUiBnAfP147W755LW9S/WJ6WPqcNJ/MO86rtXNyv4ZrmljWCyRSgIDYdmQK944CGu
	 Ns8kF+GGRz29yklxLq8mL/dSgMuPU//dGoc8jmhYhF7/Dr6fl/njzcKb2L2CA3sf0D
	 kyHzOqv+BRa5vwKyi9TdgZq9OTaAm1+VePEHlua5CkklEpoOrG8jhaLG7eFzVitW1+
	 5aX/GskYk984tkRbWrr4fukrYvXWyRvsuMzvNai9MxzTV+7lTFVy0wD++iF1dql6ZV
	 DFfCYFLdROIJw==
Date: Tue, 3 Sep 2024 12:43:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/149] 6.10.8-rc1 review
Message-ID: <e4893497-bf99-4336-8600-902af7e9f633@sirena.org.uk>
References: <20240901160817.461957599@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7Nvo9Z9791eL2nRW"
Content-Disposition: inline
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--7Nvo9Z9791eL2nRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2024 at 06:15:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.8 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--7Nvo9Z9791eL2nRW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbW9nwACgkQJNaLcl1U
h9CUHAf/ZjrESMW/xiG5DkWECIBK/bTwePnbSBhYjmL24ThfKbFJ05UfI5vQ5RCq
Z4MUa/OiTVHbVd9cGlRHkHiedVfk4Ze3ZjZCNdG/yt8Z9tGIbK/OUyKdSxI5cNrw
dm2C508MxTWkbPJ6C+MPPPMEx1vbdAiL7g8c+kHfQ+Mao2kixGYKVqs/HsRRjvZ+
dTOtbpcyRt2TxPyl9kEIc1FOLiqBC0vU7t7BkKXgcxXH3oxWzwSwi/N6Wo3ylliw
Ej1ELI7xq61nE4RQivP/UdUZ4nJYeFsMBWhcyEHn6Pwzj1QxDAfN5ZAxB0RWSaXW
dOFttHPYpXZPvnKhNAJpfrZD5aS/uw==
=mKDT
-----END PGP SIGNATURE-----

--7Nvo9Z9791eL2nRW--
