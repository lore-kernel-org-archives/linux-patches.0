Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C18D2E54A8;
	Tue, 15 Jul 2025 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586870; cv=none; b=u51BABgUh46UJeGDiSSVJkLtQFebr8p6qwE9/b255sDpvUAhL28aOkNsdb93uqk4tvLzP5RX6qMvzkE2RRNMPRXm4EgfRuY2eNBvcel4WXMl1DhpjRTgeXmtNJTi3hDyZ9Fd7x7T5aa63Cnm9N7tTGlnpwlf/p9Fa7gqVdG+bVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586870; c=relaxed/simple;
	bh=zSsfcGP9v2gEF70RTpNS8td+buZxG4usFIjyNXj8NnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIlcXYy7uES/9WKkyxNpzw/oayYtP5wsS2RrH2awMdTKvz8Aro1MCK86CfSXpyF3bAYg7+B0RAKGXC85ZZHmN3oMMBbdlZpwdo72dB2iLCDEi4VZQsZC3eTQqq7aVDtERYYSApcNMoNiC+OqReGMg04B7Iq/B33MUGr2qpHqoPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ee46FZa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ee46FZa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C553CC4CEE3;
	Tue, 15 Jul 2025 13:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586870;
	bh=zSsfcGP9v2gEF70RTpNS8td+buZxG4usFIjyNXj8NnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ee46FZa+FORMZF7KbLRLVO4o3EYbghA9TzXZ5hHGeUQg2mkfQiQq1FakGTQilBn3l
	 3gcPQxBfk/RwUyR6+I2tF1XZyeOuKR4aNIqHVBlshQ6157KINFKE1mFmcBQVe9tfUJ
	 UTaWjGwalc+lxcJLvIuSizKonEaaWiAllomiRpO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.15 079/192] wifi: mt76: mt7925: fix the wrong config for tx interrupt
Date: Tue, 15 Jul 2025 15:12:54 +0200
Message-ID: <20250715130818.095643222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit d20de55332e92f9e614c34783c00bb6ce2fec067 upstream.

MT_INT_TX_DONE_MCU_WM may cause tx interrupt to be mishandled
during a reset failure, leading to the reset process failing.
By using MT_INT_TX_DONE_MCU instead of MT_INT_TX_DONE_MCU_WM,
the handling of tx interrupt is improved.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250612060931.135635-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -58,7 +58,7 @@
 
 #define MT_INT_TX_DONE_MCU		(MT_INT_TX_DONE_MCU_WM |	\
 					 MT_INT_TX_DONE_FWDL)
-#define MT_INT_TX_DONE_ALL		(MT_INT_TX_DONE_MCU_WM |	\
+#define MT_INT_TX_DONE_ALL		(MT_INT_TX_DONE_MCU |	\
 					 MT_INT_TX_DONE_BAND0 |	\
 					GENMASK(18, 4))
 


