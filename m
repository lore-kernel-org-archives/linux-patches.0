Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7943232;
	Wed,  2 Oct 2024 14:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878850; cv=none; b=vGrlzaW5BlrZ5yeY6aURX0WgEPdmzRi+86FpmSFOv2Q6wshwdfh+I3rtkHB9T7v8fK6c16e5vtakhDELWFLKo6qk7CGIXJo3NlaDrxKK/ccR6+ynuC+wutz8yHS2hpiF4PvRNBH6TTreQ8+GmktFSbulkJeLm7QKVx1QCoeesCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878850; c=relaxed/simple;
	bh=uuRDCimW1atwgO281iUCuT/PoGDiE2ikmi3ZsemqhmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH7wBoMxptxcUxbzTr+NAoJcfojuwQQWFSGCk1bXAS0lA7rVhdApl7TS6EiS7aVq32MbaFBqo0QHWoNHIrp+DpLCwoGpQGSToHPEbDRUbcMrgDw6BgUMyeM/r6HxsB58EnavniVAC+jRGt9+3Pa9Sx6B94VkI/ZbacxRtBgL4hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqxUW0j0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqxUW0j0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612A3C4CEC5;
	Wed,  2 Oct 2024 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878849;
	bh=uuRDCimW1atwgO281iUCuT/PoGDiE2ikmi3ZsemqhmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqxUW0j0SSLs+a4dPNe7/0UtpFMATvZf0ko2zI1cXkW89ZtkDFUga2PLsRw2djxBL
	 8GFWiic9JrPIE0Bvj8ep05+O61P8IXLg0ZHu0UxAnerD9KL4IuI1s83CpeW45OPtXR
	 YyHnluSsBRpJjNjZOdDFg5JHolfv5Yl8vc6zmqUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Fiona Klute <fiona.klute@gmx.de>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.10 554/634] wifi: rtw88: 8703b: Fix reported RX band width
Date: Wed,  2 Oct 2024 15:00:54 +0200
Message-ID: <20241002125832.979891636@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 0129e5ff2842450f1426e312b5e580c0814e0de3 upstream.

The definition of GET_RX_DESC_BW is incorrect. Fix it according to the
GET_RX_STATUS_DESC_BW_8703B macro from the official driver.

Tested only with RTL8812AU, which uses the same bits.

Cc: stable@vger.kernel.org
Fixes: 9bb762b3a957 ("wifi: rtw88: Add definitions for 8703b chip")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Tested-by: Fiona Klute <fiona.klute@gmx.de>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/1cfed9d5-4304-4b96-84c5-c347f59fedb9@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.h b/drivers/net/wireless/realtek/rtw88/rx.h
index d3668c4efc24..8a072dd3d73c 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.h
+++ b/drivers/net/wireless/realtek/rtw88/rx.h
@@ -41,7 +41,7 @@ enum rtw_rx_desc_enc {
 #define GET_RX_DESC_TSFL(rxdesc)                                               \
 	le32_get_bits(*((__le32 *)(rxdesc) + 0x05), GENMASK(31, 0))
 #define GET_RX_DESC_BW(rxdesc)                                                 \
-	(le32_get_bits(*((__le32 *)(rxdesc) + 0x04), GENMASK(31, 24)))
+	(le32_get_bits(*((__le32 *)(rxdesc) + 0x04), GENMASK(5, 4)))
 
 void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		  struct sk_buff *skb);
-- 
2.46.2



