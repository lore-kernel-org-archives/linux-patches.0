Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348F14A088;
	Wed,  5 Feb 2025 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765593; cv=none; b=M2pdEQRwwvDECdTnc1PFs3Nrz06BWG8eGVRTGZGNPCELq7vBiDSKdgbUJf2qyD8Me0vJuxNmt4zOVsXKpZveSxzwvd2spwsuUw04DqYkLNcEbPaUeRcldo9wN5pEDix7jSxF8kUPnaNhP47YVp4X5OpWKrc0F2qfHR61ykmlZio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765593; c=relaxed/simple;
	bh=41meWPEb3gazLUKh0/Ymaizl3H8HvI1FDLhM6Rq8zbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAXBJvoLLHwxvrndzvhMFY5E5NPskaArlmGaA31GbwJp22UccCU6pL1hxu8Yh73WuFjR+hHm6y1OY38piRy2z6SSH6PHGhSbJtca/7Lsxwy9GJYWgT0I2M68npGwL0+GYzfNLlAWljADTCuzX8DwUNh1/AAdBDJcwUhTtYhOPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpYgbDIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpYgbDIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F02C4CED1;
	Wed,  5 Feb 2025 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765593;
	bh=41meWPEb3gazLUKh0/Ymaizl3H8HvI1FDLhM6Rq8zbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpYgbDIOYO4ft+66pPgJ4SNrOGwUSdjrxKqG9TnYf3/HfWJsb/qBlic/M588FsfEO
	 shdbk93E04VmRdqvUSWA90DJPDNYqk72oiPLwgy3+hxiISMh2+MpKwW+3PEiKgT1v8
	 5ON2YqCRCQ98gd/h4hgtYfFosMvAgaROy3mGtXLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 196/623] wifi: mt76: mt7925: Update mt792x_rx_get_wcid for per-link STA
Date: Wed,  5 Feb 2025 14:38:58 +0100
Message-ID: <20250205134503.732744744@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 90c10286b176421068b136da51ed83059a68e322 ]

Update mt792x_rx_get_wcid to support per-link STA.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-11-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
index 106273935b267..05978d9c7b916 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
@@ -153,7 +153,7 @@ struct mt76_wcid *mt792x_rx_get_wcid(struct mt792x_dev *dev, u16 idx,
 		return NULL;
 
 	link = container_of(wcid, struct mt792x_link_sta, wcid);
-	sta = container_of(link, struct mt792x_sta, deflink);
+	sta = link->sta;
 	if (!sta->vif)
 		return NULL;
 
-- 
2.39.5



