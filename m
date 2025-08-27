Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A6134DCC3;
	Wed, 27 Aug 2025 11:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756293498; cv=none; b=r45rMAwqbmZi6TPW8yJYZQWA8z6TETiCsPdirpAlPAhs59VVHMHF3M7sbp/SOQbzQ0hmvbJ0+7NEiYR2VV+QlZaGVcWjZ4upZr2Tc3FRMc4ERjAET9QbdlVgWlUtSwviQeZ2UZrvhCOU2QvI8zPzZmZcn+R91dKQyKy42pswj7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756293498; c=relaxed/simple;
	bh=l2JJgVoBKe+Px/Nhr4vuq5pEtX6ZkuoHOkijdLCZ5BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SIsBiN7gD6RP8dJlzhokGOMY3rwc6xOKFVOhchLvTj7pdOKSnk/eNiH99PBW811g0kHEaA6cWZ8AmoX2dtory9QYa4PPq2veYhy+FWVjHVVkC7fISYKFhHiyzG9CGey7OVY/bmh1iYZsxMOerB9i6q1ueStgLNURld1qP/PyIQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AW+V/M9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AW+V/M9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5000C4CEF4;
	Wed, 27 Aug 2025 11:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756293496;
	bh=l2JJgVoBKe+Px/Nhr4vuq5pEtX6ZkuoHOkijdLCZ5BY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AW+V/M9RNV2/KZKK5+Wr886wALIsc3Cz1r3eEw8XgYYoh5LKv+otLh0Eoy8PMxPQ1
	 gSUg+fuf8ZOsezcMrMX5lNzNPbiHiWtZUPUhnt3Wg7RQ4WhRLpRS4Uxd/dluHxE3wy
	 heVcAXRr4lb3RSWt0zypzVFTlTz9Hj8UIlBCq+MshFwIMxUKRxtwX/x/0HrOHYQG7M
	 PKC84qW072+176SSD96p1MQlOa43td7squ3tKJnxNLfup3MhoPHIkmqJa/vhprrXhO
	 5NdXAPzGhksleWYrpHBLj3/cibBvKhd414rdBk6h4z/o/DpZalRzISMq9HE+xQwQF2
	 m2nMDYzDG/rXw==
Date: Wed, 27 Aug 2025 12:18:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.1 000/482] 6.1.149-rc1 review
Message-ID: <cc10d9e5-41b9-4f57-b736-9c34429a7501@sirena.org.uk>
References: <20250826110930.769259449@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tywYIuNuljt3+O8u"
Content-Disposition: inline
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
X-Cookie: Most people prefer certainty to truth.


--tywYIuNuljt3+O8u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2025 at 01:04:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.149 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--tywYIuNuljt3+O8u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiu6W8ACgkQJNaLcl1U
h9D18wf+M9OtzdZlM5Gi2ZqDWGbu2fMVdEtJ3Td7t67PfLjtAEHWnL9ozU87ihRG
oCCoaxV8UqBbljetHVbl584uftgCCyvahQc8zFmhoFyeRZup9d6hB/RSsY4ZJLyG
p0Aow+HglL2lyT+pG173zJCSkTJ6JYPtrbJYDZS+jXuECNTcdt1zTmJuZtkPzsjV
MkNuodKwXjBV1TtkQhNO0KPog/H8RTzIpwEIE3kCOQr2WVVSwyur6+8PR3tEwn1E
//t+l+4WSxc2mMLvcICGvuoUDo+0Kyrelx1oxrx5ixGDzKrSL2Yz1yGK7C5ulv/9
I2pbAESJNHZmYN3EyWti6b8QW27PCQ==
=+9ba
-----END PGP SIGNATURE-----

--tywYIuNuljt3+O8u--
