Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366624EB86E
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 20:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789676523; cv=none; b=quKoOqw3wanM1oC0wO5w7t1R6GAuA5ARPP9tbr73jOQLfBk5xnPEpaPJH89nm8MT72kXjcu9IqrNZqiCxn7lq53WThQcKoUXtvM0hMAB1YdL/n95uhsh14afv4/2+0urpXc19RHkT40mKkV8HV2OuIYuaCnOk2kc8JVduxuz62A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789676523; c=relaxed/simple;
	bh=1HwzD61EYtx71gA3KUhUV/0vp0dpcZ4CkTyylKxLURQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usEdE8FgZX9qqlW1SAF115oc2DPdMtMcIwL2HThhKe23mnTpwOgf/DJhwu8Lj9uLusYOU03w7embl++trSbpmX9wRjv13jEDBh7XnG+a+ghcfDmASZ6o2DIMYZr9Ej+N0yohQZqIc21vzRm3pn+QIi6vwUEnXLSREjme765YFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=HG3aMDd/; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="HG3aMDd/"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AF0DE104DAF;
	Thu, 17 Sep 2026 22:21:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1789676510;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=I+LaLuEwkgxc/49whv6ctlzmOAs+2Q1NKq9sMwXZlxg=;
	b=HG3aMDd/5p9KtanF4oUCvSi6toH25sFtvw3augxw7za9X2nAVEbn8Grl7Bqi+EX6uqOJZs
	InX1b3MPupkiTh++DM+EnLy0oraNxMzDMsj1hjWMWHv437x5oGHbw3h1KpcuAiZdd6fEHz
	j4adXiOSpA7e6JrQRZgo5i51ca8MZHRagtRZYUu82neDmN0D2GJRnqLvAE3F16nBrU8Rc8
	ur3UAUk5XijMHPkQrHv1ZZmh9bdniEpsx1Qzv3D7ubs3RGXPE8l7QjXgi05M4/jrJ+jTef
	/PXdK59CyqMx66zp4bTvbxYGAextX/Zcj4AV5eOPGOT16AV5iYMaxXxDmTumBw==
Date: Thu, 17 Sep 2026 22:21:47 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Message-ID: <aqxL2yCxD-sqNdi4@duo.ucw.cz>
References: <20260917151539.408551884@linuxfoundation.org>
 <dda6b1b0-5c9c-4417-976a-e20c4ee59ef4@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2PIYnpHewhz3qZ5g"
Content-Disposition: inline
In-Reply-To: <dda6b1b0-5c9c-4417-976a-e20c4ee59ef4@googlemail.com>
X-Last-TLS-Session-Version: TLSv1.3


--2PIYnpHewhz3qZ5g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> Am 17.09.2026 um 16:59 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 6.12.111 release.
> > There are 1102 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> This rc1 kernel crashes on my 2-socket Ivy Bridge Xeon E5-2697v2 server w=
hen
> booting into it. Unfortunately, it does not seem to get to the point where
> it leaves something useful in the ERST, i.e. in /var/lib/systemd/pstore -
> nothing there...
>=20
> So the only info I've got is a cell phone photo of the crash screen. I ha=
ve
> put it here, in case anybody wants to have a look:
>=20
> https://www.peters-netzplatz.de/download/IMG_20260917_204118_HDR.jpg

Seems to be identical / very similar to crash we see, and we have full
log:

https://lava.ciplatform.org/scheduler/job/1510595

Best regards,
								Pavel

--2PIYnpHewhz3qZ5g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaqxL2wAKCRAw5/Bqldv6
8lGhAKCIKFVRbL5ZR90c2BNSAZdEYKUYJgCgtv5fo3cS1KgV/xabgZoU7rA3OaE=
=a0CW
-----END PGP SIGNATURE-----

--2PIYnpHewhz3qZ5g--
