Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034319;
	b=HXZGyuUDcyFDQ6yjlIrRPkuuD5dKX4uyy55+A5ZuuyCbWldAP2tfN4hbbSPn3WJWKTrZ
	 +Z/ylcS5Ns/ccWbhGQuRymslDzthfoizwBdwL2d+upMrS6Odr5lPpuSjD1TTZiDW/zgU0
	 jfxUItLogN4ToJzb3nFOJxxaaNrwQXGDCNHJkSweU0lsJkZNXOUffNeFE7pY0EzOp+Seg
	 WySuR3s2+F3nUtw72/jR50TMLPyESNc6anXhdT9m9lt6oHckCtPcyPUh0JD0jccoLevgt
	 uIKUFcwSVX2nHX2iNO5WXoV9H47pHkvWjcibaAIsP0ipUs2Ji78WhP9Esgwx9IxaPow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2OaTcsan0zPKSq48kE+2IbKwNWwbdCI0TEMzchalJmQ=;
	b=jRsHAHQnrZSAKgINvBdaNnH9KCJYqeu2u2dMEUT8pD6OOCH9xI8GtwIw0T9d0wqX9BuS
	 bnWxKqEufPgAsMCLzyxSh741MjUEalRlxJa+Mj9RmsQcuEutW4PvG4CCiiJ8xhdlQblX7
	 H4zeLiFZ5LlLTfIiHx9ibJ/n1CLu6wlG1cOCmtEuUS+sHDMDAe9c5b/DEfiyLiDYjBHxP
	 +lN1AKqn1moFHQ0+rlletYTwNFRiprEoc0s6P9U3TjeaSPDBCOIUoUdgkOlTPjTLLfgx3
	 DaasthJQzD7Mz8lTAyPFsoXSveLQYoe2Uog244v40mVy688wN6q2Yo6kgRRB1Yo76Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKGfjejO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB9B606A31C;
	Wed, 18 Nov 2026 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKGfjejO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103281F000C6;
	Wed, 18 Nov 2026 20:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034319;
	bh=2OaTcsan0zPKSq48kE+2IbKwNWwbdCI0TEMzchalJmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKGfjejOaA0HRoVuIKnZaXa47GHL76ra8XTSPm9Kw0E81c1AEurYix+mDkAsujpoJ
	 PtboxfykQqzwQu3MCeb8CHQUM/hvI9k7+HP/51nZpSw62kJleydluOLMC4aTOoW9R4
	 GmT/vgIvX+ShG5+Db3BjaqJqm1Hfbye2/T44r5Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Klishko <vadim@cirque.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0325/3318] HID: i2c-hid: Add a quirk for a Cirque I2C device.
Date: Wed, 18 Nov 2026 15:15:47 +0100
Message-ID: <20261118150325.637843108@linuxfoundation.org>
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

From: Vadim Klishko <vadim@cirque.corp-partner.google.com>

[ Upstream commit 1c942462c3969b287a86ab6dbb143324289d564e ]

Cirque touchpads with PID D0C1 generate an error when probed
by the I2C HID driver, resulting in no hidraw device created.
Adding I2C_HID_QUIRK_NO_IRQ_AFTER_RESET fixes the issue.

Signed-off-by: Vadim Klishko <vadim@cirque.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              | 1 +
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d98d04e9e0bdf..e7ae90817b62e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -323,6 +323,7 @@
 
 #define I2C_VENDOR_ID_CIRQUE           0x0488
 #define I2C_PRODUCT_ID_CIRQUE_1063     0x1063
+#define I2C_PRODUCT_ID_CIRQUE_D0C1     0xD0C1
 
 #define USB_VENDOR_ID_CJTOUCH		0x24b8
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 1760f2693d31b..60f04a36d5f8d 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -133,6 +133,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_CIRQUE, I2C_PRODUCT_ID_CIRQUE_1063,
 		I2C_HID_QUIRK_NO_SLEEP_ON_SUSPEND },
+	{ I2C_VENDOR_ID_CIRQUE, I2C_PRODUCT_ID_CIRQUE_D0C1,
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	/*
 	 * Sending the wakeup after reset actually break ELAN touchscreen controller
 	 */
-- 
2.53.0



