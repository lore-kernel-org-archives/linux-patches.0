Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064546;
	b=b823Z/WqayNSci1Iw8ri3jRNdTVxFDsP/Gd/fQRVi2BZTV48aR2EXrPhn+KeoHPn5Hz0
	 yUIRr9crKQrmwUC62Xci8u1mR0ABhuD+C5IS7HdzqjEi/t3EmztOFfUesqL6qcvgg1b8T
	 mcViA+ZK44LftKq6+VAOnClQdQ1CDL7u67Xklvv9oufffXJYlQqGJ2TJLGQebYGt7jjVt
	 KmIloFIYqo7a6CNTwjhWGa31G+HK5/2elzQKL7pcL8g7HKA5ezPtteW/9cg5+vZZJtcBz
	 sfLyGqXtSSYlm8GeGONOFWk7A+ibs88hBDvUBO+jhoNnLwjeqNNiYmvn0tQLcV6sbSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxomo+oUjoFhQ8rLWj4uWxhhyduruB7seHpIOrvBeNU=;
	b=Jpqr3p/EmqSQhX7+AXG31DajkghR4rGZkNeWubxhNYM9Go7Fi0GlYsiymWue25AP1Asz
	 SJEVpZfutT1ic3NtxHcxl0wqqgHP9m8C0r+BGouhcKqmi6MXBJi9hY1paWneHZhzXqKUA
	 xzooCe8UnBwxGvPdPtJ+PUR/2b+QumSmAWw/1UOMbNC7SknwScaE7yriHc1u1sdH0gWOr
	 JyfbOwUHCgZefSJP92Xpb+1lcUzBhfoGlhRorPhoCsUwrXTpsWdu0RyUSzn5lA5sM7Bsw
	 UvKwfhRPNiUZYg3UPqT5ajnmcMBNzhGIsARNaV/hXoowMrybLl8wawpVg9S7NsIqcVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJZAtdSj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE9D606B8A6;
	Sat,  7 Nov 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJZAtdSj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7191F008AB;
	Sat,  7 Nov 2026 15:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064546;
	bh=nxomo+oUjoFhQ8rLWj4uWxhhyduruB7seHpIOrvBeNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJZAtdSjyXkEXsSGr+0O+0npTRfm061xvFlAIj73A31tcdMxVHrxRQ41mjSduQ3nh
	 wcLGtkXomIyGadaVkgEmuliXZ1u+Kf+chHbtOlsr33No3oLGrzIlGD3sf0GuUe7VxL
	 RSbu2dFXVQKNMD7RUPkbWLm5jtaroxxLIV0u/7ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0545/1257] wifi: mt76: mt792x: fix negative errno truncation in offload capability
Date: Sat,  7 Nov 2026 08:47:21 -0500
Message-ID: <20261107134954.450571409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index f56f03bfe3874..3ce6c6ceac81c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -858,7 +858,7 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(mt792x_init_wiphy);
 
-static u8
+static int
 mt792x_get_offload_capability(struct device *dev, const char *fw_wm)
 {
 	const struct mt76_connac2_fw_trailer *hdr;
@@ -927,13 +927,20 @@ mt792x_get_mac80211_ops(struct device *dev,
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
 
 	if (mt792x_needs_cnm_runtime(drv_data))
 		*fw_features |= MT792x_FW_CAP_CNM;
-- 
2.53.0



