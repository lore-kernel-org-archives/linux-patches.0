Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED16335BA;
	Sun, 31 May 2026 12:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780230846; cv=none; b=dApI1sJ/jVSfRhEst2UNoOQzxI7IyLeKHGaYBNlLDB5CBaOayb+cuFFd/M94AuRxrkBGUxBIhpOLwS1KpSSJQiaCWDMjSCskK6k7noZaoqfEpfJwHCNIIBecp3q9IHARp95rV5Ewzrr7vzgs9bG1l3qYafKFAiREt4FvM2nR9Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780230846; c=relaxed/simple;
	bh=BoBAlG10CgV5SweZUjHsYBM7U2GWC8AECDm/4l2XK3E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=knUih7ICx7aFNuzKVPp/05nJfkpJb0oX8ImwTTYW2xp0YgG9EFkH2dUpXmDvfTizrepzgUmj3PvijYss4gH+k3wHynlhXtE5TpGvMaxUUMHPmHmfzEaKSrnK03P6UfFHIC8ZhftRQjIXimTF9UL9SED5yddN/V0M1M5X92JI/RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTfMa-000NwC-1n;
	Sun, 31 May 2026 12:33:56 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTfMZ-0000000FBhx-3Dii;
	Sun, 31 May 2026 14:33:55 +0200
Message-ID: <ca469f4a22fe4688bbf88c355d074ae5be16a621.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 095/589] ALSA: usb-audio: fix null pointer
 dereference on pointer cs_desc
From: Ben Hutchings <ben@decadent.org.uk>
To: Vasiliy Kovalev <kovalev@altlinux.org>, Chengfeng Ye
 <cyeaa@connect.ust.hk>,  Takashi Iwai	 <tiwai@suse.de>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Sun, 31 May 2026 14:33:46 +0200
In-Reply-To: <20260530160227.194081368@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160227.194081368@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KDc48Xu9x3RJZjVYgOfZ"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-KDc48Xu9x3RJZjVYgOfZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 17:59 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Chengfeng Ye <cyeaa@connect.ust.hk>
>=20
> commit b97053df0f04747c3c1e021ecbe99db675342954 upstream.
>=20
> The pointer cs_desc return from snd_usb_find_clock_source could
> be null, so there is a potential null pointer dereference issue.
> Fix this by adding a null check before dereference.
>=20
> Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
> Link: https://lore.kernel.org/r/20211024111736.11342-1-cyeaa@connect.ust.=
hk
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Fixes: 1dc669fed61a ("ALSA: usb-audio: UAC2: support read-only freq contr=
ol")
> [ kovalev: bp to fix CVE-2021-47211; added Fixes tag; the null
>   check was added into both UAC2 and UAC3 branches since the
>   older kernel still has the clock source lookup split between
>   snd_usb_find_clock_source() and snd_usb_find_clock_source_v3()
>   (see upstream commit 9ec730052fa2) ]

In the upstream version the return statement was added in
snd_usb_set_sample_rate_v2v3(), so set_sample_rate_v2v3() will do:

        cur_rate =3D snd_usb_set_sample_rate_v2v3(chip, fmt, clock, rate); =
 // =3D 0
        if (cur_rate < 0) ...                              // false
        if (!cur_rate)                                     // true
                cur_rate =3D prev_rate;
        if (cur_rate !=3D rate) ...
 validation:
        if (!uac_clock_source_is_valid(chip, fmt, clock))  // true because =
clock soure is missing                                                     =
                =20
                return -ENXIO;

so it will ultimately return -ENXIO.

Whereas this backport puts the return statements in
set_sample_rate_v2v3(), so it directly returns 0 i.e. silently fails.=20
Shouldn't these be changed to return -ENXIO?

Ben.

> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/usb/clock.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/sound/usb/clock.c b/sound/usb/clock.c
> index 197a6b7d8ad6f..3d5d4f3aafce4 100644
> --- a/sound/usb/clock.c
> +++ b/sound/usb/clock.c
> @@ -646,11 +646,17 @@ static int set_sample_rate_v2v3(struct snd_usb_audi=
o *chip, int iface,
>  		struct uac3_clock_source_descriptor *cs_desc;
> =20
>  		cs_desc =3D snd_usb_find_clock_source_v3(chip->ctrl_intf, clock);
> +
> +		if (!cs_desc)
> +			return 0;
>  		bmControls =3D le32_to_cpu(cs_desc->bmControls);
>  	} else {
>  		struct uac_clock_source_descriptor *cs_desc;
> =20
>  		cs_desc =3D snd_usb_find_clock_source(chip->ctrl_intf, clock);
> +
> +		if (!cs_desc)
> +			return 0;
>  		bmControls =3D cs_desc->bmControls;
>  	}
> =20

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.

--=-KDc48Xu9x3RJZjVYgOfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmocKqoACgkQ57/I7JWG
EQmv5g//XKzTREPT3S+Bj7NpL0OpN4xUznypFItHKZe/iBh5X8Hb4IiF+H5KSMkk
YbGgNCGeQOG9AqumXb3ffzmYDdBDfz/zIG7nquq2YbrF7SmLsoBf3PO/U0gI+m7n
/3vIGjtTk6OdpobU6okU8Njfgi3iaOGBOLBhpMKIHOlwfOCwlRLJWEQXTLzIxPJD
6aYhKQrrfAMoA2yj2Q/9s2WU4o5xC3e+A4YrPXziR80/CHshXIuPCbp7BTIpP1DR
VyNzRsWrkFAqWu+GMOP9DljaJt30G8zQQNUAQhwu3k3AY7hpTwBglRAjBlMasYzP
Mal3CfDMqKkqO9Mhapnycuv0VP5Tgl+BFjk5zVV+BnmEc+bqQ33af/2sMXhIekzX
QIGFtKr3dAeULRfFfQzXK1My3QSs9f83KZ34bgjZ/TfUF0LCNs/mJyhJ4tzlp4v5
VDav4uVWy1QgbW8p1mGvhsP7EDgaIFlpOv6EdIzFMFFCYU4PXnPqPAiQ4VBVg4vb
Du255x/qmm9W9nRV01Vnfek9FDB+OYqM5t8XMpOsv8O0b9cdbiRKL2zaOs+JoPp1
c226biFzwCdbJQvGFUwscksHUKO7kIB8i542VYyEsbM/7rxo1jG4IIIbqv/gsYwf
pyms4hV9VmPRrGzVDZnSN7ds6LunpO0WEpV73kMUxHF7RXcMDsI=
=VZ6D
-----END PGP SIGNATURE-----

--=-KDc48Xu9x3RJZjVYgOfZ--
