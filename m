Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831044;
	b=Ukqp/01hezUhUYcmljjgjtkPZ7xLI7VD8RLnvjdWOpAVJRswZEVv2EMBzC+baOQ2z+ZL
	 89vfM5Zw9SZ9Qsgmf8m53JR/gKSiR6qh1bYHmA6Aextd5YBNw9Tho5GWizbDsIV5kNSQr
	 0ebllj8XjOPxV3fifyUD2HkXwFPgE/RPov0/HX+u+G1OV7crW/LkIGsmwLJw8WfM8yXyk
	 h9zgL/zGFEt6McVvEIXNDf2A+ZTBXJ+O5jIbAe8MaTZLXE43LgRltyMalGaGTFsBJJqlt
	 I5xZxmqRoZGGYgHRal7Ghvq85H8bFS9Z3EPv6/wOmGhXG6U2iVbHMrcgCAuGJWSag0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mrlSm2XsoJvAPkYqhjCR088gRqxyJ/VxQsJXHqzkFhM=;
	b=VCuN9yd4vTrAlwER1w7ThB0zhdzqQqAvU7sA8CZnT2y3oZ2DKTWKdH5HmLLJZORXd9ME
	 A0ZKgnx0XdNM7Z6O0MmFrYi2Dh6z3LhOygKsYZ56A3uOzFtjcqxs7Yq6VvetePyjyZwKA
	 P4j7E5rJIfCCXi0Iw3oVbkOUTwHi9HdrdDloBsUAiu2k/tMr6dGx7PMNSvbgh5xGIFwNl
	 J9nD4HJB68eBr+nzGz7Wt3TsNSLeDaeq3Fbx//zHIVAJASIyYceUVd1DLjmRu+ivMZpTj
	 v25O8UCTDJ4MbojId0qPG6XerNdxlb7cSmXZWq5IbzBr1UBKYFM+2t3SzzQ/elYPGig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJjt8JMz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E982606A843;
	Wed,  4 Nov 2026 22:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJjt8JMz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03D51F00919;
	Wed,  4 Nov 2026 22:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831044;
	bh=mrlSm2XsoJvAPkYqhjCR088gRqxyJ/VxQsJXHqzkFhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJjt8JMz3/bEyPsVF+SystCrHqHhymotQujx2jqb7L4sMKUHJrU7MDL5Tp/ZsdA0v
	 /czRYdhqvJu7UGc3RFw1CoUFjVB5VTvwtBNLUpCYWNuRmTPV64cl7ouMW0RmsljjSv
	 V3jIgHf50XuoscJgBr3fWiGG7N1Bq7BqqaRM2FiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0477/1005] HID: i2c-hid: add reset quirk for Lenovo Yoga Slim 7x Gen 11 keyboard
Date: Wed,  4 Nov 2026 16:03:30 -0500
Message-ID: <20261104211057.355960551@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit 39e8e085710a2d36d9ceade11739fb7b87f5aeb0 ]

The ITE controller behind the keyboard of the Lenovo Yoga Slim 7x Gen 11
(048d:83db) carries out a reset but never raises the interrupt that
acknowledges it. i2c_hid_finish_hwreset() therefore waits out its full
one second timeout and logs "device did not ack reset within 1000 ms" on
every probe and every resume, before the keyboard comes up regardless.

Set I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for it, as is already done for
several other ITE parts, so the reset is followed by a fixed 100 ms sleep
instead.

Signed-off-by: Oleg Keri <okerixx@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              | 1 +
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 11f120a5d1b90..a10b4ae0e3d8e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -737,6 +737,7 @@
 #define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA900	0x8396
 #define I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_KEYBOARD	0x8987
+#define I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_G11_KEYBOARD	0x83db
 #define USB_DEVICE_ID_ITE8595		0x8595
 #define USB_DEVICE_ID_ITE_MEDION_E1239T	0xce50
 
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index e5a4c7deba502..62b3dd0390a7c 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -126,6 +126,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET | I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
+	{ USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_G11_KEYBOARD,
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
-- 
2.53.0



