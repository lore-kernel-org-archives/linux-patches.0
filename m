Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40729824BC;
	Mon, 10 Jun 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718029449; cv=none; b=ImMt2y9rshNqhS0Kv3JO84h/9WaTr93F1Dnlip/Dl3Yt+gGrL+2HNMvpOoYefe/tX1KuX7tlEt2lxfPnbMx592UF75swJn597hyx0IkToD8RArkrCL6gle3p8KHcPP1JGrVpCpc8QXR5ESa17hGwlOdsJSkAcEcJ8vc2AVDgKsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718029449; c=relaxed/simple;
	bh=CkUwTt47GLouCYj8pWf5kGXAZnUE1T961KN130nzjtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N86Cf6/8sRPMzvfK4FXCEs0npMYDZKw8eQN0MPlm8HRIQwev6KnldQFzgNBcsTahyX6P+G1WHLFyngVXvhgi3R5Yfc9B2OZ80j9DTQJi9uii9vVjWXF7b7panasS8I7OThE/Y0wDNB0F2gBllkqeXeqJWM7i761RHCoOkT7H6uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upG/xgHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upG/xgHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C9DC2BBFC;
	Mon, 10 Jun 2024 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718029449;
	bh=CkUwTt47GLouCYj8pWf5kGXAZnUE1T961KN130nzjtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=upG/xgHVs7cGo2/wqxqdkh8fOUPpWKl5fy933KQpxUsEdCudYWfjzv97/ge4Ej0uK
	 2WWm5ASWIg8YbR58ejP7syzfoMRgNzsRRYxM0SzN4sRmDvYFOM+CYgjQW8oSd0EUBz
	 ABAYwXEfq/jZGJzuq2uyZmvbuwnBm4JasuvVhqnXTDwOxoBZH4nKx/AuT1ratMQX0L
	 6CPO2Cz4lgo8HgKyRX307Kf+mGn8k1s9k/F3tS6OuebqX+EWKHDzJxZQVcTGDAE3X7
	 IukgRZ7KU8zOZ0XvcJ/17Xo2LsNawbBIXcn5xRwTlTnFvh3YtHwPuXNJqKL5m2kVut
	 h8osqvEqtaf1w==
Date: Mon, 10 Jun 2024 15:24:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/470] 6.1.93-rc2 review
Message-ID: <ZmcMhUoDivrsanoC@finisterre.sirena.org.uk>
References: <20240609113816.092461948@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KaQkTlKc3VFPOLdb"
Content-Disposition: inline
In-Reply-To: <20240609113816.092461948@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--KaQkTlKc3VFPOLdb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 09, 2024 at 01:41:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 470 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--KaQkTlKc3VFPOLdb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZnDIUACgkQJNaLcl1U
h9CJWQf/YVAg+ZkqDoMO9WeeIgDSLYQx2CDQAlfCGZ2zUtluVpPdYPwaahgalIaJ
YFqJPpHaKz61eOjWzNZibL5z6sTDHvYRC/PbJTt6snXTiP1pfNwhtcVxOsVnxDyF
fmstcavklHxWr4+1ILAxbFTu6OwTHjbOzEzmzuB5TudLBHmfM4Pq5IoOnl/C53gX
2HwVr1I8We4dNqm6dvHYe/1ripyjghAwaKgzdnGTzb6TGNS84rlaHClVQjjvqmrA
bK/AF7cBgY9G3q3agsiKyPcrgEDrSFNn5WylZg/DqSxEYy1mSWuDaw174UxYPPTI
bU2vGHqlkfi9jx+m/M3A15kQEudbaQ==
=4lJO
-----END PGP SIGNATURE-----

--KaQkTlKc3VFPOLdb--
