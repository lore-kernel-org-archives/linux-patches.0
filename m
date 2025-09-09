Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805BB32039E;
	Tue,  9 Sep 2025 11:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757416886; cv=none; b=njHF3qeBLQDk6cDzkmF2fwPXH2P3qiFxkoO3F7uIrP7uCyP8Wf5YYXlN7mPhvpR4UaI83blRCabQYGsj166MbqQ3oAu1eAqUyu2Y+luf4iieboJnFI/cIs3mGJv0j6g05yqoGOSzYXLm8rlxSY5vlaW7lSbXCb/iZQp74IR4IvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757416886; c=relaxed/simple;
	bh=nvzb1Lrog6KFya3P8bFG+W+kS1eOa6Dc9362cZxvL8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQXI4/5DlZFulGlhgtI3CqzDCNqALk9UD42zza44MOw8hPBU0Z9QoBlLS5qxraKQIfss02hIRgJJMK7mV9Rc4aBjUT0/hX0JWBomAAs3NAWtkbxOUIgRLOBvqr1LqOBipvbImjWM3CrulsisES9Tk3PwfVk3oEW1vy8mEKtGtzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otpGLfTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otpGLfTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD44C4CEF4;
	Tue,  9 Sep 2025 11:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757416886;
	bh=nvzb1Lrog6KFya3P8bFG+W+kS1eOa6Dc9362cZxvL8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=otpGLfTQdb/Ve1vlpJY4gn9XqzwuGKs9DhRlYhbnetcMNxS2sOoE2na6DOLz5eTds
	 15p0LEEf+9jRMweaqwWKbsEqm3ruCPV4PyFMFZMX3jVT1U5WdMy254jDlc3h0zT1G+
	 nd5ksqkVceZXVYqa1CMkL1qJMY7XlSg6A5Nal6cJz1ust4UWf/e26VwyJq29lEMLk1
	 0BgPMCmecREu4P628h5HR0rt6YiWs96mjA7UthGxFe5VTw6oOHoM3fKTRAuJkPGiOc
	 42dqeF6zhfGg85lbnngVuLWN0a7QfEyK/HAZX82TCDqrH2SZ/kV420s0HiR+TSOFrN
	 FOFP2ZQNhtmRA==
Date: Tue, 9 Sep 2025 12:21:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
Message-ID: <89b8c0bf-3879-40f3-a078-0112ea9334d1@sirena.org.uk>
References: <20250907195615.802693401@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A3RAOnqIS4luGgUQ"
Content-Disposition: inline
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
X-Cookie: Ma Bell is a mean mother!


--A3RAOnqIS4luGgUQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 07, 2025 at 09:57:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--A3RAOnqIS4luGgUQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjADa4ACgkQJNaLcl1U
h9Dhowf9Eb1w7U3LavnuZEd7/dX4zcwNYL3PCLoCIQ8xRjhxEwUiWp1xoTZD6ijt
NDK8KGyqHCr2apiRpnbqG8WcqHcqsBwleNSsSUY6xoApxUAWV22bBWXLoO265YI2
SeS3FTs9BKWii0/inbXclRX8+O+9+IMP1DP3bNPsoczcp7yLXuVfhioUaC8cI8d/
x/4ufnzuNzs6YMhveCHpndifbMCWgZlXycLFLhFHK5m/s1xY5oPqsuviwp0KIL8W
aWRPlFSTIXjPrHw0L64eHeLU6iV8WwrpzRZzVChum21VXVZVaBUENyqjcFELq15X
BBPec7TeMuYM36ipX9zPfBX0x9ObQQ==
=nP4s
-----END PGP SIGNATURE-----

--A3RAOnqIS4luGgUQ--
