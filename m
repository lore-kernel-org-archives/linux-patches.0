Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FFF15D1;
	Wed, 30 Jul 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753893091; cv=none; b=r8jI7wPfN2p9khV0VeW/l66JJrbNiO+fQ+n5lgN5MF92VMpqYB3RC/noReeRSuclIw8SipzCMunhICev/4G9dabrbFYwW74mGExPEANU3Oo4avI0wKxjzth2nSIgcsS4HpErDDGUFHFx9d3/Er8a3vLV5Zw+H49vagKruQz/H24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753893091; c=relaxed/simple;
	bh=I3nM6qDUBoQLr2eBT1iD5Mms+CpVCuZm9hCSckIRaEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oo5DN0BTt9203t0R8O+jRKKiPxVCu9qKVZykLo8vn+AxO8aRGwzNtrriSjwBj95HcZmBaICeBvy8ifRWpacgZg/wNrJ+wpml70dw6+3Jc9pnwxSZDz+knVKMAgX2oz0UH/DM8RYtNQAykJcknUD1sQqS+4mxAi3thGOh/nCRITc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvbkU381; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvbkU381"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62899C4CEE3;
	Wed, 30 Jul 2025 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753893090;
	bh=I3nM6qDUBoQLr2eBT1iD5Mms+CpVCuZm9hCSckIRaEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uvbkU381OBddoaSfhZSNkrN1bfM7jQVQzBhniP9HHl3hslcqTXeFY8DYY7w/H1Bt2
	 5fZw/gtEd4TSnK1cn/hpC+PQdHcRzrf87yh6hdL+6q0eN2v3oyPlrLmrIzDLFodo1X
	 awVI2hz+lbNZ3KAxv0CF0BXQBNrNL1dhqp49mPEcPhu+ADerb7p22NoxUVEr5mOfwW
	 /PhWtfXPeBnRwS1B/H76b7O6BL24Bxg97cx5Pb+jbB9opDx6smIQAgWOvWcjRvRHb8
	 uy62V8ETox7J1+vUBpVe5HP8d7Wx0BfxxT1Wv96AkB1jZ66tuH7pC9apCFcKajhrJP
	 do/+s1b4E40Mw==
Date: Wed, 30 Jul 2025 17:31:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
Message-ID: <c5034db8-8157-4988-8121-c5963b6159a0@sirena.org.uk>
References: <20250730093233.592541778@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E4LLuqG657Bv/uZ1"
Content-Disposition: inline
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
X-Cookie: Linux is obsolete


--E4LLuqG657Bv/uZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2025 at 11:34:29AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.41 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--E4LLuqG657Bv/uZ1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiKSNoACgkQJNaLcl1U
h9DOegf8DDhdGFinBjDlo76ZNwBm8Vs3hGtvc/huf/ysY4J/XbRqLIfdK0rd1Gou
SdablcBbrJ90L/VC42A246nMzrWL39tJjPmP4eYXxT4kVHPOxCm4SoHxi/U0xAnX
HsIazw8ehGqmHfaFofSWsdijiZtCperR5Rsy9VhX8AQk+DPneyPsaRjsYrT8+bwC
nzIxGpUZW7jhKqeqtlVh7gJZgwuSXvYjxel5S++AWLltnQEEiQ7f8t+3gNlhYN0j
OH86JBYsIQiCmCuMfTRixAgqONNnBB+mI+E2txheaC/re2suvoCroduQXvOThhFc
4V5wT+T6KRSxjERTH16B69z3SfH2zg==
=phYp
-----END PGP SIGNATURE-----

--E4LLuqG657Bv/uZ1--
