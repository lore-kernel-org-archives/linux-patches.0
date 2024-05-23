Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C371F5E6;
	Thu, 23 May 2024 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488266; cv=none; b=QNSd0+DHI2uT5L9T8jjQdvorclYF9m7QpYBAdP9/rNvGaTOrtQjDB+ai73XZ+vON63yONBASwU8s65QyZT7LTC1B7Wqo2GfuUgWPc5b1Hx5b2WZIDFPqUXJhGr94zf3304Yb0lq9sb2WgxutRHg+a8+dkSSX3n06oV9t1am7wgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488266; c=relaxed/simple;
	bh=vkmu8UdhjhpWVEKlTSaj9k5P8vzkcX2lC7Mak5DtgCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p0likR4c+3RJwFUhCvRGpwh6xBcvStb+IJG5YKLNq4GPIYZgjcmdIdKKV54hDhv51ADTIDyoZgmOX57oRY4zNZrGj2gPboZ+hpbX6Ea7LpcsmM82BunX3+CIrcU0Tlk3XgJeegIpmFjnuL4s+UWboCJcHh1uQbZD9SMahKEul8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ylqv5CJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ylqv5CJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16E3C2BD10;
	Thu, 23 May 2024 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716488266;
	bh=vkmu8UdhjhpWVEKlTSaj9k5P8vzkcX2lC7Mak5DtgCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ylqv5CJZODOS1H9oM5VozTnMj6HwFN2/ABc/ooj5kfJF7eLk3AAJVxfquw88Q9dT8
	 lMflZD/NWbxeqsc9BHs8pNqlDAfcwEde+8zTn7N1I+hTPPn4jSEA/bFMBO8cEI/w9D
	 8ZanFd5YegOW22sw6rVFlV4lZpXUCJEcBP/a7oDvqdy4Rxl6gwC1U4xxHRpeahOHq3
	 fRikuV6/+Rk53p5LrK0fhfuC2wUFGE+pcoQvjJDrREMJsEzefX+aAzsNuzKkiYc2i1
	 XxgF7SSfcHR95Z5vd2TJ58zhJvYH+TFyMY1tzWdUrnOoRpaVxnUn1qGZDo3ga5QXlZ
	 j9anWfjXdqs5A==
Date: Thu, 23 May 2024 19:17:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
Message-ID: <527ca1de-fa0a-4375-828a-466c953280d0@sirena.org.uk>
References: <20240523130332.496202557@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wIKOMuHZLj/TNVKN"
Content-Disposition: inline
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
X-Cookie: You auto buy now.


--wIKOMuHZLj/TNVKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2024 at 03:12:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--wIKOMuHZLj/TNVKN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZPiEMACgkQJNaLcl1U
h9DPBQf+JgvaVT5hPn6U+9b/AioemShAil6OHDcaEgs1BBRl0hZEc0fcNVIxeyGz
/xdtCKCPX1pLBz1JgiTwX02sLUiQd5Wj7xaVlzMEFAfvBCdQH+gt6pHhoUTn6msd
0H2LxciNJtTXCW3IZv01v63DxqxZyCmqc30/eLaGiKhHsh7UOIr5PviOY9kdblrl
4aTfbc4PiSe5eoXdiXHt8aa5oZGICPI2j6AcZloRbeiqY6Rj2vKDtTQWYDZQQFPz
fS7Cv9FMIqegwInp/yVfH3nYLqlNLueZzANuorV3+RTPVlMbIIuvqEt1COP/FD+m
kBgW4U+veOsoEBkt1rmQ4ZAhBtjalg==
=n+Xa
-----END PGP SIGNATURE-----

--wIKOMuHZLj/TNVKN--
