Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620454;
	b=2Ez3VkUaTn42auxTrLvhohYRfwSpB7IqadPgHJgbnds1DetDRJvJm/syuJ8rPcro/JV7
	 AJECxCc4RTGlwg+YPli11G5PjuuFM6Gi0BiMNofwSpTebvqL3LgT9jbDpBcXeNawsfAEb
	 k0Az4di081U2lp2YaCA2woZLeO/Y2OrnQCe14Vwpd/zxUr+1L9o9QrDOhvNnnLWWme7PA
	 g1JVdgwgcOZ0opuAyPE8m8FRF4p/ZtFzK5+6sRvaWOl2MPrLwnx5joZ3ZSB2tOvGjyZbT
	 M/lt58DC3xL8xy+XoC7H2jWsOyMvXcbAaxAtPLbCr+OeZFkAIsrC8kya9DMUtLVxXtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xUjTsk0kYUCnvemRaypQn9ZtRdYq77itRy2ibNprVwo=;
	b=4G2MAax72kPaQ2U0RrWLLaP+Q/ujEoyQvldKpx3q+Kwbh7EIpZX5fF3cs9dPQbYCXXeo
	 9W9AvhberktUk9ky0cA4wFbjwygWTDeibPNXAE4Fm/yf2MYeRJuwXbz761ZQvmQcnJz2B
	 rsJEmQTOgJG3twFBeU1POADzFdOLoku5iXtFLos5rI2xVJ6j36uX06395XTLBo0Ys+Oi5
	 e5cXMvo8aJxNBGEAX3h42vmnTAj39d9v0LKFosOtk/SnYOkcvHiVlWQU0Ga0BE51818zP
	 HdYUAU3b9MGSqPEIu84FXwcCocY5T2U8WdrZnqA6F5NRPDx4gQAMCReiEMiTSayZUbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJfRCMwt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF6B606A321;
	Wed, 25 Nov 2026 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJfRCMwt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252DA1F000D3;
	Wed, 25 Nov 2026 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620453;
	bh=xUjTsk0kYUCnvemRaypQn9ZtRdYq77itRy2ibNprVwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJfRCMwtAoyphd8CpvD7rxHwfYceviC/sGF0uCBnziP0+3Hz1pFOgrtBaOtLMpY8o
	 zhpsEaGAXR76HzjwyBLUBEcsHQoBbBQHSJMeCw9S7OJtJPlIDHLA7PLjCJlil5SEsP
	 ieT8+74iFmYrzrndujooIsKWoi9LqxyllkHOUItI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Francesco Orro <ncesco@interstellar.eu>,
	Ihor Urazov <z0rc3r@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Huang Wei <huangwei@kylinos.cn>
Subject: [PATCH 7.3 0922/1005] usb: typec: ucsi: acpi: Assume UCSI 1.0 on HP ZBook 8 G2i 14
Date: Wed, 25 Nov 2026 15:37:40 +0100
Message-ID: <20261125143843.286171915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Urazov <z0rc3r@gmail.com>

commit 3ee1e1c3fca6fb5d0abbe0fc91539951ffa60aa7 upstream.

The HP ZBook 8 G2i 14 (board 8ED9) exposes a working UCSI ACPI PPM, but
its UCSI VERSION field reads zero until the first command completes.
ucsi_register() rejects a zero version with -ENODEV, so no Type-C ports
are registered.

The firmware's _DSM READ function (2) is a stub. The mailbox VERSION
field is written only by the EC response handler, after a command
completes, after which it reads 0x0100 (UCSI 1.0). The mailbox is
48 bytes with 16-byte MESSAGE_IN/MESSAGE_OUT fields, the UCSI 1.x
layout, and _DSM function 5 is not implemented.

Add a DMI-specific read_version for this board that substitutes the
version the firmware itself reports, UCSI 1.0, only when VERSION reads
zero. A non-zero firmware version is used as is.

The same firmware defect on the HP ZBook Fury G1i 16 was discussed in
"[RFC PATCH] usb: typec: ucsi: acpi: bootstrap PPM on HP systems with
empty _DSM func 2" [1]. The defect was reported to HP as case
5166176673.

Tested on an HP ZBook 8 G2i 14 with BIOS Y70 01.02.08, from a fresh
boot where VERSION reads zero: three connectors register, the PD
contract and alternate modes of a Thunderbolt dock are reported, and
its DisplayPort output stays up across the PPM reset in ucsi_init().
Dock unplug/replug and s2idle suspend/resume update the connector
state without errors.

Link: https://lore.kernel.org/linux-usb/f3M_fpjtt8FxDqGKcA84vqXmRbKzCBfpCrIK4-jCWvIscER51zkD8qD8FYpz75qZw51rMDRSkUyYlrBvLvdM8CGRY2l8TFVvr4MC1LdTzbc=@interstellar.eu/ [1]
Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: stable <stable@kernel.org>
Cc: Francesco Orro <ncesco@interstellar.eu>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Ihor Urazov <z0rc3r@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Huang Wei <huangwei@kylinos.cn>
Link: https://patch.msgid.link/20261026-ucsi-hp-zbook-8-g2i-v1-1-91002e9ef073@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -148,6 +148,34 @@ static const struct ucsi_operations ucsi
 	.async_control = ucsi_acpi_async_control
 };
 
+static int ucsi_hp_read_version(struct ucsi *ucsi, u16 *version)
+{
+	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
+	int ret;
+
+	ret = ucsi_acpi_read_version(ucsi, version);
+	if (ret)
+		return ret;
+
+	/* Firmware fills in VERSION (1.0) only after the first command completes */
+	if (!*version) {
+		dev_warn(ua->dev, "UCSI version is zero, assuming 1.0\n");
+		*version = UCSI_VERSION_1_0;
+	}
+
+	return 0;
+}
+
+static const struct ucsi_operations ucsi_hp_ops = {
+	.read_version = ucsi_hp_read_version,
+	.read_cci = ucsi_acpi_read_cci,
+	.poll_cci = ucsi_acpi_poll_cci,
+	.read_message_in = ucsi_acpi_read_message_in,
+	.write_message_out = ucsi_acpi_write_message_out,
+	.sync_control = ucsi_sync_control_common,
+	.async_control = ucsi_acpi_async_control
+};
+
 static int ucsi_gram_sync_control(struct ucsi *ucsi, u64 command, u32 *cci,
 				  void *val, size_t len, void *msg_out,
 				  size_t msg_out_size)
@@ -198,6 +226,13 @@ static const struct dmi_system_id ucsi_a
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8ED9"),
+		},
+		.driver_data = (void *)&ucsi_hp_ops,
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "LG gram PC"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "90Q"),


