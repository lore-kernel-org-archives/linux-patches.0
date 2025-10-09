Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB8E2FD1DC;
	Thu,  9 Oct 2025 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025681; cv=none; b=bNBKkeQ3Dr+U/4si8Bkfx2KRKjd4wMHzZAgSjXTTUBR2CQSOlAfqSg6AWlO2ht2wpJu4rndtrBfOBNBrjGoMM22z+H92lDEcltikgb5UQsJifGfpyfm5I4LAwdv2o5uBJtGQCaPHodM8S4Id7mmOxdGI7sqNnEpApGknR0TfI40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025681; c=relaxed/simple;
	bh=sR+fB4loXJxQiF/88sIzg65sFKZEeojUQoye/QYw8AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=otosDdfk97dtFqBSI5UyRImh74unqNU6pJC9dNAn1lUplXQzvigcG/KUmt6bLUpWWljRAkX9wqsV5Bo6yDhtfX4TcUy5ikGzYt2O/J0mdPxH/gkP92vCeQg7UfxXlRzuhJRs1NpXTjYmiHoXGilTEvu/5TX01ynOPpt6bKKoEWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiZi1uJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiZi1uJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29BAC4CEF8;
	Thu,  9 Oct 2025 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025681;
	bh=sR+fB4loXJxQiF/88sIzg65sFKZEeojUQoye/QYw8AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiZi1uJ8T8PB2BGcsPrUDypDP0ZgNhFUSorSvn8RIKQNsEHjOHCSxYvxoRvfuQeiw
	 nGrSBaG6r1sa/2RfLGXHg+gdqTO191LoIH0BlDT2Hu/2KfSkVMDfaI3ytoOW4ZcAbj
	 gcxjDJkIY91/usl1x+JedpENI/QT66IgXsJ+pyJUzxFVdAdSfM2pMJY1n9ABqi8+Q2
	 QRxEIryXq0Smx5u3Ue5nXGLCBD8Pkty6yKYeJez6iIaJyokOslZAcHAQzwrCpBSvmK
	 lby/IvjxGpBOFTjUEguVN28AeaAiGLbjLZKXckp3uuI/xOs2Mgpbsqn3VyNE9Nx+ed
	 eZ7spYyZ9c5fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Ober <dober6023@gmail.com>,
	David Ober <dober@lenovo.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] hwmon: (lenovo-ec-sensors) Update P8 supprt
Date: Thu,  9 Oct 2025 11:56:19 -0400
Message-ID: <20251009155752.773732-113-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Ober <dober6023@gmail.com>

[ Upstream commit 43c056ac85b60232861005765153707f1b0354b6 ]

This fixes differences for the P8 system that was initially set to
the same thermal values as the P7, also adds in the PSU sensor for
all of the supported systems

Signed-off-by: David Ober <dober@lenovo.com>
Signed-off-by: David Ober <dober6023@gmail.com>
Link: https://lore.kernel.org/r/20250807103228.10465-1-dober6023@gmail.com
[groeck: Update subject]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Corrects the EC register map and labels so P8 machines stop reusing
  the P7 layout; the new `p8_temp_map` and dedicated label table at
  `drivers/hwmon/lenovo-ec-sensors.c:91` feed the right offsets to
  `lenovo_ec_do_read_temp`, fixing the bogus readings and misnamed
  DIMM/PCI sensors that users currently see.
- Adds the missing PSU temperature channels by wiring the indices into
  every platform map (`px_temp_map` with PSU1/PSU2 at
  `drivers/hwmon/lenovo-ec-sensors.c:69`, and the generic PSU entry at
  `drivers/hwmon/lenovo-ec-sensors.c:109`), and exposes them through the
  hwmon descriptors (`lenovo_ec_hwmon_info_*` blocks beginning at
  `drivers/hwmon/lenovo-ec-sensors.c:301`). This closes the gap where
  the EC already provided data but the driver silently dropped it.
- Updates the P8 probe path to select the new map/labels
  (`drivers/hwmon/lenovo-ec-sensors.c:571`), so only that SKU sees the
  remapped channels while P5/P7 keep the shared generic table plus the
  newly exposed PSU sensor.
- I checked the driver’s short history (only the initial add in
  70118f85e6538) and the surrounding hwmon subsystem; the change stays
  confined to this new platform driver, aligns array sizes, and avoids
  architectural churn, so regression risk is low. The only user-visible
  difference is the appearance/renaming of sensors to match the
  hardware, which is expected for a bug fix.

Given it fixes incorrect sensor data and restores missing thermal
telemetry on shipping systems, while touching only this young driver, it
fits the stable inclusion guidelines.

 drivers/hwmon/lenovo-ec-sensors.c | 34 +++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/lenovo-ec-sensors.c b/drivers/hwmon/lenovo-ec-sensors.c
index 143fb79713f7d..8681bbf6665b1 100644
--- a/drivers/hwmon/lenovo-ec-sensors.c
+++ b/drivers/hwmon/lenovo-ec-sensors.c
@@ -66,7 +66,7 @@ enum systems {
 	LENOVO_P8,
 };
 
-static int px_temp_map[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
+static int px_temp_map[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 31, 32};
 
 static const char * const lenovo_px_ec_temp_label[] = {
 	"CPU1",
@@ -84,9 +84,29 @@ static const char * const lenovo_px_ec_temp_label[] = {
 	"PCI_Z3",
 	"PCI_Z4",
 	"AMB",
+	"PSU1",
+	"PSU2",
 };
 
-static int gen_temp_map[] = {0, 2, 3, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
+static int p8_temp_map[] = {0, 1, 2, 8, 9, 13, 14, 15, 16, 17, 19, 20, 33};
+
+static const char * const lenovo_p8_ec_temp_label[] = {
+	"CPU1",
+	"CPU_DIMM_BANK1",
+	"CPU_DIMM_BANK2",
+	"M2_Z2R",
+	"M2_Z3R",
+	"DIMM_RIGHT",
+	"DIMM_LEFT",
+	"PCI_Z1",
+	"PCI_Z2",
+	"PCI_Z3",
+	"AMB",
+	"REAR_VR",
+	"PSU",
+};
+
+static int gen_temp_map[] = {0, 2, 3, 6, 7, 8, 9, 10, 11, 12, 13, 14, 31};
 
 static const char * const lenovo_gen_ec_temp_label[] = {
 	"CPU1",
@@ -101,6 +121,7 @@ static const char * const lenovo_gen_ec_temp_label[] = {
 	"PCI_Z3",
 	"PCI_Z4",
 	"AMB",
+	"PSU",
 };
 
 static int px_fan_map[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
@@ -293,6 +314,8 @@ static const struct hwmon_channel_info *lenovo_ec_hwmon_info_px[] = {
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL),
 	HWMON_CHANNEL_INFO(fan,
 			   HWMON_F_INPUT | HWMON_F_LABEL | HWMON_F_MAX,
@@ -327,6 +350,7 @@ static const struct hwmon_channel_info *lenovo_ec_hwmon_info_p8[] = {
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL),
 	HWMON_CHANNEL_INFO(fan,
 			   HWMON_F_INPUT | HWMON_F_LABEL | HWMON_F_MAX,
@@ -359,6 +383,7 @@ static const struct hwmon_channel_info *lenovo_ec_hwmon_info_p7[] = {
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL),
 	HWMON_CHANNEL_INFO(fan,
 			   HWMON_F_INPUT | HWMON_F_LABEL | HWMON_F_MAX,
@@ -388,6 +413,7 @@ static const struct hwmon_channel_info *lenovo_ec_hwmon_info_p5[] = {
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL),
 	HWMON_CHANNEL_INFO(fan,
 			   HWMON_F_INPUT | HWMON_F_LABEL | HWMON_F_MAX,
@@ -545,9 +571,9 @@ static int lenovo_ec_probe(struct platform_device *pdev)
 		break;
 	case 3:
 		ec_data->fan_labels = p8_ec_fan_label;
-		ec_data->temp_labels = lenovo_gen_ec_temp_label;
+		ec_data->temp_labels = lenovo_p8_ec_temp_label;
 		ec_data->fan_map = p8_fan_map;
-		ec_data->temp_map = gen_temp_map;
+		ec_data->temp_map = p8_temp_map;
 		lenovo_ec_chip_info.info = lenovo_ec_hwmon_info_p8;
 		break;
 	default:
-- 
2.51.0

