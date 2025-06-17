Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02E92EE26E;
	Tue, 17 Jun 2025 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177173; cv=none; b=taOMI4wGSp+SaJyPaP+6hO3aNQFGYz6wpix5ouwIuAjiY/9++SwbWHbiaDsrBg4fvwzMTLdk3gf7ObbdFkxtQEEO2ah1R4zW+V64mW4sz5RBNFYQXCDxH9RoEU/kzdBfesp3p51wJeXpGduDSZRk9DCGoLNi5hs/FZfpgJZ0QV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177173; c=relaxed/simple;
	bh=8xS5L3gHDfHeOQI2rTZ85pAxrVk0MX2ALgA6H/tE/EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BScnDXXK7h2aY7A6Y3HZn29kdiqcNHxoAPCUJv6pkIULrQieroTYwbxBhUwxB3ul29l2H+TbkdhqZwha+Vp/xVcI0mG8KzHsxuf4REPQXQWnUMNFLOIPCip/llPYPycu11JYK2kRe+H/CYOjK/OuzonuHOIH+Jm+H7+OPpygcWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIKnlMlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIKnlMlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A10C4CEE3;
	Tue, 17 Jun 2025 16:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177172;
	bh=8xS5L3gHDfHeOQI2rTZ85pAxrVk0MX2ALgA6H/tE/EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIKnlMlRwha2J1hJmaw8amaktI09uWrXpMRqjrlfMNHc/SfNsDMxE/t/GvwSmRoUk
	 vT8Mk/bFhWYJf4eF55TQ+L+21xiALnn5ZGBoHuiwwNNjnpPkAP4vor4GHw53IREY9f
	 3zmMA7V7sxKfRVSnwyrQ5+hxt7sKPZWqSJ84+XVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Reyes <zohrlaffz@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 268/780] wifi: rtw89: pci: enlarge retry times of RX tag to 1000
Date: Tue, 17 Jun 2025 17:19:36 +0200
Message-ID: <20250617152502.379650689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit dda27a47c036d981ec664ac57e044a21035ffe12 ]

RX tag is sequence number to ensure RX DMA is complete. On platform
Gigabyte X870 AORUS ELITE WIFI7, sometimes it needs longer retry times
to complete RX DMA, or driver throws warnings and connection drops:

  rtw89_8922ae 0000:07:00.0: failed to update 162 RXBD info: -11
  rtw89_8922ae 0000:07:00.0: failed to update 163 RXBD info: -11
  rtw89_8922ae 0000:07:00.0: failed to update 32 RXBD info: -11
  rtw89_8922ae 0000:07:00.0: failed to release TX skbs

Fixes: 0bc7d1d4e63c ("wifi: rtw89: pci: validate RX tag for RXQ and RPQ")
Reported-by: Samuel Reyes <zohrlaffz@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/f4355539f3ac46bbaf9c586d059a8cbb@realtek.com/T/#t
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250509013433.7573-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index b5cdc18f802a9..064f6a9401073 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -228,7 +228,7 @@ int rtw89_pci_sync_skb_for_device_and_validate_rx_info(struct rtw89_dev *rtwdev,
 						       struct sk_buff *skb)
 {
 	struct rtw89_pci_rx_info *rx_info = RTW89_PCI_RX_SKB_CB(skb);
-	int rx_tag_retry = 100;
+	int rx_tag_retry = 1000;
 	int ret;
 
 	do {
-- 
2.39.5



