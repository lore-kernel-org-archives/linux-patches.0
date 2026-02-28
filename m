Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE0A313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301055; cv=none; b=tTxifz8IwNOAy+7mmlAO/IliB6bczesWrJN8hDF//Wb6SPwtlyZh6yFY/y6fC+KJkeHHQV86Tp0hvNtnZTJbzWLVuY2hA7SQUK5TbqQj9e6eRmOV4w1ei3YlRAWBMczystEn8RUjmFZaCK4W8XeGZbT8gA3/lTY/0LoT9pRZm2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301055; c=relaxed/simple;
	bh=IoRAKXrojNunKUEtjtnRxBOfEvG+GvL74JAcKv2iLis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PS+GtaMv3vsGIo5pZGEUra2V3jl6wVZa+wiJggfynW+sPk9Bv/EKwLKyIgwl6JwfPsns1LmDo3UFkQaqMgOerNYodTM17w9BtfugaXPF3tB9LWAL0/wxoisguG1tWULt/AQrvObTCdwBr5wEcysDMuWyEIKXou2QNzIDneRAO7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H406qhS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H406qhS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A2AC19423;
	Sat, 28 Feb 2026 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301054;
	bh=IoRAKXrojNunKUEtjtnRxBOfEvG+GvL74JAcKv2iLis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H406qhS+6naybLitC6izUEhXzE7uA3xcDgsJSzAXxe6DfOpuLSH/9oR706agwEixg
	 m0XhsDQLWPAuyvPzfh97M6209Eav/O2KtxiX3Mm1NYJbssqqfchqTAtp/ID2ob4Y32
	 V5Dz9Kyk1nVJ9Z6ChD3PXn68VDmNRfpXUc7GYjEMOm/NhaCyZwXxlUr9DdIfTN3TNA
	 X3lSgjgmgS4w61XVwqaXhM4XfJVSGUPbMU/uwu7Al+bMp5M7Z55rjGmJxDZPned86I
	 /u6Aqe39dExTDyk3xZP2C70fhS9h7RVUnsKdXgS3IPjaoegpkibq9YFR6pamr0xrn/
	 TfXy4Kj2/0gpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/752] hwmon: (dell-smm) Add support for Dell OptiPlex 7080
Date: Sat, 28 Feb 2026 12:38:26 -0500
Message-ID: <20260228174750.1542406-195-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 46c3e87a79179454f741f797c274dd25f5c6125e ]

The Dell OptiPlex 7080 supports the legacy SMM interface for reading
sensors and performing fan control. Whitelist this machine so that
this driver loads automatically.

Closes: https://github.com/Wer-Wolf/i8kutils/issues/16
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20260104000654.6406-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index f3d484a9f708b..768690a597f4d 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1325,6 +1325,13 @@ static const struct dmi_system_id i8k_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
 		},
 	},
+	{
+		.ident = "Dell OptiPlex 7080",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7080"),
+		},
+	},
 	{
 		.ident = "Dell OptiPlex 7060",
 		.matches = {
-- 
2.51.0

