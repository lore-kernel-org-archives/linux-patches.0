Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037360;
	b=Bf8WitGPpZGJcKhpNknhukw6C+e+dGuIrtltWj7Mzrli+/eytMqXB53QA6mREU/d8Fau
	 4X8A645dIIzDTZgTXYVNupyRw0uPvhpdfw/pw04IqDeq4kJt1sprqsmaa3fR4KQUGjiFO
	 rfhB9WF3TJJmlMtNGJGlb3UKD6p4lg8r/Mj9WAM3lPZ8LyRLsQ3NqP5Tk9KRxXz19tmMn
	 nB1PA9mS/Cs9M/QW9jmivssk6sBB5ZIthmwjd/GIRFQ0XsMaQAA9+8vgLvZnnLPW3+an4
	 LhLksX4ItzYfHBH/6wdxxrki20JrvIaQyXrZ3wZ4kCabbeVfcGZlQe71fWsOi0lvsdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C6h/z4ntlSd8SoXzUcLaOnlAwlPDmF5kdpz6zr2bEYM=;
	b=gFk6zSgIR3kMi8t0TGD3huc0MsIJ1q3FGpvOudb05cf0b3YvmaVAEaDbIK1Od/S7gBaS
	 dsugElNG1Ko3FVrizeRQzf7UTF9AIEd7E735Sca5jW4TnrH26ZCy7xjvJc/GCi5KgJ1Vb
	 5vleM6GWOE3Iu6nxHL3By9MhmOl/8TLagjB8ZUYkbeXibfnZwc8XnLOL5adJUCvXoCRDv
	 SsBxbjIutRmV1PdSVqPwFFluQkW49HeHLh17uVzdc4poDdEJUD5l12e1aPegm23noaWcj
	 YhN49mrwek9HR4LqUnB6k1JCRu0olecZHl1pUFHsj3aPaT9JsR8xjCK/FfydhVF/efA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZihHW9W5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE7660A3812;
	Wed, 18 Nov 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZihHW9W5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694AB1F000C4;
	Wed, 18 Nov 2026 21:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037360;
	bh=C6h/z4ntlSd8SoXzUcLaOnlAwlPDmF5kdpz6zr2bEYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZihHW9W5vUX2MXhOcL2Cw0E6/x99ZHJiQfdBfv3dHvsk2mprFKkwcCb+qxarzdnJY
	 i7EQrcrITKpBP+/Q8KCW3WVvcSIU6kOE+Is9IO6OzOBoE4QDfUQEqjAk9EsDYsnMup
	 yqOxvJcqPCNYJ4dfMRkIIIicFOEnqSwhzxN8JSW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1374/3318] wifi: mt76: mt792x: fix negative errno truncation in offload capability
Date: Wed, 18 Nov 2026 15:33:16 +0100
Message-ID: <20261118150401.731921408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Cong <yicong@kylinos.cn>

[ Upstream commit d0115096429ca090a592770c7645f9553a839954 ]

Returning a negative errno as u8 turned -ENOENT into 0xfe, wrongly
enabling CNM and NAN caps. Return int and default to no caps on error.

Fixes: e8a264ccd2de ("wifi: mt76: mt7921: move init shared code in mt792x-lib module")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Cong <yicong@kylinos.cn>
Link: https://patch.msgid.link/20260824021429.43761-1-cong.yi@linux.dev
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 66806ed4f942d..d990e34cfcd23 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -591,7 +591,7 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(mt792x_init_wiphy);
 
-static u8
+static int
 mt792x_get_offload_capability(struct device *dev, const char *fw_wm)
 {
 	const struct mt76_connac2_fw_trailer *hdr;
@@ -653,13 +653,20 @@ mt792x_get_mac80211_ops(struct device *dev,
 			void *drv_data, u8 *fw_features)
 {
 	struct ieee80211_ops *ops;
+	int ret;
 
 	ops = devm_kmemdup(dev, mac80211_ops, sizeof(struct ieee80211_ops),
 			   GFP_KERNEL);
 	if (!ops)
 		return NULL;
 
-	*fw_features = mt792x_get_offload_capability(dev, drv_data);
+	ret = mt792x_get_offload_capability(dev, drv_data);
+	if (ret < 0) {
+		dev_warn(dev, "failed to read firmware offload caps: %d\n", ret);
+		*fw_features = 0;
+	} else {
+		*fw_features = ret;
+	}
 	if (!(*fw_features & MT792x_FW_CAP_CNM)) {
 		ops->remain_on_channel = NULL;
 		ops->cancel_remain_on_channel = NULL;
-- 
2.53.0



