Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCC01A01B4
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 19:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721156513; cv=none; b=R1NYgdepf0U+yAYIRl0AXGuvi2U3mxXxXoE8USHGFWcuay/mYhN6GepVxvA8XOhn6mxkm6QcCvNX9kHH1vNttCmEK8PZA3uUHupIBRac66QuVdLIVm3NYqF3eZ2Hn3Z6O13kr2C24PqEQa06ubv2UVJS0zmTtA7ZbVsZPZQrhWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721156513; c=relaxed/simple;
	bh=qbPqSw7XIaWV92RDB+Ej8DeyFRoH84eG7k5j3NO6WIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TELa4h/CgPMMuUlLlxbiRjvZEOHvuFQ64w5fmNY7gF2WDRQeR936upfKbRDF5CgBCYyctqqe0t6k7g21vcvap4lKUS1dhkR3OqXnZKIKObc3wC54n3JHimOA3RIiyfgX1sRiL1/UxgVlysKPlig6RodwwJyXkI+7ti8CXVIT6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0468C1C009C; Tue, 16 Jul 2024 21:01:44 +0200 (CEST)
Date: Tue, 16 Jul 2024 21:01:43 +0200
From: Pavel Machek <pavel@denx.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/96] 6.1.100-rc1 review
Message-ID: <ZpbDlwpfBwViDonu@duo.ucw.cz>
References: <20240716152746.516194097@linuxfoundation.org>
 <aaccd8cc-2bfe-4b2e-b690-be50540f9965@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EcuUTjkQxgP/gNb4"
Content-Disposition: inline
In-Reply-To: <aaccd8cc-2bfe-4b2e-b690-be50540f9965@gmail.com>


--EcuUTjkQxgP/gNb4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2024-07-16 11:42:39, Florian Fainelli wrote:
> On 7/16/24 08:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.100 release.
> > There are 96 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1=
00-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-6.1.y
> > and the diffstat can be found below.

> Commit acbfb53f772f96fdffb3fba2fa16eed4ad7ba0d2 ("cifs: avoid dup prefix
> path in dfs_get_automount_devname()") causes the following build failure =
on
> bmips_stb_defconfig:
>=20
> In file included from ./include/linux/build_bug.h:5,
>                  from ./include/linux/container_of.h:5,
>                  from ./include/linux/list.h:5,
>                  from ./include/linux/module.h:12,
>                  from fs/smb/client/cifsfs.c:13:
> fs/smb/client/cifsproto.h: In function 'dfs_get_automount_devname':
> fs/smb/client/cifsproto.h:74:22: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>   if (unlikely(!server->origin_fullpath))


We see same problem.

  CC [M]  sound/soc/soc-ops.o
3131
In file included from ./include/linux/build_bug.h:5,
3132
                 from ./include/linux/container_of.h:5,
3133
                 from ./include/linux/list.h:5,
3134
                 from ./include/linux/module.h:12,
3135
                 from fs/smb/client/cifsfs.c:13:
3136
fs/smb/client/cifsproto.h: In function 'dfs_get_automount_devname':
3137
fs/smb/client/cifsproto.h:74:29: error: 'struct TCP_Server_Info' has no mem=
ber named 'origin_fullpath'
3138
   74 |         if (unlikely(!server->origin_fullpath))
3139
      |                             ^~
3140
=2E/include/linux/compiler.h:78:45: note: in definition of macro 'unlikely'
3141
   78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
3142
      |                                             ^
3143
In file included from fs/smb/client/cifsfs.c:35:
3144
fs/smb/client/cifsproto.h:78:63: error: 'struct TCP_Server_Info' has no mem=
ber named 'origin_fullpath'
3145
   78 |                                                         server->ori=
gin_fullpath,
3146
      |                                                               ^~
3147
fs/smb/client/cifsproto.h:79:70: error: 'struct TCP_Server_Info' has no mem=
ber named 'origin_fullpath'
3148
   79 |                                                         strlen(serv=
er->origin_fullpath),
3149
      |                                                                    =
  ^~
3150
fs/smb/client/cifsproto.h:88:28: error: 'struct TCP_Server_Info' has no mem=
ber named 'origin_fullpath'
3151
   88 |         len =3D strlen(server->origin_fullpath);
3152
      |                            ^~
3153
fs/smb/client/cifsproto.h:93:25: error: 'struct TCP_Server_Info' has no mem=
ber named 'origin_fullpath'
3154
   93 |         memcpy(s, server->origin_fullpath, len);
3155
      |                         ^~
3156
  CC [M]  net/netfilter/nf_conntrack_standalone.o
3157
  CC [M]  net/netfilter/nf_conntrack_expect.o

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EcuUTjkQxgP/gNb4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpbDlwAKCRAw5/Bqldv6
8o90AJ9pfWKazKzyQ9Zf8xtjMMMi9+9+iwCbBZREk52w82fzRyy6hMkeuT5au1Q=
=qL/n
-----END PGP SIGNATURE-----

--EcuUTjkQxgP/gNb4--
