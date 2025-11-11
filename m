Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26D5246768;
	Tue, 11 Nov 2025 01:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822998; cv=none; b=dBwKhGv3APXBJEBczzYJ/RLfPua5Rby18piUlz/44Acbyagk4DXtYAFLpIxHlBefOZMYRv3S1MkRVVIe88tXsWjdmbrV1heQXR1QdIeIrhrJdKcelyInN4D505Ql6HcOBYZR85mADBhDE6ZnczztJ1aAgGdlF2XvnOQ8YVZBGhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822998; c=relaxed/simple;
	bh=yLyuMcLE3LdKZONcOWexHAypwNvI2IoeswzNZVTtV0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PX0KeclJylecMdeWhb831+Tii8Xi8QTIrDe/VeOtExQ5ZlmoOoad7JmZPTwMO6mOZZfn1cuQ43fGTWpyixE4k7EUR0nd6UjnQiPFu6lFYwBzss6cxhvZPvKdQtm3vUA6Fm+ZPqkVEUQzTHbnk7KbEgf9E6cMDUmJN2NVKQGEODg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rti8wI5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rti8wI5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022C2C4CEF5;
	Tue, 11 Nov 2025 01:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822997;
	bh=yLyuMcLE3LdKZONcOWexHAypwNvI2IoeswzNZVTtV0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rti8wI5CRKPkvMiL8rRuZqt7o77sgaSLMxHPb3VfuVFH+2lnpoII2hpA8SVEmSEyM
	 rw+Q7MPrvfa06/peXDXpVZtB1S7hlbDanf3EVKAcx2yrdzEHRkiuDVuimb44zqvs8/
	 kpd9mf1d00LNMJvTT4mJAReByvoxd9PwzvmowD0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 211/849] hwmon: (dell-smm) Add support for Dell OptiPlex 7040
Date: Tue, 11 Nov 2025 09:36:21 +0900
Message-ID: <20251111004541.547481565@linuxfoundation.org>
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
index 3f61b2d7935e4..5801128e16c3c 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1280,6 +1280,13 @@ static const struct dmi_system_id i8k_dmi_table[] __initconst = {
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7050"),
 		},
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



