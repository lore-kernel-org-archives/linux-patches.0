Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3B8470
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 18:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB87BC433D2;
	Thu, 12 Jan 2023 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673549129;
	bh=z2EaDr0mycRicVJhhuAX799aLzcYHxAh4bAC2+rrckk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9OFZkoJT9dJoq+CcSI50P/Tj4OPjOhmaHPj6y7ioLP8aX9qN9Ji6S8hJducBfNXM
	 ju3hTRnEhaSFCISGoX6gFuEUCe+x6jQrfOc+N2xlR2QwMJs2/qgpy7eK1pfrSynSxq
	 LUqsD0N0LBqVN6ceZC4G2wVwIJW57mt50xiyECDIJK+VmcsO7m0pj03BOpIkgBOrfd
	 yoWX3EukIzX/O3TQ/bBhANOqkDl7i3Q2d0JQuANWw0qUXOl9kiR9n4h94jx/j2BVW1
	 Tl5kEKXhYGxUl4nUs8miW5v0R9rDBej1ulfLtQzPcG0J42P23DcEPzjDY7WrACxgVs
	 T+FdbHHuJXTag==
Date: Thu, 12 Jan 2023 18:45:24 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <Y8BVRObU8v8KUZxx@spud>
References: <20230112135326.981869724@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fwuvP1Jk5iVb4Kyb"
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>


--fwuvP1Jk5iVb4Kyb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.6-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

Looks like not much in it that's of concern for RISC-V, but FWIW:
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--fwuvP1Jk5iVb4Kyb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8BVRAAKCRB4tDGHoIJi
0kz3AP9fjlEnFeqSysQuxkZNT480k3srTgkwc0n/z2c0kPmtcQEAxEzq1Cj7Z2J2
XbY4+l1/snNjOSwuxonSUFB4vjoPKAQ=
=HsRv
-----END PGP SIGNATURE-----

--fwuvP1Jk5iVb4Kyb--
