Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EFE258EF6;
	Tue, 11 Nov 2025 01:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822992; cv=none; b=J88zISHB1n0TC25EzmtpipuTyNMW9UBKF2fYaaVTCqx3UTG9S6kkCG6T2iWTp9nt9lX05Qb7yySbmBVJgPSMYo4SQNN07T/nDMvCslIbHwCSbU9K3WupkUBHd8ykoUsaBk6Qyw7Hu2f1Vv+uQI2rZi58/WYlTg+lPeFAqkZ0Kls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822992; c=relaxed/simple;
	bh=vqioFOxfZgtLXHGBSIneGoGTsHbleNF28bvpzm6B+jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSZt8WHO8W3SQOn6YUKihS0iVBe+ER9aw1Tdg33Nf6BjQU5SJMw5QCc/8RJKAQDJWnpu/kGoJzNcSqfZCPvOXkCE510EsNlIZMGBaxBWf9Zyth0xG3g96gJFz3iJy7x9twdJiee+KqDZVW5C0Ql0TkkX0V5XZvfj2xunkRWLA3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAkQ24mU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAkQ24mU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDAEC2BCAF;
	Tue, 11 Nov 2025 01:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822992;
	bh=vqioFOxfZgtLXHGBSIneGoGTsHbleNF28bvpzm6B+jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAkQ24mURQ7KpB3QX3lBNphx/Vwhd0Twua1IVCVLsKxy6VKlGS2EbGVmlGSA0apqS
	 BDa1XV+LoAkpRigyuT/bvf7BHVvDRRspmhEh9JQ4umNb6WFbcSQ8VegoT6E5CSoZwT
	 +gd7DpY/vLDywmf/jsbwSv2NCy+CiY5V79yMBeIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 210/849] hwmon: (dell-smm) Remove Dell Precision 490 custom config data
Date: Tue, 11 Nov 2025 09:36:20 +0900
Message-ID: <20251111004541.522005486@linuxfoundation.org>
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
index 1e2c8e2840015..3f61b2d7935e4 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1331,7 +1331,6 @@ struct i8k_config_data {
 
 enum i8k_configs {
 	DELL_LATITUDE_D520,
-	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS,
 };
@@ -1341,10 +1340,6 @@ static const struct i8k_config_data i8k_config_data[] __initconst = {
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
@@ -1364,15 +1359,6 @@ static const struct dmi_system_id i8k_config_dmi_table[] __initconst = {
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



