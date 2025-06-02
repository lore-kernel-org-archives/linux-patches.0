Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6220B2248B0;
	Mon,  2 Jun 2025 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875709; cv=none; b=IfOm9UJhyjSgE8BZrhz9g/Q89AY897g4b3EhY/sDu9tW/7AWNE7Rvkc815958S9Rem22hYSnw2w3d/v6aF4ORC0Vlm9v5KPWrqe5Dcaaga+BaJH4bpttioRgBt667p1h0PlwgcYeXJl55gSylmrT8+mqd9KjqPoe7b1sXX2At30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875709; c=relaxed/simple;
	bh=QX3OBupqeYvPOWrjGnFwzHwLoBwfed58MPqvYYSiyf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz8mAT1ec2xHxW3UWni5AO4J7ekZV1a7TjWtoG7HYg4R+VlgxZ2PEXCJ4QyunjnsktA5KbNvw/00SB9CKk1rvgjqDYsrzZQBw7vhl5IlQXqSPd1b2wRcw78z4exQ4jHzE+RzHXfJJA9JPFGMxY1N+BQVMLi78iL1lGQd+mPk7do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laj5Ewpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laj5Ewpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE16C4CEEB;
	Mon,  2 Jun 2025 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875709;
	bh=QX3OBupqeYvPOWrjGnFwzHwLoBwfed58MPqvYYSiyf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laj5Ewpr+4BMSzFr1W/PPBp5rpdVKreeCUegTBT0DXVgXQr0AGhgo1PMg/0RxZV32
	 srEPRV5QsEdHP2jH5xsmxRonB0o4HvEGJor7NGYcnpcR0erV9PPsplsckQqBC5N7yN
	 qOuzhFo6XAzr1aVTi6Js1ZV6+mSaw0yUwq4s2dm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junan <junan76@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/270] HID: usbkbd: Fix the bit shift number for LED_KANA
Date: Mon,  2 Jun 2025 15:48:24 +0200
Message-ID: <20250602134316.136571493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d5b7a696a68c5..50c5b204bf04c 100644
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



