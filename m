Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590907;
	b=Jy1CwI2roolxR3e0yLNuAEAApgOOZp9WGdDsqcHXMFHRnLmBwdrqMIjSmxsF4B6kOzEW
	 bq3okxQ71cASk0eYy5lytI0jIYBQ1FSrIVwUpzcj4mbHCkkXd28QUfsmNcdVmmuXg7gll
	 r5LnsVArQAL2rP6tIe7s62gVTfqVuHXVYE7jVbnOhzlKnvfPvd2a4872S8a9HQrzK/wOc
	 w8PeYIUCPQNyn0pEf31cSot7yslDfahF+SJ3a4ybBHPIoOtpQTkXKHcsDf0M9nP3vwRmQ
	 jtH7gdrikUUKYSl1PlUPqKIjmVdj91Y3nvf/LJlSeytiTJvrvp5+CMGRy/Q6Vq9jTYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ye0Hyct5nMt/fkha33gyNSVHF+Y8v7gZg08P22+C8gE=;
	b=gXe6wPpYbPS7xld1oLDOV+eglf6bHaRP6vrVFwrFhx3RBuGgzrOiV4fkCkhiRI4jh4k7
	 iYypmo1uHwxUzp3OClriHFZsLBiHvoEz5RpeqcMx5MjprTHPbDxSLef0987/TeIgPQhqR
	 1WnVsRM4nrHodHFA4fpE2xdFEYqczhlrP0lFx2sRvyqimxrEXCXnBsnHDBQuZlgKKmHXR
	 fp1wdoIB/0dFC375c9+xrahU5RyEwlm1WD3DUTH4VKh1PtIU/J5BxuMxQlFdyCCNzr+eO
	 tKtf7CA8RsJ5CnklSj8q2pdxy88MGI6GTCkJtrXri0FyB7WqqBGerDh4vE3mprPKubg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFMxTi9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547A0606E237;
	Fri, 13 Nov 2026 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFMxTi9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EF81F000C4;
	Fri, 13 Nov 2026 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590907;
	bh=Ye0Hyct5nMt/fkha33gyNSVHF+Y8v7gZg08P22+C8gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFMxTi9brU2B5u3B+OT2PNd18qkaDzU6ltcjbT8OgCYBLuLGt+O4q5KSTVWVsH4O+
	 arZ41dtQPFjy5GyuwUwn1TGvpVrNuLX0pRY3sKMhFHR8nerLv+5g4qVoVpmLRRYoTs
	 lOewIkEkc+/OdRnTIQw7sFp+s2iC0lSOtHuELdFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/670] wifi: mt76: mt792x: fix negative errno truncation in offload capability
Date: Fri, 13 Nov 2026 10:44:19 -0500
Message-ID: <20261113153815.119619666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c6afdf90fade6..a3ca93c9af63e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -658,7 +658,7 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(mt792x_init_wiphy);
 
-static u8
+static int
 mt792x_get_offload_capability(struct device *dev, const char *fw_wm)
 {
 	const struct mt76_connac2_fw_trailer *hdr;
@@ -720,13 +720,20 @@ mt792x_get_mac80211_ops(struct device *dev,
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



