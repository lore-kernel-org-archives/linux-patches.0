Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209031;
	b=ioT7cErxhRAg3jHZrNJkuIqH4IgJgRkQQcbB/n1QZZFvpHeqz9oxxpOuFMxW0jxsYiuS
	 SHg72yRohxNJZqlBjj9tOEzOxrIAiVz0FDoJ+BOytVd1LEJD6zCrqCpOvrIryIliPcsPk
	 gEjMTFFFeXk3daTtHi0BN2NDshCXsAi6SEhEUmv3/5SFmZP0SYu6C3fWfD3uqIqqEYP/m
	 ik/FGx1U0txOPjKxilpW4yynOKrDNGBhFn/I4Zt0LYgsKlzMz4J7G4zL+1jQcLR1+5dN7
	 iC1KokMEMZZlygQcDtXjIj8TCuLymHy+Q7pF5qhq3AgshSpVvz82LcPx2aV4oKXKgeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dmtUtcDvzdfbTK8I2hJGq4xTv/aVzusHrz1T1e1Mjsk=;
	b=coQ2OxwJ4s48EpSWMspo+pSZWHIvjdWd1CDSvEXl3vQKmO9SFQYoPjuLSoJOpgsTkmhc
	 oMY93KcgaSvZ962RUVF9Bi0Q5YHQAmRGVQh0mXxW5bnEe9cNMTwBvuOJeb6tEufO4QrUH
	 +N6nJokzE5FjaeyWaPUv22Yx6V/OcusV/Oq0GHhz4kS2Vj7NIY1sL2mCu0TVHic9UZ4MA
	 Rg3gAHgV1TZJlIPshhIhLqv5eMfTz/VQY1pOgB4wfkNJLYuobxz2PHJpJUJSJqIzq0feK
	 F53Qhmm/g9DZvR6A/1XF8DIqXDeaF0NfgOmGmNyClMhiHlctmTy5IPYq/lXowOdcQjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OI6xMTXA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6DC606A33B;
	Wed, 28 Oct 2026 17:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OI6xMTXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A981F031E8;
	Wed, 28 Oct 2026 17:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209031;
	bh=dmtUtcDvzdfbTK8I2hJGq4xTv/aVzusHrz1T1e1Mjsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OI6xMTXA+2xUhEbqUyOl3PjMRVXAdNN2MPO4xoFj0HlUnsJhCdqEMT1EYZUa/oSo+
	 6/aP/nv7+XSZ+KPcPXNPTjtytkYKVCbdIEcVI/X1PMv46XiT7slSq/GfazIk2XtRGc
	 0QTZrijTGV5gr0QnkEUnFJu8SL9NkEJo/zkVPdfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/516] usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41
Date: Wed, 28 Oct 2026 17:57:17 +0100
Message-ID: <20261028170010.242694993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the dedicated read_version callback with a DMI-gated check in ucsi_acpi_read(). ]
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



