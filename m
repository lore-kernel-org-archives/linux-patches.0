Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2C0531624;
	Thu, 17 Sep 2026 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664485; cv=none; b=hd06EJXDnAluooP2huz/pWpy+5gsG60txmj81TCVqFVLl9mpD6h4Z/GHZ95uzHoKg0basGSn4U4juf0uDrbcLln+NG8w9DJ8WdfdOfBkIQTyWK0jt9BkZUR3lEeKPY9kSHNvKA3FPTe8yqeSKbGoIdCf5IM9gjZIFPagKR9UnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664485; c=relaxed/simple;
	bh=amyDS3drD2zWaP7HfHA/wOatcIgDLrk8ZpIG4caDbd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOKV4dZbzEfTqsFsLEVOLfHVVe8h8AD9g2QD7Huy/uma4gCIkatFt62YXijRV0ghqEUenL20T/Cn+hAEZR0AbNrOs6QLqNCdb4G6EGTJAm1NkTjgKWenh/eOG8IGoUSF969QjYj9/ZTHqT4vL6Z0ZIKdts+fz+b/ZtlbmBRhGQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7uuAtcr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7uuAtcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DB61F000FF;
	Thu, 17 Sep 2026 17:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664484;
	bh=vbdr1abMDTyBZZqDonH5Xzj5gODtx7W/4KyGaJNmqXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7uuAtcrhyx3dThyjRfgVJ9nmleAT1/LFISBl+mpHeFylSG1sXkbEoFHIDfOX/Tcc
	 NdY0Cg4J+0hOAVj/LsP0sgqLOf58k3jCMRcs0n7HHud7fcg/SF89TG7N6cSZqsFgJh
	 1191ZB+1nUxgU/UsCXsbxNV3w/NBRdgrrbk3opwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0386/1250] hwmon: (dell-smm) Add Dell Latitude 7530 to fan control whitelist
Date: Thu, 17 Sep 2026 16:03:01 +0100
Message-ID: <20260917151602.503890609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 5a1aba28f6c79f4bbb7a5361063225030ecd36f3 ]

A user reported that the Dell Latitude 7530 needs to be whitelisted
for the special SMM calls necessary for globally enabling/disabling
BIOS fan control.

Closes: https://github.com/Wer-Wolf/i8kutils/issues/17
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20260610180141.311503-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 768690a597f4d..9f102589f240c 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1565,6 +1565,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
 	},
+	{
+		.ident = "Dell Latitude 7530",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Latitude 7530"),
+		},
+		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
+	},
 	{
 		.ident = "Dell Latitude E6440",
 		.matches = {
-- 
2.53.0



