Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831069;
	b=ocoKM8J5dmbJd0Flxim9RX+OJ6yVFvpTGUn5PWd+03NqWr8XFJHJXLGBEv2uVIiBL5rI
	 IhRlq7gQg8VUnlYLMOgoWyG7GZai7jCYGTez858iBBgXPVK7jJG7/ZxJLJjhicJzOYVfr
	 qCiZYX3/dVddrSW+5XGyLgFhMGwC3+sRrwz5vYZnN9zI9Tt+FpGEFKog/KghKe31FtyJC
	 PxfidsGvzp7iYyE64GfidQtRFgFccFWRZ4mJQQ5i2fzJ5c6TrMDU5KxBxZKWRdFLPi6Kj
	 yxb4Ye2FJtuI2xw15NUZ0ZyIJZAZmhc8xBBGrMKwi0TgJzrmobhaZJoP/w59Ji5njXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2WBJmRhQtFLFeDBdbE2pbI/AYIGVTugIWQJRB4Uzg7k=;
	b=VlmgNinL1ucyCF5hdtVV+8tD+Qc7QCK38l25ORXXQmljQ0s/vwG45UXpncZwjQuIzf6E
	 Gy7L6ppOj9XfQpicif29buJA7qtryEiWM5giAWduOcbmxT2x8vH52sNZtIumrk5Cq0mvv
	 JmYKqbiyOkDegGoAEx0dAbyq+G8km4kfWKEMmAVb8i8ORXvT3u1MXEN/sN1GQlTM5yGLD
	 Lhyp3mG8hfqOiIvboopdAxuVm00LVSnV33TswgAZZRT57vjPA4b5VZss3IjEI0J8c3YOY
	 b4m7b0w4/z7lA9zX1lfzhoeqJ+925zM2VkXrL3kxShHjFCn0dZKQDXEoz2sdagluF8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUhZirMH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E3606A32C;
	Wed,  4 Nov 2026 22:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUhZirMH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300B61F00919;
	Wed,  4 Nov 2026 22:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831068;
	bh=2WBJmRhQtFLFeDBdbE2pbI/AYIGVTugIWQJRB4Uzg7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUhZirMHOMQW8frT+w4wWFOniBrzqknJILKAP2yfRRBwvkthnF7XUzUIIlsmtdk8n
	 zJ4ADmM/nZPZFH3xY/PV3EnMv+11fT4UoI6o/vVdaXyw+FItIYdDUvi2t9opX+yBPp
	 y5GMMXyAHk8kI37gzc2lQgwexOLcioQv6qCzbewc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0486/1005] HID: universal-pidff: Add support for Turtle Beach VelocityOne Race
Date: Wed,  4 Nov 2026 16:03:39 -0500
Message-ID: <20261104211057.593508088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 53f7f7955a684e820bdd6bd6792c45c4b434f637 ]

Add usb VID and device PID to hid-ids.h

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h             | 3 +++
 drivers/hid/hid-universal-pidff.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ca5c62f29aebe..69b1b0f98c99d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1415,6 +1415,9 @@
 #define USB_DEVICE_ID_ASUS_MD_5110	0x5110
 #define USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART	0x7100
 
+#define USB_VENDOR_ID_TURTLE_BEACH	0x10f5
+#define USB_DEVICE_ID_TB_VELOCITYONE_RACE	0x7077
+
 #define USB_VENDOR_ID_TWINHAN		0x6253
 #define USB_DEVICE_ID_TWINHAN_IR_REMOTE	0x0100
 
diff --git a/drivers/hid/hid-universal-pidff.c b/drivers/hid/hid-universal-pidff.c
index 60180467a0bfd..f1854cfe42d0d 100644
--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -187,6 +187,7 @@ static const struct hid_device_id universal_pidff_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_FORTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_LA_PRIMA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_TONY_KANAAN) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TURTLE_BEACH, USB_DEVICE_ID_TB_VELOCITYONE_RACE)},
 	{}
 };
 MODULE_DEVICE_TABLE(hid, universal_pidff_devices);
-- 
2.53.0



