Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7997163
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 00:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7033AC433D2;
	Sat, 31 Dec 2022 00:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672445359;
	bh=aKmFnAcijWU3fCBHUiyU7joPGR9QOBad1kj7gvkGXI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P0jQ43E/CSNMY8IOnBP1w3PImVKUbBc75efGRNqICxfSDgdrRru+T67fkQK7jORqx
	 EvDLLYrLhG9PRuV6lRIFtPLsUeMY66TUbeMsS9OaY7CMI6vvXYpWrwLCXsRjZ8DVij
	 0/Ah+ahOxYXJCbw5lKf5Cqd8RymelhTbrEXA5j4EgJRQf4DQG6HHiU/rJ3kyd3RkhP
	 iKtc4EY1zKe2XzhXjtEjoX8X4Jg0kwA3752dByQHYoenIfR/sSClWPT4qDJMvsbbFE
	 6T3PqdbU1+QIgK7bcKx/VyP90SDjSPhdcz9UAt20d3ZNII0jtmwjREnt7UcvY6qAlZ
	 pJV3SW/gx6mUQ==
Date: Sat, 31 Dec 2022 00:09:13 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <Y699qYnUYUwFuQ/E@spud>
References: <20221230094059.698032393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8Bd/gRRSpmcEZlL3"
Content-Disposition: inline
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>


--8Bd/gRRSpmcEZlL3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

> Paulo Alcantara <pc@cjr.nz>
>     cifs: improve symlink handling for smb2+

This patch here appears to fail allmodconfig + LLVM on RISC-V:
=2E./fs/cifs/smb2inode.c:419:4: error: variable 'idata' is uninitialized wh=
en used here [-Werror,-Wuninitialized]
                        idata->symlink_target =3D kstrdup(cfile->symlink_ta=
rget, GFP_KERNEL);
                        ^~~~~
=2E./fs/cifs/smb2inode.c:76:35: note: initialize the variable 'idata' to si=
lence this warning
        struct cifs_open_info_data *idata;
                                         ^
                                          =3D NULL
1 error generated.

It looks like this was reported as a smatch error on Christmas Day:
https://lore.kernel.org/all/202212250020.fyWQFNzF-lkp@intel.com/

Given the day in question, missing that report seems pretty
understandable :)

I tried to see if this had been reported already against the patches
themselves, rather than Sasha's queue, but given the size of the patchset
I may have missed it. Apologies for the noise if I have.

Thanks,
Conor.


--8Bd/gRRSpmcEZlL3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY699qQAKCRB4tDGHoIJi
0paOAQCTmedZoh1+06/NOWEA1Hern5DrQe424AMrKRmmpPYmZQD9FlwYf0A+G9px
PPypEXD+MdlrRbvu9teidCSsgMtemwo=
=pE9H
-----END PGP SIGNATURE-----

--8Bd/gRRSpmcEZlL3--
