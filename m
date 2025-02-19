Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EAD25E449;
	Wed, 19 Feb 2025 23:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740006622; cv=none; b=Ee/aABQLy/c+gjVqOizYGb3eBn1hopeogJggmA6/2Dh90GE/kzIHRJZMFeKeh722wGJt2tmufI+u+ZvuANxWbgGPUUTGwqCCnwjJq2RfLdgBmQ3LV7fYTRz4sGn43sKAnH8QotjbhVf64Dh2yGPq1qLkDYJ+DiJpvjeTE1p9nSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740006622; c=relaxed/simple;
	bh=R+drP0ZeDBQHDs3Y/gXGGFAVwGvsC3oJl4MozRcpvvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ta6C6evgWrcvOO2rJb+AuP314KJzdzl6izjJJsy5E8eoRR+i+b4/LyiZlnyno3Gvn2d0EmtnejAmKotrHWcIDuyFjgOUOQ1L8Kg+tKi799dMAw13uBvArxe2+DGpho4ngqgYpJh/tmNM+LkXLVl6UGZVdj/Wp4XTKKw9S4hvCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJSlo3Kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJSlo3Kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B96C4CED1;
	Wed, 19 Feb 2025 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740006621;
	bh=R+drP0ZeDBQHDs3Y/gXGGFAVwGvsC3oJl4MozRcpvvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iJSlo3Kv4DtbBJBKiyIqxLFY/RQ5rk0qvA0ji03CHG89wssUXR2CeY15hzKp/1QWx
	 +FRPn7HCVdYT3eD2VSdOXg+doGGKsLEn+awrf37MaVUpA8z8vQR4AUqmYPuF9amleZ
	 rDKHD1zsgYtMQTa48P1bMqCeG3ds2wEcJCOf7QfCnEVLcrFvhvONRIaOJ/TXizxuzp
	 5QlBYQLw6TYIcA/th4RS4kqnxV17IvjHEsHkunw2RxeJtzT3i0z3lb1aVePVFDY2so
	 mt/v7nrXXv28vxhKCx2jANH+XyvqrzPBFrAR+nSIVw0aXTSwI5wiUJDLBgiSJd0kWA
	 GkUgeJ5YwPRlQ==
Date: Wed, 19 Feb 2025 23:10:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
Message-ID: <Z7Zk2x8qHLaV1oBf@finisterre.sirena.org.uk>
References: <20250219082609.533585153@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TPvJc1INWGlJ4w32"
Content-Disposition: inline
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--TPvJc1INWGlJ4w32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2025 at 09:24:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 274 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TPvJc1INWGlJ4w32
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme2ZNoACgkQJNaLcl1U
h9Bwzgf+OwQr9fsN70XZLLo965eCAZujezE47/OkGUOiPc/R0AQ+IEPO/s8VTESQ
m6iRbXCXG+L9W8NjS/Ynt9yR9DrMbLIDcWtsdQZ5I9I8F/fmk5PN3PRK0v6dhxMO
4FZad/pAbVh3oed5M2paqnhFoImmcr63QkyPSCwWoEd447aI35PQyh+XYARJP2L0
Jc+Z0gpzXo2E62KOyidykQSoZUf+thjyJaQKfHGru21O+d8+gQloPj0BNosVWxav
b3uaVhGFldsPXvSv72rNEpJlFmNuWsuv2xYTgUF13d0OwzSsUuMNTMpuFECO8kDY
eClPNEOWIkrqZTAfMPsU2HEo6PLciQ==
=QSOx
-----END PGP SIGNATURE-----

--TPvJc1INWGlJ4w32--
