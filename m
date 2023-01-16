Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6363E290B
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 22:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A306C433EF;
	Mon, 16 Jan 2023 22:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673908726;
	bh=AVdJVesBckUshztYPU/EucowrURa2SthZW3QIezS5SE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uzlp303vcC7QkFxTNFu5Ng6WtujujepOR/4tumyWz9e1EGpMPenfUxID0dhpoA81x
	 v0hjMGuDs5+iQmIUp1lCFHrk5km3VWKpVRRk3mwcVvR6kkq2OHmD4K8iPvSAe85Rec
	 NIKUW13aNe92nEhQWJmotTjZMZcgR7n2VQjT614WLChNB85qnG+iQrSvNHpHi6YJB1
	 oq7EDgPtgqTAyrQHA07EMWwcz9C+Q1ODnOx7JZa6cajwWttCRAqfB9p4O8q7/AvqC7
	 n7boAnyuBZNSyH2EaUaT9QRp0NDXq4VPNyJblKtCxPWWUj19+rDBMpqO9Giw8sAe4g
	 3xS3rkw+8alAA==
Date: Mon, 16 Jan 2023 22:38:40 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8XR8L+l4iBoUXGs@spud>
References: <20230116154803.321528435@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="db4sbOaDAH1NeJaV"
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>


--db4sbOaDAH1NeJaV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

As far as my HW is concerned, looks grand on the RISC-V front..

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--db4sbOaDAH1NeJaV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8XR8AAKCRB4tDGHoIJi
0r9lAQDt37XJ8yRGSjuc2R6ScAar48FCmlIkgMaaiY0v0Lx8UQD+PzVQ6pwvwrLb
Ql/qmgl9X6s4iVKj3AY4ZOuB2Wtz8gs=
=REs2
-----END PGP SIGNATURE-----

--db4sbOaDAH1NeJaV--
