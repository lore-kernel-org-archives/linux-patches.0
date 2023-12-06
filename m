Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEB82E3FB;
	Wed,  6 Dec 2023 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkV2jMFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B5FC433C8;
	Wed,  6 Dec 2023 23:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701906005;
	bh=JQp1oL5A45HzXA8sxH/IkXyf7ozKJRmzRu5UbEsDfYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nkV2jMFPNNdIlnzVH790fgYfLVgoN9J7v54BsbqXY6MbBQLIdO7nY3RWZvlB5jMsC
	 0M4LVJmKLyKVQJq5IJQ510dctIrVO8SR2HmEBrHiUCrgSim/l6rf5BWbyPjJK8LX+n
	 bzMHIaVqCj5LwQ5SAo/tr+WS6uvRqdN+EMl3MHrOlVSSKkfog8YU2XLe7eJGrZG3JA
	 xuAGQZZSUyNv2IFiRHEeV1wrHG0EfmJtaUE8s7j9cROwxrFIeb6WlXpweZfjMKtQ2J
	 xiU3LcsAyO709V1BTQ1Tyi9/3TpLaJcCLk712zEhMkqQJTaBeWq/sST3mOWQldX8yu
	 3vHBaqLyd8jtA==
Date: Wed, 6 Dec 2023 23:39:59 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/105] 6.1.66-rc2 review
Message-ID: <20231206-deviancy-trickery-f90d0374db1b@spud>
References: <20231205183248.388576393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ot5A10vgoOVtOqYU"
Content-Disposition: inline
In-Reply-To: <20231205183248.388576393@linuxfoundation.org>


--ot5A10vgoOVtOqYU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 06, 2023 at 04:22:38AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.66 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

rc2 looks good, thanks.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--ot5A10vgoOVtOqYU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZXEGTAAKCRB4tDGHoIJi
0pbzAQCCr810gUItXA5O8wXYoS1ZUXprnRzcHCSkq9OqD2Ru+AEA0TGHzt/paPAM
zQwzFCVl37LzZBIEbeRMWbQ5xsM03QY=
=Z4HV
-----END PGP SIGNATURE-----

--ot5A10vgoOVtOqYU--
