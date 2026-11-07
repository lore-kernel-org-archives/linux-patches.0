Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064533;
	b=d2VEqctnx9abanzTudrMBEEm4pYYo/ipUE7FoJBkn0UHzyFLfcZkiD0fdhFl71hzwjCy
	 oaOalE0vNWaScAMcKjFOU2UzEBhuZAGy65uUALTU3uW5ZoxMHUN6YsJfD/xirhLX9RwE/
	 6V2n2kWXXAGAvPzE2AgE2/2w14djcRjcupXrw00UzXftnx/0sMpR9ymDcW+YdT/z+8Nfy
	 UqWMiaz/+HkXTVUdxlb/wjzp+vzHfh7z0zqdfgLbNyHJdHtREtsumfHq1vtCF8TAp5F1V
	 wWUcv7IBFwrcQvsCCVAS97XWmA4AHKlvFfjzzYW06SXtW4XoySEPec7rzwseQOIDUVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mooySoqAJWllapwduXzFKUmwAuuwkV7qP+6je6loD9A=;
	b=WbaxY2jlHcCKP/P5eAbomA4FKcsvuVMZyD/fL9wWqlKseE7mSkHtBcBQO9sIkH0AefF7
	 KVRMllEy6rmhuNzAkQ2XZEhUdrwojEN3xD0zch+J1fNPjs880u7B3zWSSarDaGc90Z5r4
	 qe6zetMBnYLomFgKKgGsB25bRTnKqt8j6p4bBMvpQAng4CzpaTy9UFNbxkvTF9hvT490j
	 3HpnHgYoY8nUM3cxwYhxb0UPvba58i1KYYxtb7GW0OJ6QUjhonS6gPbS31gCaJLfTmhdq
	 /7EHc42rMqXtJzsw3pkJaf+awoysbpXb/KsqW+LoUDVRKbY2CX2BksPs1vxIy7BULBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EeuCcjwe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E2B606B8BB;
	Sat,  7 Nov 2026 15:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EeuCcjwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BE41F0089F;
	Sat,  7 Nov 2026 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064532;
	bh=mooySoqAJWllapwduXzFKUmwAuuwkV7qP+6je6loD9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EeuCcjwe1bS7huREogzBRWAZRMd00HOyaNheMqCrw2fvQUfRDqEMhhn0DXg0ghrs1
	 4yR120Q0nHj5oOjhbLFlscmKsgZfnOeecGMxGGAON+m8Tx7fPRAStsThkfzqcUBCYP
	 lb6OJLrsn83XqfPPy8lkeA09RqQug4zhrJr+gR6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0544/1257] wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()
Date: Sat,  7 Nov 2026 08:47:20 -0500
Message-ID: <20261107134954.425743872@linuxfoundation.org>
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
index afdb73661866e..93552f6f7f340 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -231,12 +231,14 @@ mt76_find_power_limits_node(struct mt76_dev *dev)
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
@@ -429,7 +431,7 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 			      s8 target_power)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct device_node *np;
+	struct device_node *np, *band_np;
 	const s8 *val;
 	char name[16];
 	char band;
@@ -459,15 +461,18 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
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
 
@@ -514,6 +519,8 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 				     ARRAY_SIZE(dest->path.ru_bf), val, len, target_power,
 				     txs_delta, &max_power, n_chains, MT76_SKU_BACKOFF);
 
+	of_node_put(np);
+
 	return max_power;
 }
 EXPORT_SYMBOL_GPL(mt76_get_rate_power_limits);
-- 
2.53.0



