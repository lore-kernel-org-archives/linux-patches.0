Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE31A83E8;
	Mon,  2 Jun 2025 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876335; cv=none; b=V0eoHysNyLD28sC3/ySjh7Dn9at1A7VMc3xwDgRbTv71EK7Fw9Y8pIvHrSxNmx/5vVB/qUO+S2v1DMHkvqvcIt0a4VjuqhFyoyNlmpP90blEiAofLxFKrsHhv6vY0pPPMAvCKQrZDkGqKzxxN7lbj/3GNkV0UfeA4sIgRIdG4zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876335; c=relaxed/simple;
	bh=+DIaJa9dpr9kdIA7FkpsD5vw1fHP3FfEN6Cbbegj9dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exVdH4PgNVRyD4V1FZlce7hsqOHHoRrdoupkGkk24HZLREEUeZ4zTIFJmVt5zuV1RpX5qU6us04n3R+dFmwWuc/2OKfXNGO+p+/lqrYNelMh1TMHdMej51zf/ZoaJYwyW2Pj7tK0GNgbpSwmc7kENv19Cg+CHKjjyJJfV2m4cy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grNHSD1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grNHSD1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3C4C4CEEB;
	Mon,  2 Jun 2025 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876335;
	bh=+DIaJa9dpr9kdIA7FkpsD5vw1fHP3FfEN6Cbbegj9dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grNHSD1hk0z8/tEdYucPgXo7GVlX0Cdh/5Glt+6uHILLSwCxOW67/apvSnbm2UCEh
	 WlC8zUynV0ro5Nt850bpufTrweW6Ek9/6kOWEbeWnvF7DVye/Q3twc1x9Wd9AIHmLE
	 fQjGq4HRAMZjKwJinqjIUuWpLLCqRbu4qr3T9MQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junan <junan76@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/207] HID: usbkbd: Fix the bit shift number for LED_KANA
Date: Mon,  2 Jun 2025 15:48:36 +0200
Message-ID: <20250602134304.363309269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index df02002066cef..1d94d246f8162 100644
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



