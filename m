Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591393;
	b=qUuZGJeHpjKNfAgrDFMilakm7h/1lPzcvTfzu2atWtyrmG3NzQsPzWPd9rKekjjTjKAX
	 1OQowWbbFYjjzyXLI+C62DgtELopx3DFePjxU+hAK7v6bIPQ7BXWMBJPmp+smDB14vQF4
	 Vtk3askIAnuK9FXC7ykrSSPv3DQBmGWUDjUbL+MElnxs8qrJ8N8TLEWC0HnUH4xMLTeB6
	 NQqys8NNhvaPKJh6Kwqf+MS0emF8SponAD5wG+8rgwxi+VbEpED5cVMPtG7FKzqA8zaBO
	 6Uig0Zax8abuKc2T2MWajUYk67SCFa7hwBVlK0U+I0bpb2L7TYGv4teL4NdoTgyKc7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6T1hHQe9Nda74IC/ZHEGpp79ahNhqI8p7Ng5LyzZAuY=;
	b=mBikLcdZsrRBxF4pKm4QKg2xJMxZblmJPWZ+4I8A7Ro5ooRjowBg8JYMePX/HIUSZI/H
	 Dj2oOBiMJVCsEayqvI178Eu+M1y/VN7FUVDS5NzaYdQoNPCLZUrdAk0TS8XMxftyfES/8
	 hnxXsrepbcB9aJPw3PozNaNvFmDQh+u+qrPsAE7Hc3Tg8miu5bU/jlkxholgpgJdcnI6G
	 tzT3xZcfwGLWtBArZE/X3hDeF/TGrq9CHc1YIICKlbDFs3kiBUP3gMpVZSQEvmQFXYmjg
	 osaF6+appZMV7LszDNzQoxRkkoKHNVocOp6qq/KOU6P8uzYazb8onXmO0WWUQ8V1MyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxkg4p6G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290DB6079D40;
	Fri, 13 Nov 2026 17:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxkg4p6G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EE01F000C4;
	Fri, 13 Nov 2026 17:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591393;
	bh=6T1hHQe9Nda74IC/ZHEGpp79ahNhqI8p7Ng5LyzZAuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxkg4p6GhSm2g1H48cexOjwhWQ5IS4nM7JmAMitCHkip1mjqpNiNINVEBKPfpEUSs
	 7YuJXAQWUsS+GRCaGcLHKvFVzWqbUvDpiv74CEODopdv/iWSlyGHk8iwSr/K7ozPE2
	 grEK0c1CFlpZIwz9GUu0wd5MjiYjzG3wCR6YgDSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 492/670] spi: cadence-xspi: Replace ACPI specifics by agnostic APIs
Date: Fri, 13 Nov 2026 10:50:56 -0500
Message-ID: <20261113153828.608770240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6f9e4740e8591176eb90bb1dae95bbbb5c7d789e ]

Replace ACPI specific calls to get device property with the agnostic one.
The code looses the direct dependency to the ACPI APIs and get cleaner.
This doesn't change functionality.

While at it, drop now unneeded acpi.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251129151739.3998668-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ea9854a169e9 ("spi: cadence-xspi: reject SDMA transfers larger than the requested length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 36 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index c3676b21e8167..b6b42daae1bce 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -2,7 +2,6 @@
 // Cadence XSPI flash controller driver
 // Copyright (C) 2020-21 Cadence
 
-#include <linux/acpi.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/err.h>
@@ -21,6 +20,7 @@
 #include <linux/limits.h>
 #include <linux/log2.h>
 #include <linux/bitrev.h>
+#include <linux/util_macros.h>
 
 #define CDNS_XSPI_MAGIC_NUM_VALUE	0x6522
 #define CDNS_XSPI_MAX_BANKS		8
@@ -775,19 +775,15 @@ static int marvell_xspi_mem_op_execute(struct spi_mem *mem,
 	return ret;
 }
 
-#ifdef CONFIG_ACPI
 static bool cdns_xspi_supports_op(struct spi_mem *mem,
 				  const struct spi_mem_op *op)
 {
 	struct spi_device *spi = mem->spi;
-	const union acpi_object *obj;
-	struct acpi_device *adev;
+	struct device *dev = &spi->dev;
+	u32 value;
 
-	adev = ACPI_COMPANION(&spi->dev);
-
-	if (!acpi_dev_get_property(adev, "spi-tx-bus-width", ACPI_TYPE_INTEGER,
-				   &obj)) {
-		switch (obj->integer.value) {
+	if (!device_property_read_u32(dev, "spi-tx-bus-width", &value)) {
+		switch (value) {
 		case 1:
 			break;
 		case 2:
@@ -800,16 +796,13 @@ static bool cdns_xspi_supports_op(struct spi_mem *mem,
 			spi->mode |= SPI_TX_OCTAL;
 			break;
 		default:
-			dev_warn(&spi->dev,
-				 "spi-tx-bus-width %lld not supported\n",
-				 obj->integer.value);
+			dev_warn(dev, "spi-tx-bus-width %u not supported\n", value);
 			break;
 		}
 	}
 
-	if (!acpi_dev_get_property(adev, "spi-rx-bus-width", ACPI_TYPE_INTEGER,
-				   &obj)) {
-		switch (obj->integer.value) {
+	if (!device_property_read_u32(dev, "spi-rx-bus-width", &value)) {
+		switch (value) {
 		case 1:
 			break;
 		case 2:
@@ -822,9 +815,7 @@ static bool cdns_xspi_supports_op(struct spi_mem *mem,
 			spi->mode |= SPI_RX_OCTAL;
 			break;
 		default:
-			dev_warn(&spi->dev,
-				 "spi-rx-bus-width %lld not supported\n",
-				 obj->integer.value);
+			dev_warn(dev, "spi-rx-bus-width %u not supported\n", value);
 			break;
 		}
 	}
@@ -834,7 +825,6 @@ static bool cdns_xspi_supports_op(struct spi_mem *mem,
 
 	return true;
 }
-#endif
 
 static int cdns_xspi_adjust_mem_op_size(struct spi_mem *mem, struct spi_mem_op *op)
 {
@@ -847,17 +837,13 @@ static int cdns_xspi_adjust_mem_op_size(struct spi_mem *mem, struct spi_mem_op *
 }
 
 static const struct spi_controller_mem_ops cadence_xspi_mem_ops = {
-#ifdef CONFIG_ACPI
-	.supports_op = cdns_xspi_supports_op,
-#endif
+	.supports_op = PTR_IF(IS_ENABLED(CONFIG_ACPI), cdns_xspi_supports_op),
 	.exec_op = cdns_xspi_mem_op_execute,
 	.adjust_op_size = cdns_xspi_adjust_mem_op_size,
 };
 
 static const struct spi_controller_mem_ops marvell_xspi_mem_ops = {
-#ifdef CONFIG_ACPI
-	.supports_op = cdns_xspi_supports_op,
-#endif
+	.supports_op = PTR_IF(IS_ENABLED(CONFIG_ACPI), cdns_xspi_supports_op),
 	.exec_op = marvell_xspi_mem_op_execute,
 	.adjust_op_size = cdns_xspi_adjust_mem_op_size,
 };
-- 
2.53.0



