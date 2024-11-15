Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36C412F585;
	Fri, 15 Nov 2024 21:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705500; cv=none; b=HgCASezeMdkcrYC9BAkExfjBlv5CGWZ1/RGYm3k/M96nYBzVGjtvjQB/nk63gPjIPSws+1flKhFOkDWEaSXEGF0o5AKfjgmGhA1HUdJbSQ7R2L6hb61eW6Fck5+LJK3SXTbJJgTPFvWFMtgEOx1w41G+zwHACPUL3LnSiL4t/pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705500; c=relaxed/simple;
	bh=1ablpgLpJCIXGvUvMmoRjJ6D2/PYdM1jTSMdF5fEjGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNp32AluSSMiCTHHlZh8zFmECkLjOIFlQ8xsLhF2Vk9hXjce3XUOZ3nH0oNSAsiwIk8GXcUeNX2WeGf4Kc2rz0ChKhhCuc+OWZIHGcg2ssB5rC9SeG7kodCmVarDSoUZHpMC/3wuTOK8XiDm+WRuQCaAqJCk7gvUcK0KPjz0JyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYPMGbWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYPMGbWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67FFC4CECF;
	Fri, 15 Nov 2024 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731705500;
	bh=1ablpgLpJCIXGvUvMmoRjJ6D2/PYdM1jTSMdF5fEjGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KYPMGbWL2MQNnE5p6O66CmQ8/12m/I4qxeYyILuI5y0CGGOyPwcIJGSNBL2GNDU/x
	 JRnwBQ+Y0FEhMBbDI6EdR2NRj1nhhPCgk9fLGnKRpoxuqTrJWXc1O1lavHrSg3I/Ll
	 AdZzVf/gaqjlkhvekkAgGWsueUkVf+ELUwaTn4xe+sjoRdAix58j8k9GlAPy6PQ+bX
	 8SJteCtDCBs51f3UQapS9Y7MBonFtDEklH/2d1fP5kYm1EqLkMxQqLGJz1wlnHd4l6
	 B16/VjKuHGYM5NrPYRgUMWtI9kZ/N9ZnVmk4V2G5VEctz0h0RTNzVkLOeBBswGKOb1
	 ZV35eI6orvY2Q==
Date: Fri, 15 Nov 2024 21:18:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
Message-ID: <Zze6meJKmuupFKL0@finisterre.sirena.org.uk>
References: <20241115063725.892410236@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yPTeVfOOax1NwQUj"
Content-Disposition: inline
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--yPTeVfOOax1NwQUj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2024 at 07:37:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--yPTeVfOOax1NwQUj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc3upgACgkQJNaLcl1U
h9BuBAf9E3QRKT6rf+btKlN5oVYDMEY3LIMzypiwVpM8NHJ3SR/vjAZ4D+oVymyh
yidtznywRN12ij4J6G7ESiHZ/lcZtjBMvsfhgdRJlxb+BTLIC53sY8tHQdLXFNHT
UeO7THwDH39jWLqvEXhxikfgjtsf5OC2K9P9XV0jTC3OtxlSajlmzRZMEX2TXPbl
KwbTVi2gADFk+ZkwGE2BnPU2uLFVWDxFaiAhl3km1KGboYDzv7L5usbAd/ux8vKO
4UuXPu1cn2mlGUW43cU1MyydqkT6V+eftY14RdpnFJJ+IbLOON3ey3CLV8l6kJoT
p3IFHGBCM5KEohTcHYI9LLH27ZxAjw==
=a7nr
-----END PGP SIGNATURE-----

--yPTeVfOOax1NwQUj--
