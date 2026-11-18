Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052517;
	b=kYhPXOH7CMxv7vf1hdCbJ6/rgVu02wNX/5TwtW6Bf1br3F6fYbme/AT3QcYwLqKA/pUt
	 jDbKHsf3j/3XOTIRTH5eLzV7E/+xGi0spVXh7BftMHMcVqt2NIrnPvyOKwBN4sxuWjJq1
	 YXD5AAwzfoyI01s6lErwPvVppdNtFt4V3soH/phz4yRmjN2B7QzWQLtUAcJHRAiXZVqBh
	 9MTaNkbi9uAha8zxOcECuDFQk+KV+YX1x5yy+DuHsx3wiJIkPsNg4+8abj4dXF28lmZY7
	 zHOSQQk92tYW5vE9uyjeT5hQMOBzZdvMzx+DbGBwDC656gb4GSXwRKC7y732YmYIzwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U3GJJWSTtr1bJUrlUbcaA1EHf0ccRVMFJ4Uqn4DQyLQ=;
	b=anBEu/duHVAOS0bzszet8Bl6JhenN1FSUseoaoq+BCui9bgXtD5z0wUYUpQ+wNcUgkYG
	 OGpK9WHVCRkS1b+toXYPck0IahlAk9puL5CqOWMDel2V6h2AIkP1E45GnThgzt/JBKlCY
	 VZGajpG+nkzdVSCowMyxFq4YrcqiPVs0iDESZkBqoyzFjIHsumGBU90G8Ov+GwOavFeZ5
	 8EIQvEUuuHmgWHLcZFbKsOee086x/pxvdH0ZpsUhtk+EFjO3tdjmfYzNSLfsnfmKI4qW1
	 DAoYwWGY65WzJmSyw/LnDWPh/9LiRQmYHdEs6tW6bFrkOSVJmY2EFjCQ+YQ3FdQcJAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtF0JZi4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F63606A31C;
	Thu, 19 Nov 2026 01:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtF0JZi4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41B21F000C7;
	Thu, 19 Nov 2026 01:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052517;
	bh=U3GJJWSTtr1bJUrlUbcaA1EHf0ccRVMFJ4Uqn4DQyLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtF0JZi4M9uDLqaipny+GmHW9Td+fnje8Ff6+HBE0f5SUevSgOBfLHhdL7xm5GTFd
	 bTAJ+brWfjWasQjUhbAhlJru6Ep9k7nqVPnh3tLwT4L9h/AvYxcTgy37vhAsM/2YEF
	 nJBUAvN/90UHDpkQA20nbVs1ZR0P7ZYq85Om68Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0593/2214] wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()
Date: Wed, 18 Nov 2026 15:37:49 +0100
Message-ID: <20261118150034.618162459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5776671f8424a..9ddeb727dafc3 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -145,12 +145,14 @@ mt76_find_power_limits_node(struct mt76_dev *dev)
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
@@ -274,7 +276,7 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 			      s8 target_power)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct device_node *np;
+	struct device_node *np, *band_np;
 	const s8 *val;
 	char name[16];
 	u32 mcs_rates = dev->drv->mcs_rates;
@@ -304,15 +306,18 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 		band = '5';
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
 
@@ -337,6 +342,8 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 				     ARRAY_SIZE(dest->ru), val, len,
 				     target_power, txs_delta, &max_power);
 
+	of_node_put(np);
+
 	return max_power;
 }
 EXPORT_SYMBOL_GPL(mt76_get_rate_power_limits);
-- 
2.53.0



