Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036306;
	b=itpfN9PtiA9mgN/d+NmWyGY4bqZSTTCxe9O2ERDI5VxTWw2EyCDH+8Gtw+77j41ySSEj
	 j77jTyYazKz0T8erMHNhdhdwTyDiL18DZtYGQEkCFX2yFQd+cTMxbt47+wFiCryUA/2x/
	 ZunwhYuyCo43IW8aApK4Z0mz09/xiwC7gEy56Q2jh0nr2xImNu5FX2cvonBk2b5QXT/UR
	 gjDqApwbGHfJor0Bi4au++TNbr2wBFmQ/UQ0kbN9xVWSXAVZwY6LICs9917rSV4yLZ03B
	 FhQV6TFrKBpkX3obFqYkSN+NkendFlLmw0pPcqy+RRjslG4UZ/NoPBdaRP0Qt8tCBjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r3lnaQ3Iiu/SLBrOcrREQsFaAAx+lqKLr6UnECNMSu0=;
	b=GXtfCL98XrRrGw+ZHhR2Ju9q0qmO0auqqj7ALdkn53SohPV3CIHFbNs7G8clxZBzlatf
	 hkCA9zgLb4JD+yqkCY/m0Rvl/wvOko8sGL92PXlTZ4TSU5rIs4mrRP9ysa+XR6wPVBJEY
	 UKxPKglppVQOyICpv/RXPV7UN4qpzHjPzXt6YEPJCx1sQj88QwyCP2PLxTKf04vteAK+4
	 0+b2RzUS+KzudF7iETgDSzkm4K02JI+k4k0YIz4iKO2L5g/80uUb4DQBP3xUKApdXphSe
	 gM03oKXIWvuMcKjOEYPqSApeBG8mGmhou+l/DSFcZLqET934KcU3SopahhdrhzMnZ5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfL2G5uz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F0F606A31C;
	Wed, 18 Nov 2026 21:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfL2G5uz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CAA1F000C5;
	Wed, 18 Nov 2026 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036305;
	bh=r3lnaQ3Iiu/SLBrOcrREQsFaAAx+lqKLr6UnECNMSu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfL2G5uzgemZ2ZZwyrph/WQ8GtKtFygWLREEVSbixTR9drAchPtisA2rwQfxkoZZL
	 rVA7giBG1SAOpOz1RIwk4ALVjK70bZj48ltyk6Ir9sPcQ9VeR6D0vJBexGZVNZh3XX
	 PFClWwuS1BdVPfQ5Dfa0F/MnbnuF2Td3lbkegYXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1010/3318] power: supply: ab8500_fg: Accept status from supplied power
Date: Wed, 18 Nov 2026 15:27:12 +0100
Message-ID: <20261118150350.181582362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 53560fbb6dcd3..fabab6f9961bf 100644
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



