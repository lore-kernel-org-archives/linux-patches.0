Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D4E6FC3
	for <patches@lists.linux.dev>; Sat, 22 Feb 2025 09:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740217623; cv=none; b=KIgI7Vmd2bNUwi5ssHt5oCHLK4pOFdQ/bnip7kawcqTvK825VmvvcQGeN/aaT8Mkmby6/Mb2beyOCzgsK3aL+m+l0xTQPC3D7bT2nCff8n4sKPsC2BtWPr+Krl/lg4SibtMAkDJLlbFcEY/BQDxAkFylUt49G13GXHo5rm1tg5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740217623; c=relaxed/simple;
	bh=VF6Ud8woaUw2hBuatgzb7156hJnHCd13pH4ajF1JnP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POxPMbKie1te8eIYMU4ruHWRmtgyUxI1qpO7lVtIGIIlj/NwXRyfS1oA6UkPxpMBjfKP2PsEUrr4ufa1WlXAwt9HROvPxIX9H3Cu8kFxx3SXEqQDCKwOUGwQLMoZ4QoaH6xP/53BYhkjb3FsUzdEHEGR24WaHkMJZiBJFt9Gw80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=d13HXYl9; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="d13HXYl9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D15FA10382D37;
	Sat, 22 Feb 2025 10:46:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1740217619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e6kkcauuE4Q+rb4U5UeJINPLqDBviQ0uDB7Xhy6jslY=;
	b=d13HXYl95ypF+ZWw5RxVuIUMv18zN90/drgU45hZwlcp5i1fkzCdi7Jhporw/jY7PcDdF8
	frdQcLuQFtCeRzXUX4U7F2gYHt809p98HVUW+5HAHIL8OM+7Jr67DLQva3NR2tBJ9Akn4c
	wsfWCuXeOfEJYRi/M6cjgz1F6JBcsbkgFYpfj6RFrxsBfYRMO7LWSKq8+n9Dzz8a1MvFUH
	gdNJmvHgE2tvkv1Mys9HAITHxZH+ewpMen9nsD0WICXlmVM/T+5gmVAONlxxVLqkw7JLPD
	aHfNX5cc8qFBOuuPRJPrfCy9BV3xYPfggPD2go+/BWF12yl9tKFKHukih68szw==
Date: Sat, 22 Feb 2025 10:46:52 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@denx.de>, Florian Fainelli <f.fainelli@gmail.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Message-ID: <Z7mdDISNDz7Dq3A3@duo.ucw.cz>
References: <20250220104545.805660879@linuxfoundation.org>
 <80ab673f-aa94-43e2-899a-0c5a22f3f1e0@gmail.com>
 <2025022221-revert-hubcap-f519@gregkh>
 <Z7mXDolRS+3nLAse@duo.ucw.cz>
 <2025022213-brewery-synergy-b4bf@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CCNlqIj4XocDQZrA"
Content-Disposition: inline
In-Reply-To: <2025022213-brewery-synergy-b4bf@gregkh>
X-Last-TLS-Session-Version: TLSv1.3


--CCNlqIj4XocDQZrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2025-02-22 10:39:23, Greg Kroah-Hartman wrote:
> On Sat, Feb 22, 2025 at 10:21:18AM +0100, Pavel Machek wrote:
> > On Sat 2025-02-22 07:28:10, Greg Kroah-Hartman wrote:
> > > On Fri, Feb 21, 2025 at 09:45:15AM -0800, Florian Fainelli wrote:
> > > >=20
> > > >=20
> > > > On 2/20/2025 2:57 AM, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.1.129 rele=
ase.
> > > > > There are 569 patches in this series, all will be posted as a res=
ponse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >=20
> > > > > Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> > > > > Anything received after that time might be too late.
> > > >=20
> > > > And yet there was a v6.1.29 tag created already?
> > >=20
> > > Sometimes I'm faster, which is usually the case for -rc2 and later, I=
 go
> > > off of the -rc1 date if the people that had problems with -rc1 have
> > > reported that the newer -rc fixes their reported issues.
> >=20
> > Well, quoting time down to second then doing something completely
> > different is quite confusing. Please fix your scripts.
>=20
> Patches gladly welcome :)

:-(
								Pavel

diff --git a/MAINTAINERS b/MAINTAINERS
index a5e49d57c589..526daaf5b87a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22471,7 +22471,7 @@ STABLE BRANCH
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 M:	Sasha Levin <sashal@kernel.org>
 L:	stable@vger.kernel.org
-S:	Supported
+S:	Odd Fixes
 F:	Documentation/process/stable-kernel-rules.rst
=20
 STAGING - ATOMISP DRIVER


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CCNlqIj4XocDQZrA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7mdDAAKCRAw5/Bqldv6
8jNqAKCK5nxpHfcYWmjFYCol7TTqC1ElLgCglp3Jqu+bQqptNUIHG6WeV1ZHJ2E=
=7oeb
-----END PGP SIGNATURE-----

--CCNlqIj4XocDQZrA--
