Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2615304DD;
	Wed, 23 Sep 2026 14:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174008; cv=none; b=Lxq7z6CYgXsYJxCbNg33Shy1slKq0M6PAiU6z35Ye+n8dqz2wZ4YbxV25zgHnwm4JUcs0ze+fhioA7utJoUSAMkbrHd8E6xxwZ09P0p4ezJQDop55fhqUNOUnHhAiZAw+DbCleoXW7GsuolplCY1afBrgRi0lcVFu3QUH9GUUNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174008; c=relaxed/simple;
	bh=S98pfdd/eNztAox2EmXjDuF1wrdA/cU32LbJIDb6d7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImH0TZ33t55lt0jhPWFm1oiI1L9oXY5re/WtXO4GWm7EeypcH7viTg7UeAOTl3KuMRENurj9wsHqsqg/A58YYSQeJymrHQL+1rwlKn5TON3IYFk6cbZajwdln2t0rlY1Td0R7dcax9eb4BahF2m/FYBycvnE7dtKdDr53jltvXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpRum8CS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpRum8CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA31F000FF;
	Wed, 23 Sep 2026 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174006;
	bh=B3gLYHmBJ/s6EuTuu/fGPPPcPPheTF9Txfd+sdWQm0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpRum8CS3DOn0rVQwPou8IF9K/pr67srY91fFpIfQF8uxOHKHCpI+TwEwwnQrazy3
	 tUmvXzccEKk8WJkghEO0fU65j0Rcziz9HUrNpfEwbxPPyQ2hENrxfaTqHHYeEikqjy
	 Nm7PGpZ+I8sn0ge5Bm73tBhAFHgWvb6o1jQjxlNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Thomas Richard (congatec GmbH)" <thomas.richard@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 373/438] hwmon: (cgbc-hwmon) Add missing sensors
Date: Wed, 23 Sep 2026 16:06:34 +0200
Message-ID: <20260923140654.532116746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard (congatec GmbH) <thomas.richard@bootlin.com>

commit 3550d1dbbcb9f51b77e077e8958423ee2c401c6c upstream.

Add the following sensors:
- Alternate Board Temperature (temp11_input)
- Top DIMM 1-7 Temperature (temp12_input to temp18_input)
- Bottom DIMM 1 Temperature (temp19_input)
- 12V Standby Voltage (in14_input)

This fixes the following warning on conga-SA7:

  Board Controller returned an unknown sensor (bc_type=1, bc_id=11), ignore it

Also update existing labels to match Congatec documentation.

Cc: stable@kernel.org
Fixes: 08ebc9def79f ("hwmon: Add Congatec Board Controller monitoring driver")
Signed-off-by: Thomas Richard (congatec GmbH) <thomas.richard@bootlin.com>
Link: https://patch.msgid.link/20260911-cgbc-hwmon-fix-and-new-sensors-v2-2-0c6bf078d173@bootlin.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hwmon/cgbc-hwmon.rst |   42 ++++++++++++++++++-----------
 drivers/hwmon/cgbc-hwmon.c         |   52 ++++++++++++++++++++++++-------------
 2 files changed, 60 insertions(+), 34 deletions(-)

--- a/Documentation/hwmon/cgbc-hwmon.rst
+++ b/Documentation/hwmon/cgbc-hwmon.rst
@@ -28,34 +28,44 @@ system.
 Name          Description
 ============= ======================
 temp1_input   CPU temperature
-temp2_input   Box temperature
+temp2_input   Case temperature
 temp3_input   Ambient temperature
-temp4_input   Board temperature
-temp5_input   Carrier temperature
-temp6_input   Chipset temperature
-temp7_input   Video temperature
+temp4_input   CPU Board temperature
+temp5_input   Carrier Board temperature
+temp6_input   System Chipset temperature
+temp7_input   Video Controller/Board temperature
 temp8_input   Other temperature
-temp9_input   TOPDIM temperature
-temp10_input  BOTTOMDIM temperature
-in0_input     CPU voltage
+temp9_input   Top DIMM 0 temperature
+temp10_input  Bottom DIMM 0 temperature
+temp11_input  Alternate Board temperature
+temp12_input  Top DIMM 1 temperature
+temp13_input  Top DIMM 2 temperature
+temp14_input  Top DIMM 3 temperature
+temp15_input  Top DIMM 4 temperature
+temp16_input  Top DIMM 5 temperature
+temp17_input  Top DIMM 6 temperature
+temp18_input  Top DIMM 7 temperature
+temp19_input  Bottom DIMM 1 temperature
+in0_input     CPU Core voltage
 in1_input     DC Runtime voltage
 in2_input     DC Standby voltage
 in3_input     CMOS Battery voltage
-in4_input     Battery voltage
+in4_input     Battery Supply voltage
 in5_input     AC voltage
 in6_input     Other voltage
-in7_input     5V voltage
+in7_input     5V Runtime voltage
 in8_input     5V Standby voltage
-in9_input     3V3 voltage
+in9_input     3V3 Runtime voltage
 in10_input    3V3 Standby voltage
 in11_input    VCore A voltage
 in12_input    VCore B voltage
-in13_input    12V voltage
-curr1_input   DC current
-curr2_input   5V current
-curr3_input   12V current
+in13_input    12V Runtime voltage
+in14_input    12V Standby voltage
+curr1_input   DC Runtime current
+curr2_input   5V Runtime current
+curr3_input   12V Runtime current
 fan1_input    CPU fan
-fan2_input    Box fan
+fan2_input    Case fan
 fan3_input    Ambient fan
 fan4_input    Chiptset fan
 fan5_input    Video fan
--- a/drivers/hwmon/cgbc-hwmon.c
+++ b/drivers/hwmon/cgbc-hwmon.c
@@ -41,32 +41,42 @@ enum cgbc_sensor_types {
 
 static const char * const cgbc_hwmon_labels_temp[] = {
 	"CPU Temperature",
-	"Box Temperature",
+	"Case Temperature",
 	"Ambient Temperature",
-	"Board Temperature",
-	"Carrier Temperature",
-	"Chipset Temperature",
-	"Video Temperature",
+	"CPU Board Temperature",
+	"Carrier Board Temperature",
+	"System Chipset Temperature",
+	"Video Controller/Board Temperature",
 	"Other Temperature",
-	"TOPDIM Temperature",
-	"BOTTOMDIM Temperature",
+	"Top DIMM 0 Temperature",
+	"Bottom DIMM 0 Temperature",
+	"Alternate Board Temperature",
+	"Top DIMM 1 Temperature",
+	"Top DIMM 2 Temperature",
+	"Top DIMM 3 Temperature",
+	"Top DIMM 4 Temperature",
+	"Top DIMM 5 Temperature",
+	"Top DIMM 6 Temperature",
+	"Top DIMM 7 Temperature",
+	"Bottom DIMM 1 Temperature",
 };
 
 static const char * const cgbc_hwmon_labels_in[] = {
-	"CPU Voltage",
+	"CPU Core Voltage",
 	"DC Runtime Voltage",
 	"DC Standby Voltage",
 	"CMOS Battery Voltage",
-	"Battery Voltage",
+	"Battery Supply Voltage",
 	"AC Voltage",
 	"Other Voltage",
-	"5V Voltage",
+	"5V Runtime Voltage",
 	"5V Standby Voltage",
-	"3V3 Voltage",
+	"3V3 Runtime Voltage",
 	"3V3 Standby Voltage",
 	"VCore A Voltage",
 	"VCore B Voltage",
-	"12V Voltage",
+	"12V Runtime Voltage",
+	"12V Standby Voltage",
 };
 
 /*
@@ -77,14 +87,14 @@ static const struct {
 	const char *label;
 	int id;
 } cgbc_hwmon_labels_curr[] = {
-	{ "DC Current", 0x12 },
-	{ "5V Current", 0x18 },
-	{ "12V Current", 0x1E },
+	{ "DC Runtime Current", 0x12 },
+	{ "5V Runtime Current", 0x18 },
+	{ "12V Runtime Current", 0x1E },
 };
 
 static const char * const cgbc_hwmon_labels_fan[] = {
 	"CPU Fan",
-	"Box Fan",
+	"Case Fan",
 	"Ambient Fan",
 	"Chipset Fan",
 	"Video Fan",
@@ -255,7 +265,12 @@ static const struct hwmon_channel_info *
 			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
 			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL),
+			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL, HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL),
 	HWMON_CHANNEL_INFO(in,
 			   HWMON_I_INPUT | HWMON_I_LABEL, HWMON_I_INPUT | HWMON_I_LABEL,
 			   HWMON_I_INPUT | HWMON_I_LABEL, HWMON_I_INPUT | HWMON_I_LABEL,
@@ -263,7 +278,8 @@ static const struct hwmon_channel_info *
 			   HWMON_I_INPUT | HWMON_I_LABEL, HWMON_I_INPUT | HWMON_I_LABEL,
 			   HWMON_I_INPUT | HWMON_I_LABEL, HWMON_I_INPUT | HWMON_I_LABEL,
 			   HWMON_I_INPUT | HWMON_I_LABEL, HWMON_I_INPUT | HWMON_I_LABEL,
-			   HWMON_I_INPUT | HWMON_I_LABEL, HWMON_I_INPUT | HWMON_I_LABEL),
+			   HWMON_I_INPUT | HWMON_I_LABEL, HWMON_I_INPUT | HWMON_I_LABEL,
+			   HWMON_I_INPUT | HWMON_I_LABEL),
 	HWMON_CHANNEL_INFO(curr,
 			   HWMON_C_INPUT | HWMON_C_LABEL, HWMON_C_INPUT | HWMON_C_LABEL,
 			   HWMON_C_INPUT | HWMON_C_LABEL),


