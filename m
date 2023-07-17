Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A931FD7
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 17:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0FBC433C8;
	Mon, 17 Jul 2023 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689615147;
	bh=AbtYHtS2JtNYwEO8ZoUf0G+9zyh2/yosgJT+eNjvDoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=miHOkMGwmKSDTQgagUIwAtEb0IDWiK2rraaSxWZZBpTstxg7/BodAHcctUcJJR7sR
	 Kfazakw0S/onzX3sVnykx7I4OoWsagmmdL+OR961UpwhpR6uGT59hI4M5pEjSS2HVy
	 ceMXA4eXRpz1hqb0JN20GPCPTufEqGktRUJMPbPpF9nJ3JW0yIsnvGhcNyDOBgfQsX
	 vqN5635Fdh31rnFH4LELyjJtzOm+KV1HqLtbwpmYgCcnCCpEPqLZg+WIe7FPrVJD+0
	 xnSFECStcq2zfG2WUIc65g6PJJbjHhwZD4z7CPlRfcKk0G9pQADuScqao6fqxUDW/F
	 +B0TTU6Hi5L/g==
Date: Mon, 17 Jul 2023 18:32:21 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.4 000/800] 6.4.4-rc1 review
Message-ID: <20230717-sweat-posture-c8b425f71df3@spud>
References: <20230716194949.099592437@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="owMIyiso7i8Ijzkb"
Content-Disposition: inline
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>


--owMIyiso7i8Ijzkb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 16, 2023 at 09:37:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

My CI has no complaints about 6.4,
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--owMIyiso7i8Ijzkb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZLV7JQAKCRB4tDGHoIJi
0jToAQDwT3iu9zV8h7hv7pNC+x1IsYeBjXovzwWxZOvDAJWs1AEA/2Bo96A/C7aD
rq4TkiM2t7GFEU3tmwzrY6HolaV2lAI=
=su4r
-----END PGP SIGNATURE-----

--owMIyiso7i8Ijzkb--
