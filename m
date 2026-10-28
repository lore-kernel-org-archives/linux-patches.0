Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213257;
	b=t3bfaqJ9X6t9C1j+GzPzDKNVTl31M25BUTmAo27Vr8lxjLlY+OtGPZYZK81CMDcpV+Rk
	 TJNREK/k/RaKV4EXies0w/vkOKf1Y8to92yKKRMD3CqJv//D63jvmeX2zxzw7jixrfFJM
	 cvYr0vf88mkF6w354nDMgU5BCmHG+FILveaHA/MAykgmb2X88HRh3y1t3fiYzsphjeBZW
	 iklnqXiUGku4YV72qFTcrzaawoBOuPs8+Dr4owFF7wIQHRthEdO3P3EjXI3zYpr1ZrNqK
	 oaRIZh8oWqOgkDT0II+xfxtYw8aYzlUBopwcSFy81RT/8P9Tx7q2M/6V1zRo3gyMqaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i2Kk+Vgfci85R7+VeB/rzWRVGG1uxNp21LnLrWaJGLU=;
	b=X04npJJmHX73qHt3YEJo/8XtOO3UHOxUTrX0nR/DmLfxLam0r8aj8EupNJnLvmmcKfky
	 qggIv6Y4Z9T0Lajt4cmXiURm85Uxl9C6DqKuXFSmwC6uqzPN+W3gzUutD6vw7YaFqQHi2
	 mB/05iuPH82i4wTIGXANQNo73rrsfcwBspoJlc7rA5emPdc7pTBjEVGi4cYcrSghd7Sbd
	 wBoiPRJVUBcMtEF5w3Ll+XZNKkbpfzDVDt3fCsPJ1314ksNbsLVydf8G43+e8Ccw3N2bO
	 VNGVTZ4g8SWYcP/PIcwMrmkeOqqNXpMLzrhWVqpvSuAWl2jekO9Wyb4vMob126GuK1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psLnsuMS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4A7606A31D;
	Wed, 28 Oct 2026 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psLnsuMS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0E41F01825;
	Wed, 28 Oct 2026 18:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213257;
	bh=i2Kk+Vgfci85R7+VeB/rzWRVGG1uxNp21LnLrWaJGLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psLnsuMSRkxkzmBw79VtBzQ9Lj3QeZ5OpuJzn6aOVgTWP0/IZTH/z1kcTHjc07c6v
	 G8JRUrvbAdE4k4EbHXDZ1t6iFIb+TwoLj82n/JkrKkDBSIwFzCnroF2zVoVBbQ1MvZ
	 TSA4Bcd9EgiBmIo/ZPFXjYFz8jAnFd0V3kI1Ii3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0388/1887] usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41
Date: Wed, 28 Oct 2026 17:41:24 +0100
Message-ID: <20261028170508.063717487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the dedicated read_version() callback to the generic read() interface with offset and length checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 32 ++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 03c820fe5b0c4..eeb457ff255e4 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -106,6 +106,31 @@ static const struct ucsi_operations ucsi_acpi_ops = {
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
+		*version = 0x0120;
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
@@ -173,6 +198,13 @@ static const struct ucsi_operations ucsi_dell_ops = {
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



