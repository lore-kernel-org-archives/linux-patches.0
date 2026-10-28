Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211251;
	b=PqpFVJo4zXodPc+IcrrXvlS/i6V5O/qD750kGergI1H0ZzS3AvyXvOgl4ECC1PUY4chN
	 FyCAKLINMKV+itbsOIPWTb5FBTlLcow2YmxhKTN1i4ZUtCm8Qh1WwTvvWDwfpHxUWTwnN
	 /W/ptfNkqR6weFxyfA1BIoYbnYTVmqnxKl4a6cpSBSx4cUTHnWpuPES4Wo2nTXy+7AsrI
	 G06Bc/vkx93NErIrW/7orFeJtUZN0VUStM3wPckcTJJ/J9rsTHapFt08WXEWfc/sVx0XY
	 ifgs/ri5IFjXlySA7ulwyLW6pSy5ktTK+ahcuk5HU/pvATvM/NVu3nUfjc7n92sY7Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v/Llge+g7VoHY3+50w9iQwgmXP+ot6Ne3yNdzpX2gAI=;
	b=Jl6lK/jTf2kfX+txEcEe+5WKj/Tuf7JrhAQnYDYxlXW54H6Te2Tk9Sx4kzZZl6HGiqQb
	 xbHY7zLiIpIsTY27TM/qK/fSzIEdmrLzVK7+/DriePS4doAs02eeG7+BzckHfvvjtWFtJ
	 W4JoRi5F3yLYEn8kd3IOka4YnjWe4/bp3LPjYboOqQlJgdboHrncN9UmhWdlDtbJfphvu
	 DQS74IJmoMmjMDBqs0tRqy1xPISwiKV8WA/ucL0xVSXtAPgtk+E78MVWrOQPEdaN7c380
	 /exGP0rnnRiocUZ+1yGQGSMJm7NDDiTVeCbpa2wrN5MPWK41uPCkgHJxu4WkKX32zug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlPzMx0r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F20460A3807;
	Wed, 28 Oct 2026 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlPzMx0r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85BF1F031E0;
	Wed, 28 Oct 2026 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211251;
	bh=v/Llge+g7VoHY3+50w9iQwgmXP+ot6Ne3yNdzpX2gAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlPzMx0rxod5OF1jEvoJE5WZ1L0oDm7h4E3UgHb5Wn1Qk1BGgs2y388+95hUHId0M
	 btdZ35vsi/X9e5BtdLvE7CPT5oTCiY707WfEEpQcWQLMRGIrGK3kKsb0VD3rAvO6hr
	 3WeSrT0jUT+45uGI0UfdyQ8Q+AKywKKFwtUvY5FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/571] usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41
Date: Wed, 28 Oct 2026 17:57:37 +0100
Message-ID: <20261028170015.354038554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>

[ Upstream commit 8c51ea651d043c786c37668c51624bd6b338a0ef ]

The Acer Nitro ANV15-41 exposes a functional UCSI ACPI PPM but
reports a UCSI VERSION value of zero.

ucsi_register() rejects a zero version with -ENODEV, leaving the
system without registered USB Type-C connectors.

The PPM works correctly when using the UCSI 1.2 layout. With UCSI
1.2 assumed, both Type-C connectors register correctly and USB Power
Delivery negotiation works.

Add a DMI-specific UCSI operation for the Acer Nitro ANV15-41 that
substitutes UCSI 1.2 only when firmware reports a zero version.
Preserve any valid non-zero firmware version.

Tested on an Acer Nitro ANV15-41 with BIOS V1.51.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Signed-off-by: Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260910023338.31816-1-pannarat.wiriyaarritham@danielcorp.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Moved the read_version callback logic into ucsi_acpi_read() because the dedicated callback is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 0c88d5bf09cae..17567bd134d11 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -9,6 +9,7 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 
 #include "ucsi.h"
 
@@ -25,6 +26,16 @@ struct ucsi_acpi {
 	guid_t guid;
 };
 
+static const struct dmi_system_id ucsi_acpi_quirks[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro ANV15-41"),
+		},
+	},
+	{ }
+};
+
 static int ucsi_acpi_dsm(struct ucsi_acpi *ua, int func)
 {
 	union acpi_object *obj;
@@ -45,6 +56,7 @@ static int ucsi_acpi_read(struct ucsi *ucsi, unsigned int offset,
 			  void *val, size_t val_len)
 {
 	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
+	u16 *version = val;
 	int ret;
 
 	ret = ucsi_acpi_dsm(ua, UCSI_DSM_FUNC_READ);
@@ -53,6 +65,12 @@ static int ucsi_acpi_read(struct ucsi *ucsi, unsigned int offset,
 
 	memcpy(val, (const void __force *)(ua->base + offset), val_len);
 
+	if (offset == UCSI_VERSION && val_len == sizeof(*version) && !*version &&
+	    dmi_check_system(ucsi_acpi_quirks)) {
+		dev_warn(ua->dev, "UCSI version is zero, assuming 1.2\n");
+		*version = 0x0120;
+	}
+
 	return 0;
 }
 
-- 
2.53.0



