Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90411B0111;
	Thu,  1 Aug 2024 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722528273; cv=none; b=ru5GPIMTjH3OvHCaP04QLTzVE3PWfMNbhSmnjHZnzAJQbn8M2HfWtas86xRnOuxSFvkTp5WPBkWTGuEhws9f61Sz+/HdwCTHZ7lEL5B6jRUk1cEpXLIylJ9lFHk6j0o0CVfRN19XAno6E2ckS/qEStzxjYELIGv8/JMO7hlsdt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722528273; c=relaxed/simple;
	bh=7mBO7lX0P5DdOz9926ZQLVSEXqhAc7Jfuzv/0EuHhy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyUCeFOrLPAsFlus7D2jup3ksgEYmnlY796YsAS/NGsB8zjdjEVLB/mXIyp5INxyMxiGkWXd3Tb4HuoI5W2sA/IAz9l1brXXSlaHCNk5ml9ut+Ypi3MparoXjwSQN1CImXbDZBnHhDgI5pSrqp4Yw0z11EAiwdVKqTlSsoyLefY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+mTCHEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+mTCHEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8BEC4AF0B;
	Thu,  1 Aug 2024 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722528273;
	bh=7mBO7lX0P5DdOz9926ZQLVSEXqhAc7Jfuzv/0EuHhy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+mTCHEHMOsMq0SZWLe1Uplfddy/gE79E2B3zevU0VZgg47AzYn0J6jW+hTTR9FkE
	 el037BeZw07qYj1Bq/hCsCDl6zgNxb9uJSbXOYnrkk/JPrI9lzmH9uoyuo//HNJ5NA
	 AcafytuPEBllk8iNJP9RePE2uaGfuPYPWKSDP6Wrx6s1cmw5s5SMBGVytrn53VzMvS
	 Pp0YJvcvZwZr66TaMYu1QzObKAyIIYoTYssEf22jfoKMguhEInV6uyRi9AJOHJDZZv
	 GfEtgyuYt8ajd1lPSkQoaxKLIh8MUd9AEOEQJbZb5lc++1A4aCwFFttBwG+xUhz9PK
	 1u/U3Sxbv4SZQ==
Date: Thu, 1 Aug 2024 17:04:27 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
Message-ID: <20240801-energy-answering-89e396d5ebd8@spud>
References: <20240730151639.792277039@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IjnDVttNKDfrVBgC"
Content-Disposition: inline
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>


--IjnDVttNKDfrVBgC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2024 at 05:41:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

--IjnDVttNKDfrVBgC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZquyCwAKCRB4tDGHoIJi
0hT0AP9NpOW/yWTJZ75+joe2RtCIA8dDZlLpftbeSzSrFEuohAD+J5qGZXwtEBxB
m73u+UMgz7WvqwagAD12XdfjUJ0EVgw=
=4369
-----END PGP SIGNATURE-----

--IjnDVttNKDfrVBgC--
