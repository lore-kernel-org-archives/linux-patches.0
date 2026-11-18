Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034006;
	b=D/0tx7rOaBu/5tYAI4gwvMHEa/WHv4MZ58k3EtNF/sD2Gm9XY6vDII93ab+CktHR63sH
	 HQqzCl6CQcl/zwvXwWi0OtofUl3EJltaPvp+ZvmrZ4SEyaMoCknbXGrvhqDIGr0FLr6VN
	 5hd3NQaEoAteq1wFv8IXs0MRHXLhzaii9K/JFKnt7pmxke1BdN7nA6XhcTmPIe9kbWGAK
	 f6tQhFhCU80TmpW4LBc7q1Vv1R8TjXnXT1vn9Ep7/0PgM0I0FotdO22mMZchfO/f2/2tv
	 8xDjekT/OyZt2KAyH+xfOUMdZLsBDqujcQFcPbjHqNf4C/pXmOc9lfEXp5r6qh5OGDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/Qz/9Xf5yukTWFkDM12wG6r7jOZ07VLz/wtBb6bNOg=;
	b=d8TH2ElmCs26JfifI6F64iyGJPBqd4b+P35ZxbU/QZY74MlRZuTNSkCn+LGYHfzZhtwp
	 hb16WKSZTXLdM/3BpJZRCATIlo1m5No6IEfLqI4JUOj8IAy90Ox9dUwMjMN61m26gkI9h
	 qpgvKAYCuntn9TFuMnHsqFQarLZ0x/34Cn5+a1LJ7MlNnxy2sCiYEjKdSTtNHB/SESMcJ
	 o11Bp+FME716rA9QqxqGdH/1RNvLIcV9vajClVN3rOxZGmMgyb5hC7EqQb0/VrLQ89SU6
	 0yb1fvz7adL3u9QxhqkOJ2qIq86d+lYgSI9QpWX+V+uMVrhFHPbjAfIrFszT7fHRI9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsxsObTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A97606A31C;
	Wed, 18 Nov 2026 20:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsxsObTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56011F000C4;
	Wed, 18 Nov 2026 20:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034006;
	bh=S/Qz/9Xf5yukTWFkDM12wG6r7jOZ07VLz/wtBb6bNOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsxsObTR06PpWCJypAwT1phB6StxbS0YuGN3m5y9Fga32aFcIqHWBWbCuiUgxkXdt
	 72jtFa/jy68Aj+XPQ/6kcGdxZNXJXOgu6P13ASXp/X0snV9BY8/0iug5g3b2Jgc1Cj
	 rz89NIGGf/fMmO1226hb7FNq15wM3L8TsAkhGeBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0217/3318] HID: logitech-hidpp: Add support for G502 X Plus USB mouse
Date: Wed, 18 Nov 2026 15:13:59 +0100
Message-ID: <20261118150321.476280030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

[ Upstream commit 6f4b44abe4ccdcfdab75c9493b8c7634fee37133 ]

The wireless dongle is already supported, this adds detection for
the mouse in wired mode. Supports battery reporting.

Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 88b4027236cdf..eb3066cd24d47 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4654,6 +4654,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
 	{ /* Logitech G502 Lightspeed Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08D) },
+	{ /* Logitech G502 X Plus Wireless Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC095) },
 	{ /* Logitech G703 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
 	{ /* Logitech G703 Hero Gaming Mouse over USB */
-- 
2.53.0



