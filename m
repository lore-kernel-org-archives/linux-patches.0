Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357711A23B1
	for <patches@lists.linux.dev>; Wed,  5 Mar 2025 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741203453; cv=none; b=Zggn02tJCf4ULqAN6bfn7VU/MuULUSUyzpREsNCi993xn07icG34XDPePbuCkE2p3HzDE2rEXs91XKxn4TCPtKE5Cwor1HKluKIGx33RQTTu38kXSHdsEH4WF/rO/eZlBPBqra6XF0Q7vMc6xFoaMaCjyCUQjw8gzWfzNuLMZfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741203453; c=relaxed/simple;
	bh=9vhMP0zGanGCaeuvGfuPag6z9ZddLvLWl4w58eHuX/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezsenhxrNHmXdNS2Po63bGdej/3CAFSUEBUrEW7oBW+LXniqQ0n0z4upIao6dLBTl5WJEpvwlgB1gU/GleK8fkVd8TyKaQMmLvBISusScBHw2N8Ggn5nKRF/ewCm5wUoZf4u2um62iPCTD2pQSYr8FxiBeO2XnnF+g66H6BKLhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=BIsTq1PI; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="BIsTq1PI"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8988D10382C18;
	Wed,  5 Mar 2025 20:37:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1741203448; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=uLCLZyF9chiE2e+9nrAul9Rl8NcyHcKHK1QTFrk0MjM=;
	b=BIsTq1PI5qtbPGeQyt/DqwEb5IMeIXphj7ctU68J9xs+Fim40wfASgQBU1KCz3tDbF32Hv
	Q9Snhu6Und/L3DD/qcapgpcrJbbOugHFRM+brF44WfwSCAjYVHBlXwBrJGdF+QKOUwS4An
	LwifKGmFebM1u6d4J6+usupqlLuJ9ZuLwYIXA+6K1rtwuFs7HebM82CfYQ9nVw4avCQAFy
	VlUDJLKAcwsbs4RVcXNTq1FB+Y5wPFFLg4tVNUXHER+WUZht8i/h0waeGjXnf1jPcskGDO
	r69513fccWtbHF6gvUVm5p7/Kh1JCX2SG4+sm3Ox9BgFCtDdgQHsNhlObMv/9Q==
Date: Wed, 5 Mar 2025 20:37:19 +0100
From: Pavel Machek <pavel@denx.de>
To: Ronald Warsow <rwarsow@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
Message-ID: <Z8in71h4nhXDbbCq@duo.ucw.cz>
References: <20250305174505.268725418@linuxfoundation.org>
 <891abe3f-af74-47ee-8f5f-b5d43f11d8fa@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yzM4msC65fRIJi2c"
Content-Disposition: inline
In-Reply-To: <891abe3f-af74-47ee-8f5f-b5d43f11d8fa@gmx.de>
X-Last-TLS-Session-Version: TLSv1.3


--yzM4msC65fRIJi2c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2025-03-05 20:04:26, Ronald Warsow wrote:
> Hi Greg
>=20
> no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)
>=20
> Thanks
>=20
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
>=20
>=20
> P.S.
>=20
> is it necessary to have all cc'ed user informed or should I leave them of=
f ?

Normally, people leave the cc list. It is quite important to keep the
cc list at least for failures, so we can debug them together :-).

BR,
								Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yzM4msC65fRIJi2c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ8in7wAKCRAw5/Bqldv6
8tkLAJ9ZA3sUo9518cD4PqRro2WWD0ZvLQCePBHmtCIIM+bqGcNKOelO67OJdtk=
=/YrT
-----END PGP SIGNATURE-----

--yzM4msC65fRIJi2c--
