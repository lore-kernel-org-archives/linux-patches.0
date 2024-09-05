Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0551919409A;
	Thu,  5 Sep 2024 21:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725572999; cv=none; b=BzwG8n+CqMfgx70001v2ConFCBfrAmvN882XMvZ39u9nxwXOlfrIpYlyS+12MrUj2d61REs8ixYLaB/F9DwBVyQpbdSurbZZKPuB/wV0wN8P8buOiJBRfW6T85iGRTdBPLrosfh4tu9tLJxNOVRH95CXwCs8GdSr0nPwxz12l9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725572999; c=relaxed/simple;
	bh=eZDA9JW727objTzfYZfMMPvf0u5yRSidlGU7zlzi9Fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzAt8l/p0Plf0gUbuC3uf4OTG7IygTxFbfzclKKWyjwOqBzTH+InWchM26WRzPFgq/TS+cHGwaoWvoHpCz0CSUoss1IIU1VyuuygvtChNtarv+lQYPqUlWTg4dgZrBBQ73fneRNkT1dtGKqtOuMVmFXvSHKFG2pwa0nL7va2uvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gu0j0b9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gu0j0b9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE87C4CEC3;
	Thu,  5 Sep 2024 21:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725572998;
	bh=eZDA9JW727objTzfYZfMMPvf0u5yRSidlGU7zlzi9Fs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gu0j0b9sIPd+KqH7TAup5IVm/6e4IP6KLntljn7N7KOmRV33NbF18wYhYKh/Iy7u0
	 DYUS11h13WovQxS7EmOZ4vpGYpNxCIonJFlx6IpJYe29UR96YngmiSyfr3GuXyLSeH
	 6TXUR6XpuDWATHMgfFZscnOWx83ebadfjpHMABUgMO5dF3jQBXbT7FndWYl3Oa1GG1
	 R2ZYTSPxPKZts4Gb67unhNsWLcR1S0i/lleKUjMCNg4zaWyjpswC4MjmJ9QkZ6iwvl
	 SiWzr5B7Vda9QzVlJQTY7LkJOeR1YBvIX+ZX+0nwdd3cD2VCsjTddO7e7wUn+JXjFo
	 JY5kDmbimDiFQ==
Date: Thu, 5 Sep 2024 22:49:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/183] 6.10.9-rc2 review
Message-ID: <969e33ef-c3af-4a88-a889-6c52391863eb@sirena.org.uk>
References: <20240905163542.314666063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3B/NmC7x0qSXSQJJ"
Content-Disposition: inline
In-Reply-To: <20240905163542.314666063@linuxfoundation.org>
X-Cookie: The horror... the horror!


--3B/NmC7x0qSXSQJJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2024 at 06:36:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.9 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--3B/NmC7x0qSXSQJJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbaJ38ACgkQJNaLcl1U
h9ABSwf9HZF/eeyRI0sPXuO19mVEE4nwOCt6LyryJuPcbI4alypcPxaJzvnM+22L
/nmjjKzgTQ/hr3i4aX7kD7sTcj3idp2h29z6BuScZ1iATOtKbItkJw91pwdvsN07
UcL1mUGHYC3WqKExfEnAkV0o3HlXg2oxQSxe6V+Z2kJTZ1L36b5nOwS2A9AFpSyJ
Zk/gp8shhxFEenHmenGvIwzhHC93WzjkRCY4kOOyRCbfrCfk3pvbdccPn5Do1gOs
7Ms8pNdk2gyvzfGpt7zsFpu7AxvBnSZro5bVUCuoh9Gi+WS76VPq9YvTtQcCoI/i
RU4I+P/TEyGPjsVKfmCMGpT4LHVBPg==
=g0AZ
-----END PGP SIGNATURE-----

--3B/NmC7x0qSXSQJJ--
