Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018952;
	b=b/Khgt5azwTeljCLuVRbfU3ivHfMe4A2tM9d29wijxKgS4luLexQlM8j8c4OupvZyE29
	 JGTvQEjEa3YCUF8faA6Ft1ductcDm5YtBL/T2Cqqe2d6TEaZQ6eYBezTGz1wW1jJIuLM7
	 qk3pJXkeNxRDDYpmivcTP+PfcuedSEFLfYSItgyG5OphbAt1BnaaqlZbVnJ8JvYoJTZCL
	 AhYT1kgfdq2FqtD6PXnPo2Lzbr9DA7O2qMqy6ba20LoHxuB+r0LEzGQXRv1koMwYUe/+0
	 q3LjYQprKjhTMaKBLjq+sv1tqSWRp3S8urnLOJikeEnUnE2DJ6TyG/bvhuol4Ysa26A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nKZrjVOHU6H4qGLYKV7tq8sYSSHGtdh5/qwWqATenlo=;
	b=tWn7GGM6ph5mq1nbxp9H/IBIaWyQxKFjNigMGgwmJ8R7LaW3eAfAnLIQj3EDWpxUsNRd
	 E7+QlF+o7nSSlMjfrMYZ1CZRzrmWRmgdpTRJtTNvYJsTvqSrnC8qapObXObxuq28aosgT
	 b3+DiKrmdtJKhYYT9MQedAgDGZ9dxpvegLGypviWKjKR/kkjV+PqdmwFz93u2HDWh5VTX
	 IFWXohoSgKqgTBU2BwROaHjVYkJgnraa7skOLVYv3G3O2vl1lR5NWpzxbZOrThEO6BU2P
	 DFasaJIj8pGwCCIFjG5gktBpjTG/HfYNBLZS7aNA//zGQwlUxAyLmTQdCSkjO1kWiuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVIVtmM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4231B606A31C;
	Wed, 18 Nov 2026 16:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVIVtmM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2C51F000C4;
	Wed, 18 Nov 2026 16:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018952;
	bh=nKZrjVOHU6H4qGLYKV7tq8sYSSHGtdh5/qwWqATenlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVIVtmM20i9n70Hk+DxAK5XnHdmqX+nAIb64bN3jcy8XOvkMf7al334Yxmc9iWFch
	 YtBlMKjYNHcunVI5bfiQlQcZ0NcN6795P1jWr0osTiT1SZ3iwnHaJLvCL3Mg+mwdJf
	 n6UQN+X7H0//oPXbJP86yL0B5gl+OomYDDhBixqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1422/2651] wifi: mt76: mt7925: drop unused NAN 2.4/5 GHz support config
Date: Wed, 18 Nov 2026 15:44:22 +0100
Message-ID: <20261118150339.245779816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stella Liu <yu-ching.liu@mediatek.com>

[ Upstream commit f87a9e7f49495e822e41828421ce51550e752dce ]

The config_support_5g/support_5g_val and config_2dot4g_support/
support_2dot4g_val fields in the NAN enable request are not used by the
firmware, so stop setting them and drop mt7925_nan_set_2g_support().

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-6-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 36de42193190e..c3a9a592dddf3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -32,8 +32,6 @@ static void mt7925_nan_set_5g_channel(struct mt792x_dev *dev,
 	if (!mt7925_regd_is_valid_channel(dev, NL80211_BAND_5GHZ, chan))
 		return;
 
-	req->config_support_5g = 1;
-	req->support_5g_val = 1;
 	req->config_5g_channel = 1;
 
 	if (chan->hw_value == NAN_5G_LOW_DISC_CHANNEL)
@@ -44,16 +42,6 @@ static void mt7925_nan_set_5g_channel(struct mt792x_dev *dev,
 	req->channel_5g_val = cpu_to_le32(ch5g);
 }
 
-static void mt7925_nan_set_2g_support(struct mt7925_nan_enable_req_tlv *req,
-				      struct cfg80211_nan_conf *conf)
-{
-	if (!conf->band_cfgs[NL80211_BAND_2GHZ].chan)
-		return;
-
-	req->config_2dot4g_support = 1;
-	req->support_2dot4g_val = 1;
-}
-
 static void mt7925_nan_set_cluster_id(struct mt7925_nan_enable_req_tlv *req,
 				      const u8 *cluster_id)
 {
@@ -172,7 +160,6 @@ int mt7925_nan_enable(struct ieee80211_vif *vif,
 
 	p_nan_req_tlv->master_pref = conf->master_pref;
 
-	mt7925_nan_set_2g_support(p_nan_req_tlv, conf);
 	mt7925_nan_set_5g_channel(dev, p_nan_req_tlv, conf);
 	mt7925_nan_set_cluster_id(p_nan_req_tlv, conf->cluster_id);
 	mt7925_nan_set_dw_interval(p_nan_req_tlv, conf);
-- 
2.53.0



