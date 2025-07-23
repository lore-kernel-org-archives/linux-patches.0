Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD986F06B;
	Wed, 23 Jul 2025 11:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753268533; cv=none; b=bwUUH4UR73nVXQVti0GujaPuGAxesJ2BQlxrQmdPAuGw6p8CElTsqQeFQxUdQYlCmhF62JTHdx9TWygmtl/5YAHez3YH9ocIeHoPUzH1UTS/gHo931jST0bIR+zhHaTXCa8V1h17tNMyKil501TicElAcFA9ouxur8mvxM15QGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753268533; c=relaxed/simple;
	bh=LaT7cA+iyk1oPEdWl5VtmqfJPqA6DCrl1b6+wHyTu+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMIGrx6fcidbyYkECVZFLuMkZrhLthlxdCuJRTKFw0Hr1SxlF1aq765rWC8dFEAlbAGcX90y03MCB2vyiYSMhfPliOzY0EBsPXr9AoxT5ueq01LcvsAz0i2mW7VBEhI8bL2cSCJnz3mcJeYdA7aiQ89z263U3lXihH4D2G7HB+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9222nLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9222nLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1519C4CEE7;
	Wed, 23 Jul 2025 11:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753268533;
	bh=LaT7cA+iyk1oPEdWl5VtmqfJPqA6DCrl1b6+wHyTu+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9222nLDV5IvGxuF8kKeGPMZ3QJ08xDQFdkhKSXUtftm4+AO/O2N0MhJ1I8LBNhnU
	 2CggaG4zMQyzYKG+z47qdiHrLx2VJ4csgXSDKDgYwytwXgNZA+7PixoW4TiZFZQFxD
	 TsUfwfBcBvAxjLBVE+eSUrQPKveg2nu8UU/Wvn+3Eg5mYqWBRNxq0MArSTBu4D0Dkq
	 6Albav6Obmmjp/JT+71r8ljcfzfJHddGjpGAW9+l2aW0iWV7LXIlSO4gVE2LFr8+ny
	 ksPytQonyt22EU99q0rMsJi+Juqi8XICDVPKN73xvi6RajPyWMUEYyzwGUDPhqjnee
	 1rmHLsaknojUA==
Date: Wed, 23 Jul 2025 12:02:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
Message-ID: <fa525e4a-923f-492a-b1b2-a80b7786d5b9@sirena.org.uk>
References: <20250722134333.375479548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XTHbJhPRCo2wXQuT"
Content-Disposition: inline
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
X-Cookie: List was current at time of printing.


--XTHbJhPRCo2wXQuT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2025 at 03:43:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.100 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--XTHbJhPRCo2wXQuT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiAwS4ACgkQJNaLcl1U
h9AdFQf+KSnVpx7R5bEQ9uZzTT0XPWAaUWLNc+V41dpzJ3fFdw941hg+IoMaknzX
4irVk729zOuhekk8YfT90ogBtDSbW1s1QRt2IoPLsXP3cxlBkqI4+iLt6GMoYXpm
i5FN5PNF607xbtYiW3yuJBYvXBV+Gzb8ipA3o1ycPWfoP5yy9LS9OIASKSRCckqU
9XhlApHXPpdVrwpDBlvRl7wTLZDD+I0+ne6eE/950c7kyShmBG1uaC1jmwajwdXm
VVfZdhI1hZTJerZziZqL63ssMrrgxK2dOOn31M0SwyAVyDRRsES3kj/GGky2eRWo
ZPDiGqMYQVVr++uCrUMweBG12mHoJA==
=ypRt
-----END PGP SIGNATURE-----

--XTHbJhPRCo2wXQuT--
