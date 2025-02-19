Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF7922CBF3;
	Wed, 19 Feb 2025 23:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740006513; cv=none; b=LqcnpAP9GUUtFfnxp1yEp/LKns2YXCY1pATD11mW9cEAQ47Fs48/OPz4cNKMqq6oKZut3rDsWsm+sSwhYCNC3wPK964RaQU7BrWvjbD/O1kqpGr/2QkRWaedZl/IO9YfxUlrI7KwcBmiJUUKT8AQ/I4k+z+X/MseQPIYj3HTBQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740006513; c=relaxed/simple;
	bh=BH/GLFhGLoZCYmEE8Mgf6IQrLeqLjEdmIth5bY44zBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bx8z7387KdtNqHQAyvUoLT2KsbBoVfBX1wURyVCZuu66AXQzZRcOAx/qMNjbwfPF5phks/mxPxD/EIpOj6khQTpia2/L3PTAS4mrMLJD+9WUcjsuhwpAVYg7JZoeukazursca8xuEqUAvuQRR2HfJFlN0EW2Ih2+JxSJKs9JndQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFsFQas4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFsFQas4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37CFC4CED1;
	Wed, 19 Feb 2025 23:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740006511;
	bh=BH/GLFhGLoZCYmEE8Mgf6IQrLeqLjEdmIth5bY44zBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OFsFQas49lmKOvqnkxfJpzjZz0hCQ0qX7cXQQJwR1oJ9HVa4o+KOtOmpCq74R9ckQ
	 fsGEUYk9FIQtWJHMgpDdMNS7oNiCh4151sghqJ32lVkROg4UsRwbwjWNrkOcw4ZO3H
	 m7oRAdTgo1T1YTqCWRvwYwY4w4EsWHKOYmC323gSe46d06vqzLjjqtUy4Vc8G2hcLt
	 hvjp0oghY6VPqsEzP0LRn8zFIy6W/lZy8dqJdSl4x/xs0XQR7/Z7E7KW4jWQyI7d3S
	 jex1Nej1A9EbPF5K8mwLEyvcl8i5wcw3GAWxpNmHU1yCsdqPMffmxARHvMawE3gLe9
	 vaoxRo9x+TAoQ==
Date: Wed, 19 Feb 2025 23:08:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
Message-ID: <Z7ZkbNSv3YO2cgwR@finisterre.sirena.org.uk>
References: <20250219082652.891560343@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H84hluUwDrty67/p"
Content-Disposition: inline
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--H84hluUwDrty67/p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2025 at 09:20:04AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Reviewed-by: Mark Brown <broonie@kernel.org>

--H84hluUwDrty67/p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme2ZGsACgkQJNaLcl1U
h9ArHQf/Qx5FD1MyE1qwKzY9mvKIHqERT08fPL+NTMgRyiw4ObQsk0ODwJtaHwXp
tRT3FnFskx/T+6KNQnwfX8j7Goqt80j2XhfbAkRvwNoGKpHX2dr19u4baLVEQNy2
XsTeKrgwPtb4ER+j6MxnINkFgXDv6+Ew2E44P5RM/0mcr1GY2YhwJPD+mIAH9ZLD
4ud0+hECYiSWJ9L8wm2d/Qg35zIwz0hTLgWU/s0WlLbh0IT19ehj1zVnwO1zSrbJ
vla6aoZKYJkAs7Mc0vPNgZsA6UXDigr22ueYrLF0iZmu5UY/pKyVEdzZ1t6tGVYz
uch3b8q7pHvWAsz/eyPHowH8SUN8hA==
=WsbN
-----END PGP SIGNATURE-----

--H84hluUwDrty67/p--
