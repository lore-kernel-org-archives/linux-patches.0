Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA4832E69C;
	Wed,  3 Dec 2025 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777578; cv=none; b=aOCjuiWNER9hd7HNc3V+4BNSOp598JrXPeVkI49n4zHPlix+BnMh53YlG8UK3i4p2wQR4qAarDXEz3WKdkxK5FfnMLQcinXDq5rI/QI2A+iYT0ByV2wo0ZmGC3GLXNulU5T7PJ8qa4kKU69ER7ZDXDfeVS/BP67FqQ0eEhrkEk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777578; c=relaxed/simple;
	bh=XOz7j9DR2u9EnwDmOsTPtbqxDTzcy7NKBJMsCHbeUvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtmSQ686Y9vxLm10eCCv4Olorg1aQYiKHJ3fnEgUrZ5uG6+5JXk7d1ePU4/4PELk6YA+RGkPZ5KvJk9I+9tJieSipAwgcmwjvvDZ3zGlPtnnncRmr+mKFdtE6odlPiYNbr0U6Pz2b62MDia0F7jkzt7yKDd4mZenHwOq5DklOfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAVyZYem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAVyZYem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD02AC4CEF5;
	Wed,  3 Dec 2025 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777577;
	bh=XOz7j9DR2u9EnwDmOsTPtbqxDTzcy7NKBJMsCHbeUvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAVyZYem2dyYfuE6RDd0J9OdMyeVzDFAnBBqIKpaIDZDgx9xQfP+vmli7+rePbA7u
	 7OKHazocoeEdVul4xALdd2VFDfhWlwgyqyCqxv06QKe1PdnNOCixmGPSEp39GCjUXL
	 28BaZuNKza0NgF9QBwwtdJYU++mzko7dkkSd5bz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/392] hwmon: (dell-smm) Add support for Dell OptiPlex 7040
Date: Wed,  3 Dec 2025 16:23:51 +0100
Message-ID: <20251203152417.084560009@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 597cbb4391bdc..ff0209c92a755 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1030,6 +1030,13 @@ static const struct dmi_system_id i8k_dmi_table[] __initconst = {
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



