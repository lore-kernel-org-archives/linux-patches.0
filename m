Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A4B2EBBAF;
	Fri,  9 Oct 2026 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557307; cv=none; b=sX/HC89vYYDgri2SUlSSYWN4WIryA8180FU9RxCc6XjEx1iikaw4kkQW0BZ9IAF4p+mjQgFteWPLmcqXpXRz9LQ00Sl/25pyhY1c9LpDPwImfvmkjKS1Shl3dyLcNLbj5dot2eZTMRaW2XAg1sf1u6lGhtw2jHOBSil8Deaz9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557307; c=relaxed/simple;
	bh=Ftlx4S268VmURYqd939/ncsU1gYxwKZjv0dnYp1RS/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyCALs8+vmljOHGCKy7RK0nQe+KtR+O2UwEo0J6Xa3m5C4HaWwOn+vlNXi2wBk9vz+vaf1CpH4at0Cu/ndPStVOf7KQLMe59+MHxMResum3Nyp7Igqx9Wt/6ECR+myi1VrD1RF4o/K6HuJLy5TezqnoDe8E+WGqXPaF1Bnsy9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQjTgFAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQjTgFAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718671F000FF;
	Fri,  9 Oct 2026 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557306;
	bh=xDtUG6eZaqddG9jtwR3xRXIUnk/Erskn/TjTHe18dzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQjTgFANt03A0pgbVMthyqBziLTvicUJNf2TCzc4+2Fht7Kp8vC6B4HxDiQ6DeXA8
	 1POYQQHl4xARCfm2IoauDTDRjb2yGJc4O0u4HDZkuGLJMW4e+9dYJ2N1/43yX2Ghhx
	 DVuCNWLtf06qRWee0rN7UIP83XsEDS+w/kLxjLr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/403] usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41
Date: Fri,  9 Oct 2026 16:12:20 +0200
Message-ID: <20261009141001.184909901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted the unsupported .write_message_out initializer from ucsi_acer_ops. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -105,6 +105,32 @@ static const struct ucsi_operations ucsi
 	.async_control = ucsi_acpi_async_control
 };
 
+static int ucsi_acer_read_version(struct ucsi *ucsi, u16 *version)
+{
+	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
+	int ret;
+
+	ret = ucsi_acpi_read_version(ucsi, version);
+	if (ret)
+		return ret;
+
+	if (!*version) {
+		dev_warn(ua->dev, "UCSI version is zero, assuming 1.2\n");
+		*version = UCSI_VERSION_1_2;
+	}
+
+	return 0;
+}
+
+static const struct ucsi_operations ucsi_acer_ops = {
+	.read_version = ucsi_acer_read_version,
+	.read_cci = ucsi_acpi_read_cci,
+	.poll_cci = ucsi_acpi_poll_cci,
+	.read_message_in = ucsi_acpi_read_message_in,
+	.sync_control = ucsi_sync_control_common,
+	.async_control = ucsi_acpi_async_control
+};
+
 static int ucsi_gram_sync_control(struct ucsi *ucsi, u64 command, u32 *cci,
 				  void *val, size_t len)
 {
@@ -146,6 +172,13 @@ static const struct ucsi_operations ucsi
 static const struct dmi_system_id ucsi_acpi_quirks[] = {
 	{
 		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro ANV15-41"),
+		},
+		.driver_data = (void *)&ucsi_acer_ops,
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "LG gram PC"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "90Q"),


