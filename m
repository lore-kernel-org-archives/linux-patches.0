Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1332F328A1
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 08:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584ACC433C9;
	Tue, 19 Sep 2023 08:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695112069;
	bh=r9QmRiJyr9c37QRlvNa9jFqmNAcuHpDN6UqmEzIp5+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DlruwKHYAp31M/iXfDTCorbUUH+CU0dunFIulD2ze06+jZHoRLOBLwSRvJAm3vrW0
	 CvzcXAh+qnyIz6HOH5DKgfM5sCeD4FT17xt3WyXOA8Z9RogVyr4LE3gL1GZV8xD0p6
	 yW1hsBWb/57dl9aS9IX2+seqnTCZsRnrkOkurP58+913zCBaipaO+KyMyS3fgivZXW
	 0tHj9P0h6AU5uEtMnxhMD4HjnYgjo/9THqCYSzcjabVP9A1OEdqz2hflR6+7d2wpA3
	 kO2rcc+QfspIDfKOOZe3Iy1GKu91AHfx6CTEDEozE/09XfN7BjnlQf7bVg/VfL7K1B
	 6lACX+wSfQNQA==
Date: Tue, 19 Sep 2023 09:27:43 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
Message-ID: <20230919-7d5bab0ca9c321711183986d@fedora>
References: <20230917191051.639202302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HKSILnXlAUrk7SQC"
Content-Disposition: inline
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>


--HKSILnXlAUrk7SQC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 17, 2023 at 09:10:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--HKSILnXlAUrk7SQC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZQlbfAAKCRB4tDGHoIJi
0tVmAQDk/UG5t/KFl7SOZULlFzBXgShCiqSp0muNy7tfz3vDkwD+O3oEMXLDBPrU
WmASn9Q7QJ8eVH/SBxneFnDd7uIfsAI=
=Um8+
-----END PGP SIGNATURE-----

--HKSILnXlAUrk7SQC--
