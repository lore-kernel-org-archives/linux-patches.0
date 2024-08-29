Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA318CC02
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 12:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933521; cv=none; b=FI9Y/UV16CifcXjqldQ6AAqlNX6qQGBgE0X91+h4tPXIq5RmUeSg/bxtfgXpY2wozs38jGiOykfGAijV7ID7AeyWePUKYrJxXO8drbMS0QThsxTt9v5p/WeyS8rl6NyMj/leOTLPThZ7NfYK8oXAOq0pvyNQ9XaSMDZGJ02/Gt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933521; c=relaxed/simple;
	bh=zapUbZJQVanMkIHZhhfPhDB73v8gU7VmyyYoZ6pTKoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h94wl6/JNBoTPLjn3DvehAL4o2Y184Aa3sl29ACrAFVgDfcCOicTSNmJwuiHorR3BgUDT0aArAi1zkliiAUytoHZjXCvinwQPy1FwNXnQHf5gXBQnnkas0Ij8hr20SicuU8d08hmACs0s0b1lLJVrfwPqB5EbdphBT3rtgD5Auo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 99E241C0082; Thu, 29 Aug 2024 14:11:57 +0200 (CEST)
Date: Thu, 29 Aug 2024 14:11:57 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org, kuba@kernel.org,
	linan122@huawei.com, dsterba@suse.com, song@kernel.org,
	tglx@linutronix.de, viro@zeniv.linux.org.uk,
	christian.brauner@ubuntu.com, keescook@chromium.org
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <ZtBljcXHrUdvglG0@duo.ucw.cz>
References: <20240827143838.192435816@linuxfoundation.org>
 <ZtBdhPWRqJ6vJPu3@duo.ucw.cz>
 <2024082954-direction-gonad-7fa2@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBWiqXJWiq3wsYRA"
Content-Disposition: inline
In-Reply-To: <2024082954-direction-gonad-7fa2@gregkh>


--JBWiqXJWiq3wsYRA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2024-08-29 13:52:59, Greg Kroah-Hartman wrote:
> On Thu, Aug 29, 2024 at 01:37:40PM +0200, Pavel Machek wrote:
> > > Christian Brauner <brauner@kernel.org>
> > >     binfmt_misc: cleanup on filesystem umount
> >=20
> > Changelog explains how this may cause problems. It does not fix a
> > bug. It is overly long. It does not have proper signoff by stable team.
>=20
> The sign off is there, it's just further down than you might expect.

Is it? Who signed this off for stable?

cf7602cbd58246d02a8544e4f107658fe846137a

    In line with our general policy, if we see a regression for systemd or
    other users with this change we will switch back to the old behavior for
    the initial binfmt_misc mount and have binary types pin the filesystem
    again. But while we touch this code let's take the chance and let's
    improve on the status quo.
   =20
    [1]: https://lore.kernel.org/r/20191216091220.465626-2-laurent@vivier.eu
    [2]: commit 43a4f2619038 ("exec: binfmt_misc: fix race between load_mis=
c_binary() and kill_node()"
    [3]: commit 83f918274e4b ("exec: binfmt_misc: shift filp_close(interp_f=
ile) from kill_node() to bm_evict_inode()")
    [4]: commit f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
   =20
    Link: https://lore.kernel.org/r/20211028103114.2849140-1-brauner@kernel=
=2Eorg (v1)
    Cc: Sargun Dhillon <sargun@sargun.me>
    Cc: Serge Hallyn <serge@hallyn.com>
    Cc: Jann Horn <jannh@google.com>
    Cc: Henning Schild <henning.schild@siemens.com>
    Cc: Andrei Vagin <avagin@gmail.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Laurent Vivier <laurent@vivier.eu>
    Cc: linux-fsdevel@vger.kernel.org
    Acked-by: Serge Hallyn <serge@hallyn.com>
    Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
    Signed-off-by: Christian Brauner <brauner@kernel.org>
    Signed-off-by: Kees Cook <keescook@chromium.org>

Regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--JBWiqXJWiq3wsYRA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtBljQAKCRAw5/Bqldv6
8hEuAJ98arwiZ0nH0QVgNCAYcu+ZgY+ylACfbnoO/39Q0lW4EkGXGBCy1/zxhUc=
=lz5Y
-----END PGP SIGNATURE-----

--JBWiqXJWiq3wsYRA--
