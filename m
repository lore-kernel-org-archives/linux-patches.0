Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875FF27713;
	Tue,  9 Jul 2024 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524512; cv=none; b=O91PCJmDP6NR25zsv5NF8nbZU8xweYNu12QiBB6+9iu54O5nEgClCVeDm9vKWn4h34HAMXzy4xUKv4hTMGJrfB0V3ovoGicyU5rIQRDaJQ9NRyGHVDmZGht/gixOZdCyhjqbmg/WKs7PbQxBCBUNKRlcqDZMOTCw+8qmVyNz0M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524512; c=relaxed/simple;
	bh=Q8VSV50a9t9lA6fUoBerVxBxPt8YydBRA6aNkvI7a7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ENL4baPLus9DlFrJJr1I3L0w4VnUH1KtMVIsIwF8blQ4P2WrNTOQD1H1op24LGNhZA6mpHyOwEJv0BV4as2O6kUwTXvA3u3IFoc/1fZtTA+LT7TTDduehP3DyuPF8idoFDMLMcJ+iYw8BN5xHPYaxIdyA91W9QuvbXxj0BAqXpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNLDzSt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNLDzSt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C19C3277B;
	Tue,  9 Jul 2024 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524512;
	bh=Q8VSV50a9t9lA6fUoBerVxBxPt8YydBRA6aNkvI7a7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNLDzSt44cawPqRxnEEcew+xA1x5mIfWZHP/vFqUwcnxZeokNJYaP10Q9NjWbQXuE
	 mqlbe63+vf27qWYZHppbLOOWg+rFtPUr3xdNLH24z2AWDjVw89jQxElg6obcQhVZRw
	 oyvC+Of1IXlRLuMV3iV/8heYzn2WIP+Vmg8lr2MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 195/197] hwmon: (dell-smm) Add Dell G15 5511 to fan control whitelist
Date: Tue,  9 Jul 2024 13:10:49 +0200
Message-ID: <20240709110716.486077660@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit fa0bc8f297b29126b5ae983406e9bc76d48a9a8e ]

A user reported that he needs to disable BIOS fan control on his
Dell G15 5511 in order to be able to control the fans.

Closes: https://github.com/Wer-Wolf/i8kutils/issues/5
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20240522210809.294488-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index efcf78673e747..b6a995c852ab4 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1530,6 +1530,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
 	},
+	{
+		.ident = "Dell G15 5511",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell G15 5511"),
+		},
+		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
+	},
 	{ }
 };
 
-- 
2.43.0



