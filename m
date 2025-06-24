Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C47252287;
	Tue, 24 Jun 2025 11:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766295; cv=none; b=tFPz0wr2+nvJKsz1MqqkrVIqJ1IJqj49YtnvaB6mq5VRcxmtxXn1zybALxf5rQGczPhbR6jD8rgfHai1uOsQYHWsyFAr7+MbV9wDaWjYPluRWLxMfPNJbB6HVY/mxnj/Fo7+4OszUr8Ybe2TbcS946MvcxrNUBAr5XTXDMIRueU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766295; c=relaxed/simple;
	bh=FZMb9xIbMiJLfUoWqlucL2Qw7IWuVDdMTJotSraEXtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDtnBpb/8LNPr7FFVVCYLDJoYQTMLoQxdn4UjvjRVEJ1aSlgMTVOO82m6ldZ5O9cd8vpR0maZenkAxQ2CH/8yrieg/tc+8WUc0WxMJ1FYcybp1fsscpuM+bSo25zk/5g1T+4ZtkT8lD9whVfhr2wWnZFm7gNzTT6Ksl/nXJFnNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmQ5Z8Wu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmQ5Z8Wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997C2C4CEE3;
	Tue, 24 Jun 2025 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750766295;
	bh=FZMb9xIbMiJLfUoWqlucL2Qw7IWuVDdMTJotSraEXtw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YmQ5Z8WuQP7V1MX4w6Fmk3Ct37BB/Hoa4qSMNzoYPy/jHBRpxidvLKTDZ08/L5YOP
	 3CeofL7Gazzz1OFZJO/lSf1E5Y59PVy6/MreJYprXA8aIojC9f3/R0xUOOULSMvnnS
	 /fc2XeIwXe1UVHIqjgtwVX+4MiWitxS/f/OuNkkXuWA52KnW/McZ1Sxp/+BW9eEPA5
	 FG2g6wankQOIZAcLP6eiL1Yp0V6GStwB/JmbhdqZ3RXzFS7v3Yx/Jvi6iC4CJmKhm8
	 pzOldsVW8rAG7iHFOzL2j13TQaEQJNflXqbCanN5dgmtbFtScVmCO6d9M5rvfRXACm
	 8YTQOwDYOIT3g==
Date: Tue, 24 Jun 2025 12:58:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
Message-ID: <d62d618b-7ea0-4b9f-a4a7-7aa7b5713def@sirena.org.uk>
References: <20250623130626.910356556@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3JUlCpscSXiEgWsS"
Content-Disposition: inline
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
X-Cookie: Do, or do not


--3JUlCpscSXiEgWsS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 23, 2025 at 03:04:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--3JUlCpscSXiEgWsS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhaktAACgkQJNaLcl1U
h9AQjwf8CmXGFpDxqQw/zcckNXIbjJwX/tPeOGCLC74M3FboOIMMds83tXoLKhX7
hrkAssWfSZ0C3l9jTpLB8TF8KNqYC4TkupNPWGZM9a53tvfClPQLyswm8KFrhr4y
fKiI0WinoMGZodibiz47tg9dWb4WwYJJh9DNnmHeK5rd8hsCrntPPZYEtTUTYno9
Nsoig9LcxEBOM5roYIlVPabsETpCG58TD7XI3ecNLNCIS6lNhjpmYfsY7r4ZLvDW
gKw9SnV8PKMXUP0YghJxBsMPvwg+pR5X9cq9I9tX0palXD/LtwBfFXPcFsdwvmS9
0QuMKlZqHVCOqP+wgc/00Oz+eNHt/Q==
=dOvN
-----END PGP SIGNATURE-----

--3JUlCpscSXiEgWsS--
