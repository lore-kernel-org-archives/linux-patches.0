Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47C319B3C5;
	Tue, 22 Oct 2024 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729601902; cv=none; b=uifLaUWQBSZpMFvzikVaeSPBTuzv3pO7T8YP/RU9vOpROGmYBn+8CmHMwm6ETPLHvbPBLuLtrqnZPs8SFxXoFySJikNjrhVDE/anDl6AB7lOHFpu4O9v5jxuaiouTka2B1EMIUGglAxzlEgmQ96oIpyfhk+yh1YNMzE4ICWPww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729601902; c=relaxed/simple;
	bh=gzn4IEXSajhwhtGek7uMizTqEY+fU+WOBbbTf1SeaZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AorTTu85lr96AycO/qtA/ey5+rAEasDfgf1TDvzAhgElz/lTAZTSSlnnQvBSITatNqXe5Mqw6p2CfjWKjnuoqpHEgY4RXSAQoBaihEw5X/n62w2yzAjUKCI/jRrZ2bh6i9dMCxvfMhwF1uKKKVYyc1UCzgEa2yUqOKRShRMcV0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lovQ70u2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lovQ70u2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E32BC4CEC3;
	Tue, 22 Oct 2024 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729601902;
	bh=gzn4IEXSajhwhtGek7uMizTqEY+fU+WOBbbTf1SeaZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lovQ70u2br0ZYsv3zN5oHC57Fw2skI5MiEKe9dvw5Zt542MPzYwtp2h7FR1tTcLNg
	 qXGW4NaYwQBkLJSO+pQF2T6YHU2V7sq8UAJv0PqhL3Iqn4kdPuwD0SbMcgzr+5cmjv
	 5yKrQFvtdoAZjOtPpaythfmIF1KJdBZnB5/+FJ8hMRFDNdDckVRa5zCkjgKWdV2Se6
	 1ve6q88QdD3oKJWTCf1hkM0tuUlSSfpIwd4Op3aMUeGeLEkAMhv4d4zlh/H0mNzLdh
	 +U3f+iF42rQ7hMG5lUEw2nLZY+VsYlG5rWWbW34zYwfFwjZr0CDGgkO5oSZPWCuG/8
	 tc4/AlfmF+fEQ==
Date: Tue, 22 Oct 2024 13:58:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
Message-ID: <cd66f6e8-637a-43e3-9cea-6d2cbe76b065@sirena.org.uk>
References: <20241021102259.324175287@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gfUhzPpWCCshUa+5"
Content-Disposition: inline
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
X-Cookie: Surprise due today.  Also the rent.


--gfUhzPpWCCshUa+5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 21, 2024 at 12:22:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.5 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--gfUhzPpWCCshUa+5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcXoWYACgkQJNaLcl1U
h9BOewf9Ehjy2yPDVfv8swuPSBgb63LhmeVEXYZMCMn70t1GT4993RFW3nt4UkEI
XkctgxWyzn4t9DdHFCUZcdIX1enpZnHW/8oDJs8aJYrwsN2jKofVVUYWiDGy1H1L
Wga1Wo60NDlyMTqkCRjXYVEKhap66TdzRu8FoUNQkbDVQ7cM0DFEg87oIXwWi06Z
sIExG+HSQpj5qtdmQuiMMzUThd63wNlRZMAsendqdbYPwa3czywWzlVxooFfnpWk
NDWgSX/eLPs/PqV+yZxEZ6Jkux8Mo2Uxuf25NaJegFC41sK3inDMt+aaicM19OBf
RMDnf93S6cET1Noz8NeJNUCYfjc6fQ==
=Lhkb
-----END PGP SIGNATURE-----

--gfUhzPpWCCshUa+5--
