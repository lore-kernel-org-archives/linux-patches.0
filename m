Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B2427FB02;
	Tue, 27 May 2025 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368147; cv=none; b=PMswgQT3JDacJmemBYiaq3t75ZD2CKF91hfd6RWNLSlw+uhjpP51IlvG6IG2vXKB/2VigcMVnL0YSFr/b+ktYlLmpEtm2Lo3jhr0VhjaBNH8fuFc2UXextt/hBfZW62Ht0q+0+m+LWFmqaTjnaDnjFjEkK6eq+eWnz8D08SL+mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368147; c=relaxed/simple;
	bh=IIhPItedbhw3AA0Rx+oaB6L5X/yBdC11WFvfDdA02m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqaM6rr/8KFL08Ofpk1BWPWxN0HqkwWwvswizueEzdZES/GYW6dRCJy2yQBZgQkQBkfQnIRM5lLLxeroocVh4pJQDUH+n3pYqsjC9vQqRZ5RCZjW64StdGLEdYC8H/dc5v8fWEYykPQDvpzlPDQxJux8gsJfOFdRzf4TMlDRfWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gk8wQgJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gk8wQgJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1625BC4CEE9;
	Tue, 27 May 2025 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368147;
	bh=IIhPItedbhw3AA0Rx+oaB6L5X/yBdC11WFvfDdA02m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk8wQgJDL/JRPopK92nFp4n6Tp4Ni0QlDgJEn74evT6tc82nE+WgF+o52STB54UWF
	 03AT+gC4aCGqCppg0dKPfTctQzmNRhMsSEKYtKtC3SGEB/Zldp10VL5ZWFsHedfCmg
	 EfAukq7rrz7Dv1u2J1ZLhPrQJD0yTnOACW+Y9Vhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junan <junan76@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 583/783] HID: usbkbd: Fix the bit shift number for LED_KANA
Date: Tue, 27 May 2025 18:26:20 +0200
Message-ID: <20250527162536.887460223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: junan <junan76@163.com>

[ Upstream commit d73a4bfa2881a6859b384b75a414c33d4898b055 ]

Since "LED_KANA" was defined as "0x04", the shift number should be "4".

Signed-off-by: junan <junan76@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/usbkbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index c439ed2f16dbc..af6bc76dbf649 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -160,7 +160,7 @@ static int usb_kbd_event(struct input_dev *dev, unsigned int type,
 		return -1;
 
 	spin_lock_irqsave(&kbd->leds_lock, flags);
-	kbd->newleds = (!!test_bit(LED_KANA,    dev->led) << 3) | (!!test_bit(LED_COMPOSE, dev->led) << 3) |
+	kbd->newleds = (!!test_bit(LED_KANA,    dev->led) << 4) | (!!test_bit(LED_COMPOSE, dev->led) << 3) |
 		       (!!test_bit(LED_SCROLLL, dev->led) << 2) | (!!test_bit(LED_CAPSL,   dev->led) << 1) |
 		       (!!test_bit(LED_NUML,    dev->led));
 
-- 
2.39.5



