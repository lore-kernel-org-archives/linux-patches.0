Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A659237CD5E;
	Tue,  5 May 2026 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777982340; cv=none; b=PSJW2YMG4OIsV5NhaWli5fHF2zbKn0AkCgj84mN5w8HeJC285+3KHzT3EplYACjBedu5+QakM1g9Naga7DfAFwjJ2bcmHxNrMMhqoE3fDC3fX5Dr+ExS/1HTUgOXwaXGyiAX7EE1RwtyXUmPqc0FRu7jjFU0oFfTb+vFCKXi3t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777982340; c=relaxed/simple;
	bh=TjfTnidfflrxMf3b6EDtfmJYplXxIam76T/lXVeSZ4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6jfAKrvhE6NLDk6VPGtn90xQ7K4FnA/XKFT+RVMMAUH82HJkX8ore75h8lKpBdevOKQQHwgw/zlkou+oI7zlJ+yoFz5ou5NJbeB675X0D6KqzpYbrKGug0dnd1ecbk0lbODZCqKG3S77fgN+6U9Nr7Ze8lE1kkanFtC0MdxrtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VATPlcyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VATPlcyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25506C2BCB4;
	Tue,  5 May 2026 11:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777982340;
	bh=TjfTnidfflrxMf3b6EDtfmJYplXxIam76T/lXVeSZ4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VATPlcyKanjQg4Ws8pge+ie7G6uEc+P61Ot9CPfOilIROk78F6+txIwnsQ1LcMTeW
	 yGQ5RXYMrexhy2ZrFylfznazOvZNdoFR+7e9HW1aqLQRMja+8lbNhcaO9YQCA3gpKN
	 FcV4j2AS6X0yuROI/5oPgbf6dlVGZEEUCvB6jxRVJj2Jp+SdcH6wDeJkMYGY9E+RPS
	 cp9eJHODcxz9rm0xQUPtmUDlohUsUGnH/R8GckbN7M2JCtap6xnFcC5OByeoeacYDr
	 jMWG3f3stCPahBSYu2xcq4avZJ8B7hN3MDM4Es099dndaB7kGL+HzSX4VU9fNXQye8
	 xmoIyQVRhpKAQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 86F0E1AC5871; Tue, 05 May 2026 12:58:57 +0100 (BST)
Date: Tue, 5 May 2026 20:58:57 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
Message-ID: <afnbgXNTLSkVcRq-@sirena.co.uk>
References: <20260504135142.814938198@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Oxxqey9RoXKa+PnH"
Content-Disposition: inline
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
X-Cookie: Alex Haley was adopted!


--Oxxqey9RoXKa+PnH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 04, 2026 at 03:48:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Oxxqey9RoXKa+PnH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmn524AACgkQJNaLcl1U
h9AwWgf+OiT1CCRJcCI4BA5dAYeU1MJiBa5R7FnEdcLm9dbCvNHhcRWJyxtNor/s
gmSN0zKt9PAtXhT8HHTiUXvKDfO7J1u6B5OP2G7Lue7bG5vWBwhy1G4FPIgdYjJh
PpNU7bj8gaDmXpjO1BH8VACS0GqvHApLsHjQgMPAr1Oh0dRMH76UHTvdGjdrclc4
aTQVpjtPw2TVV3mwntzG7YE9H5zWdQ9xhlsm6VhHXyx9PRSyno2CrT7sSLkDOeKd
B0V85BgB85D9A9vkjsl6snTAGlRJa+LUWo/KmRivhjOvUSGh/jeixz1pa4+dffBG
KXUPdivX7IwRrQyBt6UooJirnf19Qw==
=IH3L
-----END PGP SIGNATURE-----

--Oxxqey9RoXKa+PnH--
