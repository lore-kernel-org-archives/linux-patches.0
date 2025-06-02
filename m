Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AD222259A;
	Mon,  2 Jun 2025 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874861; cv=none; b=Hyx0U3CE4sAZqpOMtbWF2WUOjumCQ0pKiuYlFEfaKx5INzUOg/0Z3BlaNT4qgGNmLlix01ONsA+vOsFLLHxq84AcIC/b5mvoKZveeNZV1R/zOTCQwb1xly5qS95VeHyCqjxDWJMf1/b9X8R7wsSKLDmMWkAE08F94Y/GQ/oErkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874861; c=relaxed/simple;
	bh=Y9SUu7yuj84pqayxDy40huYVHRmDKAZ3b5I3z6ONlKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWAcVD9XgicgRYg89dprmq1TzpzaTaN1+qQCs0v89UQA24lna4C08xu14C7mZ5cRSADRvusKDJM0+wTtLKY3cbjuExQiuwN4T+NN00mOv+XVzbEVE62JeX3t3oUw7wzf5PXjYVlu21ojWu02r6QkxxhL305adL0rbTj1eZhkaHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAtGm4x8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAtGm4x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2F7C4CEEB;
	Mon,  2 Jun 2025 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874861;
	bh=Y9SUu7yuj84pqayxDy40huYVHRmDKAZ3b5I3z6ONlKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAtGm4x8XWZZIcyEMDZegvqwSfpMPOki22l/XqM03V7e4BIiW99IWQmUbzBOPYqND
	 /czLQ9Fjq0ThQjNUMw71v38MK5zag9QZ1fiv1SN6nMrPiEk4vnWA7TFywRlMQk1XGR
	 E7mmpz3hILGbqFFyKAcD5t9zeSmPt11MDPz7g2QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junan <junan76@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/204] HID: usbkbd: Fix the bit shift number for LED_KANA
Date: Mon,  2 Jun 2025 15:48:12 +0200
Message-ID: <20250602134301.903762061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



