Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545C43D649A;
	Fri,  3 Jul 2026 13:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783086222; cv=none; b=lm/1wZOfDDR75VFAwncwXkmmLNKmVlcSOf1YVX9YavemA0TtlbSqwFxioMxtzExElzuaHF8F5C/WmWuSbK5P4BNkFGhbgPyJUTQ79wpm/22SUlr987MY33R3IVL7fX3Mqr84PiLo5n9buiy3QG1G6ROpM/E4xOCekILZLn81EiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783086222; c=relaxed/simple;
	bh=iIso7eM5YzbFrTo3iC8P44HQMD19LUhEpkdpF2m/jo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fkm/5BEr+VeWPFFBsRK6S05Tgj+WGXhorc9sj5cwKh7pXcKhy2AD6bZDasV7kZMSfLqpS0UD89yzrfTlcPon156MpZE3os2HxoLSu3/06pKRswO64qn9TA6veGt08wgpJnRMQb6yi/9+Mlenf/PU+KAVvoslWtf65EyLPemEKs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B05uNDxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B05uNDxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3801F00A3A;
	Fri,  3 Jul 2026 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783086218;
	bh=s38nu67LJp4w1fQqHhtc1zIkXxsdmvH0k9LPs4dIF3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B05uNDxNJzhfGL6Op1IoiTgTZTW1xPrxpHJBdUPXA2PAi4dd5WhrNQv7txr4Rv0l1
	 L3jSBz1oKYKqA6AQo+V8vKPAx0tTK0SzPzBMUYYYr8HiLl1DNhjBbr6UqMfgFCraPZ
	 cuW3nKe+KbFMFKBcwAuGKhbMqOaeM8Y91fkNxKUvRbM3fq/+2fnHcwSfyTPnac46I5
	 MJmb2Ncmlo1vRMvXjxGncLUA8p9IyXfMrgF3pHrOzgG1Y3qHu6tTlEGvCbmsL9MfsW
	 eGGPEYo/f3dFmxHtC2ko6V2EdQAWA0zJFv3klMvWrPrV+UKlfuyCViFtkrsxfVhQFb
	 BVgtDjzaEDHzA==
Date: Fri, 3 Jul 2026 14:43:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Message-ID: <52b3e867-5915-4ef2-82a8-0caf35131703@sirena.org.uk>
References: <20260702155115.766838875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0GQLPP5UiXITDZ/t"
Content-Disposition: inline
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
X-Cookie: Another megabytes the dust.


--0GQLPP5UiXITDZ/t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 02, 2026 at 06:18:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.144 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--0GQLPP5UiXITDZ/t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpHvIMACgkQJNaLcl1U
h9CkoAf/ZyfIfCE6Y0Ju6yK+U+vO3TAFenGzqZVKhm3WDLtW4xuz/oQ0TLA0ZBxQ
ZzJs3rDfnlCNL0MsBo1PhwkL5TXU1v++NpU6ShGkj+2pxKlOEqvv5Wy3EhMZItj/
JWc9obTdkgYtLWnpm/1i2tIq6C6dX0MmzQZwVVtt02FrMr6x2PkC7HnbPMV+tzNU
lI2eo0HTCBDGrnv9yUjBLC62F0dV7SZDkPMsA7vju4jdvD5GUp1gsnzdqvo8hf1T
w0DNHAmOsq2iNzmCgSR7ryEH+dMXEKo6IYlmVm/gIsmTvWUZHaW0IF215NRWSETw
fPvZs6RfW9INyCKMlFb9d6cd9Isamg==
=ldOO
-----END PGP SIGNATURE-----

--0GQLPP5UiXITDZ/t--
