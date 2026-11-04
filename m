Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831042;
	b=S7jeGOq90najkBXw+fa1zqdmsStZbd8L58ClhC2+m6jI0PTTcVWrVU/paIGbRKPGrUCO
	 +5VwsKAPfKnOK5e6G1SyfdbWxtQTn/KEGhjpB3GFURqHBCTy/IPsUqCrLbApWHhRwnk+s
	 JtD8gnEC0BgyfwKOe6tJbXekbCcCz0aLWdvMGyT28yUEcdZI6oFeDUcsnMX42POwJj0Wn
	 XZ8EZOA+9FfQltbZ5FIf2AdXSB1kuLGqXW/RCaxPS/LrTylsKlZsCcs3tHesUz1OgeCeI
	 cz6GCUslqULm5w7jY+yR85ErhqaqaHDwea8SJR2ruDoIeK/Y5KvRTp3zT5+44nkFYJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4+Dr5C2NRh/AgyPfc5nP8rxY5oyeJIxLACB8sUAStOg=;
	b=5KNJIOf7mkddDg+O8FuaXY0VnYuQF8xWMWhKZ53Cdn+rui6pJSP0flJsUvJFeKvOYqgW
	 w6YZ/+LcjwvjH3ZgVFkyr7x/C6tXb0n/fAoAzmtAJG3EwcWsxH/08c//cpcpKdRnIk61n
	 fDa6eT0fnYp/d2TKIMy7+CW7AFg9OPJ1Xv0JSbVfiuKjbbGPHFFi/zHzEDCqm7EUZf5+7
	 4dZtKu6/DUeb49OwpHch7o7uIEDNs62YIyxjCiz0oYtbJVIflTj4AMosloa+EiuraEdie
	 LF3wJKcz2pxwx3RlSTDvi6Muw9besB53ozDxPzzkGS2cem/v9yqlUaJYm/QTFJ6HhzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stEC4haE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBA7606A864;
	Wed,  4 Nov 2026 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stEC4haE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D091F00919;
	Wed,  4 Nov 2026 22:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831042;
	bh=4+Dr5C2NRh/AgyPfc5nP8rxY5oyeJIxLACB8sUAStOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stEC4haENrjLEHZC+f9ja6G/UsbFDVF7sRLjHOfcV+uJGx6nijjAxx9tmliTUjRy0
	 5gEkaYLl/VudowPfZdq3DlPoCBsa4UlNVLOMB2S/rAv1ZrgehG9gtPbFvaihQBkJkq
	 twCsSkWfaS83JljiEib6qEPcYy86LJpuRvz82S1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youth Cao <cocoh2os08@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0476/1005] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device
Date: Wed,  4 Nov 2026 16:03:29 -0500
Message-ID: <20261104211057.331819575@linuxfoundation.org>
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
index 29c4f624f3c5c..e5a4c7deba502 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -123,7 +123,7 @@ static const struct i2c_hid_quirks {
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



