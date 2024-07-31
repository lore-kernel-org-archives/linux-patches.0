Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA568D512;
	Wed, 31 Jul 2024 00:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722387300; cv=none; b=dMPi1IzLoMYne51erDPyUIKVrq1u/XH8TMoADdyCdXAfIP0prXIbXzqptozVBzGQ4aJR4Bn2YXmgspd3T6RPUdferFatRpEOtintiF+BcnOjgbXaYwz6wAFwVW/mGRaa5nc0Ku/XBkJuOQDAMSBOyeVYzVcP8ScxXtT9VR5X+gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722387300; c=relaxed/simple;
	bh=CmM43waZGak4yCefqzOSHRQra7iXX233t6EtQImOPlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgaUk5Xlov74ofO1OTUMg++D8DQiLB/upKGfL4UJXt905zl+Fq/Kt5VUVWeZn742o57f8XqrQQ+Qg+isqTQx/ZTC/jaxlTtZq8RMRaLe54x09Z2gchYGc99bflHf+JxOWI/vdhw9/m1el+L/ZqFW0XYx+corLLLU5aPVpyJ7WqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyxtoBlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyxtoBlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B0BC32782;
	Wed, 31 Jul 2024 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722387299;
	bh=CmM43waZGak4yCefqzOSHRQra7iXX233t6EtQImOPlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UyxtoBlJhxGiIGHvORECvjmnydK7zj+1Rs6irAT11Y1dMIdH8nUxa6nG6crilnfqz
	 XpZJFe3QehAgu2ySxu3xY1ZktYZQ/Tpp8LTGSlXFveFR/uXxuw/ObbLykckeeaZ7lM
	 /Q+TO/rmCt7UYqk9ST9ajmrzzlW75MxQMq5TBr81MpxFFmj6gcNSkXnAHU7sqHFZnG
	 JWp00/4Jm0glMkUBd/83SQtSMJz45aaGhN3BWbMyFo4sj7a/1LKW3oXAXWNU2uN8D8
	 bYyA+1gFtEj75eZyNuaG1RrZJtvPh4NFdRMrLGmqgTThrk1WKQGMH3uznETFg2+2rl
	 /AmfevbdjflPA==
Date: Wed, 31 Jul 2024 01:54:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
Message-ID: <1d17b8f6-d10f-4c7e-9a94-3f4698e2f119@sirena.org.uk>
References: <20240730151639.792277039@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0IsDmSCi87GWgQNb"
Content-Disposition: inline
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
X-Cookie: Don't SANFORIZE me!!


--0IsDmSCi87GWgQNb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2024 at 05:41:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--0IsDmSCi87GWgQNb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmapi1YACgkQJNaLcl1U
h9As1wf+N3/BcCDhvDK2fdQwQ3W1hXUXswR9SsdlLp8BeTHrL9my4yo4BRKnrXlY
+AK0RU/rU5IrPquFUrG29ubKJ0e/QgnlKsmNHQ0Qb6mVlLoqm+AsX7B9kZStGDhR
+gMWV8ASX1Ny7/ZofEPqykBwovpaK2TiNf4OdTDTSIZXWAYcYmqSz4SHOp3QBrh8
6nLIdEJwvRcSWEtdHDkymKqZVOiGyzLiapP1Exy97t1TEHJMvM3d9ESPSgc26H/z
2YS0LML45oUeXDcWVgpw1WtH5xCDeZn4CK3iop5CBeJZqAlXULO1GwuUaZZ2yRFD
r7tWKEkFoIyXye7nvvK6qsfdpuX4gg==
=qX9f
-----END PGP SIGNATURE-----

--0IsDmSCi87GWgQNb--
