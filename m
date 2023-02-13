Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C74AD52
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 21:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E821C433EF;
	Mon, 13 Feb 2023 21:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676323115;
	bh=yNA8N33kWyxOe+kb9FbBhbOwxsJK2XGkWEL/rc91p8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AmbyDDIOD5LYGDjAWJjDeWs74d4lU/JnT5xL2X4RcnNxNRww4PDcMk15CevgPS5Ac
	 gjbOsu15XA1Fck85Ek3IK/BS/wAe0o9bz3dEXa79vA6XwJEiVpfAWllkmI+cvPuZG4
	 I0GN/doDVjRKd3PN0zmMNmOeGJC1phHJb3Nafo+exXC1raLhXz2+wW2tMIqN6woP8F
	 jsqpESgEohdNQEr8U8Ze7QDDFbcJYepIKwLCQJ9IYFuy3b3ZW0DJmPMTdB1zJ0rNGR
	 3aR9EspaN+j42G8ZDiwoOX4+KX9CEfMnew84mMTSA3jFMcK3x0UIRezPEFgUljUVU/
	 5JI13LKJc0NOQ==
Date: Mon, 13 Feb 2023 21:18:29 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Message-ID: <Y+qpJXdpXuTmXcxW@spud>
References: <20230213144742.219399167@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oK7ZIoPX9AZ/i/gs"
Content-Disposition: inline
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>


--oK7ZIoPX9AZ/i/gs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2023 at 03:47:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

LGTM chief,
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--oK7ZIoPX9AZ/i/gs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+qpJQAKCRB4tDGHoIJi
0smFAP95y4pyC1qj7J7bPnu2mmWUZbgbgH3eWaPxDTaaL/fR8wEAyxbTHgsuvmsi
088qrcNQOIZkynL73tqXeoc6dCUR4wE=
=QmYo
-----END PGP SIGNATURE-----

--oK7ZIoPX9AZ/i/gs--
