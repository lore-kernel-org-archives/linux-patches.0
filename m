Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061080;
	b=UpPMDg1N6WgWlF71k6+KM2FfsZuWKs9JXLZ1qkJeUQ8e8UCwHYB715U1nx/yxAqQJ6Oz
	 igpYcW+TfvB476LVDp43ZrhYmdr6YLlftW02mgWBpSf5rd6V/ZQxbvQk4eaWiPgrKM4Nd
	 6kMc4GCvTCqeKJbBZSjKdFBo1GEhSBSnJKMi2KWl2YRZBz7XHmen54vQ9z7WjO39t/eoZ
	 5JB1uIkSF11uII3Eal/VSs7o1EkBvpUbI91P4W9nkcAnkkKXqJG+lfJaKEFvb8WeE0h2Y
	 fgNMsLtDFZ2VdIYlb3GMWLfSR2a5ailzTLX+LAJ6isHBs7vknH8b3bc7woE5rWllQtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NqAWjplcugzPMEPjxjVeW+0Aj+mkar0KxMVBk96mXPo=;
	b=GSNXVemIpcKIZMhWYuROUT65EWoBoG3SXcREGIW1/2BPcwnK8BH919dnJCnFFDAMlHN6
	 X3n/IBO7g0XJKNDABXPMR2r/Xe7xFBvXWGbp/P1oRwUI05R+bLWfNGLOGuzjX7Pql4m7s
	 BfmRzmbwcz8wWuoJnvPY3vHDkBJdguN1BJHpSJ5Hlu5Q+cBHiAEzL7ntPY5j3g9Q8DcNS
	 w0AaLkCPlwuT0M9IsjGKHUHA8vWQKHsN0nXu5AS0g9gH9o+QIinYiFjGZ+pwH2NyPnrmr
	 fjhttObzJfZR2IXdofIcPkRjR1KOMypH8ZHyUC39oceb7WaZLXKtnTiwo6PsoWMzl6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xe7UoCq1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB97606EE98;
	Sat,  7 Nov 2026 14:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xe7UoCq1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5241F008BC;
	Sat,  7 Nov 2026 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061079;
	bh=NqAWjplcugzPMEPjxjVeW+0Aj+mkar0KxMVBk96mXPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xe7UoCq1Joi1eIKlQU2sh8f9mUWu7P1Ye509/xbQ8Er8058fw34SxfLZtIJYmLY7W
	 liUY8y/JyBf0jr3Msg/YEtf4rzfA+NzOer1hm9+C9+INrBYGmpW3nRPjJylcBbqL85
	 +uJE8gmxlXI9EP8kOYu7emrgmCAVeyXXJE6cuX/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youth Cao <cocoh2os08@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0403/1536] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device
Date: Sat,  7 Nov 2026 08:40:19 -0500
Message-ID: <20261107135008.902430641@linuxfoundation.org>
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

From: Youth Cao <cocoh2os08@gmail.com>

[ Upstream commit 58d97b45f3f43af0afd9c74e8480d22d36fd3f72 ]

I have recently acquired a cheap Apollo Lake-based laptop that uses a
Hynitron CST128-A touchpad controller. While booting from a Debian LiveCD,
the kernel log is flooded with the following error (though the touchpad
works well):

  i2c_hid_acpi i2c-ALPS0001:00: i2c_hid_get_input: incomplete report (27/42405)

The CST128-A was identified via ACPI as ALPS0001:00, and the I2C HID
device ID (0911:5288) was shared with the Hantick 5288.

Add the I2C_HID_QUIRK_BAD_INPUT_SIZE quirk option to the existing Hantick
5288 quirk entry to suppress the kernel log flood.

Signed-off-by: Youth Cao <cocoh2os08@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index be64e30bce9f0..42212ef2aa0f8 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -122,7 +122,7 @@ static const struct i2c_hid_quirks {
 	__u32 quirks;
 } i2c_hid_quirks[] = {
 	{ I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288,
-		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET | I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
-- 
2.53.0



