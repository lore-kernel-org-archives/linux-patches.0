Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7F830AD04
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 13:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732805; cv=none; b=DwbZf0C8WePLjE2VBvukhbZ4rbUsvynRf+ESihury/Jw1iSs9ds/FlgLvE6Kc1TPOt1VmNiQxwqb433ucfYr3YCogR2v9VUWG6t7h1GMciQUP/oyvY9syz12GCFX+w52mgPgoM1qV4Wi0vxb5IjS0G3XVUKhvF4YsAcUdORp2wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732805; c=relaxed/simple;
	bh=UKOcKhyxpboYVq8QwId3CcYWPcr0ojqzhpWjY3RPQqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCA2Ol08sZHSxTiDwLoDrrvEEyr+TD4dKAjqPtP7KZ90zhIuMMLJQlCAQ/XcuERls7QX66VvMg+yEBJTABvjwIjEeytZhmYkUneB+qkPCVsLpxMx7evzJZJnfT9xDOQtJk+1t2cgYgzUyFyxXV/QTtvnrWNfCHaXWDM/A/Equwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Dni7XxGn; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Dni7XxGn"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CEA0F101E0E74;
	Fri, 21 Nov 2025 14:46:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1763732794; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=0hOQTMzGD21rj0ucRgP6e8Z9rKjJXzdNoulIFUlbaaA=;
	b=Dni7XxGnpDCLpfxWtMBXLr7W9XcHhrmLjA6CrmIUqCmlP/2fDAPlztyucAIGI0T0ssnleQ
	yZzuzNeL/9vZmBal5kbLwd/vjVwyijBLdYspCB5Y0xdIt/4UQ4rqWVtGVvg5httxSA8BrV
	ee0eFQmVfjE0+qzWQro55ARvxh/eI/8zLS3jd6KBop5uH0ia9GiF6Fa/JWmSPfP4fYGjvB
	wOVBinTYqHs+RFDcJy1wwAPDcTIPYBqqhnaRKA1bewolxcYZWoj/R6aiwz2fdmmt86MMyc
	+ONLxC8xyI7wqjZvInmPR0VRdgHTH5SZ1MBhSOQn69/4zt+vA+zRFkFeRT0S3w==
Date: Fri, 21 Nov 2025 14:46:29 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
Message-ID: <aSBtNeRr7NBjWHep@duo.ucw.cz>
References: <20251121130143.857798067@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xxqhi70gSUAyMCZi"
Content-Disposition: inline
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Xxqhi70gSUAyMCZi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I have successful test result, but I am not sure it matches the
release. Please quote git hashes to make this easier.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
170546623

Linux 6.12.59-rc1 (bba98f3faf27)
Passed
 cip-ci created pipeline for commit eac30293 =EF=BF=BC 19 hours ago, finish=
ed 18 hours ago

Best regards,
								Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Xxqhi70gSUAyMCZi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaSBtNQAKCRAw5/Bqldv6
8rxdAKCxc2bB0bOtSH1epsBnuM18Fwr2hwCgroERBsZMS0ADFGeGOf0cykBSbpg=
=Wn9x
-----END PGP SIGNATURE-----

--Xxqhi70gSUAyMCZi--
