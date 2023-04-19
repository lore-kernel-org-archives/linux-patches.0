Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24CE3236
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5626FC433EF;
	Wed, 19 Apr 2023 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681930918;
	bh=nS7IFsIQ2XE5KxPoADp1jJAGBFdtwfc5+1V0uHGj770=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RQEuLsbkICXzngP+VJ/NUhbu3gwoyyw6fHEJL/Ok2FLtt48WmvSz7RsxGrz9OiuxP
	 QdC97ckOt2nosMVrVnC4+Ry1eGu6bhYPRKhWG6lLi7asYtBBYNolOP4b7K42YonLB6
	 txiwL5cGuA8Kyo20GDHkISj6G/6MD3QNLGQMrQdTbQ/riZ0L7LWBz7HnaBaHurSwzz
	 2rLLUBjdaLv+eez5dYug0AMbdxVpOo4EOc5gd5ETg0YdjbE89iCA3HmuZcwNIVGTmY
	 w8XkQtyz/4omj3YxZcK0H+5uYYhcpIU664BC1obBP0DLCU8S6yxUpWdYOViQ9oWCKZ
	 ID638eebQPqfQ==
Date: Wed, 19 Apr 2023 20:01:52 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Message-ID: <20230419-tribesman-evergreen-c7a48a28395e@spud>
References: <20230419132054.228391649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vuZoD0rnACbXX0ef"
Content-Disposition: inline
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>


--vuZoD0rnACbXX0ef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:22:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 21 Apr 2023 13:20:25 +0000.
> Anything received after that time might be too late.

Finally one that I am happy with! Thanks Greg.

Tested-by: Conor Dooley <conor.dooley@microchip.com>


--vuZoD0rnACbXX0ef
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEA6oAAKCRB4tDGHoIJi
0q5bAP9yJODA/0JlCTNvUJsAQGfdj5WmyKOFqtzFZqpF/Sbk6gD+OqImbclqqoM0
hIgnUYoUJXHqHl7Xtq1wwPG+Uz9+pwA=
=Dv0t
-----END PGP SIGNATURE-----

--vuZoD0rnACbXX0ef--
