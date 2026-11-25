Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625140;
	b=QMr5GGkIFrsbzlulVwppBRZXfZl/7xuXDV2S6QT4y4bg0b4W47CkM2wsd/gJ5JC9O6d4
	 RZvgAwD27soDkAn6gvbhwoPbrVZ8JD+kDOjF30hwffPqyY96ikZfyzUoE4p5ltmXD8peL
	 P1u1AS+dvu1uE6MYXWYol8uI7WFnhM0gc7/UnnbEwh02Zvlj3upUmZuHxEcbm3dJhVv1m
	 IzBdkAEVQ8b1S4Qr5pBwr51eOuSI74lym1sQZc3JoFKi8asrR9YfoA5dsFNOHlvEFiEEo
	 iLipJXn/M+dY64hbeGtp2NHwnEWS501qSq2d/P+zxksKqJlaf16usw7t76ZBTZ41whQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e6LT3yPreuassQcNnETGxhQRSof91/H+uvvYWu6KiQM=;
	b=hveyHRlIFypcN1rpykDVONAE33LRwNZCgGoX/t0UqFpTDytk9GHxxkAPd5IOPC8y76tn
	 A5J5NO6tZL9b6LaFAQ+xBaq8MQurbr4kbNkdvZAO9jSnqqNOJ7oig/Suf9JBAVZ0e6aLz
	 Dj3dqQjDffWK3BmQrPaE4q1LpZNpjjAZ15WAZqySe60yw0dZoN/Wwqu9LSo4enkRr4qXa
	 +ULLZlD8raJVoaAbbRMfa2phaQ7aUYza4Vy0wgpo3RxEdvxJfvX2PEal3s5MGzQpKdFMN
	 DgpcAai8K56Vi/uqAJoToVauvKANugdWfNV8D1bGUjtRN4pCJGLbWIh4Zdp5MlaB1mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gzmR55E1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A654F606A685;
	Wed, 25 Nov 2026 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gzmR55E1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039EA1F000E0;
	Wed, 25 Nov 2026 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625140;
	bh=e6LT3yPreuassQcNnETGxhQRSof91/H+uvvYWu6KiQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzmR55E1MlbfN1FcoAJu2PNrs0AhO6YEiPwAq23eap/nKifKAOK15bAnxtR6+0IHL
	 g6IFFYFyl5GJkOBJHkD9Bs3+JiQSJU8K2U0hekjzrjsWj8GhYaVdd7a2pVpu5eBZO0
	 wI9IQSO2KVykb+y1dVMgNEEGti/jutwk4XOQbx2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Lichuan <shenlichuan@vivo.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/816] power: supply: Correct multiple typos in comments
Date: Wed, 25 Nov 2026 15:32:03 +0100
Message-ID: <20261125143857.877205062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Shen Lichuan <shenlichuan@vivo.com>

[ Upstream commit 570c2234d5d62d52be7e8e35169b96d98378a7ce ]

Fixed some spelling errors, the details are as follows:

-in the code comments:
	dettached->detached
	meausered->measured
	meausurement->measurement
	sholuld->should
	Tempreture->Temperature
	measuremnts->measurements
	detecing->detecting
	persent->percent
	Parallell->Parallel

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
Link: https://lore.kernel.org/r/20240914085415.3886-1-shenlichuan@vivo.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 1fba78714201 ("power: supply: qcom_smbx: set the charge enable after software control")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/88pm860x_battery.c | 4 ++--
 drivers/power/supply/ab8500_btemp.c     | 2 +-
 drivers/power/supply/charger-manager.c  | 2 +-
 drivers/power/supply/da9030_battery.c   | 4 ++--
 drivers/power/supply/max8925_power.c    | 2 +-
 drivers/power/supply/qcom_battmgr.c     | 2 +-
 drivers/power/supply/qcom_smbx.c        | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/88pm860x_battery.c b/drivers/power/supply/88pm860x_battery.c
index 34619c4d4eced..b7938fbb24a51 100644
--- a/drivers/power/supply/88pm860x_battery.c
+++ b/drivers/power/supply/88pm860x_battery.c
@@ -422,7 +422,7 @@ static irqreturn_t pm860x_batt_handler(int irq, void *data)
 		info->temp_type = PM860X_TEMP_TINT;
 	}
 	mutex_unlock(&info->lock);
-	/* clear ccnt since battery is attached or dettached */
+	/* clear ccnt since battery is attached or detached */
 	clear_ccnt(info, &ccnt_data);
 	return IRQ_HANDLED;
 }
@@ -566,7 +566,7 @@ static int measure_temp(struct pm860x_battery_info *info, int *data)
 		ret = measure_12bit_voltage(info, PM8607_GPADC1_MEAS1, data);
 		if (ret)
 			return ret;
-		/* meausered Vtbat(mV) / Ibias_current(11uA)*/
+		/* measured Vtbat(mV) / Ibias_current(11uA)*/
 		*data = (*data * 1000) / GPBIAS2_GPADC1_UA;
 
 		if (*data > TBAT_NEG_25D) {
diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 082bd09cbedfd..769d28ebca105 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -283,7 +283,7 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 			dev_warn(di->dev, "failed to identify the battery\n");
 	}
 
-	/* Failover if a reading is erroneous, use last meausurement */
+	/* Failover if a reading is erroneous, use last measurement */
 	ret = thermal_zone_get_temp(di->tz, &bat_temp);
 	if (ret) {
 		dev_err(di->dev, "error reading temperature\n");
diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index 272f963b69130..8d2c5de1603af 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -221,7 +221,7 @@ static bool is_charging(struct charger_manager *cm)
 
 	/* If at least one of the charger is charging, return yes */
 	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
-		/* 1. The charger sholuld not be DISABLED */
+		/* 1. The charger should not be DISABLED */
 		if (cm->emergency_stop)
 			continue;
 		if (!cm->charger_enabled)
diff --git a/drivers/power/supply/da9030_battery.c b/drivers/power/supply/da9030_battery.c
index 04e0f4162d42b..b89604a8c0199 100644
--- a/drivers/power/supply/da9030_battery.c
+++ b/drivers/power/supply/da9030_battery.c
@@ -269,7 +269,7 @@ static void da9030_charger_check_state(struct da9030_charger *charger)
 		}
 		if (charger->adc.vchmax_res > charger->thresholds.vcharge_max ||
 		    charger->adc.vchmin_res < charger->thresholds.vcharge_min ||
-		    /* Tempreture readings are negative */
+		    /* Temperature readings are negative */
 		    charger->adc.tbat_res < charger->thresholds.tbat_high ||
 		    charger->adc.tbat_res > charger->thresholds.tbat_low) {
 			/* disable charger */
@@ -470,7 +470,7 @@ static int da9030_battery_charger_init(struct da9030_charger *charger)
 	if (ret)
 		return ret;
 
-	/* enable auto ADC measuremnts */
+	/* enable auto ADC measurements */
 	return da903x_write(charger->master, DA9030_ADC_AUTO_CONTROL,
 			    DA9030_ADC_TBAT_ENABLE | DA9030_ADC_VBAT_IN_TXON |
 			    DA9030_ADC_VCH_ENABLE | DA9030_ADC_ICH_ENABLE |
diff --git a/drivers/power/supply/max8925_power.c b/drivers/power/supply/max8925_power.c
index 621a006d52a96..fc24a6d3b63d8 100644
--- a/drivers/power/supply/max8925_power.c
+++ b/drivers/power/supply/max8925_power.c
@@ -73,7 +73,7 @@ struct max8925_power_info {
 	unsigned		usb_online:1;
 	unsigned		bat_online:1;
 	unsigned		chg_mode:2;
-	unsigned		batt_detect:1;	/* detecing MB by ID pin */
+	unsigned		batt_detect:1;	/* detecting MB by ID pin */
 	unsigned		topoff_threshold:2;
 	unsigned		fast_charge:3;
 	unsigned		no_temp_support:1;
diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 81ec6ab7e1ad0..2c34cda87d07b 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -153,7 +153,7 @@ struct qcom_battmgr_message {
 			__le32 capacity_low;
 			__le32 capacity_warning;
 			__le32 cycle_count;
-			/* thousandth of persent */
+			/* thousandth of percent */
 			__le32 accuracy;
 			__le32 max_sample_time_ms;
 			__le32 min_sample_time_ms;
diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index 099d1385ea12d..1f35416b0d939 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -837,7 +837,7 @@ static const struct smb_init_register smb_init_seq[] = {
 		  AUTO_RECHG_BIT | EN_ANALOG_DROP_IN_VBATT_BIT |
 		  CHARGER_INHIBIT_BIT,
 	  .val = CHARGER_INHIBIT_BIT },
-	/* STAT pin software override, match downstream. Parallell charging? */
+	/* STAT pin software override, match downstream. Parallel charging? */
 	{ .addr = STAT_CFG,
 	  .mask = STAT_SW_OVERRIDE_CFG_BIT,
 	  .val = STAT_SW_OVERRIDE_CFG_BIT },
-- 
2.53.0



