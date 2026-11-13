Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590122;
	b=dmaD8EAUPn1FEsAZDt6HAcKBJy0nOpEDR+EIU177F2B9PqpOk4AELYqZ5yu1T2fFJC0x
	 6WvV2jVuR0PYupvNGebzAq/NKGF12eYaOdM5F+iHeH2ga0jlRGMGRVGWBPVKELEAgJE5P
	 0n2gLQONP2dFJMwV8dT3KVO14sKZr5T9zX4twenlIXfLPN0Rz/gSGvivSq+Tti8SH33a0
	 PvLnq4taw0tmTGmLVh8mszVU9MVp7SAERhPjkRtKKVk+akUyK23x/Vl3fIMQCMMYFspSB
	 fdpIRJf+Uv6qRDpKhlANby7NQFfsopNZBA/ikfLvvX6UkL2GA4QfXsahtiZM1CHs84A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wv+5rBgJNtAGxiz8okwskAsVd/vc1cVUNYdic792Ves=;
	b=IRviKaSeHW2g5xlAE9RYxiGX5CtNsqWq01suRvLRSeeNqxfzUP8jAPuolxUkQBjUdvsE
	 P4CPMTYaiO0hzycqp+sLAMfyKWCL5NFV1+fMpQw5MRUHX3qTlLlrdwvu9yDxuhZdT80GN
	 qqEPYFV/GLF6WA3nWgEuy2W6jtOqgNi6E7KrBlPpLZb2CrbAQnRLs22ZaIHlqY1C84VQM
	 5xRnF3I/Ik7UX/z68NqulLhZ2RP2tZ4JgYpxomYCgWqnTrKHoh9Ec7cF0db+KJ/RVhvA5
	 fqu5TD7VrZoqGACflln+eGMbVO5UD5kQ1jAtEpI9eyODidGz8FRTm3/f7thfpvC02FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE4JPDu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CE1606B237;
	Fri, 13 Nov 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE4JPDu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E6C1F000C6;
	Fri, 13 Nov 2026 17:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590121;
	bh=wv+5rBgJNtAGxiz8okwskAsVd/vc1cVUNYdic792Ves=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vE4JPDu7q2akVut24SyYyo/a7BmTjTy41iK7KFR2ZSeeZ+cNPrDaYBsgED31OCp+x
	 Z4w2LkTN53DmdHunpCXq99QRGQeRpPgwyOvFLaop1jmTXebpNqiHIOzSgdDjnhglW+
	 OA+1kFKxmkfs81sC+X4V+vYhO+IT6vC/QJuX1Q0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/686] wifi: mt76: mt792x: fix negative errno truncation in offload capability
Date: Fri, 13 Nov 2026 10:43:51 -0500
Message-ID: <20261113153824.183575355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 96c50a501c1a9..d00807075c71f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -704,7 +704,7 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(mt792x_init_wiphy);
 
-static u8
+static int
 mt792x_get_offload_capability(struct device *dev, const char *fw_wm)
 {
 	const struct mt76_connac2_fw_trailer *hdr;
@@ -766,13 +766,20 @@ mt792x_get_mac80211_ops(struct device *dev,
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



