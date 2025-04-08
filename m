Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC7922A1ED;
	Tue,  8 Apr 2025 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124573; cv=none; b=JYvDIPeEnCCyB0cmN21HJNlbDhBTl1owbjOAAcUIOyGy5zcnYb1UdsaogE0nY4nBHCW47eE0jv+cfbvxHxs19TNxgSLCWz+42LQCRQxUdFqkuejenZ7Xm/LWk5SykLtckdFNn/u/fCiEUi1b/KpWRkJrZWz2sN3yW1qcZT0Ua1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124573; c=relaxed/simple;
	bh=y9SPC+9F2eeTKRh0rHVf6WMRi3+51fAilpmgHZGrM1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frFl+i1lSaH89UMryU3cyo93gxWpcDqagSVuRxVBywLt///NzGkDt5c8g5Vx/VbIf40rpams/JjyFZdfBlRiQqf8tiQK0ZtnPnkeFAoRJtFBmKF4IZzKsxvJ9mpCBBwnjLbUQ2i481J4Q0oTp8ti9kIoBZA0HbN5OYwkVgsn2t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oETUJYtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oETUJYtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E68C4CEE5;
	Tue,  8 Apr 2025 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744124572;
	bh=y9SPC+9F2eeTKRh0rHVf6WMRi3+51fAilpmgHZGrM1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oETUJYtpDcA6qa2qASRYf1ppTlzQpc7/hqrE56F7mFhBw+OY6iNhPpONTFLhEJoux
	 g3nXtGJDhKkxTKzUKJ+cD9JtvgwxXQOeS75tWc9CHQdzu6/cjNrd3S9JXS5fKSc7tg
	 GcRDItI1K8Btqa8BBa+8nK3EzTkSLMsybQvWiGdJTXpQ4wEjk5zB1OoGHp2Fp79QUJ
	 qIvOvXa520/l5ca6ymOc//4cbbBXKGO6/nmbQp5DqCiicmUltZYTw3JnEMwEexrPjR
	 VisWNgE30QqK/w2MYU1rGuFF6JpfomiwCk5mL1PU2QuKdj+5f/ZoCZbMxBby9GVBSx
	 kUF/Nu+KPVGmg==
Date: Tue, 8 Apr 2025 16:02:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc1 review
Message-ID: <37b6a9f3-9a64-40d7-9c69-5c09140ccddb@sirena.org.uk>
References: <20250408104845.675475678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A7P8b1pWztdRKXtl"
Content-Disposition: inline
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
X-Cookie: Meester, do you vant to buy a duck?


--A7P8b1pWztdRKXtl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 08, 2025 at 12:45:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Also arm64 defconfig gives:

/build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR (phandle_references): /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"

  also defined at /build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
/build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR (phandle_references): /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"

  also defined at /build/stage/linux/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
ERROR: Input tree has errors, aborting (use -f to force output)

--A7P8b1pWztdRKXtl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf1OpUACgkQJNaLcl1U
h9DX9gf/UoJVckk3cEDtGhXykJ/53qq6RGB7Q3RbQNzvhgXqqfsa6KExCgJ/ayo4
nBSVhytIGx2et69gwMeWWDpdrvba7mWDfsC5ccrkpTHpxuSzF3a8vv/rXKbys90q
0NiFqTKvklvbevq7l4iQ4Tp9SqEKto8zx8cqlWlKx6SyNb9g1WJ1KspM08wiIJ1H
lS9qE8LXUKWWmDngbSBVLW3Dt/9tEl+xStXG/S5T2AHSroTDrRmmjf0aYZ5tQaDK
dRJT3l108+V6e/WfYyPMfRyOnvOedqKJ4d4WuvPFfo89OQXvsrk+ruAFAUFFMhXr
tVzndYP+V+O8fV/zzHoc4m4euo0IYA==
=Benr
-----END PGP SIGNATURE-----

--A7P8b1pWztdRKXtl--
