Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045500;
	b=TzLyrDfs28040flcJD88xJce567jMExrAiSkkwEWrjLGslJL9Ztjx3/Qm5Ds3oZsKhZH
	 g44VGM2MTfjuLUXSEjLh6UnzJ8bZym5ew01iEQxQihscO7/BMN/16HPTpj2MYsIlXhtmD
	 uadQ7RG8sVJMRdT/eQUfcKxmuZ32xlkjpje7gn9QQF3kJKyYjMxsS/oeZnDJxpeapvxGV
	 3ZIKE3BIKFDGqoYuPUHfJb7I0NjvLKxZZnCZ1ZXXdb1uUHvTaSGosYTyTWyb9JnSm2747
	 ajKlF8mH0iVqSgky0MLch781sZDAQWRF4n1VdzngPzWWA479uc12X45fQ0TB2qZGtnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VeS3729nJ8HoN8Yi772xHMUnglNXlMHGY9OrfzRJuts=;
	b=ii2yKv3a3hd8E/EOEX8E30yhPT4Gw16hSUjng/+DRHwH0qJjAMRNSmvuOzwvr1ofCL5b
	 vPMg/g9K2/qWp2NaTCRq34LN0JJzF3d/Ri4EABvhA12sAo1i1ijT6DhHIzcv/hzhDXavB
	 rfQO2Mt41aY9XjvgBzUqxCwFO1LGdEmsOHvzxuK3JMU3Dn5+l/0hnlRnXmmEN0eFudZA+
	 2sOYH2D2gxRNXay8o+VtRJ3cb+qZihhscKdNBN7sFbVD26X2uWRrpCJh9DB6XqMePBhB7
	 2w0aEi5atv/NlBEWepn1+ZtYuKl1MAbQCTd0rwo2Um7+1n/WzSPm+OSnnqrCZdwwHQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gs9lu17G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FA8606A320;
	Wed, 18 Nov 2026 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gs9lu17G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8577F1F000C4;
	Wed, 18 Nov 2026 23:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045500;
	bh=VeS3729nJ8HoN8Yi772xHMUnglNXlMHGY9OrfzRJuts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gs9lu17G0AW+PuRjT6Ux42AGnr+Bhht6o9k0/kS5FjPxmtsUFQSH1XxLiK0flbHO4
	 DGUdoShElE39Xp3d8jKx23q7gVQRO8KD9FmHm8W+E5Svqv7V1VTqDrA5kLX/RMu7fF
	 jd3S6+UysaRlPgJ5/jlnhIP3izCJD5I7V5TWcCZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0896/2857] wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()
Date: Wed, 18 Nov 2026 15:32:10 +0100
Message-ID: <20261118150233.820479230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 8d604c899f7bd1a76a2eb21c0b706c02878abd36 ]

mt76_find_power_limits_node() and mt76_find_channel_node() return nodes
with the reference held, but mt76_get_rate_power_limits() overwrites the
"txpower-<band>" node reference and never releases the channel node
reference, leaking both.

Drop the intermediate and the channel node reference on every exit path,
and take a reference on the fallback node returned by
mt76_find_power_limits_node() so the caller's of_node_put() is balanced.

Fixes: 22b980badc0f ("mt76: add functions for parsing rate power limits from DT")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917121944.2150737-1-vulab@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 17741621aeb8b..a03676a7c740d 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -161,12 +161,14 @@ mt76_find_power_limits_node(struct mt76_dev *dev)
 		struct property *regd = of_find_property(cur, "regdomain", NULL);
 
 		if (!country && !regd) {
-			fallback = cur;
+			of_node_put(fallback);
+			fallback = of_node_get(cur);
 			continue;
 		}
 
 		if (mt76_string_prop_find(country, dev->alpha2) ||
 		    mt76_string_prop_find(regd, region_name)) {
+			of_node_put(fallback);
 			of_node_put(np);
 			return cur;
 		}
@@ -290,7 +292,7 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 			      s8 target_power)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct device_node *np;
+	struct device_node *np, *band_np;
 	const s8 *val;
 	char name[16];
 	u32 mcs_rates = dev->drv->mcs_rates;
@@ -323,15 +325,18 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 		band = '6';
 		break;
 	default:
+		of_node_put(np);
 		return target_power;
 	}
 
 	snprintf(name, sizeof(name), "txpower-%cg", band);
-	np = of_get_child_by_name(np, name);
-	if (!np)
+	band_np = of_get_child_by_name(np, name);
+	of_node_put(np);
+	if (!band_np)
 		return target_power;
 
-	np = mt76_find_channel_node(np, chan);
+	np = mt76_find_channel_node(band_np, chan);
+	of_node_put(band_np);
 	if (!np)
 		return target_power;
 
@@ -356,6 +361,8 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 				     ARRAY_SIZE(dest->ru), val, len,
 				     target_power, txs_delta, &max_power);
 
+	of_node_put(np);
+
 	return max_power;
 }
 EXPORT_SYMBOL_GPL(mt76_get_rate_power_limits);
-- 
2.53.0



