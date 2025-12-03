Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFBC30F535;
	Wed,  3 Dec 2025 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778999; cv=none; b=LKjPonvwqwzEGRJiekFwgUoYNxyLaniyPJ/PbiVhiG2F1DUOX4XGRekHwGKxwsRQipgWZgS5ALeRE+5QjZ+340TTPkMcUqP0XheR2HKKezqjaGQubuhW57OOs/+ISM/o5PSOMwkFTJOFxa+M9VlaeJhn2/v4z9lNby58Ic2TFl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778999; c=relaxed/simple;
	bh=/58Q/K4QU/n25m7k2Cptd4gwApt7xqeHMJJSTUZ96V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOYVIprcBQjJVZoa6+JkTFUk9shWIy8hmjjnAhMZaU4wHI5Nelm5ehlVGyXcdC0BB6pYkWHY7PBBwPJco99SNilEzmfnNmzJ3L6EfrVcTWBQIlGcMuqBXrSpUL3zr7LxTweLVyQdj/rLgb1o/TmAwIbYUfC5ApxsKlZbeOaeKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dz9Ehs2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dz9Ehs2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F971C4CEF5;
	Wed,  3 Dec 2025 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778998;
	bh=/58Q/K4QU/n25m7k2Cptd4gwApt7xqeHMJJSTUZ96V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dz9Ehs2CmFkr94tn29x4VO9dWXwv7YVsRq/pl4YwI4MCr9SN+EQAQwn5TUoX2EwXr
	 wdFYQyTSZGWpsfQGV8dfNr5m+t6fObVxb4/KBlleNwHvgPTCcSspMMefTFfpgMCYc0
	 BsLmMvD31xRskvqI3Zq2tzTb97tBNyO31MDht5zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/568] hwmon: (dell-smm) Add support for Dell OptiPlex 7040
Date: Wed,  3 Dec 2025 16:22:06 +0100
Message-ID: <20251203152445.271978858@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 53d3bd48ef6ff1567a75ca77728968f5ab493cb4 ]

The Dell OptiPlex 7040 supports the legacy SMM interface for reading
sensors and performing fan control. Whitelist this machine so that
this driver loads automatically.

Closes: https://github.com/Wer-Wolf/i8kutils/issues/15
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250917181036.10972-5-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index dbcb8f362061d..e13d545fbc570 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1158,6 +1158,13 @@ static const struct dmi_system_id i8k_dmi_table[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_config_data[DELL_PRECISION_490],
 	},
+	{
+		.ident = "Dell OptiPlex 7040",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7040"),
+		},
+	},
 	{
 		.ident = "Dell Precision",
 		.matches = {
-- 
2.51.0



