Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907CC1A3141;
	Tue,  3 Jun 2025 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748971388; cv=none; b=EO4Udnw2T49vOXdYqjPUMDS+DrOFW67RXI7WHonhhfTfCOYMP/mNuYAgUFPq0EkENltbO2EEdiPpbQQx1X1zrJk6hrA0z9ysh/7HECHpSfdRvnNxf9pfhrbAnmvGuI9CX3IMYXcw27L1eGoZsMGYfoggTYO3ih08imUB5nipRrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748971388; c=relaxed/simple;
	bh=funqV+1p0oIkM1r3Ch+kQq10rwlHOEx6dSpoC9H1w3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gi//V777dI/jUpaoGSYKeDZM/sCR2gaERb5i57o+7luqDucpm7xMd3y9qC69dIj00am7xeSZ9dN8vr4ikzGUGVCCwv9PQeH7ksw17FFnOCErtkOYYIqRNCYNB/CoxEgL8NY7HKW8rEPANIlpvJNmSodGIAaKnnZ8K9u2WnCk4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0qvyvMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0qvyvMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300FBC4CEEE;
	Tue,  3 Jun 2025 17:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748971388;
	bh=funqV+1p0oIkM1r3Ch+kQq10rwlHOEx6dSpoC9H1w3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H0qvyvMGr9zngMMVePUllHWsgCJrAlFp5+UcZ3ilixtjXv7bOGI0cMVRTHZvhmMdd
	 YJsQaMNcL3uRtNblbapi6o1HPgMfX6yEcLQ8oOPeNC3YW6pvioDic+2CC4HdzePeF5
	 IMCWBJCVPUMMrd6Mnc9KUx2kx3O+7/TH+5gip+5vzr4BHk2nWi/EwjhJQJzZ0cfGZg
	 2OD/VTbSLctU9RBne5oKNSAg/5Uf2IQ1XCGIBrS/bag7iYmJxdA8DsAPov7ca3fLD2
	 +rs0/ozYD1Gck3OUmGFanmIK7GKrF2PQ1f/HvjNIzLE8153se7KQjdvIIEBRoLgi/2
	 SPW/uBQdKvKNQ==
Date: Tue, 3 Jun 2025 18:23:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
Message-ID: <e65dcca9-7354-44a1-b9cf-21ed767d0c59@sirena.org.uk>
References: <20250602134340.906731340@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aw1RgynfPm3+kg/J"
Content-Disposition: inline
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
X-Cookie: Avec!


--aw1RgynfPm3+kg/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 03:41:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--aw1RgynfPm3+kg/J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg/L3UACgkQJNaLcl1U
h9CjVgf/d//Z0TRf2dryiyHo9goubmgnyioxNJiNpzxe18D2vWPWvoLgQaHMLoJb
I4nI78MW/E77PQDyIi6klV1dEhx0SrHvYRCNnnswoL3l1MSQiB02Y9Ri7rG6lmYf
aTbCIgvXzA9nvdEzTZ/URCCXV5kwECYJDySl6lRogdwyfATlbVhGHbpv6YvTng3/
Tz5yrItfED61/oPeIbJ8JScU+g/iG03IVbE4Tz/4i3bng0A4jvTYYPWkyhDNFNM7
I0s+Bsh0b6Q+HNSlnrRCJoojrSQFwmvsCxJMpOUfNm7K3CrJiUWs3JOqCLovbRPc
YZ894ihfaLB1Wi4uabKgdB+Q8J6TKQ==
=Tyl3
-----END PGP SIGNATURE-----

--aw1RgynfPm3+kg/J--
