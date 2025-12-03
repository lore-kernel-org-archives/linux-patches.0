Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9130F535;
	Wed,  3 Dec 2025 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776033; cv=none; b=U8LmKGJtICRf0sgEJuH0xcBqyDhLAjOy9kTsXSmuFdfGC6gZVBSid4lRqluToiiR+EZL2ud0Q8M18eIMCx2c8RtP35nfqCNXBeepRKo8Y2LvW+2ZWeSs+fgVqwZnosLRbnPaP+aXEZ+JUFDNikn4bO+XLxcRBgWZXqhDbJ7P6RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776033; c=relaxed/simple;
	bh=KvJN6ct/JdKOzrydI/Vs/uw2d7InfeWSQLUsN7UPvK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVHlvXRGQ7akVvCVAywvsM9wPLikntQPE6Z8Ix+aqjaQ4mStuRkF1tKTBOjxjKW+m+qtVnosru/7paRw11TRGFFLEHxbNxJDeGKPR7h5Vs9y63XBZWYJ11m474vKqUiHJlkZz0HHiFvl0ZG1evyDH75dxB5TcklZQcuNW42PAmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaUNUE23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaUNUE23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667A6C4CEF5;
	Wed,  3 Dec 2025 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776032;
	bh=KvJN6ct/JdKOzrydI/Vs/uw2d7InfeWSQLUsN7UPvK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaUNUE23cPQzvVLMhhtzVMyVcYF7iZT8KOTYBD4U4xxtuz8SUwERGQsCT/Fwv1T1k
	 IY/t5apwe/R/X/pLK4pUvYR6COtX73eSU233T9wa9G0ACTzWIzONYgDG0sJXviKKJU
	 iRCcTiTCQn4GX6WypwyxR0Wd55fI2KqgIolO5I7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/300] hwmon: (dell-smm) Add support for Dell OptiPlex 7040
Date: Wed,  3 Dec 2025 16:24:23 +0100
Message-ID: <20251203152402.808310535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 10c7b6295b02e..9fb389fa17817 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1065,6 +1065,13 @@ static const struct dmi_system_id i8k_dmi_table[] __initconst = {
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



