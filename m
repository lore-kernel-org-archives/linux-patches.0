Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1692145A06;
	Thu, 16 May 2024 12:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715861013; cv=none; b=UvLlFv0luLKLJPelgIpt6Mgci6GHE9ddG59ZVkicJLpFKh8THwia7LNxEv9BPkok7IdRIcOQa60ZLoRZSz2PSGsaR01awy7+fDMLRzNYxickT9f3RURunbPo9xAfOXjqKZpSqvT5tbNJtrHZNWaUMBapVRC8uEXlq4+CvxPeuSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715861013; c=relaxed/simple;
	bh=dg6kzJAPjiuh2fIwqiqDebaA+cAJh3JzkSfG1x0+Xq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfSCJ0TCfdGHr4wtmuh2FNaktqp8uKNF57ox5+i3xKppS4M6rLvu6IdDrLjfOfoyLCtpEofF/EZUg+lPlf/GKJZpb2bdFk5j/rwsrOh4U5b3nuudWLmr55v19zhtL0viyPxwAWwWdsGbxRAuFXDeSuh2f7uNyoJx6POf2xve8jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hC/QoI5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hC/QoI5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9005C113CC;
	Thu, 16 May 2024 12:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715861013;
	bh=dg6kzJAPjiuh2fIwqiqDebaA+cAJh3JzkSfG1x0+Xq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hC/QoI5gIisaYfXB9gv1f0UEWPn9oNmVxkOEApp6Qnh8lQwQboocqcfk4skv4Z9m2
	 uNI4xlAG2E/i7Pa1ZMELDah8ba9KiYePPInzbpsqPAarKNTGjKIcvpah2DjpuW8asW
	 LJuvI7/yiOulONHQkGW+K7ZCqJAftjrkXpDP0UnG33WEOZJp1waADYEWPu0Z5cKnSG
	 4GyI0kNJMq7YXeXw+gS9pnfS2EVgOhX57e0e+oO7BDiymwGXGv9LbAMf5ZT5EHvcxK
	 w4Hh23hOkP8SQgOXTcSIF1Vk5nEiCo4XXwPXOFMc/+qDWsTD7+crhml8HbuDJuamFX
	 vH91Yc6l7tXAQ==
Date: Thu, 16 May 2024 13:03:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 0/5] 6.9.1-rc1 review
Message-ID: <d29a1fd0-2f41-4bb1-8b58-3247e3c78fcf@sirena.org.uk>
References: <20240515082345.213796290@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r6DbF3qCc2Bch+MR"
Content-Disposition: inline
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>
X-Cookie: I'm having a MID-WEEK CRISIS!


--r6DbF3qCc2Bch+MR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2024 at 10:26:37AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--r6DbF3qCc2Bch+MR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZF9g0ACgkQJNaLcl1U
h9BcfAf+IbVHHMX00WfhtJLpT3cfR3TbLPPQt9ylUUycotD5fVSakrlP1gwrzc1e
Ne+2H8lXkh+Qzj6LF3d37fMIUZoWaqmPdt62hC/Vjj7WXNI4tef8Vyv1xzrwtVPr
Vf/g5+oUxXJoqmghktEjDcoCD7w0BuUtZ+/mCuLWLVCLcYiFwTGtAB7tmeNb/cIl
RZph9izFSJhvfWVJNac/zM3y8ySiyeC2DAh+nGm690KpkS1tyCBhqafyVijFWg59
jRNdID6KecNseZevmwmGj5Z4j1RISwZgKPYpO7tPBpSYMvmDCni1yZi1MBr9Qxlu
s4wMqosFx6JEya8OX6uTVAp8wvSpAA==
=BCmV
-----END PGP SIGNATURE-----

--r6DbF3qCc2Bch+MR--
