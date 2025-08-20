Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630BD17A316;
	Wed, 20 Aug 2025 10:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755687576; cv=none; b=Y6asbR2+tuleGNwsNBkzC2X4gtzBNWL/D8RJ1AWwm2sCPB9TsgiXRwuLRXq7zQ6YfYOhTE9Ozu4dF57E4t2P+Y6rhqmVSRsQahsWgO2EwJzuCTU9KJVDvja+AsE9s3z2dx+D3X7u6hulM9kxJJdCDfUHEixl5MvTPzAvdZ/nB9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755687576; c=relaxed/simple;
	bh=tZw5HdnGL+AX9rRZl5TKkeTD8OyKPOhtHy+iibKMXog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ck5RibeEV53bVsf3Q12kfeaU9Wsw1iLgBLPoKaH+PEPTpHU5V74pXOuEcqERtJrs5YmMPs5VxA4cLxsGkiErTC0kNoneU4EZa9q2urIIHfMwrpLi7UlTO5RnoBadivJ+P+aB9wVNdAQe4Q+pnsiCcGxdw5QEjySUCG3VIOfSTKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YA0kSCep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YA0kSCep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D623C4CEEB;
	Wed, 20 Aug 2025 10:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755687576;
	bh=tZw5HdnGL+AX9rRZl5TKkeTD8OyKPOhtHy+iibKMXog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YA0kSCepV2jlZP9MerDpus3UQLGzHB71eAHohzRZX2Bin2VzNRTHQyqTbE+Rj52IR
	 7tIrnrUrc2QIwtNBhAbHZnqzZgWMAeh598Uc71SBIa6rx5TGkIcm4s+SkYB7NHTswh
	 9fuEtDqmr2An4io6hDHlpN0iEq2t8ov02GYtDXT9VrVmzlj+0J6JOunI9RJJuXXcOH
	 QZEITU5tkHX7KwHOzQbkyaoppQ41Yrf45YCieb7wgUcASNSZA6GHuv0vLSYraILgh9
	 Rhqkn/viLRzH9dL52Eq8aycjC9y+S6BFwQPNH6079o2FkDYmRwhwg6EjPUymlwutQx
	 vBVjagVzamOWA==
Date: Wed, 20 Aug 2025 11:59:29 +0100
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
Message-ID: <96d99806-9c85-4135-b749-7e56259cd37c@sirena.org.uk>
References: <20250819122820.553053307@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sCXl3scuh2qsEQNd"
Content-Disposition: inline
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
X-Cookie: What UNIVERSE is this, please??


--sCXl3scuh2qsEQNd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2025 at 02:31:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

The epoll04 issues I reported against v6.15 also affect v6.12:

# bad: [e80021fb2304b3e1f96e7b9a132e69d2c1d022f1] Linux 6.12.43-rc2
# good: [880e4ff5d6c8dc6b660f163a0e9b68b898cc6310] Linux 6.12.42
git bisect start 'e80021fb2304b3e1f96e7b9a132e69d2c1d022f1' '880e4ff5d6c8dc6b660f163a0e9b68b898cc6310'
# test job: [e80021fb2304b3e1f96e7b9a132e69d2c1d022f1] https://lava.sirena.org.uk/scheduler/job/1695957
# bad: [e80021fb2304b3e1f96e7b9a132e69d2c1d022f1] Linux 6.12.43-rc2
git bisect bad e80021fb2304b3e1f96e7b9a132e69d2c1d022f1
# test job: [7b7342b46b4c9396878626b27d99c64d193af3c3] https://lava.sirena.org.uk/scheduler/job/1696542
# bad: [7b7342b46b4c9396878626b27d99c64d193af3c3] net: fec: allow disable coalescing
git bisect bad 7b7342b46b4c9396878626b27d99c64d193af3c3
# test job: [3957cc291310fe1ab1307d406f08e9740c72a9ad] https://lava.sirena.org.uk/scheduler/job/1697052
# bad: [3957cc291310fe1ab1307d406f08e9740c72a9ad] ARM: rockchip: fix kernel hang during smp initialization
git bisect bad 3957cc291310fe1ab1307d406f08e9740c72a9ad
# test job: [da60fa79fb931923969e4bed25b970242786952a] https://lava.sirena.org.uk/scheduler/job/1697319
# bad: [da60fa79fb931923969e4bed25b970242786952a] udp: also consider secpath when evaluating ipsec use for checksumming
git bisect bad da60fa79fb931923969e4bed25b970242786952a
# test job: [e6b8c045342197880804674d66a788b74b02af81] https://lava.sirena.org.uk/scheduler/job/1697685
# good: [e6b8c045342197880804674d66a788b74b02af81] LoongArch: BPF: Fix jump offset calculation in tailcall
git bisect good e6b8c045342197880804674d66a788b74b02af81
# test job: [a0aa6636b95e0ea53340c41d109991dd09ee5aa5] https://lava.sirena.org.uk/scheduler/job/1697830
# bad: [a0aa6636b95e0ea53340c41d109991dd09ee5aa5] ACPI: processor: perflib: Move problematic pr->performance check
git bisect bad a0aa6636b95e0ea53340c41d109991dd09ee5aa5
# test job: [7e040976e0ed9f2f13ad15e6a1712688b7814805] https://lava.sirena.org.uk/scheduler/job/1697981
# good: [7e040976e0ed9f2f13ad15e6a1712688b7814805] clk: samsung: gs101: fix CLK_DOUT_CMU_G3D_BUSD
git bisect good 7e040976e0ed9f2f13ad15e6a1712688b7814805
# test job: [bc3509f3a78f85ff1f6f19dbe1be09f83a1eb044] https://lava.sirena.org.uk/scheduler/job/1698217
# good: [bc3509f3a78f85ff1f6f19dbe1be09f83a1eb044] fs: Prevent file descriptor table allocations exceeding INT_MAX
git bisect good bc3509f3a78f85ff1f6f19dbe1be09f83a1eb044
# test job: [b8584ada9b249a433a9d2540f57e2dbd1b410cad] https://lava.sirena.org.uk/scheduler/job/1698383
# bad: [b8584ada9b249a433a9d2540f57e2dbd1b410cad] Documentation: ACPI: Fix parent device references
git bisect bad b8584ada9b249a433a9d2540f57e2dbd1b410cad
# test job: [9b420327ca126036f93186abe0a4140b64e3213d] https://lava.sirena.org.uk/scheduler/job/1698512
# bad: [9b420327ca126036f93186abe0a4140b64e3213d] eventpoll: Fix semi-unbounded recursion
git bisect bad 9b420327ca126036f93186abe0a4140b64e3213d
# first bad commit: [9b420327ca126036f93186abe0a4140b64e3213d] eventpoll: Fix semi-unbounded recursion

--sCXl3scuh2qsEQNd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmilqpAACgkQJNaLcl1U
h9DLCAf/TKc1rkRh7t/Z+IPt/R3K/ZWf/0WwkD8Pd2UxQIv8stbTLc/1uYhqx6fC
XWLzKCJpRqXfb/2XyfRRts6tzyE2ehu0DxzO+0c+2SX2t036dCFOHNcG9l0h8Xbb
OYBwbQNAK3/cEXofEmNqQZsMl54dEW9w8ozolv2tkmcf9xRSesYxRCPMbx4Y8hql
aJId9zI3coCkTxtM0FVLcgQGNBez4KZ2p0uCS3L58IMX5hmNr2PC+pAQ6S0iQWo2
Z2YInZuB6yLsFeUcCCykPD0siRRMOm8p3811uzf+Qs4Ls+Rbex9GLEqLPP3F/tyZ
4+l5OhhbBrQDNXZR5s35ryesBbivfg==
=MON9
-----END PGP SIGNATURE-----

--sCXl3scuh2qsEQNd--
