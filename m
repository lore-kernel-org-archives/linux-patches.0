Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062235;
	b=Gsk/Vl1+BsQ26rGmIH2RdbaX6KrgaDLnbtPna2kQ/c+oqWicYOURQNbXiYULgrDDGsTJ
	 NYfXWFtib80X7Q5/Z4PNmDPwbuyZ28xH4nUcNdpP8kV5vY9/xdPloWM0qG651L5kN9lGJ
	 Ov+C8j47MARh2P426TzRGc9pBtYH0rEkBKpo2/qFLzgf1smUFngHfuLhvuYZepvR/CBLh
	 IwhLZfT1di0N1CdP4dJ/9P9sMvszYgNiRdNqsBPoosDfXM8W5hbbzAGlWgghHCdjVcWJd
	 9a301AIhejkCsKPOODuzTjw/av3nTefsbMGAfLZxTHBDMv47oFBJ5g3dK2ttA4dD+6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5UIXaXYaMpXWS3M7FwGwC6hq+OwWq7GGtjt7gw75rjM=;
	b=cSksQG+PNaNStZyfYImZBBvqfsELxmYHX+unk+2ecPSwE7EUCEZCZkqa9cP5BRbVI7Qw
	 6h+FdBQHsVWGswinlgb7bhqeJrua+g65H/AkZ33dqErATmFurwhtQDA2VGhzEA3cvgrh2
	 zGp2GL4jiiRdSn4uKcisvXfkCHZ9AR4f6OGhKxt/LvQ1XvNwFmeOm06kBKpVqNmO7f/UY
	 TLT1AYqgDkeXJvYunaW6mAM2m7avsryiuWFxlmim63sP1OWVhmQa8hYXp6F2uc0/G8Cpj
	 UWBnc9pSEHVrMzBnLvJTEgIYBLrBkeG4/+sjXOncIjghSyUiTV6iYuc5xJTV6WiiafQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCicZnrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247A1606D810;
	Sat,  7 Nov 2026 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCicZnrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C650A1F008A3;
	Sat,  7 Nov 2026 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062235;
	bh=5UIXaXYaMpXWS3M7FwGwC6hq+OwWq7GGtjt7gw75rjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCicZnrLgTOgsQNCSuX3ayzQnjm3SFNYJgmIg7u/xR6Eo2sMcqFIPFJPj7ad+/ln1
	 1QFFdt5TGhyD3sykC08V5DwYe/2+aud1bzXqRR3W4KFzPPeyIQCyFdOnJ4ESJwZWrL
	 lA2FFNYDJFAXCxprruqsucLmfwNRzOrU5fPwSmZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1184/1536] wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()
Date: Sat,  7 Nov 2026 08:53:20 -0500
Message-ID: <20261107135030.999627194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 6ce8e4af18fe5..281b2c3e9e7cf 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -224,12 +224,14 @@ mt76_find_power_limits_node(struct mt76_dev *dev)
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
@@ -356,7 +358,7 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 			      s8 target_power)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct device_node *np;
+	struct device_node *np, *band_np;
 	const s8 *val;
 	char name[16];
 	u32 mcs_rates = dev->drv->mcs_rates;
@@ -389,15 +391,18 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
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
 
@@ -422,6 +427,8 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 				     ARRAY_SIZE(dest->ru), val, len,
 				     target_power, txs_delta, &max_power);
 
+	of_node_put(np);
+
 	return max_power;
 }
 EXPORT_SYMBOL_GPL(mt76_get_rate_power_limits);
-- 
2.53.0



