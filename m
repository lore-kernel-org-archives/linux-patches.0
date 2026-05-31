Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C65E376A18;
	Sun, 31 May 2026 10:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780224811; cv=none; b=jU2VcSIBgsBwoURTADtLC1PEIaiXc6nXpHMJO4ewM4hlmoWAWpRwbOsU6IHuVRU48TIHEfzoLnvs2VLjxrgaXdtLGrm6bf3bICa1puMiBbllNKGOBCRaAh7e/18fVLWk2TG7cbU5pmr/jKFsnYiWYXLjGoQkt6q34ypkRJoIoQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780224811; c=relaxed/simple;
	bh=i45gdTuZiRDSr0I/OSp/H4C/1/l9afk6RfqlpF+CjIs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K6h1PXeLQ99q/KpKyJ53TrZZXjMlWnLSFsjCw4v3K+NCphlvQIVibjCC6gTtUsfNFr9Xm9Sqg6YfOH858/UaSDx2R95CiNVJw+I+eXlg28PTNJe22GWAMn0V+nwHK/DK1eOnIuQDHDsr3O6lj92TnSCoZ4a80yoeyxyXm98y3M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTdnL-000Ncn-0a;
	Sun, 31 May 2026 10:53:27 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTdnJ-0000000F8HQ-417y;
	Sun, 31 May 2026 12:53:25 +0200
Message-ID: <136f03aa6f51bdfecc786e5278f5fd03b4a6966e.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 072/589] media: uvcvideo: Use heuristic to find
 stream entity
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Angel4005 <ooara1337@gmail.com>, Ricardo
 Ribalda	 <ribalda@chromium.org>, Hans de Goede <hansg@kernel.org>, Hans
 Verkuil	 <hverkuil+cisco@kernel.org>, Sasha Levin <sashal@kernel.org>
Date: Sun, 31 May 2026 12:53:20 +0200
In-Reply-To: <20260530160226.496219768@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160226.496219768@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1/MpVFW9o6bj11MJxigQ"
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


--=-1/MpVFW9o6bj11MJxigQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 17:59 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ricardo Ribalda <ribalda@chromium.org>
>=20
> [ Upstream commit 758dbc756aad429da11c569c0d067f7fd032bcf7 ]

This doesn't properly fix the problem.  Commit 3d9f32e02c2e "media:
uvcvideo: Create an ID namespace for streaming output terminals" (which
reverts this) needs to be applied on top.  I haven't checked whether
that would apply cleanly.

Ben.

> Some devices, like the Grandstream GUV3100 webcam, have an invalid UVC
> descriptor where multiple entities share the same ID, this is invalid
> and makes it impossible to make a proper entity tree without heuristics.
>=20
> We have recently introduced a change in the way that we handle invalid
> entities that has caused a regression on broken devices.
>=20
> Implement a new heuristic to handle these devices properly.
>=20
> Reported-by: Angel4005 <ooara1337@gmail.com>
> Closes: https://lore.kernel.org/linux-media/CAOzBiVuS7ygUjjhCbyWg-KiNx+HF=
TYnqH5+GJhd6cYsNLT=3DDaA@mail.gmail.com/
> Fixes: 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id UVC_=
INVALID_ENTITY_ID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Reviewed-by: Hans de Goede <hansg@kernel.org>
> Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Tested-by: Ron Economos <re@w6rz.net>
> Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>
> Tested-by: Brett A C Sheffield <bacs@librecast.net>
> Tested-by: Mark Brown <broonie@kernel.org>
> Tested-by: Barry K. Nathan <barryn@pobox.com>
> Tested-by: Peter Schneider <pschneider1968@googlemail.com>
> Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/u=
vc_driver.c
> index 34e3f04340a23..20a18caf77176 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -442,13 +442,26 @@ static struct uvc_entity *uvc_entity_by_reference(s=
truct uvc_device *dev,
> =20
>  static struct uvc_streaming *uvc_stream_by_id(struct uvc_device *dev, in=
t id)
>  {
> -	struct uvc_streaming *stream;
> +	struct uvc_streaming *stream, *last_stream;
> +	unsigned int count =3D 0;
> =20
>  	list_for_each_entry(stream, &dev->streams, list) {
> +		count +=3D 1;
> +		last_stream =3D stream;
>  		if (stream->header.bTerminalLink =3D=3D id)
>  			return stream;
>  	}
> =20
> +	/*
> +	 * If the streaming entity is referenced by an invalid ID, notify the
> +	 * user and use heuristics to guess the correct entity.
> +	 */
> +	if (count =3D=3D 1 && id =3D=3D UVC_INVALID_ENTITY_ID) {
> +		dev_warn(&dev->intf->dev,
> +			 "UVC non compliance: Invalid USB header. The streaming entity has an=
 invalid ID, guessing the correct one.");
> +		return last_stream;
> +	}
> +
>  	return NULL;
>  }
> =20

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.

--=-1/MpVFW9o6bj11MJxigQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmocEyEACgkQ57/I7JWG
EQkVPA/+MSEar0a53RF8fIgTGxoLwkeWNKLzZhkG9fOcIZmi0r8auU5XNvRih+d6
KRPticuZoFDHDQm/vO4w/RtFJW4akPT2d2QJ/UcezxuncNegCNLdKxeEpnfCW5d8
UvSoGJpvCSX/bLa3+/NmyvvF+GvmYlBo60dJNF8Dh3WG+3FHOmriPTazfy2irXsk
yOX9prSpjDOheDBf+cQ+dfqMJ3mPFS12Piecb9yO4uNVQZgE01Vt6Hfx7qUdwt93
D4Jgp1Gn7NF0YKE4q856q36LLFUeMZRZnEiP9+cQtosH/XFdxF1sE8lzgtASwDww
BygE8Ov4NTDCAhUFQikpPqq3IAq1tpQoKK/X001dzT2SJGXuym0zGFg5jACzda54
UAWWLnvymCho3IwR9UcTwKo73hBgp2wyZMDXAHDAOKLYKoooxfxnXBvoffPF150g
0G12MACYLRHBsKgkDaf+MshMGDu36qrFN2DGjRSvEa8bje+JfMHYJVY33QJVzZ71
xQ00yOYKU2NgZqdYIM6oVScNiePL/eX86r98YbdXszlHAvi39w7kYNQYh/LdZnbb
eJFDBECC+xKJP9qxZLzw5vqVyr+fTo0Pt6RdVVYuhFCybFTXTqt3i4vFEJ7YCbfD
qF0sUqrcbzqc5fdvcIbckF7ZDUFRCHgBZgbMdIQhGjzwFWJndLQ=
=706S
-----END PGP SIGNATURE-----

--=-1/MpVFW9o6bj11MJxigQ--
