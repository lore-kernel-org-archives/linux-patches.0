Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3572C327A;
	Tue,  3 Jun 2025 09:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748942404; cv=none; b=EZ1sX1kVUKkIhsmss9kIuq3La8fqRToR6lkBfhzh5Z0qZKPakw8N82r7SDXzMkIzzaabim9EStb287gnGhzKCEcuTYZC8oXheF+o2KtuKICAr8ICRZD+pU3GiqorJkPLHa0UGZX9E2UOMSYMgCKaWfP1WMloo/h2p1D5NK4R6Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748942404; c=relaxed/simple;
	bh=D2lggQk3a3nV1nBHtk+iJkwOoenb1YJy1BvjQYbgU90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDVZhquGBlUjKmkBWI6oWHAnH2pjUlu4j+x56WsnPkC9pOOxj5vpUS3erv5l3qBIBDN93gZGn5yWVWMY87JDhoDyts+iuRCtacuU6jMUHIQU9ESu0HT257r8gY/wiZ7HRjUr6T0Q29pK3VKX25rMgKrgjU62feY3B6/xjdTvIiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkvFGDtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkvFGDtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC24C4CEED;
	Tue,  3 Jun 2025 09:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748942403;
	bh=D2lggQk3a3nV1nBHtk+iJkwOoenb1YJy1BvjQYbgU90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YkvFGDtDNaPrIjtugI7KogxKffDn9XcJXkr+hcQTzmZpvRY5QAJMguz4BtdOFJQDL
	 Ri9/GbJQ7NrkKNe6zbA1S1mFN32jUQIQOay5d0aVSAS3539q6nqo6VgpLJJeEmu+Kl
	 HtcibZPgSpRThPXAyU84RFyWe2fGujofQfk6U7F0mI7CDqij9ePOj5nYzYt/A3BQJV
	 /pXjr3zKZzHwKNe0t0mSdFL0IgaoZZLKRIGAVN9S/XMN+CqH2puA2fkRmF9vhsveaq
	 qfAbJLkauUidSxydZ7mqSJyQzzT82pEzF9nAnJGVMVpfRo0UOkgvwmak+xZpQaj4hC
	 4jgLpcZQcoNOw==
Date: Tue, 3 Jun 2025 10:19:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 00/73] 6.14.10-rc1 review
Message-ID: <8f0e1686-699a-4cf2-b930-df846026d466@sirena.org.uk>
References: <20250602134241.673490006@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Dsnk04l3ZLjMy+c0"
Content-Disposition: inline
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
X-Cookie: Avec!


--Dsnk04l3ZLjMy+c0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 03:46:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.10 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Dsnk04l3ZLjMy+c0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg+vjwACgkQJNaLcl1U
h9AiAgf/WCRc6aaGBUn1vmHOUEzCRocuPq9vXPh9amlP01Tpnw+IXiH3uZgef5Wc
yseC5vZ1EISxiLW+PN+8U0geAeKaJiPz7wqpb+8PsTOIn1p+VmXde3s7KWEtr5hd
tmcfOQcnbl/OiDRS7Whwr+HfKFNMbWWEVXW/XdOP5SJWRs1r6GRYBVwbQN0CqDVc
lKGE7aQhqZAyhNya+b8HMvfjFryhQfp/HSPDqHnNQGxRMKvYnWERJSnGFlSyY8u2
Bwtt7iKKxLg2omNliedg/BM7DUGpmqM3SbEyuVjhj4FRWNCsiUfYKiF2gvokyN0X
+ob2fO7k4c6rpDHxOos6+YyPIut+Vg==
=6Izc
-----END PGP SIGNATURE-----

--Dsnk04l3ZLjMy+c0--
