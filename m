Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502E627C172;
	Wed, 20 Aug 2025 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701369; cv=none; b=SQKvF5r8ojZcPBySOequC4u35i28luHehTTmDyiMllNrJfu+8EPmMjj066Cla9q9Erd51dmDxYz+3MwYQhpjaHsT2ytC13sz8x4hP6FZEz58mOOGaur1u2dDb04S+MMS6kUYCJRnOBLSYaL6io7HIMlJm1atKDiSWQfb4f0Zd+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701369; c=relaxed/simple;
	bh=s4nfPVcmRasmonPqk9vuBP3hp3Ub1+rC9rv5lAJPRXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhHJerSmUknFBig2rh9r9j7a8X3iCFCJLpGvRBadcX+Mf9BWTPwjnKKysBUq+j5lchMxLEd4F1F9WK1MssqVJsxUZFtCbmkGgzpjKvUnx9o6ubeFL6GtHYv5FonAA77Fn2e1cTf2/nEx7wHIScGepNk62l69fntWVhOJ9qd79rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MoQN5YoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MoQN5YoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D18FC4CEE7;
	Wed, 20 Aug 2025 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755701368;
	bh=s4nfPVcmRasmonPqk9vuBP3hp3Ub1+rC9rv5lAJPRXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MoQN5YoD8J42r2+gTZqLn7ai82q7gmANDIemUe/34LL2njWkuR5jacQ3CAlPSEt1A
	 dr6/3xbZFKpwPYx+zgBcY6i5VKPDC+Mzc02+5EoFJLquuLz2LR0MaojQV8f+sqZxK8
	 IPWccKhmhamkgSB8rEsujgctaZNmnAcciJXM5kUbmNdTc5HqzFNuaICwKj9gEqzS0P
	 sbhnb+CL96kKNGstQYqV9YccyUCAyh+g6mZQnfZtpC0mWTvEr5o7L5KRgbtZ3QEDj8
	 52syNAyoAaGkpwFP18cD5V6xZK3q7PnWTYAQRI9HOUXEcPFYrgC8CuwHo65yrEp8uC
	 baR31anYnSFTg==
Date: Wed, 20 Aug 2025 15:49:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
Message-ID: <3ffb80be-0e86-44b6-a541-deeb80e0d31c@sirena.org.uk>
References: <20250819122820.553053307@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2rtn7fN3L1c4hhI/"
Content-Disposition: inline
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
X-Cookie: Semper Fi, dude.


--2rtn7fN3L1c4hhI/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2025 at 02:31:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--2rtn7fN3L1c4hhI/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmil4HEACgkQJNaLcl1U
h9BtnQf/XoHCUiBo4ifsosMk4RimE0HL59Aga6ixSDwXwA1KEghWfP0cRkMlyfyD
HpXvYbIVc7ZaVdWAYVjeExfPgMrwnOKUNYoSy51fsIjvn+xalXgKWD4fT/aBi8GB
9yGjWLQxGJiUZDkAYYQw9+O2vnF83den2p9u8Y6YD+rqJf5dpdQwEqzNl0HWJbwe
FjYbJN8VoU0J0Ibcs2Ci60z086MqDW5qz8tkTT1594lKmQY3+6JgSoqzrp1zXc2n
1Asc00bsWBw2uQWpzA2C8+XOf9G5QmFKOyEu6a0lBpIUuN2rKfSb5AmC/DRlkTyP
WSeky3F+lSjV4yEGH/ZVZMdRQWZceA==
=hX9B
-----END PGP SIGNATURE-----

--2rtn7fN3L1c4hhI/--
