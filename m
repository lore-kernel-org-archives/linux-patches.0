Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FA5139579;
	Tue, 27 May 2025 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365722; cv=none; b=To9alC430n7FYSdYIxp0USIk0dea1vm/ex2PpCmdatdiOElGPp0bW4QP98Dst52iGLvI22whe24v2HhjxJBpvBc7M4kt3iOWqjrho9aP7OdfKSMk2Nl92oIWVY1ktNHZgCH9wcQXkmgjdsmpITiwa1f1X/0cxAIzPn6CQYmzpzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365722; c=relaxed/simple;
	bh=K/97MLZ/z4h7YKGw2TitaIEVtCA7G8KBPKfw0nIpTyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W19Yzt4uPFpAMEOmxLW9kE/QFhRf6Pb0BygPHp88ApqrSOqK+pFIBtIaUQ+ocQXxvQ7i9SVnlfqx1FUh7mEWtGcNyypNZVxq750XDhYjDOcIfLFtfPdAV44DVdi2o21oJ4sCsU33jKr9w3jzGHHtpkFDXOoqqp91bXSpip03tjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFY92JlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFY92JlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D484AC4CEE9;
	Tue, 27 May 2025 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365721;
	bh=K/97MLZ/z4h7YKGw2TitaIEVtCA7G8KBPKfw0nIpTyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFY92JlQSh4onnwcagmFKMu0etJUu88ujp/+S99+q6ojkajIEzeOEajqBPZp9xHAn
	 pwrcDY6dKxw1dUvjpk5G8HeLwwm2hIDNqNPD8B79x59GBAAvVaUAUt5XAh1vtCvF8E
	 Y03vwJmgDXSrDgt+djyUA4IBqRRaaOwLnGRQSw0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	junan <junan76@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 467/626] HID: usbkbd: Fix the bit shift number for LED_KANA
Date: Tue, 27 May 2025 18:26:00 +0200
Message-ID: <20250527162503.974050548@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



