Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4521A83E8;
	Mon,  2 Jun 2025 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877266; cv=none; b=sxaEj2R3tlZK0/1DJ0NTT0h1pX/AFnb99iXk9dohEt22bSXtdR/LxJhM7WA0DI/n4HZLtjNm2vr2QDsdquDn1eVy9hAmhYH6ypqgTAl6Ut7U0Q5EQjTjJzca6qYskMSX3M5XtMwbnlfByjErkSTOijKzC7bpsiHNamvR6wpDjeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877266; c=relaxed/simple;
	bh=hQ/EcjyK5k+AhsFCsqwMjnVitDpyK8bfsY1AJZpIGPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqZfNDIILsrTw8x8hLujUoaRlMM1bvpgTyKu8VpjbQtuCK7PakBQsPy66O0E0yL1+GuMkvKTRnaxWI7m9O74kQxaiX2uNYx4Ze70JfQpOL1cw1ynFErLG/zMWSJ+Z4evbZuh9eb22mFYCOJlrQ55OLIcXI0Equ3N7+HAcDXZoh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHS9a4AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHS9a4AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29611C4CEF0;
	Mon,  2 Jun 2025 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877266;
	bh=hQ/EcjyK5k+AhsFCsqwMjnVitDpyK8bfsY1AJZpIGPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHS9a4ABDVFnM/6UpmqFEfiMfbPB+Nfl7MwpIAEvdC+Dp2t3adZ7zTDlCWEM7i5fp
	 Da6TjT/bWPrlLfyRtLAmtTvqHGnk522NBLpXgAqCksmLMm58H0U7mDfhkY9Dp8JtLt
	 olktqAXRqdqfO/GjQOqeoYkF307GZxoaD10CnH1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junan <junan76@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/325] HID: usbkbd: Fix the bit shift number for LED_KANA
Date: Mon,  2 Jun 2025 15:48:02 +0200
Message-ID: <20250602134328.159271566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



