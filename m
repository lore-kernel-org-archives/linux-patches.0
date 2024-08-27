Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A84619F485
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771059; cv=none; b=ZWPHuzxaNGu3x87ItHtiY9HqMQQ9O+OV6xR3TchZqXmeh6EgzIto1104GtuyPusV1Riw8/bsZFnCwzRUK8jFItY5fIViWuV8JZqxCadoqkhkxEBSSATfgVX1EHXBrddnUQr0GoctEoK3G0eRuzHg81+kd0Nxnp2+HZ0+igt9+qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771059; c=relaxed/simple;
	bh=sitoU9GOPCZKdPbVj7kj1YOt9IJlulo4vgrNAHs3Sv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnvNBymmOtC8/rc7feU4CmyxMqXKL/KZmH8rqec9rH+36TwvSKOxpqWgKlw4Sz5Sr+f7bZwdOA/iMYJHg4ipgLy4JES7YktFjC74x/ZAA22yxCXLVspgClYzITDa4tFVTAVOWRpaRdvvvBHBAQrpEE0ouYSbNYUAWUZLYEaCAMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mgr@pengutronix.de>)
	id 1sixjx-0001uh-8l; Tue, 27 Aug 2024 17:04:13 +0200
Received: from [2a0a:edc0:2:b01:1d::c5] (helo=pty.whiteo.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <mgr@pengutronix.de>)
	id 1sixjw-003SPu-RS; Tue, 27 Aug 2024 17:04:12 +0200
Received: from mgr by pty.whiteo.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <mgr@pengutronix.de>)
	id 1sixjw-008zUs-2O;
	Tue, 27 Aug 2024 17:04:12 +0200
Date: Tue, 27 Aug 2024 17:04:12 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 110/341] usb: gadget: uvc: cleanup request when not
 in correct state
Message-ID: <Zs3q7KGX_i99-B4_@pengutronix.de>
References: <20240827143843.399359062@linuxfoundation.org>
 <20240827143847.597379131@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ixqf0Tl6Cb5DiHsx"
Content-Disposition: inline
In-Reply-To: <20240827143847.597379131@linuxfoundation.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--ixqf0Tl6Cb5DiHsx
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 04:35:41PM +0200, Greg Kroah-Hartman wrote:
>6.6-stable review patch.  If anyone has any objections, please let me know.

Since this change is not actually in Mainline anymore as you reverted it
immediatly afterwards, it probably make no sense to pick it up.

I saw this patch and its revert past me the last week while being
applied on some other stable trees.


>------------------
>
>From: Michael Grzeschik <m.grzeschik@pengutronix.de>
>
>[ Upstream commit 52a39f2cf62bb5430ad1f54cd522dbfdab1d71ba ]
>
>The uvc_video_enable function of the uvc-gadget driver is dequeing and
>immediately deallocs all requests on its disable codepath. This is not
>save since the dequeue function is async and does not ensure that the
>requests are left unlinked in the controller driver.
>
>By adding the ep_free_request into the completion path of the requests
>we ensure that the request will be properly deallocated.
>
>Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
>Link: https://lore.kernel.org/r/20230911140530.2995138-3-m.grzeschik@pengu=
tronix.de
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Signed-off-by: Sasha Levin <sashal@kernel.org>
>---
> drivers/usb/gadget/function/uvc_video.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/=
function/uvc_video.c
>index 281e75027b344..678ed30ada2b7 100644
>--- a/drivers/usb/gadget/function/uvc_video.c
>+++ b/drivers/usb/gadget/function/uvc_video.c
>@@ -259,6 +259,12 @@ uvc_video_complete(struct usb_ep *ep, struct usb_requ=
est *req)
> 	struct uvc_device *uvc =3D video->uvc;
> 	unsigned long flags;
>
>+	if (uvc->state =3D=3D UVC_STATE_CONNECTED) {
>+		usb_ep_free_request(video->ep, ureq->req);
>+		ureq->req =3D NULL;
>+		return;
>+	}
>+
> 	switch (req->status) {
> 	case 0:
> 		break;
>--=20
>2.43.0
>
>
>
>

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ixqf0Tl6Cb5DiHsx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAmbN6ukACgkQC+njFXoe
LGSocxAAwkIN1q1RKSRl3Igq6Ln8Hu6xf135pzG8cl+b7VX9nqYsKB1QmsAVZTJr
+cIBNTxD1h/1mFMOQKGXLj37XhwKoEkDrPejR1csyY9ulw+gFPTmeiPzACHWFOMk
IO8ITsV+dsUT87M/b0vcTUd7ZANh+qHDc87nEliIrMDXi8ZKPUUzMeLiK40VPaJE
+qAOulkqV2aC9rFfxj68JIhksQKcr4CdvPO5yDaEYkfPanNZwOOlkFjOtw9VdRKt
83lbMO1+sIe/sovgmv7D04ZKfar3179XyCHyOKN+BSCqDpOQ3XTe4gTP1IvGTgcL
FaHM7S0w9V43r3i+0YQCiVmoyy1Pvp/37LxqnWccGkMtCKNkbDn3vRfXlSsjlTvL
vWOP9tNcjRykealtAWRvSqZSYjnB1E3mKEZYzI2Fq2yGocJ+aZXNHX0mzrqsTDWj
We1Cw355kK9U//0QXNJny4nhfAA/JIV6hSQRE8hF2JsRIA/vXI3bz7nKtS6gdECq
B2DxK2rBpKVACrJllMtP22643htRffg08LfFWijRxW8cRihJPZxYhwj/bnEnfftC
GeU4QoFJuiZy3SL0jKloSAoPkzl1zMatG7ZT+gwyS8Lb+0HiwQ20POuWAp3Gz6kG
mg5n8TnlUEOnzuoLFbCN9d4Zu3TeudIjPyxoEITsuwnQu9subeI=
=wckj
-----END PGP SIGNATURE-----

--ixqf0Tl6Cb5DiHsx--
