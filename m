Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9D015AAC8;
	Tue, 17 Sep 2024 09:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726566999; cv=none; b=Lo0dltIuSelkE6bQ+pJ8LfCV8r4ADJvIBG/TTopi1x6HkPreb6ZB36Y/cKvUJ/Hgp/wyZgVnV6SQqt+X4METFkkB0b3rd7g0eDLzzSIDoyKKi63TexSvVlIbRaFPMpof/d9MLHdjeXS7YemaPfLEFJ4KFcoRfikGxUvG7p5lOYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726566999; c=relaxed/simple;
	bh=tV+yzbfpGByXRxvb99BIuFlCJk5mlFSuZX9yeG2i2po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKzzIZEFzbA7PPUb1N6cs69qU/IahTn5agjPUCRmXupaZkntT2FW5qfng3B+hzxOPkaULgYMWgNHrnT0adaNS66wkbNwLg7CTl6XZL+GCBEqczn/EnGF1NBIC4HdDb1/6hxqCF8Z2SBako5ib4bwZ/cUw+8JRXorHGPJZPIHWOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCXEzWQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCXEzWQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A564C4CEC5;
	Tue, 17 Sep 2024 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726566999;
	bh=tV+yzbfpGByXRxvb99BIuFlCJk5mlFSuZX9yeG2i2po=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCXEzWQPJ2rjv1ECDpLknI3pLfanpUzqf5fD7NPMTvklU8a9x+1phrUYHHGy39PD6
	 gPzILbl3D1HVeOM6BdByHmoes974Z5TlOXnF7Tg7Q63NHv9phGdIzntplmQbSgC7T/
	 Dg4m01znaYzyZ6HsKugodAR32DMnNKnU5xXuMKOyzDK0SW5zUDlMvbLXtHc9yjTM2x
	 ZaqLzPCfEyRw6aVoMrORROgbzMHnj0VtYEzQ/pK/AJpFga+ZVs/BeykaxZu3j4QJC8
	 WYKfJLfREKKT6CXhWNcM1ikUBbgbZ9oDVbWJdFjuBQvGgSI98D7FZOjlsrHvH+uAiA
	 /OmY61aBftqOw==
Date: Tue, 17 Sep 2024 11:56:32 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
Message-ID: <ZulSUIosimK0UGQW@finisterre.sirena.org.uk>
References: <20240916114224.509743970@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AgsnYxNc55NNUN5f"
Content-Disposition: inline
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--AgsnYxNc55NNUN5f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 16, 2024 at 01:43:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.52 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--AgsnYxNc55NNUN5f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbpUk8ACgkQJNaLcl1U
h9DBdAf+PAd1pcBdwgpL50OQWuLc7yLRugTmuUHp2oUOOCY7kTh6SNJKtPvkXdsc
kvPbvbi9qM6k4G59A/0IFqAVzAh6Dfi8ojXHeuJRfN40yvPzudf5QiRHG+/4tSf2
PCof3pjIat28oKd3qe9iH2xNhE/l/biQuv1VaHuty4tf0sCocgLvQ2V/2FkAF9qT
TY4f/OKkvPaUwavlbFQTciPg5Kinzr/sAA4AADg0PqPTASbQ5EmFZeoiCpmweGmj
8hztnXcS8iDpICzn6pxpUSBjGVQ3Se5RKmYH9/2+TRqfABDApwW5nOfTvzrGwzFN
ccCUo+fwvNMnRoIOa2x0C50tMQVrtg==
=NsSD
-----END PGP SIGNATURE-----

--AgsnYxNc55NNUN5f--
