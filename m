Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA36244693;
	Tue, 11 Nov 2025 00:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822727; cv=none; b=kBP0QAdyO8CKYeOsbdHqZkhJj6aUJhomEhdzmVZfpVybQKfXgyBpoMX0wJdrI3QgotvY00GjLPXpmQAiyW4spKQ+gCd7UlreIrdKnQkx8kXViYQAVKDzX4j8pw5Zxn37yFcC7LNCVO9qnVTh7sAsIcL2Ggt51V605qf2gPsMtWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822727; c=relaxed/simple;
	bh=tSYfcLOrx9Mc01SJCoamGchLkn+0W22VdaXD7QyUxfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4DOv/uMZVxwO8RXKGq8qmP5o6FJP/TG6AlE43kk357AH4CivyglyemTuzHUrpdDtwnfNX5/3uDBYknsJpSjLvkFIkfXCa/UzlxZ/5tqqUgdgQmm9prKt8k4FbmE6QM0Hn30/L8d4PNZ3jtTeGeUJnnGpLkZ9XqAYvPZLq9mu24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfYDFOZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfYDFOZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEDEC4AF0B;
	Tue, 11 Nov 2025 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822727;
	bh=tSYfcLOrx9Mc01SJCoamGchLkn+0W22VdaXD7QyUxfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfYDFOZVM+55OUlFskTEewjWE0q+CNA1/RNw8OlnIG4mPcLd5K611UUOxowR8ZYYi
	 dI1EM7xhzwLHCpSwQrhp82W8nZh2DtRptSDWnymt+QFstaJkT6n7MMjztLkpVuGgPq
	 h7W+CFdzV17n1SUHvQ1Dr4/4mikeuJE7o5jKrHc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ober <dober@lenovo.com>,
	David Ober <dober6023@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 156/849] hwmon: (lenovo-ec-sensors) Update P8 supprt
Date: Tue, 11 Nov 2025 09:35:26 +0900
Message-ID: <20251111004540.202259936@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



