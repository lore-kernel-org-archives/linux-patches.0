Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C658E2C15AB;
	Fri,  4 Jul 2025 12:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631124; cv=none; b=cbO0zFP4XtSaZ6LqDQUZbA++Dml0eriAo8bknhQV3ZxD8OE5PKJxCmpvPGQiDAsPiwptIpDrh5OuCrzEC8qom6OlcDRxQet3QDFzfKWlqCL7kBu4fX36gVkdc7EFjOJNLPEyJIcTz1u/SCL0qf+QuLdLUwT1uaGD+ST+Wjyh5GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631124; c=relaxed/simple;
	bh=+JWoxOdiWKb2hRvItgd0XYrJCCDhH1s9nGDOqaEIyX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ig19/eqnADo/1QeRZIiPHAgrNagt2WceGrfv3JkzxKLD+mKYaao1lOxGt9oHoQVpsOIgptstJFW1JNzzNKQVzo91q9lHulonySrGvbhVzPKOnsuFaL4a7HCUDGkwpHD4WwlUjjAfjnTuiXNdSVR8PVa5fuop9namG6gsoeK2CVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laaLVPTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laaLVPTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B06C4CEEF;
	Fri,  4 Jul 2025 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751631124;
	bh=+JWoxOdiWKb2hRvItgd0XYrJCCDhH1s9nGDOqaEIyX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=laaLVPTnDYWyQgVre2pGsrQVX0fcONfO4VI3YZWrvW0XWFJDy8yz/C+LPc+EXhGN0
	 FMdZEy08qQSgPHdUJGCa4cqb9Objvhj6x9eYSgq3eu/XBIiTtbokGwwokgtbvz2UeX
	 oIIRzflMthtDAvI7vpiyiGe30UVw/Bc6n8cGGu4Sa+xvo91hHUUqWk+Uuaop/bHWxU
	 LEeFHulUHzN908cfYJg0FkJjOfyvR75DQoBf2II+ejPnIe6vtuIOGxd2Zr4c2pJdHF
	 VVhpzxl68tcnOdDZOPukPe8drUWQem9s7DNy+05fyDrqBMI3CBQl0y2HJLUHAu+9/M
	 /mJ9XoR5y9ecw==
Date: Fri, 4 Jul 2025 13:11:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
Message-ID: <7c9baf75-3e82-4648-bba5-da9e47d43185@sirena.org.uk>
References: <20250703144004.276210867@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nx4N+45AiaZMm1Le"
Content-Disposition: inline
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
X-Cookie: VMS must die!


--nx4N+45AiaZMm1Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2025 at 04:38:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--nx4N+45AiaZMm1Le
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhnxQ0ACgkQJNaLcl1U
h9DqfQf/bTfh9ZOyIIi1G3c/NxD6KiufF0YQaj5koaUIwCLw+TlnMJDp/YTIP0Gd
DZZPigyAXceB0bVssOvMVxDG3Qcmd3DGo5uXeLmMPNJUgqXPlbUKsn31r77M4jKB
7vkcmDLuItx8KYkckgZ/qstHIm3ekXFFHZVM5zrwg2XShoDEk7FTwF5dkBa1I9+t
lm+JC9uqjH6w35WfYYTNCENQhx3lDxPwp07FWMEPPoCBV+3/zCFuCW8ERaYHacnb
juyUUgk3uKJNqKrK2s32H9TuaMPDVIBG4q/CRPFamVQqHPKbUleE1MCfc31woLki
1ibxs6U0VNwijd6Ptl6SArBFVWFfeg==
=b6io
-----END PGP SIGNATURE-----

--nx4N+45AiaZMm1Le--
