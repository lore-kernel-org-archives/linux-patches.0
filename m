Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062252;
	b=JC3Po/SZTti7JpPCVbXzFpbogdXJxoH71tjQZWYLQ7T1/GOm4krv6L0CxMEtVfhYrWoG
	 PclAcXEzr6ZMqrY8gTku+Zia4GjFzuROBRyDVmG9+wVHgLXt60LX+yRgWfnKXmkCv7wv0
	 iM3BpZlL2+VEu92UJROWKlJm/TIQf3s8tCDQYFdo/rTnPFMSa4rYwKgeM879DQ1+8bFkv
	 x4ll9KW+NoulaV3SGgVAMGrh0nZJzsXxI5kd2G4hVWpf7x4k667oxU4gCl2Hjqb8VziZ7
	 MprNmeo/G/l8jDs4vpwSnIZMK3CrfVMKW8NhOTUnSi5cU88r1OGfPo4CDdKztaoNojg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=esKvd8K1FO5gEZLWlA3pN66ybv6FOE2LfjkVe8KMTQQ=;
	b=1b8ooG5bWPwJYZXq6xBTAYFt8AXCw3m6+JbrH7QJzuX2EHb0np7CjWTs8QM4ExrdOMsu
	 YjiEVypH6qCcScAlFqhQcnAGsF0uwT6R5GB0FHjxu9XKOrRn3gfA11l4zWoAKX47MZ2xy
	 SjXdd4bm3h8zdmyBxpD690LqB13QqvO0zP7+3Uf1JCac1fXXiMPDBwxpbsFMx4Cv9BbFP
	 lpJFu/8W2/wntdNhsAM2b8JUEu6S9fRTrPrkhG+ZHm6N4ZSX8nxkcG+J7U1SUz20DIpiO
	 NN7pCQcMxsGfTafb39tlRq/DCNQqpEl60uFPucgDmSYKcbZ/xFMGWvMbZItVA4j78FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtfPvDkE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC76606D83E;
	Sat,  7 Nov 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtfPvDkE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC9A1F0089F;
	Sat,  7 Nov 2026 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062251;
	bh=esKvd8K1FO5gEZLWlA3pN66ybv6FOE2LfjkVe8KMTQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtfPvDkEKiKbka4XXT3zel25nG3ZZOxnUVyzn5a17sDskU1l6VKTVYJWS9mHOXTOR
	 daveAytnImXxsx27AqTIPVjez8aBCvfgwDwroEHNb9t39U3DUd4sf/uHwJBNGwtI+t
	 blBp+xIKLU5xvMLiywDY3WaSJI1BrRVXxooNMRSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1157/1536] power: supply: ab8500_fg: Accept status from supplied power
Date: Sat,  7 Nov 2026 08:52:53 -0500
Message-ID: <20261107135030.221564889@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 16f506a13b58a55308449bbcbec89c817d619ca2 ]

Commit dc77721ea4aa ("power: supply: ab8500: Set typing and props")
changed the charging algorithm power supply type from battery to unknown
so userspace would not mistake it for a second battery. The fuel gauge,
however, processes status changes only from battery-type supplies. It
therefore never learns that charging started and keeps running its
discharge state machine.

The power supply relationship already limits the callback to supplies
naming the fuel gauge in supplied_to. Accept status from any such supply
while retaining the battery type checks for battery-specific properties.

The Samsung-GT-I8160-Codina and Samsung-GT-I8160_HD-Codina product trees
keep the charging algorithm typed as a battery. The
Samsung-GT-I8530-Gavini, Samsung-GT-S7710-Skomer,
Samsung-SGH-I407-Kyle and Samsung-SGH-T599-Codina-TMO alternative
fuel-gauge drivers instead pass cable state directly. Both approaches
preserve the charging state handoff that was lost in mainline.

Fixes: dc77721ea4aa ("power: supply: ab8500: Set typing and props")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-1-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 60 ++++++++++++++------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 89b6e599087a3..4c15cb1f7b7c2 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2206,42 +2206,36 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 
 		switch (prop) {
 		case POWER_SUPPLY_PROP_STATUS:
-			switch (ext->desc->type) {
-			case POWER_SUPPLY_TYPE_BATTERY:
-				switch (ret.intval) {
-				case POWER_SUPPLY_STATUS_UNKNOWN:
-				case POWER_SUPPLY_STATUS_DISCHARGING:
-				case POWER_SUPPLY_STATUS_NOT_CHARGING:
-					if (!di->flags.charging)
-						break;
-					di->flags.charging = false;
-					di->flags.fully_charged = false;
-					if (di->bm->capacity_scaling)
-						ab8500_fg_update_cap_scalers(di);
-					queue_work(di->fg_wq, &di->fg_work);
+			switch (ret.intval) {
+			case POWER_SUPPLY_STATUS_UNKNOWN:
+			case POWER_SUPPLY_STATUS_DISCHARGING:
+			case POWER_SUPPLY_STATUS_NOT_CHARGING:
+				if (!di->flags.charging)
 					break;
-				case POWER_SUPPLY_STATUS_FULL:
-					if (di->flags.fully_charged)
-						break;
-					di->flags.fully_charged = true;
-					di->flags.force_full = true;
-					/* Save current capacity as maximum */
-					di->bat_cap.max_mah = di->bat_cap.mah;
-					queue_work(di->fg_wq, &di->fg_work);
-					break;
-				case POWER_SUPPLY_STATUS_CHARGING:
-					if (di->flags.charging &&
-						!di->flags.fully_charged)
-						break;
-					di->flags.charging = true;
-					di->flags.fully_charged = false;
-					if (di->bm->capacity_scaling)
-						ab8500_fg_update_cap_scalers(di);
-					queue_work(di->fg_wq, &di->fg_work);
+				di->flags.charging = false;
+				di->flags.fully_charged = false;
+				if (di->bm->capacity_scaling)
+					ab8500_fg_update_cap_scalers(di);
+				queue_work(di->fg_wq, &di->fg_work);
+				break;
+			case POWER_SUPPLY_STATUS_FULL:
+				if (di->flags.fully_charged)
 					break;
-				}
+				di->flags.fully_charged = true;
+				di->flags.force_full = true;
+				/* Save current capacity as maximum */
+				di->bat_cap.max_mah = di->bat_cap.mah;
+				queue_work(di->fg_wq, &di->fg_work);
 				break;
-			default:
+			case POWER_SUPPLY_STATUS_CHARGING:
+				if (di->flags.charging &&
+				    !di->flags.fully_charged)
+					break;
+				di->flags.charging = true;
+				di->flags.fully_charged = false;
+				if (di->bm->capacity_scaling)
+					ab8500_fg_update_cap_scalers(di);
+				queue_work(di->fg_wq, &di->fg_work);
 				break;
 			}
 			break;
-- 
2.53.0



