Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831115;
	b=alraygTmP7MXfwQZtLGm1Hn5Ut5e6De0Umnc2pKYt1qbrEoTt8fR2EN06/0YbT4cLDR0
	 wxmXjNxw9dYTntAgIwj6KuY0U+J8OPUp9aY5jwyeSRjaOTQc/3kJOwE7ZCsQHFSEYcCF8
	 o1Pw2n57Wsa2QGs6lPdcDikr6QKJVvaBA32/tfDqc4xOuDFCp3huHkaDphl1E/d/EVlvV
	 T0UaHJJKe50saFs1o8hxURUsVnNlfKznVzCU2DC6jLZHXdHVgJM8kXX4VwLyAdU5rdB1o
	 aQqB5eTtHZghfdWrHpCzFX2V8xLSwi8qyn7ByeziS/b74VfuPrD7eMDsq4WQaAdoIbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I77ww9rBQA9TkfXnLE6aAZE9e0R5gSTlbejiX2rt/nU=;
	b=fT+Y1axvLrNsupospQdaCm0arMoziSyehJjg22y+GHf7hmNJ+w2IEiqMxiLrIRgilrIU
	 Tj9eJUsbwWcITHbhjNlTFCfpaIKoVlt4ZhOXSwLZXrFI+WuGrzqFWUz4cZGq7YoNc8k+T
	 9Or2/ABK8hazEu0H8Zrwdf2i2gdjbAHtakvk17FZc/eaMo5CkSLi7XuJsnevNJDpKytrN
	 dKPyhfHFwA7V03ZZ4UK16u6y9XoTGjZreKVVunJN0jhSYdu/NMrqeH0FuYEgnO/c7xrJN
	 ZEjge2fCGAK9uWJDh0J93BTWXu9n0BlKgMjCdEer8hMNSH+X8Pc5Bq58H/UWyt6Idow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tr+xbOnD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E96606B3A3;
	Wed,  4 Nov 2026 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tr+xbOnD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301F01F000C1;
	Wed,  4 Nov 2026 22:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831115;
	bh=I77ww9rBQA9TkfXnLE6aAZE9e0R5gSTlbejiX2rt/nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tr+xbOnDeaeCs9JBtMnISArQIfnSM/l4CwydwRmCMGk3JnUbZesFLIeCOypXA4MZU
	 4LJD01KXxqcgm0+A6Jl7PyzcS6Fl9ENgNx3J7G8Om2kVwnHxL4wyLmXG4BywyqwTTV
	 /X0arFfLNyzmMcgzt9N3anipXej8IGY3Efe+dx3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Klishko <vadim@cirque.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0463/1005] HID: i2c-hid: Add a quirk for a Cirque I2C device.
Date: Wed,  4 Nov 2026 16:03:16 -0500
Message-ID: <20261104211056.995267558@linuxfoundation.org>
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
index 5169713539bc3..11f120a5d1b90 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -333,6 +333,7 @@
 
 #define I2C_VENDOR_ID_CIRQUE           0x0488
 #define I2C_PRODUCT_ID_CIRQUE_1063     0x1063
+#define I2C_PRODUCT_ID_CIRQUE_D0C1     0xD0C1
 
 #define USB_VENDOR_ID_CJTOUCH		0x24b8
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 6d407cbed1886..29c4f624f3c5c 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -136,6 +136,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_CIRQUE, I2C_PRODUCT_ID_CIRQUE_1063,
 		I2C_HID_QUIRK_NO_SLEEP_ON_SUSPEND },
+	{ I2C_VENDOR_ID_CIRQUE, I2C_PRODUCT_ID_CIRQUE_D0C1,
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	/*
 	 * Without additional power on command, at least some QTEC devices send garbage
 	 */
-- 
2.53.0



