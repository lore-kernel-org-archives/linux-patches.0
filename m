Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1EA1494BC;
	Tue,  2 Jul 2024 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957627; cv=none; b=GZatGM0c0M0ytO1gvkPoK3Jc/VH4XtncbkZdfhXJoOT1/jekdvxcMixA079f1KQk21ED+AZDplHi7ZhOQ4AqZw1W9GEoya+RXTSWw6Cs34Bw5b0wtnFRH8nspPTaHekD8g8tx3fMEw7fASP2VqgThU2swPcDfBOSLBA+yThoZ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957627; c=relaxed/simple;
	bh=vlbE0Gyo7sOV6hR8YSh/Jr8L0EFK2OAZEA5MRP7sHE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJsHFqRpU8rNO2AKLv5JfImX4fNPKbi2J7XxfCdN81iOWXtGmN7PSC+ehE3+k3gtZysXRT1qw4hYNvsBt9qwG6vbMUEywCjo9FvdbXtQtiUuK9SfYTVn1dAr6EFT3lMkQCoM6Y6XqVI40IhqZFhP47A3yA5Nu1AeCvhPtAdN2Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OuSlEY/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuSlEY/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1355BC116B1;
	Tue,  2 Jul 2024 22:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719957626;
	bh=vlbE0Gyo7sOV6hR8YSh/Jr8L0EFK2OAZEA5MRP7sHE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OuSlEY/UJMDyweRAnUTcCVpNUjsqRE4+Ijfoa+57+2sieJHQTIVofAwU8e7ccpWAw
	 S/D1BcNXFZ+a5b/ZOJucfar5/y7glAb6X9JIOtFCZOvjJ1YOSHKjH1tUC+CaNmj2zK
	 u2GR6Joh6UWwFi1J9dPb97y8pg6B8Dl9XEg41CLXVum1pXbob0gVODVMKtO+lYljwW
	 /XnaQn3q4ost5pgbu/ohyxy9ZYGVHM7bsWY3KVRsUYQZgdIJDu04/DBFxpJqzoDZ3f
	 vg1ngwfuPDLwS+uuWOh/iEir0UjVCGNQgGm8/monEuMpyRfS/M1z3PWtejLZLGxkec
	 TqRqqVJs14K4w==
Date: Tue, 2 Jul 2024 23:00:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
Message-ID: <c0cdcf48-6be4-4df2-97f3-5561fd8f81a0@sirena.org.uk>
References: <20240702170226.231899085@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HE2EiyA1jZRU7HBG"
Content-Disposition: inline
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
X-Cookie: Phasers locked on target, Captain.


--HE2EiyA1jZRU7HBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2024 at 07:03:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HE2EiyA1jZRU7HBG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaEeHMACgkQJNaLcl1U
h9AfsAf/bZ33S2MTKdriq3XXgm0b5qcEdFc7PbwEKKIaT46xNl+X4jBm6FX87ihc
emnakbb9L6ijFjkaANCvSwJdv/cDxiXMJgOjUcY3l/e3uWCGMGMGplVRW0fxPCzh
mJ+A1IC5EArhaCYdu6eTwnyBnlFZ99QFk5tqAgXy2rk2gNam8udsI8vkl3AxmgSS
iayMyU/GRD/v4maEspChZeYxsbC7qizOkNhjaAC0lM7kOK+7+Qn6TzSOXHRoGnUx
H4+570f/yFfclBmOzoIp9DD7tACoWdMmYh5gJSRAfRWQcUqyG1AmaWoAtYwplOen
au5PMg2XJQQrV1SgtvBHX2okI3hVvg==
=tcFX
-----END PGP SIGNATURE-----

--HE2EiyA1jZRU7HBG--
