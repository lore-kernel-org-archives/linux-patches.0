Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FA319148D
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 11:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724931465; cv=none; b=V6UqnopL9cDUYjyNZH7+eBYpI3J0OiowINWsaEsfxTzMQP+awFCKdtyf47yQpMPiRsMlk/a/YiDtwn7qWAmm6Gns78WdbkNHzIqS9ibGweQbwbGJpW54Y/GDzBZQo4XqtQWLs1Jel1zlF2hiI73J36exXy1zhUZWhP/XVtIutg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724931465; c=relaxed/simple;
	bh=oOQOr+p9coOi9gUPDNiWFW8vOQny+mAQ1S6UKIjr+p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccLelaJH54Cpx8si2AnCG//2HE6ug8BPd0bTPIrmIbicH6hLkrwP2IkM8CbUJHFc2FmutZ8VtLegAH8ZFU9EL1EjfC8RieqPSqM/q6FSbxmijE4Oq2gWrelhb9puchlnZypXWdjnxgDU1EKPXORs3OL3OjJpns2ZgSpa3Oxv1AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E8A011C0082; Thu, 29 Aug 2024 13:37:40 +0200 (CEST)
Date: Thu, 29 Aug 2024 13:37:40 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	kuba@kernel.org, linan122@huawei.com, dsterba@suse.com,
	song@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
	christian.brauner@ubuntu.com, keescook@chromium.org
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <ZtBdhPWRqJ6vJPu3@duo.ucw.cz>
References: <20240827143838.192435816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+UEXMl8Ve75Dvp+Q"
Content-Disposition: inline
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>


--+UEXMl8Ve75Dvp+Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I believe these have problems:

> Jakub Kicinski <kuba@kernel.org>
>     net: don't dump stack on queue timeout

This does not fix bug and will cause surprises for people parsing
logs, as changelog explains

> Christian Brauner <brauner@kernel.org>
>     binfmt_misc: cleanup on filesystem umount

Changelog explains how this may cause problems. It does not fix a
bug. It is overly long. It does not have proper signoff by stable team.

> Li Nan <linan122@huawei.com>
>     md: clean up invalid BUG_ON in md_ioctl

Cleanup, not a bugfix.

> David Sterba <dsterba@suse.com>
>     btrfs: change BUG_ON to assertion in tree_move_down()

Cleanup, not a bugfix.

> David Sterba <dsterba@suse.com>
>     btrfs: delete pointless BUG_ON check on quota root in btrfs_qgroup_ac=
count_extent()

Cleanup, not a bugfix.

> Guanrui Huang <guanrui.huang@linux.alibaba.com>
>     irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc

Cleanup, not a bugfix.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+UEXMl8Ve75Dvp+Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtBdhAAKCRAw5/Bqldv6
8tQUAJ9HIPFJUPF4wxNqBq5iLMnUY3rDDACfdcK/yVH0iytrgvodz5nsyuiliN4=
=3O9Z
-----END PGP SIGNATURE-----

--+UEXMl8Ve75Dvp+Q--
