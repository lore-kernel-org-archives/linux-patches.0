Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052568;
	b=DmFw9zwvwLf1m8gvmrxihLX42s7TPvCAxcrltVRVIUTFH78Glf/vrIFzFqcSJmrS3b/+
	 Rfu45AGZgABqq4rYTzj9kqoeuCyJN+f6Fv3rHqaNQD+RC4FlIHDNjTKJs6M3DJVr0b9AD
	 hDNrD77Q3j0PV3xBx1micUvAcYTl5NDXB2tlU1xQ9g/aYbm64X+Z1qD6yx88pg5Mpw3bP
	 00H1fK+KHuymcn0gDKlO+lPny0w5lkPVfuaAWoik9DzE8NFo3adatTxcLka/jijf8qDqR
	 /QIW0yv4WDHior3C2DynuKxvXdUlNw1sBGIwWiOXc9SMuLfCRnyJOvlRv58ibj4ZqrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yX9qh6DfUZu3HaPLQSiTLNC0XLPEj01FHsTTAuM3aMY=;
	b=m6YDJIn7a2EjCzvjM75mQa67QNShKhSE2PqC7K3ywWZSnSZL0nS9AhiECBQkMmkftKy5
	 VeQiQAw/Qi7OcgWR6/zGZeBIluomS7ZCSsyAeoL8HXUivg6nVBOpp1km5cyqp9/IRDfYc
	 Jkwc4aHCQxhSSAKQYgW68EAVwpLykjVowvGcsMfluCdttWxzQznYaLAVNkSdeJ8rq054M
	 bIFftnzrkBAvlWk5aMYYdTHhMf++IaP0xiseK/OxfZl7HsqBFNMVNJWA7D8OrEJ3WDXtQ
	 93QcaRHKaZs50rMN5a7EwOGlCCw+RKSEpk+Hj9GvUsc1d0cuAjVIdXegvP9Fmq7MXBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksTGfZwv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B820C606A320;
	Thu, 19 Nov 2026 01:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksTGfZwv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116CF1F000C4;
	Thu, 19 Nov 2026 01:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052568;
	bh=yX9qh6DfUZu3HaPLQSiTLNC0XLPEj01FHsTTAuM3aMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksTGfZwvxNwV5ZAKcvmG87/GNbITv3x96ECwn76j35c1fcAvBFCdIhjMk6RXpzsCS
	 LrZJJh6Z6zMSaA7LWxWW2czk4VWYTR4lNMDPgJmkxPfVlLg+sNeRYJS6KDO28urfiU
	 Sf0EEtNlV2vgje3V4bSmFbWAKTy5bQDK6MgA6RVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0609/2214] USB: serial: usb_wwan: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:38:05 +0100
Message-ID: <20261118150035.528560439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c78dd373b5c56a5a02da591b583c6b48d0d62954 ]

Make sure to drop the reference taken by usb_anchor_urb() when removing
URBs from the delayed URB anchor to prevent them from leaking when the
device is later disconnected.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the option driver")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260916165608.2085613-1-vulab@iscas.ac.cn
Cc: stable@vger.kernel.org	# 2.6.32
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/usb_wwan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index f21f25a8cf6fe..45ca717fa39c6 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -401,6 +401,7 @@ void usb_wwan_close(struct usb_serial_port *port)
 		urb = usb_get_from_anchor(&portdata->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		unbusy_queued_urb(urb, portdata);
 		usb_autopm_put_interface_async(serial->interface);
 	}
@@ -578,6 +579,8 @@ static int usb_wwan_submit_delayed_urbs(struct usb_serial_port *port)
 		if (!urb)
 			break;
 
+		usb_put_urb(urb);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err) {
 			dev_err(&port->dev, "%s: submit urb failed: %d\n",
-- 
2.53.0



