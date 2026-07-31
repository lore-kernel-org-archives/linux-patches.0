Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DAF3033E1;
	Fri, 31 Jul 2026 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785537666; cv=none; b=hhR6QQsMomlvdhpa1F4cFgFSzeIE8bczLVppLOhNh9q1RqgrvWAjAGx+0t7r9LTUw2DiliAucOAaxmpZYgowohq8tLm90+L1w1e2HlSjKUCHmxgQjXXLipLDDCDJMmjJF0UEVM47X1zH/hIMQNtpEbtHu2kWjfxp/ZZzKIvXkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785537666; c=relaxed/simple;
	bh=90wAArJuSaH4OdrE8z4RBlPSU2taBKOqf8CamWMzfdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2quhbFNijpq2UpB1SI42EH36PTS1sbfZP2b+90SwNxLghQqwJqdWjC2VkQn6kUZJ6ReDo1gG7Y4Jb1Sikpxsq2PSPrI223kp0cKFSkuho9LWuxTGnWPOOmWJykmkj5kadetpNFBUwK8Bhm73/4Sqz7oqwGAz6aoymvlzClcphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmpwOHG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmpwOHG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEDF1F00AC4;
	Fri, 31 Jul 2026 22:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785537664;
	bh=elo7NduqWJo/HvuOjPW5G2BbarDDIT0UE/VxNYgudNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HmpwOHG8wnEhuAMLyMtLUZ/hpwMYoCas+LA8+DCz9VwdH392zQOJjs4NS8pjZj7O8
	 LkgSF2v9M7i4bYDodXcfulQ5zNM/W4VahCd8h+GLzp86qKGNESPb4pxCziXlPcP2e/
	 jyq11TPfHhWSM8gYAHXjt+pud86AeM6szbCDbl7ugmlyXe/8eAnshPXq2o7N22nKSg
	 jcvpZsTFFoHYaLvZ3r0Yt/zWZJBbfVVbSXL5zCUvy/EPSFmmQ9KCUUrN0kC5CFimyh
	 FlHSCNeu9zJZ5ZcqGHMETyQvrbBkijMFpuI0SYeS3XmMulAmyaY+tzmVDlcShWV0bx
	 g1cWJadpUkFQQ==
Date: Fri, 31 Jul 2026 23:40:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
Message-ID: <c189ac28-55fc-40d4-9f09-f26e9e736292@sirena.org.uk>
References: <20260730141445.110192266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lvRS6Eu78Q7L3slv"
Content-Disposition: inline
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
X-Cookie: No shirt, no shoes, no service.


--lvRS6Eu78Q7L3slv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 30, 2026 at 04:05:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.42 release.
> There are 675 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--lvRS6Eu78Q7L3slv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmptJHoACgkQJNaLcl1U
h9C+Kgf6A7+tG4khcvnS/YsTOm7SKBSBdcS8MJBcjgehYfIR83HBIIYHfwxxcTBj
S2f/wC3hf69p8ExDitf95RFaxKVTt6uzww09jMcw8WFIrFl/sDExNqhN/J1QlwNE
HatSlZU9M5GX+GUbNIxO++q1kRHkgrKKOiKzPejYIrLD44NC9MWD8Yh8m0Uartqq
sPAsO+7X0CtkjvyfmwlC30iozJi4e3uD616CBW2DkCHSyJ2JVkhsyXovowR1XRPS
GOH+TMwjhzSK0NdldNICjFeBfSOMYMvR/GVCcCfv6Szpee4OWGY2pJcnZ2iLJK8m
secCmrypeLMGu4pJr4wUVTkRfmRpEw==
=DcU1
-----END PGP SIGNATURE-----

--lvRS6Eu78Q7L3slv--
