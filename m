Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150F7F
	for <patches@lists.linux.dev>; Sun, 23 Jul 2023 10:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2991C433C8;
	Sun, 23 Jul 2023 10:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690108878;
	bh=YSNr6NaJj/l3Zd8Zt+CzlpZ1+SDnbH+rJBsSmfHyXXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTQbwWA6nXDrsFbJGliqSuOXYmdyaKXc1jQEixqGfBC/WohhzBKFjc4vb/WREUIQY
	 Zt/A2OSsPoje6slwuM9DNZkPFXWyAU/bD44DDCMkS0eYGtEle+0+Gg7e2XgvpFIKOu
	 biQGkg1TgyJmiSNDR4feyMj1fGD5q8aAK00vTmuBcJyvjF/dn6Qqdlz0x3WaRbjrqF
	 OyuVly8WhbDW6qrmRJW3TJQ9BI8G5kMPZrFUQ1Bkopowyzl9D3GLhjeMGYKHk7HiYq
	 W730BpMUgjzezBLzdT1cTlw1c/Aul1E+lxM0VjSEoHUaphqFDyEdgkX1QlPQTUyHfM
	 /V01qXs09Lg2w==
Date: Sun, 23 Jul 2023 11:41:13 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/223] 6.1.40-rc1 review
Message-ID: <20230723-slate-footman-c422002d6813@spud>
References: <20230721160520.865493356@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4gp48Ds4lL0Dlq6T"
Content-Disposition: inline
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>


--4gp48Ds4lL0Dlq6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 21, 2023 at 06:04:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.40 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--4gp48Ds4lL0Dlq6T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZL0DyQAKCRB4tDGHoIJi
0s58APoD0Z5dBGa9yOAu8Kd8iqSmEBAE9bREMpyU5mUZZiTvLAD+Nt26JhOWydir
WlcchGlZJSO/CjVA8f73f+C7HEK/UA0=
=frpn
-----END PGP SIGNATURE-----

--4gp48Ds4lL0Dlq6T--
