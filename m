Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46F41990BB;
	Tue, 13 Aug 2024 11:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723548983; cv=none; b=CSzBltvkMlxVGyZ4s18+mjTHghKnDPdx3ufiHeavXxOcRJQQSExxDGHrJISbjLnA3FxiBDQgYSZZZY+zNNt3VtpnTPFwKSpTRhjK29HCnSTynkqWBS2jAqP8OC6pB+RQGojTi6MXoyjuzM9/gVHf1Ci6EQG9FINf0mBiQNtG7bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723548983; c=relaxed/simple;
	bh=lQ/A0Y8abUxpFlU8p+GVXs/7GUQBIf3ttrFoeuNzD4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eyxc9kYGu5FhFbn6K9PHEkC1BGFxzF1YpJLn+iMCr8IfNgJNa0PHTAZBmhz5tpl3PVeg7jkvUQit/LSwO6pwmmwWQnCe3GSMbzLdgvlqhJQqh1Ex9YuEiNUbXrTgZ0p6coZU27fDVdzYsGchinwcMsyJYWRPKgUiliZzNYei9ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pmy+JvFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pmy+JvFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9928EC4AF09;
	Tue, 13 Aug 2024 11:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723548983;
	bh=lQ/A0Y8abUxpFlU8p+GVXs/7GUQBIf3ttrFoeuNzD4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pmy+JvFVTfjTzo/E+8wEPsHX7pvDQmm090DZjpFFtj3avgIoQCprFxJrBwkacIwWV
	 4y+5Kh6/7Ccwbld6lpMzhFKbDZXEYhX0ohL8QsHbTptbkFrehJhb3Sxk81QUifxtR5
	 jBteSFEgWVNgicObBCnEGUnSp9xNr4+I7CK0i6B+PGA95I0xBrbAEkhjbZ0/DeAXie
	 AGALoReIlY/+IiRyleArfjZbUW8VbUgK9dmPsjyxOrlLXXtDAEKOzCUtIzgvCTplDJ
	 64ghBMSOImuXMIkYiByB4zer3W+dXWrhAB9JJ9EthNKFvdkpDBlEfWO4e9k5zlFaq9
	 Mq0X6rCpphgAQ==
Date: Tue, 13 Aug 2024 12:36:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
Message-ID: <9a3744b1-b121-43d2-9ce6-09dbaf60c261@sirena.org.uk>
References: <20240813061957.925312455@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jdE9oSvG6Vnq4Mqd"
Content-Disposition: inline
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
X-Cookie: Say no, then negotiate.


--jdE9oSvG6Vnq4Mqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 13, 2024 at 08:28:36AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--jdE9oSvG6Vnq4Mqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAma7RTAACgkQJNaLcl1U
h9DFoAf/aoNFOF8n7HlwEFc3ZRglU6w+Q6pjcqnVzatsLV6nMEh6Y/0Va8MFtaas
5a25K+z/Fb9ef3oY21hXsk/ktBrNjvM9/6moVEGhpg7O8OUXUUCaMrmnmg0RVfHJ
HrRz7nAgZiCXNDQtYb2X+8Qu4rdujH88QqjVEtvuqFy7uIJ+shLgfxHfrdmqW5rP
faowu1v0yzClUdCCxITlqzA47RpkQVHfpA81atAEZOayh2iI79e/p20MOHZ6bVu6
RvrOrmBe+O/JkYz2IeMqsci26W4kx7HfGwzvSGSkYNdakiQ0RG7vzGI7UNj2hnim
rubS7dT++ovKBOotSsHusTxUnNid4g==
=u4rQ
-----END PGP SIGNATURE-----

--jdE9oSvG6Vnq4Mqd--
