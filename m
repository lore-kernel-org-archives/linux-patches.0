Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DA222EF2;
	Wed, 24 Jul 2024 11:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819973; cv=none; b=SyhrC3sA13wrA09N7DTbb+0Y8WyIbp5zGrRgErNbLtDwcR2Hfmb5lxNyIvuKEC2l75DUFmrbk+ChgzRMJh+1ygTd8maseeNEoxZFz8ucvn+ZTYrdyrEaUM2e/9aWsC07lp4adydisH2ypSq9rcUJ1jX5wS92+YPjTGbZS1AxG8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819973; c=relaxed/simple;
	bh=isCbfLwPX6bCLW+aCdevFu2zrgTX9KdoJrXVF/kXydE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulAvXyzubG6wIqxzJ97/aMTUOFO6+TadM5QVufxBxUtjD+kxFbvP3BexlaXB6qwWxOmh6MkhEJKiIUBl28m+8wXuZA0wZ2i5oCV1fNkQ2vcKBt8xrQRCYgqJCadF/MsVkADKF8D/ISfZ5J0AO6S0d7MLMYWp40oESbYeSQngaig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/IIxnKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/IIxnKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A70C32782;
	Wed, 24 Jul 2024 11:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721819973;
	bh=isCbfLwPX6bCLW+aCdevFu2zrgTX9KdoJrXVF/kXydE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V/IIxnKT4xOBihyLWPrmGy1NSIhLrEUSN3omFEZYDgN8QXlBbobKWnzjlf/otGdpD
	 w5C4Y4F97Z5eg8q0B7LsaBeHEsNLh66A9W8LPoHRJwV1Bt/COolfPMxulC1DVXQzRx
	 /RZAAorYgPiIBumIuUvcP7TGo0cApUV+Li/rFYjOuxX7SC7v7i23FheiQGUbWqnxIN
	 cb4CqiW9VDUfaVJQs6iEEsIMP/aNrmnSsyKBRa1zHM3iQ2zvOL3Yw4GGjHGTMq9QL/
	 WMDPhoWSxSmgiPYdlyUMH4/3zC6zBB6WAkyjSsvgcydTXb2hm6egNuc2TbJNcTXi+n
	 RlDXsMov+x5pA==
Date: Wed, 24 Jul 2024 12:19:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 00/11] 6.10.1-rc2 review
Message-ID: <d0c7edde-3bb4-4762-8402-ddf80c58641d@sirena.org.uk>
References: <20240723122838.406690588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sfwPQ6n++WnCai4j"
Content-Disposition: inline
In-Reply-To: <20240723122838.406690588@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--sfwPQ6n++WnCai4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2024 at 02:28:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--sfwPQ6n++WnCai4j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmag4z0ACgkQJNaLcl1U
h9Crogf/XmW7HeqBWQqkNq2pWRLeRqqRniHKaGPK4Y0jeQg0+fNNQajndzPz7r9B
4WhJtlK/DcItB0w+ZrxghF6U+9dIfSlofXufj4LGjqTDCfSX3TAfXPgaLwLVxcXy
SJE10HRvBkLbQNz7DKVLmHHKqwIDsSzHRgS0aajIWoetfFiYwtfeHt4LBa2cMmAe
3WZz6uwns1RtB7DfEvkWDDi+p25IejU7eeg6h0enFYQQv8aBTWIjepI96s8oQO95
pVo/Q/TpKt7pfOOhhn/J9kjOJO8bw4hzfBeneXlRTzeWMMY1VIEf0hoNfqi1e0MK
O0A9mvGvyusUZ+D6ZPiLupBN9oBInQ==
=A3Lk
-----END PGP SIGNATURE-----

--sfwPQ6n++WnCai4j--
