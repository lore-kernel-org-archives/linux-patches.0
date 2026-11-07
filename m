Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061063;
	b=5Po54lsc51CDi9Tso1ZJjFa6vyWpK2Vr5f29O1J8ap8JT+g6/Mjaq13HT2dHZ/N0o1/r
	 VdjOPiyLj0YIAMQ0KhWVDsY6HcGRelO3O1PDaI8mvyQe2msBGlYNaNpk0MTPZK8toA89D
	 /cU5L9RdRpf/46rQfsd0TpChaLo45mRZCVu8CehL3/rHobZN/BbtSSdBC89VdIorD5BJp
	 L3/vhNb/3l18TUqXSUXtJLgYOSe574YbXOUAmkCzg6XynFj5UUiJHpCuYrThW+wJUcfwm
	 piTUFqefkdtFm7/t33X87Pyr9L5BrX1nRtAOGG75wxJblz2x5wVxCwPIUO0z+vHa7fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y28/09hsz825vtJT+kATa59jzpN+G9+YaTpt56BNb80=;
	b=3I8c5pEPjK0y0x35kt/RoKPVVjBUzEx7G1FYFrcnAK6a3jojObzDBLOruZx60BtC04KH
	 vUrWvw2PY93gEjl7YXyMf3jTQau1sR7ykwMCSZIMrDSLLxt3NJU7HAv+PB2YRPiwoGg5G
	 3zZtaFHlx+5Ij47pQxUXH0MJFZp97vOQKjkF/lFqvoqr9iWnoqtsylpanSb24XplaFztp
	 pmN8X8/qRY434203eqY7Wf1tQb/K3uA4juqqbGj/TgCoGgP3qypAjVD1RophMX9Vz80eK
	 vo2RUC2F5tuO9DvXktiOq8AWFsBaAEBbAI4KkeDyEAO+QzIvfBpiSv4FzFQtD+DlgFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aF99r+eK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C126082BC8;
	Sat,  7 Nov 2026 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aF99r+eK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3463C1F0089F;
	Sat,  7 Nov 2026 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061063;
	bh=y28/09hsz825vtJT+kATa59jzpN+G9+YaTpt56BNb80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aF99r+eKQiDnopO7+6JCeVEbDRvycwzMfblxKLKWpHeTEI9Q+LQSYbuOsiSQRvaNJ
	 B1DMe6PGUZWJiJHwIZXTkr0C/hQldIS5QrkftpPvbX45I6BJCJAGizFo0/yiL48scO
	 VeDlqWjiE9dEJA7gpXJNKdUoSjXqatDWgzYPFtuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Klishko <vadim@cirque.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0392/1536] HID: i2c-hid: Add a quirk for a Cirque I2C device.
Date: Sat,  7 Nov 2026 08:40:08 -0500
Message-ID: <20261107135008.611421381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7de3e011fe6cf..1fb68f393aa6e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -329,6 +329,7 @@
 
 #define I2C_VENDOR_ID_CIRQUE           0x0488
 #define I2C_PRODUCT_ID_CIRQUE_1063     0x1063
+#define I2C_PRODUCT_ID_CIRQUE_D0C1     0xD0C1
 
 #define USB_VENDOR_ID_CJTOUCH		0x24b8
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 0e1adfa9b2931..be64e30bce9f0 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -135,6 +135,8 @@ static const struct i2c_hid_quirks {
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



