Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C6F1D0434;
	Wed,  2 Oct 2024 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875495; cv=none; b=pQt9GKVgqn16L0Rj48SMq6oCll1iBYw5gLYso+wvzjLxywoLocwIGEh0mgRN2rM2nXtRoY8DAoJC69oakmHpBsCjDeSyZGYF2+R2S/5Pn70SFS2tOZK2Pmhjbv5Su1y02V/hrXgnUEHXD63uOwRDD9+ZP0doPGyem/OBXlX7AhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875495; c=relaxed/simple;
	bh=nhBw3JTQ03+rmlFxGHWsBrZN0rF4COyaSFgijjQkus8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBzzGQdG5fmnW9S64a87Xto2RsdghoCXq+VKZ9okU5ocwTdW/VpM3NtdKpLYTpVLo6ts8KPOAq4Uw39YIuvSVZm6tfYrsseWvcWbxiE76h1LBv02M20ATQGKtkYKnWdsMovmrWfpGVSSlrlGAVOSIDI8SOs1cJJ8HJAY3sT0IXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFo15Swr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFo15Swr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C47AC4CEC5;
	Wed,  2 Oct 2024 13:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875494;
	bh=nhBw3JTQ03+rmlFxGHWsBrZN0rF4COyaSFgijjQkus8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFo15SwrEysTGMcz3g+dPdW/Tp2JMb5TGrmpaTVcqKh0VYkGiGP4WxruOEql57yZU
	 tur6r9uwC52zuaqJoZlrpUnqTye+mY9qoVRArlQ+Y9NB/qtdYaRXKcPqQThdshaqbc
	 7HKb2FTTN52X2CLoQboExVBF5Awe3Fx5tndPyjyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 088/695] wifi: mt76: mt7603: fix mixed declarations and code
Date: Wed,  2 Oct 2024 14:51:26 +0200
Message-ID: <20241002125825.993048846@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9b8d932053b8b45d650360b36f701cf0f9b6470e ]

Move the qid variable declaration further up

Fixes: b473c0e47f04 ("wifi: mt76: mt7603: fix tx queue of loopback packets")
Link: https://patch.msgid.link/20240827093011.18621-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index ea017f22fff22..863e5770df51d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -29,7 +29,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	struct ieee80211_sta *sta;
 	struct mt7603_sta *msta;
 	struct mt76_wcid *wcid;
-	u8 tid = 0, hwq = 0;
+	u8 qid, tid = 0, hwq = 0;
 	void *priv;
 	int idx;
 	u32 val;
@@ -57,7 +57,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		tid = *ieee80211_get_qos_ctl(hdr) &
 			 IEEE80211_QOS_CTL_TAG1D_MASK;
-		u8 qid = tid_to_ac[tid];
+		qid = tid_to_ac[tid];
 		hwq = wmm_queue_map[qid];
 		skb_set_queue_mapping(skb, qid);
 	} else if (ieee80211_is_data(hdr->frame_control)) {
-- 
2.43.0



