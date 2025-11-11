Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C057262A;
	Tue, 11 Nov 2025 01:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823042; cv=none; b=gDfwjA1J1Ls6EvGRk10oKv6pp7uG7pBfAqVGhkoWtkufV2lvekV0m3pRtkO8SpO5zbq6r5q4yIB8fkGn5XnYMI8ZjkcJWWkdzKlyOjd7ltntMAQo97N8HnuMReJSyd3i5W/fGbOxorpekG4YhaX7aQaweUwQw/ZnHkrrjJwbBoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823042; c=relaxed/simple;
	bh=+fZPIUJ2DptVX0tUVBu7pnDy+99KZBoMcPm2yrMcDNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sedk9uiT4RpKKYcjQB3hyNXigAUpxWViojPU3DxZqp49MqZ6PwBPP1BY9hyTy7FDObMbHOTxsY4pVCv1CI5/KKAWmT699g9isNub9ElD7E+z6eXhbo7pYne7XAfm83ODA25mnz+XZRBPhiCtju5WgeJKXHxG3gpB7n/jyENyASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quqKr/Cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quqKr/Cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E326DC4CEF5;
	Tue, 11 Nov 2025 01:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823042;
	bh=+fZPIUJ2DptVX0tUVBu7pnDy+99KZBoMcPm2yrMcDNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quqKr/CluiiA9hOVoYSn2q/mFkMfUgDWpC9RrU23sLi8+QS0GpTXCROkTGKozCmae
	 MpGbM6xHMCVX2sgAcGgBfPSxjuwyBS0sb/5lbCNDBKSUtKTMWXxg8cyVaODrmoSeCJ
	 TaAdD3DlXq5qAqE2nNXLEfaS9UjBsYN6ZIxoWKkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/565] hwmon: (dell-smm) Remove Dell Precision 490 custom config data
Date: Tue, 11 Nov 2025 09:40:16 +0900
Message-ID: <20251111004530.536123454@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit ddb61e737f04e3c6c8299c1e00bf17a42a7f05cf ]

It turns out the second fan on the Dell Precision 490 does not
really support I8K_FAN_TURBO. Setting the fan state to 3 enables
automatic fan control, just like on the other two fans.
The reason why this was misinterpreted as turbo mode was that
the second fan normally spins faster in automatic mode than
in the previous fan states. Yet when in state 3, the fan speed
reacts to heat exposure, exposing the automatic mode setting.

Link: https://github.com/lm-sensors/lm-sensors/pull/383
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250917181036.10972-2-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index b043fbd15c9da..f73f461937482 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1324,7 +1324,6 @@ struct i8k_config_data {
 
 enum i8k_configs {
 	DELL_LATITUDE_D520,
-	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS,
 };
@@ -1334,10 +1333,6 @@ static const struct i8k_config_data i8k_config_data[] __initconst = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_TURBO,
 	},
-	[DELL_PRECISION_490] = {
-		.fan_mult = 1,
-		.fan_max = I8K_FAN_TURBO,
-	},
 	[DELL_STUDIO] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
@@ -1357,15 +1352,6 @@ static const struct dmi_system_id i8k_config_dmi_table[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
 	},
-	{
-		.ident = "Dell Precision 490",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME,
-				  "Precision WorkStation 490"),
-		},
-		.driver_data = (void *)&i8k_config_data[DELL_PRECISION_490],
-	},
 	{
 		.ident = "Dell Studio",
 		.matches = {
-- 
2.51.0



