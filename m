Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064588;
	b=WjOuNBS0FWT0yLDfGI6JRk9RQ5zpvHeX/gW+DUjj7Whl1gFXcUKHg462NPR6TK2S3yU4
	 K2yOnSCiLI/QeOaKD0U7IjHQ8ZEgP6u6lWK0iN9XYe3g1ASRTTDLsxKDEEhOIr2TNi0uv
	 Zi+B0+d6rFyMo3f0IargClJrpelFzJgKHvyKoGj5DLGccqrIND7PpEmlyMGute4AKGQ9R
	 Ityr28t64xFBaJDf6072KVKhYZMz1I8V6K43MEeeloNBzt35A135heEQP+6+z0QPzSAc1
	 s3WoiVhBaXuWZkXx0Huddhx1wHn3NdmVoiYDn8FCfWOtdhR4wdCynjb4cTYjeMgEzoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=68lrRG8hxnvXOey8rNKSE6oaGzzXXcOiAPvTTgSc4w8=;
	b=kLkmnxhYIBF5uP2BdWZRFhJ0EJZofOVU4D2JLzAzqJ4XbidiivJD2Hw5UU01FUd83rAJ
	 BVQQchPwDhahkfm4UoSKeTXvXVOTaHU6s0krMCknufQQU+jZpJCh+3xXzMDX/WeZ0B7bB
	 X0QjyptWNfa/eDcRvGmB+tIQVGQDZIQIZIClHfN7kywXH97obNHhYGQNUmCEqhMawtAtH
	 3K0zhlLH8r5A1YDippd1m+r89W7gbqFCm8RD8oIiZQ8KpOu7PK12V5YhJMsp05OO6UXET
	 O3ZlaaLisyIZI52uNnCGGugq7zQD5xHNHkcRG0Dg7G345eFWO4k0MYtyAua3+TOO9qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkD0BkYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CD7606A332;
	Sat,  7 Nov 2026 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkD0BkYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1561F0089F;
	Sat,  7 Nov 2026 15:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064587;
	bh=68lrRG8hxnvXOey8rNKSE6oaGzzXXcOiAPvTTgSc4w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkD0BkYtvgZYVcgglvBsWWRQJBFdxZ+BJ4J3E/rqsp+O+9BFkSDp9sYgTRA7+S1Yd
	 Xcy0CeEBoKxsDMv1Y4ZN/8D0LMSIYGXpnvoZjYtUjYL4hmwV9f8nHNSsXKAI0hIcQ6
	 p3OaXAo3/K+zpJMe3h+wgzzTANxjBKyvIvnpfwPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0604/1257] USB: serial: usb_wwan: fix urb leak on disconnect
Date: Sat,  7 Nov 2026 08:48:20 -0500
Message-ID: <20261107134955.997204143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a183cc4515edb..6beb4062bda3a 100644
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



