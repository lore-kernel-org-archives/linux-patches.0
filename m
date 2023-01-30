Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B326AA3
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 17:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D677C433EF;
	Mon, 30 Jan 2023 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675100980;
	bh=lWpbM2LBKmzekcSUy3qEo2NqmJsFR7GUfXN4EgsE1hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aFPD8m7icQ4Wb2aBmTkJRUW2YTfW8tAbu5d6/lq8ffWESbGAsa1mGxsgEEZx0UF1a
	 p+Pmvh5wh8LANtauXLD9x0bXgPvzY0pbhZdcRKiKv9l5tGz6Cnk9QEybEGUPj5f8+y
	 wqNqp2O+1hilpWos5/XJHm1mQ9O+pboKhDLmiBKhn3cI6THKMsdwq6JfwxReiV0LfU
	 3QyoMyBoT6tr0AAnS0xx5urNAAt6qgCXRQcPkVF4TFJOQjpwubASG3I5pJw/lgg4p4
	 U21Hkj5gLzFDMbU7csvbXRjla7KK8IkK514GrX+TEdaInnYSTYKaZTC1P5lb6eOAxm
	 g/7fLnXGXK1ng==
Date: Mon, 30 Jan 2023 17:49:34 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
Message-ID: <Y9gDLmmAwaKZX9yw@spud>
References: <20230130134336.532886729@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NR3ZMAgE4gQVTbRu"
Content-Disposition: inline
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>


--NR3ZMAgE4gQVTbRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 02:47:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

Apart from the build issue that Guenter reported, things look fine on my
hardware.

> Conor Dooley <conor.dooley@microchip.com>
>     dt-bindings: riscv: fix single letter canonical order
>=20
> Conor Dooley <conor.dooley@microchip.com>
>     dt-bindings: riscv: fix underscore requirement for multi-letter exten=
sions

I think the email for these came in over the weekend but I was busy
unfortunately. Is dt-binding stuff like this usually backported?
I suppose there's no harm in making sure that it is correct...

Thanks,
Conor.

--NR3ZMAgE4gQVTbRu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9gDKwAKCRB4tDGHoIJi
0vsGAP40zBb1oywUvBje8ff/7Mx472MTK1QSNShqAvwCrFfpZgD/WUmUbmzAj7Fl
jqPRHtP7SYLDpH4UX/I8P8ShQTM50wU=
=6ICP
-----END PGP SIGNATURE-----

--NR3ZMAgE4gQVTbRu--
