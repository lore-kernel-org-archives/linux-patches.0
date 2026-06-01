Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6669311968;
	Mon,  1 Jun 2026 17:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780335435; cv=none; b=c/uPAaQE3pm0mpSaS3WvHD7nKpU9GJQtKcd5U7oAsymQWiEzNcwIso1IxyhSNp0opLuidyDq8o/3JJCFrguNzV6ByZLTRIes/vdCfXrZfG6DX6WgzgLb3JuZSAtZ/CmdwR1nRbGC0wOWTamI/Ou20I54IwOoavNq9aYOh55BoLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780335435; c=relaxed/simple;
	bh=rmlc6o5adaI0BpyYyl1Yl2KstdJtTxbkpxBAsQQHstk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QZoxItCsYUF5zKAJyPzKfEEkvK2C88Yj+/cWeXzR2q9IfRFTmmpt3GFF0ehWoiqfjDvDKtg1xy8JdozDHe0Fis16CI8WVaadOlPxBhZqwiqdurYqdBcmHosy9DE1wzrax5dW6vaznlq6NQVJKM1sKWUk/htjYPQFU/p2hWYJHCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU6Zb-000Wza-1X;
	Mon, 01 Jun 2026 17:37:11 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU6Zb-0000000FlfI-0IY3;
	Mon, 01 Jun 2026 19:37:11 +0200
Message-ID: <8cd2c0613f018690cba5ae76c4ab73da05118312.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 263/589] media: uvcvideo: Enable VB2_DMABUF for
 metadata stream
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>, Laurent
 Pinchart <laurent.pinchart@ideasonboard.com>, Hans de Goede
 <johannes.goede@oss.qualcomm.com>,  Hans Verkuil <hverkuil+cisco@kernel.org>
Date: Mon, 01 Jun 2026 19:37:06 +0200
In-Reply-To: <20260530160231.873363839@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160231.873363839@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HzNFlQ+ic3J1W9SEjboq"
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


--=-HzNFlQ+ic3J1W9SEjboq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:02 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ricardo Ribalda <ribalda@chromium.org>
>=20
> commit fbac03467e53d8d72e5099c03df26d9adae11416 upstream.
>=20
> The UVC driver has two video streams, one for the frames and another one
> for the metadata. Both streams share most of the codebase, but only the
> data stream declares support for DMABUF transfer mode.
>=20
> I have tried the DMABUF transfer mode with CONFIG_DMABUF_HEAPS_SYSTEM
> and the frames looked correct.
>=20
> This patch announces the support for DMABUF for the metadata stream.
> This is useful for apps/HALs that only want to support DMABUF.

So this is a feature addition.

And the uvcvideo driver has changed a lot since 5.10 (or even 6.1), so
unless someone specifically tested that these older versions will also
work with dmabuf I question whether this is worth the risk.

Ben.

> Cc: stable@vger.kernel.org
> Fixes: 088ead2552458 ("media: uvcvideo: Add a metadata device node")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
> Link: https://patch.msgid.link/20260309-uvc-metadata-dmabuf-v1-1-fc8b87bd=
29c5@chromium.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/media/usb/uvc/uvc_queue.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -222,7 +222,7 @@ int uvc_queue_init(struct uvc_video_queu
>  	int ret;
> =20
>  	queue->queue.type =3D type;
> -	queue->queue.io_modes =3D VB2_MMAP | VB2_USERPTR;
> +	queue->queue.io_modes =3D VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>  	queue->queue.drv_priv =3D queue;
>  	queue->queue.buf_struct_size =3D sizeof(struct uvc_buffer);
>  	queue->queue.mem_ops =3D &vb2_vmalloc_memops;
> @@ -235,7 +235,6 @@ int uvc_queue_init(struct uvc_video_queu
>  		queue->queue.ops =3D &uvc_meta_queue_qops;
>  		break;
>  	default:
> -		queue->queue.io_modes |=3D VB2_DMABUF;
>  		queue->queue.ops =3D &uvc_queue_qops;
>  		break;
>  	}
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-HzNFlQ+ic3J1W9SEjboq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmodw0IACgkQ57/I7JWG
EQmKEg//d0Xpt4RWDamWqSTs8ve3icqR505r03/N7m7+UtqQDBjrhxDuu4nPXMBJ
nDbFmKJfpDCHitccTPxuxDkdC57DfeZVi7lGnAoqN5hKAqHNnKZwax0s/aYknJh2
ONtNRJcSO697ipi4LgRd70h2eL33/NenxUSME9ODKsmr4uOU5+t9LSVgjXXRNhw6
+eHqyAhHaLwe+OJir6O9rGED9cHuJxM1OGLaxmWPOttJMl4vCMhhAPFIfsH7ayny
7DKAw8u6aXc+Ksg6Q7B58jn6jxlpaLI+5yuxP7/lL11fNH3X3xlH95W+HWHP9kjC
m84NDlPaMDZK9b+OipwcQqLX6xP12TOQqNt40bod598dzd0Zk3m1Yi+Fp7yQbWgf
UwqoD5AFtTjKddDhD9TAgLHtZ/SIDCATLCvm/KcLk+Ydb6Qbx+Ri5uUROPmzs4VA
ombhb9amXUDk3CqV6+/7FiuovS+74hgb4XRisoZNXRCIa53TFWpaEwiWawpk42Y2
Epu9Cctotj0T2kCH00OPUXUoz8j+R3HNt23UD2MSV3VkrK8rRZ2v484By6BKT357
kKOoI+tPZRTHjEP1hTilHE7KZtlQLbkpz/T1aZtJ9smp/MuBSbmMByhnKouXe3xN
2U3m8QpvJtFibo/AAlqWVK5okFBhg7e0zP6QufV1HtVPylNI590=
=RbZi
-----END PGP SIGNATURE-----

--=-HzNFlQ+ic3J1W9SEjboq--
