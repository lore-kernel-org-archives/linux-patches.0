Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A87F2E3704;
	Fri,  4 Jul 2025 21:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751664054; cv=none; b=mc0swhsqtPcf4UW58fT2FaexUwXPo2ZhPfYo8FI1dusSu/gM7GBothQdIlVFTRSExLjtIE9caCbx3zfhjeixXLJteJOedLQ3DDMLM3ckZ9jl8CBxSGX8A0nG7eAmhB3ghsV7lcUUmRMh+FbN5IZfhgz/hQgWtTRNe5Axn9E82w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751664054; c=relaxed/simple;
	bh=tsVn3t3EzYNHIorHx9Hr5dDhvnUwb1yl2A92x/yZ7/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fR5FiSoL7kgdsCnPS5UCwqIrrYJUZWjPIeCzkwtSCGi+QHuvMzfF2BEVXoZQGYYiYEIjz3UGZhfhJjYb0LxjuEcOSSkcOI+btCpcusRyXX/gGj7Ai9nT/rZy46v9EIH79Hg0olW9wpUYCJHILqJQneb7GjQYorkp+g3FRMLiyyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCDlfm5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCDlfm5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C36C4CEE3;
	Fri,  4 Jul 2025 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751664053;
	bh=tsVn3t3EzYNHIorHx9Hr5dDhvnUwb1yl2A92x/yZ7/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vCDlfm5y7TACiS8rAM0ELBl6lApeTBSUinH8LywnAWV4LPcs4eaYTpsIb12DgLV2a
	 Hc+X3fvxglqIIfhl8Mdi3rxAvjtFrqUUYOzfMe7xgh3kQKltOPN05u1h2e4F6u1sLN
	 ESCUxeko4hnTLUb2UBmF2Ajg4Avs9fIYOncHK5NuFerie4Qr4E7yIz99luj9jxOCak
	 VBYW11Cgu4t5iFBT8G1qQWwrUGY/uy+So/sCTCQedATcCknwVt5S8iFA8qwdAHX/3J
	 SokTQJj4t5J3fF/VPxeiZmvp/XPgHCG4qc4iG+2YpUyRM0CuosQzsTQgYgAzVAszRR
	 r+aKpgBzZ+L6Q==
Date: Fri, 4 Jul 2025 22:20:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
Message-ID: <7cc923fe-ee44-4bdd-9b1e-1fc227f36bf6@sirena.org.uk>
References: <20250704125604.759558342@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+55kRTNUle8/Vhsa"
Content-Disposition: inline
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
X-Cookie: VMS must die!


--+55kRTNUle8/Vhsa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2025 at 04:44:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--+55kRTNUle8/Vhsa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhoRa4ACgkQJNaLcl1U
h9AXdAf9HvIQm9fDDBv7nhKHhSwxg7bXwivc8XZk+XFbCgogmdBmSj2Vd4Q4yiNp
l8rWBkPHFkBpXhmFirqSvCOtKJ2J9ZDo9l8t81Ha/s9AXazxxi9csDPRtmmXBS7o
zn7UbrXyJS+GN4uKg2wGd5QPTRCNbTddaVf+GhZ/2JHMvImnr+Yzd23UFPlXk6hD
i4plI13M1HtiL5u+NdBOGdA4FD9pPwQlefGfTbdA36HWrfe6AVCFt4nwlGyijk9W
yckvfV0x0E3/DKkyAqfltlg8UpEmIGCkKFmmaVp0PAlTZTy8vxl3Nb59M+uh0HvA
EIQWsx634LRG3xpKbvCHyyaP3Q+5aQ==
=rQ/e
-----END PGP SIGNATURE-----

--+55kRTNUle8/Vhsa--
