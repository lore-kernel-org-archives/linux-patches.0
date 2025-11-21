Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D4634C983;
	Fri, 21 Nov 2025 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732393; cv=none; b=mVD5xxI1kLf/G/WjRQRuQNhqx9v9i3/HmDVGcz6wccX2mJITojUEK1A4eK+EkRvarkeZwTX/R7RdWzlFw25JUC2q7iIzM9fk7J/4iXM4Q5mfey7Xg4KEa9CEQSSThWfNTWLwlSiLeQxlkkQ/nKsh9pT/b+NcZoFAiunY7hccMBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732393; c=relaxed/simple;
	bh=LBDHh0sxgCoQXZBPol6949V2tknGqFWR2sQcJOliSK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9c59X6uWHVDgc9mwzyoorxYixwJHMDCZLmoMpQfPP/+LWA8oLL/maqiGIgnJigGO0HktDao+0H8XJsMruBgv06ishqum1PQcPRJTMvn4RSxAmQk1Ck7dgNS1qDyDVi2MtEeZg28pgNoVYGasbqcixb3vlfq81dIxtg3thGp4iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpGTmEF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpGTmEF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA698C4CEF1;
	Fri, 21 Nov 2025 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732393;
	bh=LBDHh0sxgCoQXZBPol6949V2tknGqFWR2sQcJOliSK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpGTmEF46636DV9aoj3CMSSegmj4XOUXg7ojMkqI5Rzf3bxfvcHFuV8nqeHA98Uwn
	 H3ewDVQxHx7SME7d9TeBDwBwapy7fM+Zl0uASM+xiyt37L+wd+vv4h7rk5sTF18F0a
	 TXDmCO08wIOedkkPTTzmAxhHrzcxAZa8nn8uS7X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/529] hwmon: (dell-smm) Add support for Dell OptiPlex 7040
Date: Fri, 21 Nov 2025 14:06:45 +0100
Message-ID: <20251121130234.795514277@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8d94ecc3cc468..9844843bdfadc 100644
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



