Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB72C2144C9;
	Wed, 22 Oct 2025 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761144797; cv=none; b=iVSSGrdHpB+7Y5140e9sQc/wdAJEcCNrGFqZL67T+QTZ1bM/TCdWAv8wZBBvyRWmlDqjB1gPtTS0LK05807ctVJz4Fl9ZUV1Ian5TBcWngXEuyJuVLnrnSB1a5xn2ed3KUmGOKDJGgbRL9m16PztzEo33Trh+ct1ZT/vuxk+ZN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761144797; c=relaxed/simple;
	bh=z3ZTVOhJ2G56hfcvXjaLy8xDbiROSF2Id08WFA1DRBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gXahPDI3RXqFX332UQfxuEhUKL9SqgNk9ZUDSfO20w/oilXk+9pq5/BxSa+0xTvceM1oIwTeU4MSk4kO0VUt9KwHDIoXc5P3VjJVfeuPV9h3gpdB46ArsvY3P02+RHHmJCnQkQVaTKHfqxwkFO+z+Kt6qMV+c7KEVco8w/DTVqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QywZEow3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QywZEow3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8070C4CEE7;
	Wed, 22 Oct 2025 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761144796;
	bh=z3ZTVOhJ2G56hfcvXjaLy8xDbiROSF2Id08WFA1DRBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QywZEow3yRAm9h6v8WspiC02KQur3bGcajq01F0ejNO1K097VJs69vkkwvAXuz/OC
	 TgxU4sM0Yjtj0JOxTX6DlEz/iojTwJ4Ck9csStIa0TP9Zux50YZosHcCgmMknuFrna
	 4fL8w7nv2DFpa+31nwAVzM/DHzIPIORAGBrC3i/Ijmt9DWon5ev7FAi1/xp71irLQr
	 fdjGcfjbJ0y/MVVp5THq3ykL6+uKZasp6Jg2qd3C7e/YnwtrnzHwLAnnERFa4BX7Hn
	 MtXMFasugQ2lpIAL01S1jVjVAo+CNuQU+ix4Y1V1htfWNNfK6pxydBtUCws1MrpT3D
	 e9SYeD67GBLhg==
Date: Wed, 22 Oct 2025 15:53:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
Message-ID: <c0286b06-73fd-471e-9e83-a7bd9c0d4389@sirena.org.uk>
References: <20251021195021.492915002@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I0I3cDgqQKr8Gews"
Content-Disposition: inline
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
X-Cookie: Remember the... the... uhh.....


--I0I3cDgqQKr8Gews
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2025 at 09:50:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.114 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--I0I3cDgqQKr8Gews
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj479UACgkQJNaLcl1U
h9BG8Af8CC26UOTRABV7uxjI6JWfnPOI0GcgaP+LEk5+vLfs6tFtaiLE1gCDz6jA
Oupih4isIwKUCsOaBzQCYSRlqMyluzaPUFi5jGv/F8OV0eLT9BxL+reP1Wx6riEy
5bOwS1XzP7Z9KBe4pMCQv70I7CBDROEJcJLMZbf+cVjH+avtdOiEBF+M+c/BPNSU
dm+LaovNCEph99UI7vxEyGwMcwyM0BjiUcIOB+o11l0/LH6kflBNwrlBGkVBTi8/
Nq3P81PZHFOssJ+88M5uyRNs2n541jESQqTvEyayOylcGR/lM6KaTosyW8MGJBx7
CqS5gfkQComlUjN7EcmxEx7ULwbb4A==
=cRNn
-----END PGP SIGNATURE-----

--I0I3cDgqQKr8Gews--
