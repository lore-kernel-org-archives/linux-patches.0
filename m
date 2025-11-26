Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917642E284B
	for <patches@lists.linux.dev>; Wed, 26 Nov 2025 10:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764151325; cv=none; b=SQDdeaOnGYWJ9JZv3IeQsUQIEZiKBVQn1Vg2Bk1B1u148ccBefVMlDIy9FQQ7TSm+xTq+XZX52P7zMQxow5FdOfd/nDLiua0G+h91tclZ7xrxcCTHOxzSWkvglOmve+yye4tlaHmU8vBBlJ++YUTZUYlWY7x9Mex6yr8pHA+Sbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764151325; c=relaxed/simple;
	bh=NirwZ74D1z1YP+4ANsu8AVzM4z1MRmw5+6sZYs9xSak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyhvuXTRDEPmHGZ26XgRC4UXoJyanZch5OkK/lEUuKMwRYKs7IyR/nLBTzuyie/oeENUar2oSgwxWa3BD6TTI8jbCMsGFjrJJKogi450tDSMOea9mBqMv1brKT8OooLRSHEWYkHLcb2pUtnmHwVmx9dtIx/hozmj0bV3vOT9P+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=EmCDJsuM; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="EmCDJsuM"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6EC061007D77C;
	Wed, 26 Nov 2025 11:01:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764151306; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=4euxKs6L/kWbXZsVFkBF6jXBpBZezWHnhZw399fRbGA=;
	b=EmCDJsuMrlqGoEWa74gdwymTGSe0Ozd5dBahHZWFUfHNjpW0E4xq9w79PFa3k/yKMIRXkI
	Igbir5oV8t/w46u5iBemG9Tb4+75DbdKMXXph/ac+l9UrfSvkXDhmcWzuLocFbRqwldhMX
	Qpd4TU1tf7woOvmRS2g4sDSO7hKZDksn1WTykHp7Pinpg5A1+V2qgaUFiWUnYD+4tKyFUS
	p+oJobqmzRUa5+FLyjaHlUz7BYxCdeFDRH2s4npkJEcExqxIsfmu95Whm/mMJVxXV1OSs7
	Uo5TBNu/DHe1+JgwIhxp8ujmwg5NEUXXqGttDYXBIl0ci/QaR/EXzgidhRqbSQ==
Date: Wed, 26 Nov 2025 11:01:19 +0100
From: Pavel Machek <pavel@denx.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
Message-ID: <aSbP77sRVyWjXxWC@duo.ucw.cz>
References: <20251121130143.857798067@linuxfoundation.org>
 <aSWtH0AZH5+aeb+a@duo.ucw.cz>
 <87ecpmp69f.wl-tiwai@suse.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/ZCi7hUNA7IPq/pT"
Content-Disposition: inline
In-Reply-To: <87ecpmp69f.wl-tiwai@suse.de>
X-Last-TLS-Session-Version: TLSv1.3


--/ZCi7hUNA7IPq/pT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Takashi Iwai <tiwai@suse.de>
> > >     ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
> >=20
> > This one is wrong for at least 6.12 and older.
> >=20
> > +       if (ep->packsize[1] > ep->maxpacksize) {
> > +               usb_audio_dbg(chip, "Too small maxpacksize %u for rate =
%u / pps %u\n",
> > +                             ep->maxpacksize, ep->cur_rate, ep->pps);
> > +               return -EINVAL;
> > +       }
> > =20
> > Needs to be err =3D -EINVAL; goto unlock;.
> >=20
> > (Or cherry pick guard() handling from newer kernels).
>=20
> Thanks Pavel, a good catch!
>=20
> A cherry-pick of the commit efea7a57370b for converting to guard()
> doesn't seem to be cleanly applicable on 6.12.y, unfortunately.
> So I guess it'd be easier to have a correction on the top instead,
> something like below.

Yes, works for me, thanks for handling this.

> -- 8< --
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH v6.12.y] ALSA: usb-audio: Fix missing unlock at error pat=
h of
>  maxpacksize check
>=20
> The recent backport of the upstream commit 05a1fc5efdd8 ("ALSA:
> usb-audio: Fix potential overflow of PCM transfer buffer") on the
> older stable kernels like 6.12.y was broken since it doesn't consider
> the mutex unlock, where the upstream code manages with guard().
> In the older code, we still need an explicit unlock.
>=20
> This is a fix that corrects the error path, applied only on old stable
> trees.
>=20
> Reported-by: Pavel Machek <pavel@denx.de>
> Closes: https://lore.kernel.org/aSWtH0AZH5+aeb+a@duo.ucw.cz
> Fixes: 98e9d5e33bda ("ALSA: usb-audio: Fix potential overflow of PCM tran=
sfer buffer")
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Reviewed-by: Pavel Machek <pavel@denx.de>

Best regards,
								Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/ZCi7hUNA7IPq/pT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaSbP7wAKCRAw5/Bqldv6
8k4dAJ0QeKrLCsCD9HJebHdaJFU9qi0Q4wCfYH80S9y+q4jfSqRU/4NrzcAHeAo=
=iGA9
-----END PGP SIGNATURE-----

--/ZCi7hUNA7IPq/pT--
