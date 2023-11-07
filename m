Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E764830D1E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHe46jxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5610CC433CB;
	Tue,  7 Nov 2023 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699373069;
	bh=Aff5Hic831y3AENLJQGjNlNZ1P6a6eEtwnYuHgIQuwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HHe46jxJDzVpMN/xenU0Dm7I13f8wKvStRzYQEZpFHu+BbqOZsdYbAc19JO+yFuSQ
	 j4scsPAnr7IQe+nc/XSfV1leLhmyMVYACQkvMRtQn5+VLTu+ZCx8ka88bVZv8L1mHl
	 2sBojvbX5lYB0X8ZdfauTCcnSH1wGUW+SavMz6/tLmPG2DJUrUSMTaE+7QqyS9S6PG
	 T8weEiedtQ3XCCLMSc1lk8/Dz2gTNVv812F4d8GQ883tE7evjAdT3SC3GGQ7TG7TQe
	 e838tqFLA8Bs79o7bAJqHMC/1/VXjCqZQytkr8nZYz4GNKVT1FHLKDRxo40lybfaBx
	 pC7hxbG+r2XKg==
Date: Tue, 7 Nov 2023 16:04:23 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
Message-ID: <20231107-gallantly-predator-8f064854a6a6@spud>
References: <20231106130301.807965064@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3518Ha5xSTlk2KDA"
Content-Disposition: inline
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>


--3518Ha5xSTlk2KDA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 06, 2023 at 02:03:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--3518Ha5xSTlk2KDA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZUpgBwAKCRB4tDGHoIJi
0qzfAQCMfc+ctKjDuDkmhBfxYE4HSYdwO0znHpDFS/JGLR4ysQEAn3TWTmrZlvU6
o0QOd5HOaRDtmlALgynOZRUY7DKC5ws=
=5nI8
-----END PGP SIGNATURE-----

--3518Ha5xSTlk2KDA--
