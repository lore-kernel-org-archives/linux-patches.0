Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063135;
	b=fc/MyhMW20xV5HZitvetqc5kTJK4me1lCZ+7p3Q1QxKetxiTagrACkFc/gs4ufrosWTB
	 wsLSPvhUwFcC2r3lfEGtYpj74weNbj/zZc0rhxcdBKLvhCTHdEFkx4S8V61K+ElP060Aw
	 IVNwrZEeiZGdUvOZEQFEatF/sr2xb5Oe+oVv1Sw/bLHqhGILA7HHfov/Ss5+NxaVMx/BH
	 INWFAHwMlZaZ+ierH5AnDAbl4A5jv7XLHj5V9mgBroGFgLxULoYyGq9LWZ8/+EVx/CmWk
	 ShXg+D8onqLfhRSUT6owEHLKNRextnNaMSMwBls0wKfpfWwfOIRgDUi1JiilabHPErA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1mAE9LaFn+NTiMSq715mIZQTaiLslgANcGCaxcoX2aY=;
	b=fv6A2fsdX+/UBLJddYw6j87xmW9lX0yRzolEWiSY1c4ZFuSJ64Z25VrKChI4OKqFN67e
	 Irq8KoaIeMD7pVsQU1n5mcahtBalTqLdXTwh/i2XwphPGsMiOu/wlBzVkdis/DOx+Pa5o
	 6XS9TbmP43PG5cpe/C4+aTAFVjVEHMfrn4lM+bLNU4GaboQXdIPKVD/66cS2FfJgsV7j7
	 yD+ovHjx0In5w9zJy6LfI9zh4k8W7iT281VYvyMMRXOjhTIih5J4ia6WmKV1f/Uf2ELR+
	 /8QQbKmZtcSYNnFZEz4S+M33UYjC8oH3AXBX1kwtwRpC+kWN7FQbELJTmC5K10J0Qcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9sQ0J2h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6F0606D811;
	Sat,  7 Nov 2026 14:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9sQ0J2h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617851F0089F;
	Sat,  7 Nov 2026 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063133;
	bh=1mAE9LaFn+NTiMSq715mIZQTaiLslgANcGCaxcoX2aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9sQ0J2hBXV1/FdmN2rQ4q3pmdQ1Y73xIM0NustYiGfPCOsJJsLsiiI7JbLiYG70z
	 paD3p4KkGVoMxDLx3jKN/U7xJlLqJ/G5D0W4sFDAxy75UAlgIwYNIwlvaL66Njkq71
	 8uejvTM87zGZCfiOeVryd5fBRFXoyF3o04JVf53A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/869] power: supply: ab8500_fg: Accept status from supplied power
Date: Sat,  7 Nov 2026 08:50:45 -0500
Message-ID: <20261107134904.920100615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 969a75f4c016d..b122bd473c773 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2205,42 +2205,36 @@ static int ab8500_fg_get_ext_psy_data(struct power_supply *ext, void *data)
 
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



