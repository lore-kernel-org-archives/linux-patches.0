Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045312;
	b=skKvlSUZ8k3OfF3/W+v9sEt9UirK9JU1SdRD8i/T7qaS/aaHbFfx67xpIplYBWyTcMAr
	 cJD6u8on4BF08MZUDJJgXl14rud+RgdzZY24YxcJotk6jK6EqK9+64EjpVB2I7xZGVrmu
	 4gfKfFbtrzSe+5tCDsWKIuZyz3G5IeaASIZ+itmdGAZdQDJzoe/ckhGvpKLKJa8jjCPdX
	 fHWGT1R0CiGBpxZ0HJTk/ib/qo19Z3JIZ5rpORIUSOosX6ZluqwajnFayIvXZ8B7cnO86
	 3gvQHY/wTm1YC+a7/ualePz8g7z9mOY28Z0xjEYTrOZWccwcYz5xdIpNiddSviyHI4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JIV9eO7FBx08/FOwF/tqJvxk19o1cAJllZfRxxiT66A=;
	b=FL4o1F+FYKoXzXXs+T8Mp4hbAu6mqmOtmOY4xV1lg9fTaSa2XTYygXKA1m/9Ten791H4
	 ujzwXzsEiWrmXP5/6egUdpy13EUl6DspvZT/aaCycEmAxziT0Z63huRGJXlHTTNPslXfS
	 KjvVJr1xco8PWrB8h85oOCrRn0MmRFBOBJsEFzFntVCjkrg79Cx+sXqTkxAIx9uX18a5A
	 McWAPQwAvfWlH9pVi4v2ZeSHVsbUoHY1F3zPBEP7M1ICJwu6T/8jLE9Kkzp5XdtvNZERN
	 cqOXcwOYXXbPorcMorVd9aUytJUrqWRsc9LLo89zg6F3lsVBmRL6ztILQRB6SdpY3Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxYtAMSt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14971606A31C;
	Wed, 18 Nov 2026 23:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxYtAMSt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204881F000C4;
	Wed, 18 Nov 2026 23:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045311;
	bh=JIV9eO7FBx08/FOwF/tqJvxk19o1cAJllZfRxxiT66A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxYtAMStzvVtvmlzL/3bpiBjuXipcDb/cVhL6nbFMtC2ZF97B82ARl0TcEQCL85hy
	 nnvo2ohPCkcKfSeA15qSvfA56BuXAb1P3OE4ht+aCtsDXAlasjlvxCKbkexYh6UAqF
	 hpHi0DGSW+OfseLgEjAxHRxh9Xt6TSC4ceLdyW6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0876/2857] power: supply: ab8500_fg: Accept status from supplied power
Date: Wed, 18 Nov 2026 15:31:50 +0100
Message-ID: <20261118150233.105567330@linuxfoundation.org>
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
index 71ce28eed463f..327c7a9f31ece 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2211,42 +2211,36 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 
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



