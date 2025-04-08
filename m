Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2589E757EA;
	Tue,  8 Apr 2025 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124474; cv=none; b=UKs44OtcbvJRW4bJP2w8mFvWRXNP3TaNPkUdi03b2o2YZkWPOrTT0LoLPW+1DQUTXXdqI75Z+YDsXIo6gEUWpMq/ulaM9Lmelue9lLC6QfwaSON2SbebzT0WeK3HWNLM9ecPtg0cOu+ehF7zcl8jfJRHOrH8sFC+XTjSriK1IOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124474; c=relaxed/simple;
	bh=3ZP9HcZO7OVflAYQRdHHFT34HsHaVmTwXt5m1fNlP3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udCglYU61kcjoP7fSgS3uuKadpSvznfR/uJushWhuRhjwSHnC5bYIKyK05KKrQr+vuwAJHyehrGZnJ5lqqW/WmHcrntouAfydZIZxdaJO5YO9oEHMC+m6yHq1xaKr5yDus8s5LPMyhdXBjYUPxhIKIYq4xj1d7mDusiopr8Ecrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVBSIPa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVBSIPa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FDCC4CEE5;
	Tue,  8 Apr 2025 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744124473;
	bh=3ZP9HcZO7OVflAYQRdHHFT34HsHaVmTwXt5m1fNlP3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eVBSIPa/lj+Q4xm0FTMpgBZmexILiW/RA3DhvZc5jDh0PT1z1kJdvUkO/mluhR+r+
	 5LfSZawviY3txysWhXQ9EXxZADW3V9YTvpNqkQrBuxqNzudv8XTXqSMdGsu/LZfuP9
	 pZJXEzzAdx9aNgwQd8PtePyBht3OGgtDdnYbYUt7mUSR3E58NTTOj5OKGQd1jLzGJe
	 YIm5sLrJP5/H//GOz8Sj4zCpGuSvDEcNzlVOcgbZxmJuXubVtn1vchoGPr0Oaq9Dyq
	 ZVk/UCirvwT/WR4ODggx9tC/NPfKxZ0SIoQBbS7/Mq7fNFU0I2RbXc0EhvPiTp+WFN
	 SxvLnvLyu/IKQ==
Date: Tue, 8 Apr 2025 16:01:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/499] 6.13.11-rc1 review
Message-ID: <71339b92-5292-48b7-8a45-addbac43ee32@sirena.org.uk>
References: <20250408104851.256868745@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DQLEJRITZlVHzKHh"
Content-Disposition: inline
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
X-Cookie: Meester, do you vant to buy a duck?


--DQLEJRITZlVHzKHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 08, 2025 at 12:43:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 499 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This fails to build an arm multi_v7_defconfig for me:

arm-linux-gnueabihf-ld:./arch/arm/kernel/vmlinux.lds:31: syntax error

and multi_v5_defconfig gives:

arm-linux-gnueabi-ld:./arch/arm/kernel/vmlinux.lds:30: syntax error

(presumably the same error)

--DQLEJRITZlVHzKHh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf1OjAACgkQJNaLcl1U
h9D3UQf/dahBJASJe5DG4v5H+K3ShzsBMWv5U7crnyEwdj7KoAmpAnwVoB+CixmJ
rGG2kQ8Gx/Ej1JsJYlyzmB5w9d+HJe3jyFLESfMBAeeSIZPh1ZJAED3D7C3ioYwR
IyczVK5Y4qay662mxPDLwTcuWyqVofxsbcw8YEz25oEHoLUaI6+cCs7cZ/DNvne5
Sb8rO05Ge2orhIuHtAu02PUt+ZOzayvkFAP/t9UsHfBVI4wYOGRx8Qz8sEYlicRk
O4A/FGgcWijrUVEUJr3jYmpWwJAO4qotTKdfrdKT4cSdAfKzGfESSZvVPbB+mmuW
IhsIlNYxmsy5iBSI3aAKXJWkkDMaLQ==
=XL27
-----END PGP SIGNATURE-----

--DQLEJRITZlVHzKHh--
