Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1AC25779;
	Tue, 16 Jul 2024 22:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721168878; cv=none; b=YFDzxL7nBmdJldqgzR0T3ZNOQzdE6N+Df4XerxJV+L65h+x4p2fKhRNsl+TRYcDnSk221hSpM0FZ9g7VMuNqk7dBi0FpeKHp8zp2ZEUDA+Prk42Ox41JPwOk/jKaaOb544R/dZnho4S8biHdf8JI2o+hfVvT4S5A5i5ZTD9OeCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721168878; c=relaxed/simple;
	bh=XICf/J4vEdapWSlC6sB0/YElc+k5l1HHspEipF/GID4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQvVOrGBa3cOmxv2R96qYShEwW2sE+ywlRAMhMoHOZJ6yZxb2U/u3eDFgr1ZjBj3l6yYCQPcPTt+u1qBM1wMJdvLpMilFPeQ0A0J45466lZMqytxmufjE9CHaORMSWQAKSL9kRL/kgyNroxVOG/8sZSLjBw4AFt847aT9rGZ5t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSs8u8ZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSs8u8ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D111C116B1;
	Tue, 16 Jul 2024 22:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721168878;
	bh=XICf/J4vEdapWSlC6sB0/YElc+k5l1HHspEipF/GID4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XSs8u8ZWC33CIePBO3MmP4uKeWQfbTDddsDj5CUFjfT8zWno7AS6gJCrexsqTFApc
	 uG2E5k+B4vWkG1LdlPQw0fLnlyFP+BEmMzQyGJryenbNGhVet7POfjAoplMKy2ooF5
	 G5d2H+jO1qz5kfUDAXAFedT4lrI70z+p5cpe486pqlAN9dEPiI1x7GxcdCn2nYZHDE
	 euytfPGKXgH2zVV0ZKEd38OuKMWyd8A+uWEeT0H5w/VeilBUbL2IWjLoyz3kLZqABL
	 yf96Ul+Sx2Moafy5uYOyAKSHelaOGaNlqSuyUERd6BjlHmO7t2YBd+gzFDgXc3S1WU
	 WAChr+FfhLkqA==
Date: Tue, 16 Jul 2024 23:27:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/108] 5.10.222-rc1 review
Message-ID: <14f3a52b-c934-45e8-8d39-2fc199f3c3f6@sirena.org.uk>
References: <20240716152745.988603303@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zTkn3FRT4d+unsDg"
Content-Disposition: inline
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
X-Cookie: Think honk if you're a telepath.


--zTkn3FRT4d+unsDg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2024 at 05:30:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.222 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zTkn3FRT4d+unsDg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaW8+YACgkQJNaLcl1U
h9D2ZQf7BX3dbGU4rvvrtSJgk/gZbVBNglgvPGznUitD8WVhh9tTDiELl0xTNYwe
3vRiRlcN4szARBAy6ZNZ2uCYcMRHVDWxjiYtuffwUiBIsXLsdjxh8rFanEajoL0W
HbX/cgSyEpQ6b1zSWoJlfn3cEz/7xnm8YyyhUpZN6lYFgKT2uZcEvwC6WEWFY96K
jtNHRkFubL3uSDwy2xGCjQVGfQilREiWHtEZOiW00VemA2TiIK6JBIXI+j81RUsv
CkzncFgmWalPlIF+FJhmk+WnWxfB3xSL8zRv2X7DxK9ZFbsTpHYbXX56IodaZ9W2
jWhvSoN0letC8dnZlPafZKgC8VjEhg==
=B/Ne
-----END PGP SIGNATURE-----

--zTkn3FRT4d+unsDg--
