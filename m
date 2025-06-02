Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471B6230D1E;
	Mon,  2 Jun 2025 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873900; cv=none; b=ueQrESuIqdqnXDppWjDJVVslV3lpdZXiQw936kOg6JT9yoYcJGqjUKjRxrITJ3/vv02F6UbHMvEUyesHERGM7Cb2TTioHyJfEY4mXhSB15QltH/v9pj+s0Z5HNooFX8UNVDvGEC3i0FWWOIF3J9VtJRG+1Uh7uzywXujraQXiZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873900; c=relaxed/simple;
	bh=bIYTQ3lZyyJh6FdXEgRk9u9MeSWvcasplVFNwyd7lHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4EiUjpISN4pYkZi5CHU04isrFwjXx2ICc5VA1LejN9zVTDs7s6Nn3CXCFMdujV2sXxBL4esGDlzZVMt/UMIFX1aG7qizuHABKk6xBYSQzrVcNdtklb3XmUU2g/jADMkr27UYCU6jxxaR2vB3cD9bxe43lTJl/2GEsF0bWKcMxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yq96wA4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yq96wA4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF650C4CEEB;
	Mon,  2 Jun 2025 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873900;
	bh=bIYTQ3lZyyJh6FdXEgRk9u9MeSWvcasplVFNwyd7lHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yq96wA4bwrvnslsok5jeBVIvYQvfSwMaGFM1O1SywZTVAliKwLn3OFsTkloWt0KAh
	 D02UFC/maPw1l5CjPCGxONqQLOHqYHTodtCv1hkTf8TtfKXvjqhl420C5FyikNEFOY
	 vkrae6JChiHML22qHEGzsjKIVoDn8hx+S84G2Ins=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junan <junan76@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/444] HID: usbkbd: Fix the bit shift number for LED_KANA
Date: Mon,  2 Jun 2025 15:45:54 +0200
Message-ID: <20250602134352.727697365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



