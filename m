Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8997138F658;
	Sat, 17 Oct 2026 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257058; cv=none; b=bwQ+71wOOgydnj6FtuXDFnl4WO7kRF+yCbz1/E5XuNQeZpVEArzWO7k3P26XdvEBbMwLY85hRkM1zA3m+5VTtjqKzghjTk2F6UGHb0XnuY4NVInMLWAn7fW615rRE5yHS9DuaLVJ/8NbDjx+Hv9BOZ66d54esCEhoCUUNcavjZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257058; c=relaxed/simple;
	bh=WmEBeGndFREBxd/mdULxnk1vVcTMWlfDFWuET0lG3XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YseAr22i+jSrj86gatqqm8Qpnvp4rwRAJdbREZm84cueWQU1xpUnoPgDFOz9LUFRjwtjt/n0Y9ZSj0TdnI+JPPkFLAJ0ph+86Qya0mnugVYQ6SSpC0eyOqTgSpXvznt0qn/fiHlJJhYWJ+vzamEntcY/b1QFOatNhu4IV1DgC9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLm1GKNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLm1GKNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A7A1F000C4;
	Sat, 17 Oct 2026 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257057;
	bh=uf0JQ85ne0PuOPaig4GmFZRMsY7IMb29pb1sLoX5VtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLm1GKNefVHoOHTCRYQ75S0pXQ3N/yBdUZmpvvPXxF/1vDCW7ewE6aSf2CEI29iyO
	 TBqjtQ+OlXpM7i//tx+a9GxI/zipVacqs5GqxDOfNbJz5jM2cn+HRsKaSmMHbE6/Bz
	 qAGDGlkn3fOoiGMlVMd/dupGQYZq7D2qT1Hk0Zug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0395/1674] usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41
Date: Sat, 17 Oct 2026 17:44:27 +0200
Message-ID: <20261017160441.251196026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
[ sashal: Adapted .read_version to the generic .read callback with offset and length checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 32 ++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 1054947497bb2..7a4969a086df2 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -107,6 +107,31 @@ static const struct ucsi_operations ucsi_acpi_ops = {
 	.async_write = ucsi_acpi_async_write
 };
 
+static int ucsi_acer_read(struct ucsi *ucsi, unsigned int offset,
+			  void *val, size_t val_len)
+{
+	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
+	u16 *version = val;
+	int ret;
+
+	ret = ucsi_acpi_read(ucsi, offset, val, val_len);
+	if (ret)
+		return ret;
+
+	if (offset == UCSI_VERSION && val_len == sizeof(*version) && !*version) {
+		dev_warn(ua->dev, "UCSI version is zero, assuming 1.2\n");
+		*version = UCSI_VERSION_1_2;
+	}
+
+	return 0;
+}
+
+static const struct ucsi_operations ucsi_acer_ops = {
+	.read = ucsi_acer_read,
+	.sync_write = ucsi_acpi_sync_write,
+	.async_write = ucsi_acpi_async_write
+};
+
 static int
 ucsi_zenbook_read(struct ucsi *ucsi, unsigned int offset, void *val, size_t val_len)
 {
@@ -174,6 +199,13 @@ static const struct ucsi_operations ucsi_dell_ops = {
 };
 
 static const struct dmi_system_id ucsi_acpi_quirks[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro ANV15-41"),
+		},
+		.driver_data = (void *)&ucsi_acer_ops,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.53.0



