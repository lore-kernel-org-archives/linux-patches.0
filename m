Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10309334C13;
	Wed, 22 Oct 2025 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145071; cv=none; b=KSNCKvOlO913KNM1hkYEPNx9pC2q2/OdTWzo0ocJJ6LPuPOXPVVKJoaKIMffPcmRIP11ib9CSaiLF8nK9yN4yZLEamyOt76C70aBNfz8jlZXDsE6qPdG0X9tBFhmZQlyOD4dchx3wTNXy7rKqxCfiv6JnLSDZ6u5X/n81JGZ5Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145071; c=relaxed/simple;
	bh=GZ5QRVkbbDiSJaNKnQQ8671/lTx7F3GslT+/ZGbxUwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0qkvlIo70ckQEIN1rfXUbipofzEJUv28Qaw6aZn/7hV3dwoNVrPazVuxI+MsF4/lQUsHLveCDsAheO53YJwtMoKPTQLzZh7sCprcwkoairOYiPylbAg6TII0ZLR39f0dImPFpjpfixPqucjilYlB3lWcNJu3wV2BBbHjoO7Jug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJBsOMBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJBsOMBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0534FC4CEE7;
	Wed, 22 Oct 2025 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761145070;
	bh=GZ5QRVkbbDiSJaNKnQQ8671/lTx7F3GslT+/ZGbxUwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rJBsOMBHN2fO74VeJwMOk7ese4i8ETeHfgkSQ7TTi1dq6WOjj7vC0yX4FjvkLiYQB
	 QEOkO69Xb4pUIiGL0e2bBimH71pVij4FN06UzPxlUNaFsa+INGOWOz3j1Cxi4WQOYW
	 /y/F7FCzCd5qOtZ5Y+dQg613hme1aj+HMxfdAKqMXBPelg4Ql0L+WGGy7XtmprlVG5
	 BPZJZowVFP48rPPrQH+H14y7UMoA5WfNkIaHiAO4dMQkpsCDTx95RkE4U5BVbeAeiv
	 Yx/MrhFhYw3bY6EzBw3dv1yfnbWgG44dolbgkuiUDzzCdkLPSNAP23cRU2+mFGDybA
	 2DT1MvRAhLa2A==
Date: Wed, 22 Oct 2025 15:57:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
Message-ID: <f6f6fb8c-1900-45de-b739-7cd9bd1ccf5b@sirena.org.uk>
References: <20251022060141.370358070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rbPVXkhgeuN1ogkI"
Content-Disposition: inline
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
X-Cookie: Remember the... the... uhh.....


--rbPVXkhgeuN1ogkI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 22, 2025 at 10:19:29AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--rbPVXkhgeuN1ogkI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj48OcACgkQJNaLcl1U
h9BCVAf/bnyDYnsUiQ3ORHEiMa0REL0oChnA170+LYSuFR8qFkKyRxJ4fOzSY1Ut
l+z8J8wyMPbc7I0dg/9WfIc2S6xIG28Kj1NWWGMePPXpfUBQwnBhn6vo543/Pk5L
oNDDbRmC4xXKbYV3P/p6ufu/WWo4tBEDtL2UVb7h74yWuGiRsa8+cN2DH0w0U2q+
ztpIbd1PEpaigEA4O+ayDYtTtQjY6nule/QfQ2boGCtQ05l6Tii9im40UpFNjVc/
y3Vqf9SUKMzAlMQ193tQ2AewiStxsQ6sptAMeyLEm9KqOBTPeHAyJhvTX3b9YEj2
ohE/Tp5QPq/G4mX6bxKCKiTTZUMNyQ==
=/wal
-----END PGP SIGNATURE-----

--rbPVXkhgeuN1ogkI--
