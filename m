Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33B33542E5
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113447; cv=none; b=XWE8etAaC2Swy1dq/otqe2zSWOpp8DRoiLP10GtrRlfTPsgUiqHmZHV84pM62rmr2i8uR4yE1O/ur9B6N0XW4S7MibCBQYR4i+KIlBlcKVDj+X43IeimFE9QyGshb3bX9d2fThDiQmnXeQ5/ds5sv3nD9y8zFMhhlbcbUss9LGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113447; c=relaxed/simple;
	bh=phu48ISBgFzloGx3bFM/4hErH7fJS3B/cwB4bdAFvLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WL6CUBrZmWtdPc3fD/BXhPTd80/iT9HOANJJ8vQyMdQBzS9DvLr343aNxiSEYSS7CIbAglFVSlvragDh8tj23DfJuVNNP4SeUHFNSssl+zEzPbsm9WK0uOUNBiPwztT6SmpUHxT1r8w5PR76V7bSDoEJKGqAnCft101P/V4MfrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=lGe3WJ67; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lGe3WJ67"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-671c24f23b1so1015797a12.0
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 13:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1776113444; x=1776718244; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zVPUv+wqfybhPNC6whwT8hRPdxEZtWnFtuiq+gFIrwY=;
        b=lGe3WJ67lscdWMMeG7FldhSchZ/sBH+Ady9AXaXi/EE5W9hR7UFKY7zw1w/ukTq3Tu
         mgel8rMVj6Ao7W6CbN2w0AGJfYuZq09yr3DmPLEXO1Gg53k8G97kbjyp2uxcixp6ovT6
         LM93cMaXlhBatEDoIsz4xgpOEAa2JUGbS25Gs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776113444; x=1776718244;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVPUv+wqfybhPNC6whwT8hRPdxEZtWnFtuiq+gFIrwY=;
        b=jOBItOJG+cbYd59w3k991GNklDOKqahENNswBOaM3jrP9czbkXhqtw79QSwNICn+ze
         YoVuoOvqCBqQzx1zDwhdYAreMxljrAQV89tEWg7m9Z75GRtO6LqBdPU7rR2LoriwXoq0
         upnCIXbo0dU/WG13JuCZd2d19N5CG9zDcqlqC4FqrR58fguchKuD3ge9c2R0ANWcR6uf
         a4x+016jnPVpYimDdW5bzhRMBnRbc8PyXdRKyYaCFJNbXGY6Z7qu4kK/kfIH5ESK/PiX
         HxTB+ajhXNxILXymwyDK/I+bUF7FuodKTruiveOJm0zO3pOjSeXzDVaqsb9Ose9WZCrV
         jX+w==
X-Forwarded-Encrypted: i=1; AFNElJ9e9cpOslbkqa2Cdu/Q4nZoZkAgOw/9eXxT0SDaEIVu06HNEHWtFkSiKNpgUkR/sL6pGSyrBOsk@lists.linux.dev
X-Gm-Message-State: AOJu0YyAH8PJ/xNsmwNIUDwVKYaeFlGccujrbAA4xpEYWmPlGix+QDzp
	6rfjCJr47PzLzW7NC1B8HqJQZnwYcup11jJkEKE1OMpXxOObAYN8WT2edwOWl4k4WRXomzjKAn/
	wBZM=
X-Gm-Gg: AeBDieteMv+VOyRnt1pgZnRF1BtkIFPmHBFL8n2MWwIXCs1NsSpRsxV22gPy3l+vtrc
	5x1lbFYql1iQG0mBPbhowwQP4bHuecdzZQUpx9yHXlYnbtXnh32F6ESzaGERhiCTOXbv7WR2ReX
	6gO+1n1RuwXxP01RyzLW4bvJggjw0cijePclsgFCY7Ii0B3wxbjnOIFxLlLWKTehDp4iXAVrHpe
	qI+/43YW6Uod/Gg3cMzspsBVMtzCxw9Zz890/F/3KXsAiNujbYW6rJ7+RQD6Jz2GaBWafdseI3D
	co8bykfqSXYQfOH9lA0WM8OCxgmbYZs/Fyl4qpffXLA4wipCjzASlWDIQyk/lBS7wZwPOXp1bQg
	QkzF2vnvdNv7K4Y5sp2fWdB/zjZlxIC/VlxP/UUNFPPvmjVlbPfTNJBWRgqAJYsnDCYXb5SzDlR
	Q3iA/syI3uP86Cr3+faHyy5WeihzyhYEgLXca5Qr765za7Ah4oWsjsaHMU7HQR
X-Received: by 2002:a05:6402:1f48:b0:66e:bad3:1ca0 with SMTP id 4fb4d7f45d1cf-6707a475baamr7332025a12.13.1776113443682;
        Mon, 13 Apr 2026 13:50:43 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-670e93f1898sm1853188a12.16.2026.04.13.13.50.42
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 13:50:42 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b9c1da7ac63so734275066b.0
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 13:50:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+qMcI0Ntn7Z2XoFg1IkghrDaxVSKpyvyHiUg/JGgzyg7o3TSfa8ApJso0IA0gY0FnzcVHQBuo8@lists.linux.dev
X-Received: by 2002:a17:907:e110:b0:b97:8503:8313 with SMTP id
 a640c23a62f3a-b9d727aa2a5mr567836466b.27.1776113441514; Mon, 13 Apr 2026
 13:50:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155819.042779211@linuxfoundation.org> <20260413155835.015055819@linuxfoundation.org>
 <673ddf965a5af7b881e86cb2e22055d4fcbb2dfc.camel@decadent.org.uk>
In-Reply-To: <673ddf965a5af7b881e86cb2e22055d4fcbb2dfc.camel@decadent.org.uk>
From: Ricardo Ribalda <ribalda@chromium.org>
Date: Mon, 13 Apr 2026 22:50:28 +0200
X-Gmail-Original-Message-ID: <CANiDSCt44g9PYddX1bYw+OASwV=Ah2XOKmKmf0aeXSCKZ7i7EA@mail.gmail.com>
X-Gm-Features: AQROBzC_h9nhOHxtr7G1YxDXbqLWLzbLM63nuJ9k1lJ_PFCs9CEKXTUPrPthIfo
Message-ID: <CANiDSCt44g9PYddX1bYw+OASwV=Ah2XOKmKmf0aeXSCKZ7i7EA@mail.gmail.com>
Subject: Re: [PATCH 5.10 427/491] media: uvcvideo: Implement UVC_EXT_GPIO_UNIT
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Apr 2026 at 22:43, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Ricardo Ribalda <ribalda@chromium.org>
> >
> > [ Upstream commit 2886477ff98740cc3333cf785e4de0b1ff3d7a28 ]
>
> This is a new feature, not obviously suitable for stable.

Agree with Ben here.

if the reason for this patch is to get  "media: uvcvideo: Use
heuristic to find stream entity" in 5.10 I can work on a backport that
only adds this feature without GPIO it should be pretty easy.


>
> If it really is needed for 5.10 then there are a number of bug fixes
> that also need to follow: 387e89393071 ["media: uvcvideo: Fix deferred
> probing error"), a9ea1a3d88b7 ("media: uvcvideo: Fix crash during unbind
> if gpio unit is in use"), and f0f078457f18 ("media: uvcvideo: Fix memory
> leak in uvc_gpio_parse").
>
> Ben.
>
> > Some devices can implement a physical switch to disable the input of the
> > camera on demand. Think of it like an elegant privacy sticker.
> >
> > The system can read the status of the privacy switch via a GPIO.
> >
> > It is important to know the status of the switch, e.g. to notify the
> > user when the camera will produce black frames and a videochat
> > application is used.
> >
> > In some systems, the GPIO is connected to the main SoC instead of the
> > camera controller, with the connection reported by the system firmware
> > (ACPI or DT). In that case, the UVC device isn't aware of the GPIO. We
> > need to implement a virtual entity to handle the GPIO fully on the
> > driver side.
> >
> > For example, for ACPI-based systems, the GPIO is reported in the USB
> > device object:
> >
> >   Scope (\_SB.PCI0.XHCI.RHUB.HS07)
> >   {
> >
> >         /.../
> >
> >     Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
> >     {
> >         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
> >             "\\_SB.PCI0.GPIO", 0x00, ResourceConsumer, ,
> >             )
> >             {   // Pin list
> >                 0x0064
> >             }
> >     })
> >     Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
> >     {
> >         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
> >         Package (0x01)
> >         {
> >             Package (0x02)
> >             {
> >                 "privacy-gpio",
> >                 Package (0x04)
> >                 {
> >                     \_SB.PCI0.XHCI.RHUB.HS07,
> >                     Zero,
> >                     Zero,
> >                     One
> >                 }
> >             }
> >         }
> >     })
> >   }
> >
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > Stable-dep-of: 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/media/usb/uvc/uvc_ctrl.c   |   3 +
> >  drivers/media/usb/uvc/uvc_driver.c | 127 +++++++++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvc_entity.c |   1 +
> >  drivers/media/usb/uvc/uvcvideo.h   |  16 ++++
> >  4 files changed, 147 insertions(+)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> > index 698bf5bb896ec..fc23e53c0d38b 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -2378,6 +2378,9 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
> >               } else if (UVC_ENTITY_TYPE(entity) == UVC_ITT_CAMERA) {
> >                       bmControls = entity->camera.bmControls;
> >                       bControlSize = entity->camera.bControlSize;
> > +             } else if (UVC_ENTITY_TYPE(entity) == UVC_EXT_GPIO_UNIT) {
> > +                     bmControls = entity->gpio.bmControls;
> > +                     bControlSize = entity->gpio.bControlSize;
> >               }
> >
> >               /* Remove bogus/blacklisted controls */
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> > index e1d3e753e80ed..b86e46fa7c0af 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -7,6 +7,7 @@
> >   */
> >
> >  #include <linux/atomic.h>
> > +#include <linux/gpio/consumer.h>
> >  #include <linux/kernel.h>
> >  #include <linux/list.h>
> >  #include <linux/module.h>
> > @@ -1033,6 +1034,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
> >  }
> >
> >  static const u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
> > +static const u8 uvc_gpio_guid[16] = UVC_GUID_EXT_GPIO_CONTROLLER;
> >  static const u8 uvc_media_transport_input_guid[16] =
> >       UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
> >  static const u8 uvc_processing_guid[16] = UVC_GUID_UVC_PROCESSING;
> > @@ -1064,6 +1066,9 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u16 id,
> >        * is initialized by the caller.
> >        */
> >       switch (type) {
> > +     case UVC_EXT_GPIO_UNIT:
> > +             memcpy(entity->guid, uvc_gpio_guid, 16);
> > +             break;
> >       case UVC_ITT_CAMERA:
> >               memcpy(entity->guid, uvc_camera_guid, 16);
> >               break;
> > @@ -1467,6 +1472,108 @@ static int uvc_parse_control(struct uvc_device *dev)
> >       return 0;
> >  }
> >
> > +/* -----------------------------------------------------------------------------
> > + * Privacy GPIO
> > + */
> > +
> > +static void uvc_gpio_event(struct uvc_device *dev)
> > +{
> > +     struct uvc_entity *unit = dev->gpio_unit;
> > +     struct uvc_video_chain *chain;
> > +     u8 new_val;
> > +
> > +     if (!unit)
> > +             return;
> > +
> > +     new_val = gpiod_get_value_cansleep(unit->gpio.gpio_privacy);
> > +
> > +     /* GPIO entities are always on the first chain. */
> > +     chain = list_first_entry(&dev->chains, struct uvc_video_chain, list);
> > +     uvc_ctrl_status_event(chain, unit->controls, &new_val);
> > +}
> > +
> > +static int uvc_gpio_get_cur(struct uvc_device *dev, struct uvc_entity *entity,
> > +                         u8 cs, void *data, u16 size)
> > +{
> > +     if (cs != UVC_CT_PRIVACY_CONTROL || size < 1)
> > +             return -EINVAL;
> > +
> > +     *(u8 *)data = gpiod_get_value_cansleep(entity->gpio.gpio_privacy);
> > +
> > +     return 0;
> > +}
> > +
> > +static int uvc_gpio_get_info(struct uvc_device *dev, struct uvc_entity *entity,
> > +                          u8 cs, u8 *caps)
> > +{
> > +     if (cs != UVC_CT_PRIVACY_CONTROL)
> > +             return -EINVAL;
> > +
> > +     *caps = UVC_CONTROL_CAP_GET | UVC_CONTROL_CAP_AUTOUPDATE;
> > +     return 0;
> > +}
> > +
> > +static irqreturn_t uvc_gpio_irq(int irq, void *data)
> > +{
> > +     struct uvc_device *dev = data;
> > +
> > +     uvc_gpio_event(dev);
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static int uvc_gpio_parse(struct uvc_device *dev)
> > +{
> > +     struct uvc_entity *unit;
> > +     struct gpio_desc *gpio_privacy;
> > +     int irq;
> > +
> > +     gpio_privacy = devm_gpiod_get_optional(&dev->udev->dev, "privacy",
> > +                                            GPIOD_IN);
> > +     if (IS_ERR_OR_NULL(gpio_privacy))
> > +             return PTR_ERR_OR_ZERO(gpio_privacy);
> > +
> > +     unit = uvc_alloc_entity(UVC_EXT_GPIO_UNIT, UVC_EXT_GPIO_UNIT_ID, 0, 1);
> > +     if (!unit)
> > +             return -ENOMEM;
> > +
> > +     irq = gpiod_to_irq(gpio_privacy);
> > +     if (irq < 0) {
> > +             if (irq != EPROBE_DEFER)
> > +                     dev_err(&dev->udev->dev,
> > +                             "No IRQ for privacy GPIO (%d)\n", irq);
> > +             return irq;
> > +     }
> > +
> > +     unit->gpio.gpio_privacy = gpio_privacy;
> > +     unit->gpio.irq = irq;
> > +     unit->gpio.bControlSize = 1;
> > +     unit->gpio.bmControls = (u8 *)unit + sizeof(*unit);
> > +     unit->gpio.bmControls[0] = 1;
> > +     unit->get_cur = uvc_gpio_get_cur;
> > +     unit->get_info = uvc_gpio_get_info;
> > +     strncpy(unit->name, "GPIO", sizeof(unit->name) - 1);
> > +
> > +     list_add_tail(&unit->list, &dev->entities);
> > +
> > +     dev->gpio_unit = unit;
> > +
> > +     return 0;
> > +}
> > +
> > +static int uvc_gpio_init_irq(struct uvc_device *dev)
> > +{
> > +     struct uvc_entity *unit = dev->gpio_unit;
> > +
> > +     if (!unit || unit->gpio.irq < 0)
> > +             return 0;
> > +
> > +     return devm_request_threaded_irq(&dev->udev->dev, unit->gpio.irq, NULL,
> > +                                      uvc_gpio_irq,
> > +                                      IRQF_ONESHOT | IRQF_TRIGGER_FALLING |
> > +                                      IRQF_TRIGGER_RISING,
> > +                                      "uvc_privacy_gpio", dev);
> > +}
> > +
> >  /* ------------------------------------------------------------------------
> >   * UVC device scan
> >   */
> > @@ -1988,6 +2095,13 @@ static int uvc_scan_device(struct uvc_device *dev)
> >               return -1;
> >       }
> >
> > +     /* Add GPIO entity to the first chain. */
> > +     if (dev->gpio_unit) {
> > +             chain = list_first_entry(&dev->chains,
> > +                                      struct uvc_video_chain, list);
> > +             list_add_tail(&dev->gpio_unit->chain, &chain->entities);
> > +     }
> > +
> >       return 0;
> >  }
> >
> > @@ -2350,6 +2464,12 @@ static int uvc_probe(struct usb_interface *intf,
> >               goto error;
> >       }
> >
> > +     /* Parse the associated GPIOs. */
> > +     if (uvc_gpio_parse(dev) < 0) {
> > +             uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC GPIOs\n");
> > +             goto error;
> > +     }
> > +
> >       uvc_printk(KERN_INFO, "Found UVC %u.%02x device %s (%04x:%04x)\n",
> >               dev->uvc_version >> 8, dev->uvc_version & 0xff,
> >               udev->product ? udev->product : "<unnamed>",
> > @@ -2394,6 +2514,13 @@ static int uvc_probe(struct usb_interface *intf,
> >                       "supported.\n", ret);
> >       }
> >
> > +     ret = uvc_gpio_init_irq(dev);
> > +     if (ret < 0) {
> > +             dev_err(&dev->udev->dev,
> > +                     "Unable to request privacy GPIO IRQ (%d)\n", ret);
> > +             goto error;
> > +     }
> > +
> >       uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
> >       usb_enable_autosuspend(udev);
> >       return 0;
> > diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
> > index 7c9895377118c..96e965a16d061 100644
> > --- a/drivers/media/usb/uvc/uvc_entity.c
> > +++ b/drivers/media/usb/uvc/uvc_entity.c
> > @@ -105,6 +105,7 @@ static int uvc_mc_init_entity(struct uvc_video_chain *chain,
> >               case UVC_OTT_DISPLAY:
> >               case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
> >               case UVC_EXTERNAL_VENDOR_SPECIFIC:
> > +             case UVC_EXT_GPIO_UNIT:
> >               default:
> >                       function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
> >                       break;
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > index 0e4209dbf307f..e9eef2170d866 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -6,6 +6,7 @@
> >  #error "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instead."
> >  #endif /* __KERNEL__ */
> >
> > +#include <linux/atomic.h>
> >  #include <linux/kernel.h>
> >  #include <linux/poll.h>
> >  #include <linux/usb.h>
> > @@ -37,6 +38,8 @@
> >       (UVC_ENTITY_IS_TERM(entity) && \
> >       ((entity)->type & 0x8000) == UVC_TERM_OUTPUT)
> >
> > +#define UVC_EXT_GPIO_UNIT            0x7ffe
> > +#define UVC_EXT_GPIO_UNIT_ID         0x100
> >
> >  /* ------------------------------------------------------------------------
> >   * GUIDs
> > @@ -56,6 +59,9 @@
> >  #define UVC_GUID_UVC_SELECTOR \
> >       {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
> >        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02}
> > +#define UVC_GUID_EXT_GPIO_CONTROLLER \
> > +     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
> > +      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03}
> >
> >  #define UVC_GUID_FORMAT_MJPEG \
> >       { 'M',  'J',  'P',  'G', 0x00, 0x00, 0x10, 0x00, \
> > @@ -213,6 +219,7 @@
> >   * Structures.
> >   */
> >
> > +struct gpio_desc;
> >  struct uvc_device;
> >
> >  /* TODO: Put the most frequently accessed fields at the beginning of
> > @@ -354,6 +361,13 @@ struct uvc_entity {
> >                       u8  *bmControls;
> >                       u8  *bmControlsType;
> >               } extension;
> > +
> > +             struct {
> > +                     u8  bControlSize;
> > +                     u8  *bmControls;
> > +                     struct gpio_desc *gpio_privacy;
> > +                     int irq;
> > +             } gpio;
> >       };
> >
> >       u8 bNrInPins;
> > @@ -696,6 +710,8 @@ struct uvc_device {
> >               struct uvc_control *ctrl;
> >               const void *data;
> >       } async_ctrl;
> > +
> > +     struct uvc_entity *gpio_unit;
> >  };
> >
> >  enum uvc_handle_state {
>
> --
> Ben Hutchings
> When in doubt, use brute force. - Ken Thompson



-- 
Ricardo Ribalda
