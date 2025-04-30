Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91E1BF37;
	Wed, 30 Apr 2025 22:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746053222; cv=none; b=jyfSAG0CNsbgH39jsTJ77KAfnUmjIN+4NLUFXXQnLNoqC7OcDrWtK42PWNe3d1tPtlt/OnV3lo69IdL67ctLtc7VqiomKgabsG5s5VyvJBMzYIPFg5xubCUG4sGBC3QhVlDuOfq7LV21q9nsbfapuqF6dmcocYgTou9Qf0TH1gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746053222; c=relaxed/simple;
	bh=CwfkAUiuzZvlN957gh6ypnyichX9ie86L7EkHdO2kVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsGdwvW57C8sf49qRnH7/IJwBT8Ns6paqy//x3oowshanVuGYTa4Ksbs+fmD9tlx/TK+Ds/lb3pmYc9qE1tPbGoUZOkZ+/PtFa5E7JhZBKgsa54vSntcGqIo2knvOxjBQOehVGXDem/DTEbExwLaoKHEb1ASytTShOD6mzmwJgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjDEHKZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjDEHKZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFAFC4CEEC;
	Wed, 30 Apr 2025 22:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746053222;
	bh=CwfkAUiuzZvlN957gh6ypnyichX9ie86L7EkHdO2kVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjDEHKZ9dE+oao5m0LEtahDThT1r8o2Ll7Z9JsX+ffthyJEl96d663YXIUqALNoNw
	 CmDyBhY0Rg7TpVfr+5/WoJuSxdvqk7z7365eulb7CayP5duK6dhhCU30zNQPv9apWJ
	 y6GP4NJG/u9J58Q3fyDCXS94jNwTPikApb0O/4fApMIlAz7or/7ptuIb7AHqkNi4dP
	 2wIjJSR6IUH85G/O3a1vc2jm1RLP5Mb382MiBTfs/FrUIhmrs7e6JPRhkTnRdaXByl
	 14/HOTw+ui6mA2uENaJFpva/4BlwutkhraD5xTsaj9Y36H4HuK8sbsZ3B229FzRKf5
	 Is54JiyfkiqJQ==
Date: Thu, 1 May 2025 07:46:58 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
Message-ID: <aBKoYu0bBSW1Me0G@finisterre.sirena.org.uk>
References: <20250429161121.011111832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MuThMWEnSRQ9pTtx"
Content-Disposition: inline
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
X-Cookie: Well begun is half done.


--MuThMWEnSRQ9pTtx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2025 at 06:37:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--MuThMWEnSRQ9pTtx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgSqF8ACgkQJNaLcl1U
h9DLZgf+PJ37oHPLUlMfHJ/vpvN8iDiKjynOg6/UHzyDYseKHsW4W3PIfAEG9eTg
WXxvnxb2Gb/8WWvyNFdgqmVQcSkuBVHWtrVejt8vd/CO+RZzbjeqnjkLowTlIOku
aL07ULXlR0ji1rbhPhJ+j+UHVV92jse7OMNWk06lBfCcQFMyAYXeY4FhZI+a88sU
28B23vcAlawMFTVR+dwhTN0U3ZWdZbVLrfqwhs6WyGlbVeTr7gy+cF+gmbNc262R
VE+2irp2t+RUNKTpLemwKYR2hRGdRYKY9XR144MKsBuJ5bPmC2Bw3x1jTQDbxUeK
elb0HYF9Z2GLIOenTqMSJ4gJCHtPOg==
=uiKV
-----END PGP SIGNATURE-----

--MuThMWEnSRQ9pTtx--
