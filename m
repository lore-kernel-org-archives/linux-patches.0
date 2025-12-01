Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069C93064BF;
	Mon,  1 Dec 2025 11:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588422; cv=none; b=UzS4BNV0VK2QioEdQqF2Ef5U1Rz07X29yKJFiESKaJz81CLlQgle8pg1edlyckK41drQOOUdtoAVlLUtmzRvllsHYz0G55O3bi/DIfWlDwIvRZorkafzdZIuoSqvPj3HYubxOSWRMSLEGHhx4TNOg+ZcDN9RfS+L7A7pN7e7D9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588422; c=relaxed/simple;
	bh=J/JEqss56gMaHSh/K0+GY3PV4vovEFTsqx15ifeUKNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poi9PflYaWLNJKY4wlpXg2LawZFF1Nq/Q0CjQFH87GzZ2kA+KunqPKmJWLITzKxd1DEtaof4rqQIa44Qkk+cOSGAZd0xqMjF37OLGM2aAqz9ccllpX8usANMjB4CRIqtwrXGJloRb93NCJld6hLgJhAoHjqcAWd/cuunOjQeQ2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uF4uHUEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uF4uHUEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1E2C4CEF1;
	Mon,  1 Dec 2025 11:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588421;
	bh=J/JEqss56gMaHSh/K0+GY3PV4vovEFTsqx15ifeUKNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uF4uHUEFMwuxEZkHJfRArLrm5tKSVd/vzpZAyeHGK/Xi7ASF7heo/nNCRq0/TubJL
	 Uonn1zDf2a7qP/p43JAS2GqZA5QE5z08YCc2BqxBxfztaW0fGQhVgJ5br9rGauf3ed
	 6z6WwiCsQK21LZqZ3k7dICzFFudQKSMRHkuQVy14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/187] hwmon: (dell-smm) Add support for Dell OptiPlex 7040
Date: Mon,  1 Dec 2025 12:22:29 +0100
Message-ID: <20251201112242.732915575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 785e7a07bb291..51d0f5e88ebcf 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1016,6 +1016,13 @@ static const struct dmi_system_id i8k_dmi_table[] __initconst = {
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



