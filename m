Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4C93644D3;
	Thu,  9 Apr 2026 14:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775743277; cv=none; b=jHq5DwTiQe8QYj6AJHhE72ymf6NaibmlHK1bIaAWTVLAo6jHGoff8u5K5mtgddv3NG8pg1ci0gvyk30FGIUG720aAjQk3KpUdbUUQrT0ugxauRo6gxnBT1qElLtPd9ZX57rkhSIz15ljZYx7y6h9jU8Fq4qqq5oDIsliCiYMG5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775743277; c=relaxed/simple;
	bh=X+xN5Yb8f5mCu2fOsU47f+TWcmuWBXzkAFczu+BTFUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OguWPRkEchSEG0Xy9pDOLCbWeiuGtkz8/zdaM98OHtbZrb8t7QjJxPoO9pTzydjCyM+HQ8OYyHWg6mGzecWDal5cXpSXD/P7euhEUi/E5sL8d8EVLbDiMp2B46RfvnukIIQfsr466dTMXWU9RhAUAhgzi4/ohx8QMMFikDB/G1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N54qrwfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N54qrwfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E705C116C6;
	Thu,  9 Apr 2026 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775743276;
	bh=X+xN5Yb8f5mCu2fOsU47f+TWcmuWBXzkAFczu+BTFUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N54qrwfsSnvw8v00Il34AInJiLV1wGovQc3czsJQwuhbwsDRS1mWTGyK1SEdRrRUw
	 vNmZiCCIdjr9/Iwc7Olojy+2iNWpimyJPJFUKsn70/qkwBfGcQ3BIFP/ELNZ6E8WLQ
	 eB+L3SCMo+m1UbALiSNUuyPTKWWmezBt8DK9YUoQlakGicMGW07Q6cRgRk1kr6WxEt
	 4Mc4SACFOy9xILgujDmZ3xElE+/iOjbEllkUNr3ekV9Buana/jQoe2T/nfKzLG+Uhm
	 +qLBfvtrBm12FqMKMgd5OOOoNnSE5YdT5fhycIi8NTawukJqdoAd0dGno6USXpMKu4
	 R8+/nFs7XjsDg==
Date: Thu, 9 Apr 2026 15:01:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/241] 6.12.81-rc2 review
Message-ID: <ad3fc0a6-9d84-49ea-b0d7-e2512eb44306@sirena.org.uk>
References: <20260409091733.126574279@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="67aR4l631m+cCBGx"
Content-Disposition: inline
In-Reply-To: <20260409091733.126574279@linuxfoundation.org>
X-Cookie: Hailing frequencies open, Captain.


--67aR4l631m+cCBGx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 09, 2026 at 11:25:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--67aR4l631m+cCBGx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnXsSQACgkQJNaLcl1U
h9DlNQf+MTZ+6obHFHOE8bcdPu0lB69b9qn0nMZQrwS5A7qJdqhaATnt+IqE7q8V
OuE+rVk7UgcgdeJW+3UfAoBk+J2XJQmifEY+c3Bq2VU2vrvxzBqgi6B8DjjQeNfZ
VqFPg1wZF8E2hhslWVlJjhaSv7Cs5avG8Q+fDa8+NnbuvuM/FfCtvRKKyhn21Dp8
2ibitVpi6It42jj0dAy78zvgoTT6n58JV42PTap6iffLg4jb1DojwDoEYHzdrF4v
Vn2IpftIXMJlCjvjqHD6eBilYglQReA6TnRTktUkhov/4fG3dQ1sfI39/FkN9Hw6
npZ9snKBoTkpdfsb8Jo4QUsXCTOzfQ==
=3QuR
-----END PGP SIGNATURE-----

--67aR4l631m+cCBGx--
