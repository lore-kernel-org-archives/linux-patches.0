Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75D12595;
	Wed, 24 Jul 2024 11:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819417; cv=none; b=qlLwdzPXc0tFMfcHaZudoGy3x/raw6gQcxtoIvKGsFHu+owuAMcvHKSgPAmJTnPrGe1BeXqbN7zXktb6nX0xl8jRJT65pBZFNb94pifVES7G5UgZMPkzKyB/HcaXX8526kHlv0GZKyD7coZZEhJJ8p0JPwr66eIEfCLpFOtj4Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819417; c=relaxed/simple;
	bh=x8t9NJOWQeOg+i1fCluInEfANgGNE+EVU7axhsmh+4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOZTa2ckLl7wGKuPOFd3hiR3NeZB9TqTEXbIgeTS39jh9GNrDxeFqY6R4x82FY14DLimSo+rxoBwaZcfePuqYI2JFrLrANDBIShHXFl+cws30f+GV9o3C9cRRUcFb6VWkwNoc2P/46KHKUQiGq0rpt5+itcwUY78EtCVnZB0Upg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=psh+PebM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="psh+PebM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DF3C4AF0C;
	Wed, 24 Jul 2024 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721819417;
	bh=x8t9NJOWQeOg+i1fCluInEfANgGNE+EVU7axhsmh+4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=psh+PebM1ZjbRsJBHDv9p/19JcX5p8e4nZhKfbK4IywdOlBd3wOI5E/8Ya+9IznWR
	 aGOjernpBrxVJLIO6jjRK874mgR0Pgpyi60lvb/S//dLXTSP51wOUGv/C2fg5KboRI
	 rF1kaid2NTMQUqPet6KT+QkMUib92ARDlmuWu3hA/7hVD3phiGX2uyaz2+3RKqfScb
	 vCDyF93GiDyHiS6AFzntj3Uu10No/ahuUeMiFFefItnAcR6VTeVwOJ6IDw+UI9NeQM
	 EmNTTeKCBCTwlfruWlvOxYCQG0BhwaJ6Lij0Ii+VSO0usUQFQs70hV3v8OHeDl1S7c
	 xB+8p7t8sbx5Q==
Date: Wed, 24 Jul 2024 12:10:11 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
Message-ID: <20240724-dollop-dares-dacb2a8838a5@spud>
References: <20240723180404.759900207@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uIbSGgagEDmYS7/N"
Content-Disposition: inline
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>


--uIbSGgagEDmYS7/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2024 at 08:22:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

--uIbSGgagEDmYS7/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZqDhEwAKCRB4tDGHoIJi
0rHDAQDOV5kiR+qBRvGzreeok/G8wDoXtf9awtzOIVsl/DNUMwD/djOY2nc8H6f+
3n1kRbVj8IU/FHxwQAb8oRz02SAaVQ0=
=/mhP
-----END PGP SIGNATURE-----

--uIbSGgagEDmYS7/N--
