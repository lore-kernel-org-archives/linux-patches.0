Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416F35681
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 17:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C824BC433D2;
	Wed, 15 Mar 2023 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678902917;
	bh=nvkbBnA1mkxbeGAtvPj2WMk3ljn/r3AnYo78Vjywe5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cZAlb6PbCRHDBke0C6XYDVA0gq5qHbConBcajLSA+s9zjDcCW72UJkDLSJ930P7iV
	 11N1VZL1NJoYX6zrPK4fnybw7PkLpS9WbnxflnXka5o/LNkJ8wddI5AeSbBkrnJBpu
	 yKuZnoPa17o0vk6Xv8b0U6LfdLJISZVfsVQ41e7IYPtJ4lKSONJUKKCksyuG5A9uC3
	 ERR8Cn8tzDqbuCTKvtav25od47kR92jw20aRTbKpgVjbAI0ONrnmx0FWRiN3g2shZ7
	 GaUUqp8DTGSKP12w9LW/uIq2ZDcEKPRuSistpXD7AlSTehBd1NiMq35vcfejRYAnhB
	 wc2MO7aIhcuTg==
Date: Wed, 15 Mar 2023 17:55:11 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Message-ID: <b3619d01-fa8c-4a6b-b253-0a25ceb9a5b9@spud>
References: <20230315115740.429574234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tkXsLAyeyUPziKqZ"
Content-Disposition: inline
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>


--tkXsLAyeyUPziKqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 15, 2023 at 01:11:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looks grand on RISC-V..

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--tkXsLAyeyUPziKqZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBIGfwAKCRB4tDGHoIJi
0lN0AP9BG2ptLIz3K8IkW10PLUW77gmV/Y1aDfrjFFztTWc1nQEAlo9jReR/GhVm
dLNOY4aiRECr0TEiCdDguXSfVClbWAc=
=Jr7k
-----END PGP SIGNATURE-----

--tkXsLAyeyUPziKqZ--
