Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045415;
	b=OO7OW7DoZtiCbQz07+0agGr9eHu31BFuv1Jdc6GrVkMfNXHktdS96QuiB2Y/XbbiqC8g
	 M2IrxpA7uz+7p4+IPPmf/3feqi0TJQhqQ4mU9cuV7M+i8cIYCZGQQvTjG8c1pSu5aVfNO
	 yiUeiM+2Xw5rFUEGZ/QmepUyd67q7nzeCphwMEYvOxK3R8Qey3btHpq3Hdv8jNlu23KJF
	 T9ZYKoA70SHYmZPtOlYBpOWsh90DqPQQwXT3qdRRxTRHVMqCpzJAVbLj2diOAr5dvRqHp
	 1N5Cm7/iuXqxPVTxeb/kM/ymY5PVvH9xVYeiO2d+JnkUeD3GSXaUiXmqxct8N/cN2uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mBp5MQYDMW2JnZf8YS2KBp1MBZHdVUwrOX1gQlyS71I=;
	b=5l7RSi6rJI39i93fCqrY8MnCoyGPRwjcGeqVl4MoMDm+xHDvVbGBsQ4Hv/jZWsGHv3yC
	 1uL4MF2GOPcrf55Z9BEoeSBL/g+6ZcAaqzV/e1dHIMV3FvbLR4mmsBclGQr9qXPxSc1dg
	 QEVZ0IiNfuDjH98OIc5M1YkPeLkM1nc1MePUIb1hhfgoiHheMM9zjjTKmEJefN6lIGmyC
	 /XPAtSiNfYFTAe5YREQB2n2TOCaHRuAjPAXyRjv4e+UTWHXScy3aRAG13TSDWJHraq0YQ
	 xFfLFLqFt8b4+FM08/GN/SrhyWSuE4vgzuJtfi4YDK5tuTj4Hqzq4/y6yQoX8QuEdfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENPVBm9q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC18B606A320;
	Wed, 18 Nov 2026 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENPVBm9q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480681F000C4;
	Wed, 18 Nov 2026 23:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045414;
	bh=mBp5MQYDMW2JnZf8YS2KBp1MBZHdVUwrOX1gQlyS71I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENPVBm9qH3U1h9jGlTo8zvEtB0XqosGEfEy8jfcH13S5HWSWy0u7fZDPgAiJI2Ota
	 C/kUyicFBtOvSN5F/LRST69gDSDcj4MNzkvqOFSJvvrMEoF8P9e1tX2VoCdpYys0Up
	 c55Qa96F3WNp/TtBj5vM8FvGfVAvWcpL8dokdSEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0915/2857] USB: serial: usb_wwan: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:32:29 +0100
Message-ID: <20261118150234.525423274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0017f6e969e12..67e1820bbbafe 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -402,6 +402,7 @@ void usb_wwan_close(struct usb_serial_port *port)
 		urb = usb_get_from_anchor(&portdata->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		unbusy_queued_urb(urb, portdata);
 		usb_autopm_put_interface_async(serial->interface);
 	}
@@ -579,6 +580,8 @@ static int usb_wwan_submit_delayed_urbs(struct usb_serial_port *port)
 		if (!urb)
 			break;
 
+		usb_put_urb(urb);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err) {
 			dev_err(&port->dev, "%s: submit urb failed: %d\n",
-- 
2.53.0



