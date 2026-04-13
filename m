Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A333914E7;
	Mon, 13 Apr 2026 20:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112995; cv=none; b=QgcYtpa+O9oJZpQvLyMDEMCpbrLmMrED0MD5z6E9kzO9q5wdUQ1rAgmwutKyqvqUFJ65wxpfePxKKnXws4VEmzeqQ6HiyQJKjTH2O3KMZacdk3+4EOGECiu3/b9rQ0zXuRMWpsC+qu/003jUPuIwCOssTRQ65/RR/fXpo7TdNxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112995; c=relaxed/simple;
	bh=UWsncefYEq6I1cmdkIaJ9UGt5aKIYObBz2BZmKelVzA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UzNJuKRdBifrMdDp3/xD346gKRZaKyLh4FC0b2YLRXozOIqAlsRj8cFU6+Nc4W4Jl8aCuPffvL+aTXXm2hb1f6NxH6bMmhzwYUNObHy7Nz38RTNMUxFtFeSyYArhDGM7LmCjsXOzBcnFxB36536PCRAjOxZiuDALey4GREyZXAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCO7l-004mye-0u;
	Mon, 13 Apr 2026 20:43:12 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCO7j-00000002hza-411x;
	Mon, 13 Apr 2026 22:43:11 +0200
Message-ID: <673ddf965a5af7b881e86cb2e22055d4fcbb2dfc.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 427/491] media: uvcvideo: Implement
 UVC_EXT_GPIO_UNIT
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>, Laurent
 Pinchart <laurent.pinchart@ideasonboard.com>, Mauro Carvalho Chehab
 <mchehab+huawei@kernel.org>,  Sasha Levin <sashal@kernel.org>
Date: Mon, 13 Apr 2026 22:43:06 +0200
In-Reply-To: <20260413155835.015055819@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155835.015055819@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ig/wlPZIl6jLG76iEVYM"
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


--=-ig/wlPZIl6jLG76iEVYM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ricardo Ribalda <ribalda@chromium.org>
>=20
> [ Upstream commit 2886477ff98740cc3333cf785e4de0b1ff3d7a28 ]

This is a new feature, not obviously suitable for stable.

If it really is needed for 5.10 then there are a number of bug fixes
that also need to follow: 387e89393071 ["media: uvcvideo: Fix deferred
probing error"), a9ea1a3d88b7 ("media: uvcvideo: Fix crash during unbind
if gpio unit is in use"), and f0f078457f18 ("media: uvcvideo: Fix memory
leak in uvc_gpio_parse").

Ben.

> Some devices can implement a physical switch to disable the input of the
> camera on demand. Think of it like an elegant privacy sticker.
>=20
> The system can read the status of the privacy switch via a GPIO.
>=20
> It is important to know the status of the switch, e.g. to notify the
> user when the camera will produce black frames and a videochat
> application is used.
>=20
> In some systems, the GPIO is connected to the main SoC instead of the
> camera controller, with the connection reported by the system firmware
> (ACPI or DT). In that case, the UVC device isn't aware of the GPIO. We
> need to implement a virtual entity to handle the GPIO fully on the
> driver side.
>=20
> For example, for ACPI-based systems, the GPIO is reported in the USB
> device object:
>=20
>   Scope (\_SB.PCI0.XHCI.RHUB.HS07)
>   {
>=20
> 	  /.../
>=20
>     Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
>     {
>         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutp=
utOnly,
>             "\\_SB.PCI0.GPIO", 0x00, ResourceConsumer, ,
>             )
>             {   // Pin list
>                 0x0064
>             }
>     })
>     Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Propert=
ies for _DSD */,
>         Package (0x01)
>         {
>             Package (0x02)
>             {
>                 "privacy-gpio",
>                 Package (0x04)
>                 {
>                     \_SB.PCI0.XHCI.RHUB.HS07,
>                     Zero,
>                     Zero,
>                     One
>                 }
>             }
>         }
>     })
>   }
>=20
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Stable-dep-of: 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with=
 id UVC_INVALID_ENTITY_ID")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c   |   3 +
>  drivers/media/usb/uvc/uvc_driver.c | 127 +++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvc_entity.c |   1 +
>  drivers/media/usb/uvc/uvcvideo.h   |  16 ++++
>  4 files changed, 147 insertions(+)
>=20
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc=
_ctrl.c
> index 698bf5bb896ec..fc23e53c0d38b 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -2378,6 +2378,9 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  		} else if (UVC_ENTITY_TYPE(entity) =3D=3D UVC_ITT_CAMERA) {
>  			bmControls =3D entity->camera.bmControls;
>  			bControlSize =3D entity->camera.bControlSize;
> +		} else if (UVC_ENTITY_TYPE(entity) =3D=3D UVC_EXT_GPIO_UNIT) {
> +			bmControls =3D entity->gpio.bmControls;
> +			bControlSize =3D entity->gpio.bControlSize;
>  		}
> =20
>  		/* Remove bogus/blacklisted controls */
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/u=
vc_driver.c
> index e1d3e753e80ed..b86e46fa7c0af 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -7,6 +7,7 @@
>   */
> =20
>  #include <linux/atomic.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
> @@ -1033,6 +1034,7 @@ static int uvc_parse_streaming(struct uvc_device *d=
ev,
>  }
> =20
>  static const u8 uvc_camera_guid[16] =3D UVC_GUID_UVC_CAMERA;
> +static const u8 uvc_gpio_guid[16] =3D UVC_GUID_EXT_GPIO_CONTROLLER;
>  static const u8 uvc_media_transport_input_guid[16] =3D
>  	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
>  static const u8 uvc_processing_guid[16] =3D UVC_GUID_UVC_PROCESSING;
> @@ -1064,6 +1066,9 @@ static struct uvc_entity *uvc_alloc_entity(u16 type=
, u16 id,
>  	 * is initialized by the caller.
>  	 */
>  	switch (type) {
> +	case UVC_EXT_GPIO_UNIT:
> +		memcpy(entity->guid, uvc_gpio_guid, 16);
> +		break;
>  	case UVC_ITT_CAMERA:
>  		memcpy(entity->guid, uvc_camera_guid, 16);
>  		break;
> @@ -1467,6 +1472,108 @@ static int uvc_parse_control(struct uvc_device *d=
ev)
>  	return 0;
>  }
> =20
> +/* ---------------------------------------------------------------------=
--------
> + * Privacy GPIO
> + */
> +
> +static void uvc_gpio_event(struct uvc_device *dev)
> +{
> +	struct uvc_entity *unit =3D dev->gpio_unit;
> +	struct uvc_video_chain *chain;
> +	u8 new_val;
> +
> +	if (!unit)
> +		return;
> +
> +	new_val =3D gpiod_get_value_cansleep(unit->gpio.gpio_privacy);
> +
> +	/* GPIO entities are always on the first chain. */
> +	chain =3D list_first_entry(&dev->chains, struct uvc_video_chain, list);
> +	uvc_ctrl_status_event(chain, unit->controls, &new_val);
> +}
> +
> +static int uvc_gpio_get_cur(struct uvc_device *dev, struct uvc_entity *e=
ntity,
> +			    u8 cs, void *data, u16 size)
> +{
> +	if (cs !=3D UVC_CT_PRIVACY_CONTROL || size < 1)
> +		return -EINVAL;
> +
> +	*(u8 *)data =3D gpiod_get_value_cansleep(entity->gpio.gpio_privacy);
> +
> +	return 0;
> +}
> +
> +static int uvc_gpio_get_info(struct uvc_device *dev, struct uvc_entity *=
entity,
> +			     u8 cs, u8 *caps)
> +{
> +	if (cs !=3D UVC_CT_PRIVACY_CONTROL)
> +		return -EINVAL;
> +
> +	*caps =3D UVC_CONTROL_CAP_GET | UVC_CONTROL_CAP_AUTOUPDATE;
> +	return 0;
> +}
> +
> +static irqreturn_t uvc_gpio_irq(int irq, void *data)
> +{
> +	struct uvc_device *dev =3D data;
> +
> +	uvc_gpio_event(dev);
> +	return IRQ_HANDLED;
> +}
> +
> +static int uvc_gpio_parse(struct uvc_device *dev)
> +{
> +	struct uvc_entity *unit;
> +	struct gpio_desc *gpio_privacy;
> +	int irq;
> +
> +	gpio_privacy =3D devm_gpiod_get_optional(&dev->udev->dev, "privacy",
> +					       GPIOD_IN);
> +	if (IS_ERR_OR_NULL(gpio_privacy))
> +		return PTR_ERR_OR_ZERO(gpio_privacy);
> +
> +	unit =3D uvc_alloc_entity(UVC_EXT_GPIO_UNIT, UVC_EXT_GPIO_UNIT_ID, 0, 1=
);
> +	if (!unit)
> +		return -ENOMEM;
> +
> +	irq =3D gpiod_to_irq(gpio_privacy);
> +	if (irq < 0) {
> +		if (irq !=3D EPROBE_DEFER)
> +			dev_err(&dev->udev->dev,
> +				"No IRQ for privacy GPIO (%d)\n", irq);
> +		return irq;
> +	}
> +
> +	unit->gpio.gpio_privacy =3D gpio_privacy;
> +	unit->gpio.irq =3D irq;
> +	unit->gpio.bControlSize =3D 1;
> +	unit->gpio.bmControls =3D (u8 *)unit + sizeof(*unit);
> +	unit->gpio.bmControls[0] =3D 1;
> +	unit->get_cur =3D uvc_gpio_get_cur;
> +	unit->get_info =3D uvc_gpio_get_info;
> +	strncpy(unit->name, "GPIO", sizeof(unit->name) - 1);
> +
> +	list_add_tail(&unit->list, &dev->entities);
> +
> +	dev->gpio_unit =3D unit;
> +
> +	return 0;
> +}
> +
> +static int uvc_gpio_init_irq(struct uvc_device *dev)
> +{
> +	struct uvc_entity *unit =3D dev->gpio_unit;
> +
> +	if (!unit || unit->gpio.irq < 0)
> +		return 0;
> +
> +	return devm_request_threaded_irq(&dev->udev->dev, unit->gpio.irq, NULL,
> +					 uvc_gpio_irq,
> +					 IRQF_ONESHOT | IRQF_TRIGGER_FALLING |
> +					 IRQF_TRIGGER_RISING,
> +					 "uvc_privacy_gpio", dev);
> +}
> +
>  /* ---------------------------------------------------------------------=
---
>   * UVC device scan
>   */
> @@ -1988,6 +2095,13 @@ static int uvc_scan_device(struct uvc_device *dev)
>  		return -1;
>  	}
> =20
> +	/* Add GPIO entity to the first chain. */
> +	if (dev->gpio_unit) {
> +		chain =3D list_first_entry(&dev->chains,
> +					 struct uvc_video_chain, list);
> +		list_add_tail(&dev->gpio_unit->chain, &chain->entities);
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -2350,6 +2464,12 @@ static int uvc_probe(struct usb_interface *intf,
>  		goto error;
>  	}
> =20
> +	/* Parse the associated GPIOs. */
> +	if (uvc_gpio_parse(dev) < 0) {
> +		uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC GPIOs\n");
> +		goto error;
> +	}
> +
>  	uvc_printk(KERN_INFO, "Found UVC %u.%02x device %s (%04x:%04x)\n",
>  		dev->uvc_version >> 8, dev->uvc_version & 0xff,
>  		udev->product ? udev->product : "<unnamed>",
> @@ -2394,6 +2514,13 @@ static int uvc_probe(struct usb_interface *intf,
>  			"supported.\n", ret);
>  	}
> =20
> +	ret =3D uvc_gpio_init_irq(dev);
> +	if (ret < 0) {
> +		dev_err(&dev->udev->dev,
> +			"Unable to request privacy GPIO IRQ (%d)\n", ret);
> +		goto error;
> +	}
> +
>  	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
>  	usb_enable_autosuspend(udev);
>  	return 0;
> diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/u=
vc_entity.c
> index 7c9895377118c..96e965a16d061 100644
> --- a/drivers/media/usb/uvc/uvc_entity.c
> +++ b/drivers/media/usb/uvc/uvc_entity.c
> @@ -105,6 +105,7 @@ static int uvc_mc_init_entity(struct uvc_video_chain =
*chain,
>  		case UVC_OTT_DISPLAY:
>  		case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
>  		case UVC_EXTERNAL_VENDOR_SPECIFIC:
> +		case UVC_EXT_GPIO_UNIT:
>  		default:
>  			function =3D MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>  			break;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvc=
video.h
> index 0e4209dbf307f..e9eef2170d866 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -6,6 +6,7 @@
>  #error "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instea=
d."
>  #endif /* __KERNEL__ */
> =20
> +#include <linux/atomic.h>
>  #include <linux/kernel.h>
>  #include <linux/poll.h>
>  #include <linux/usb.h>
> @@ -37,6 +38,8 @@
>  	(UVC_ENTITY_IS_TERM(entity) && \
>  	((entity)->type & 0x8000) =3D=3D UVC_TERM_OUTPUT)
> =20
> +#define UVC_EXT_GPIO_UNIT		0x7ffe
> +#define UVC_EXT_GPIO_UNIT_ID		0x100
> =20
>  /* ---------------------------------------------------------------------=
---
>   * GUIDs
> @@ -56,6 +59,9 @@
>  #define UVC_GUID_UVC_SELECTOR \
>  	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
>  	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02}
> +#define UVC_GUID_EXT_GPIO_CONTROLLER \
> +	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
> +	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03}
> =20
>  #define UVC_GUID_FORMAT_MJPEG \
>  	{ 'M',  'J',  'P',  'G', 0x00, 0x00, 0x10, 0x00, \
> @@ -213,6 +219,7 @@
>   * Structures.
>   */
> =20
> +struct gpio_desc;
>  struct uvc_device;
> =20
>  /* TODO: Put the most frequently accessed fields at the beginning of
> @@ -354,6 +361,13 @@ struct uvc_entity {
>  			u8  *bmControls;
>  			u8  *bmControlsType;
>  		} extension;
> +
> +		struct {
> +			u8  bControlSize;
> +			u8  *bmControls;
> +			struct gpio_desc *gpio_privacy;
> +			int irq;
> +		} gpio;
>  	};
> =20
>  	u8 bNrInPins;
> @@ -696,6 +710,8 @@ struct uvc_device {
>  		struct uvc_control *ctrl;
>  		const void *data;
>  	} async_ctrl;
> +
> +	struct uvc_entity *gpio_unit;
>  };
> =20
>  enum uvc_handle_state {

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-ig/wlPZIl6jLG76iEVYM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmndVVsACgkQ57/I7JWG
EQkD7BAAkpr3/JMlpzpbP4Ur59HYho+dpFaXWx+GwJEGZl56jknlNeqBpTW738oO
IQnQRz38Gq8VavxOVbcTK4rIGRmSRN2GvDv5/oxU8luoba3BqEXC1e0vaxOD5e/N
tL9566Jxjd2/TmNcA82IIV9Y7hUoRUVHmcl3ItSfb8z/VMce/Y9r5ZYGn+jxXQ1R
ao4k93QXam3If8CfIilpdJrQ/JG+xPpjdZjhqgXnI18xFaXvGFMz7j0HXPuaQFD0
hrOtwBRBw91HSkHLmSJLW58ge91eCXvnBiIf8tKd/7/8UwP8T3Ysc8+KE36CnwGD
yOTcNhO3tP67fozrbCVLwQDM5lQfnzr00n7BV5YwaJdH919hiNfHgm93mKGqZ6HC
mDsD4qzlFcG2doZeIEsEVFavGXcKDwtIedqh+kJ6wQq+prs5ZUnT7Wl0WA1N7Y1/
2QkzMSMtPQob5wdLCZUH1GJWTywpLE+rBgQR7NpGT+trtfKttTLe/vzDhSPZg4bh
0UlJYKh9gR4YI4FwRxyXQu8aHqip866KcHgN0nZultK+BatSybCzsPIL23ZReNHT
5RnwhFIQoOSlCa5pnyQpy9GObNyqtHtvdduTLpecVZB4ZRJWSw0aUdHtEEITxMJ1
nc/j+wzOBBQ1eL20kCkm2v9EtN1pSktBuhRqmHH6sKvM5GMdspA=
=gtY9
-----END PGP SIGNATURE-----

--=-ig/wlPZIl6jLG76iEVYM--
