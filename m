Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055576;
	b=WX9PmsdZx21oOcPG1Id8TkajAsrpG4vJdYyVDYe/HOFGYRA87Xz/jrF5PfAslnHTHkK3
	 pCNYRnmLL1ykw5e4c7w8Qvx54S5w7giYAP+OZTlkHOJ4clGp/UCh5buFM/a8wvtuUfFRX
	 otrmGaGG2ROFhzk22sAL/5DnasbJrQ0kcdaaGk7jdyN58WP2NbQ/bZY9kGIROtneHIiAk
	 RidQYXrtAl/7zF8vnihGmN0uYVtmR0pArmE3i5/Z3UQU3Lcq8b+o3KG3MCfdj2IDxXd0Q
	 /GUl7PaQEaZvKCXaWQS41XfPJz/q2d5f9/v0xXaEfeamTyz57bCVpk+K2XDFclpAkJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KkPtlF5u3FBunNrPnQ574FFHqAQ/i3KUYwu3gUke/n0=;
	b=oZruJXzk5aabj66EhfboVb/QXs7nkpRGSdvXZmzEt0Euu1g0k5xtPFT/LbtE4ucsPsdj
	 /BtCucR37u5wTftmHkg2pU11huWtTSTvLMq5eHefG49lLtVHrTC/ZejG7c8WZ+MQORaiO
	 ukLp2rhAFsuuJrU/ii+hhQeoZzppWiV1wFZjIWYnn4dj7axkaq9eF8w2cnCwZ+GJ+vq3N
	 TY8mVWfDQRXzVYwHPf8omgORF0FYxHaYRepWOlpmJ8vVJFRR057bz2VRKG0hO3DF4QMWi
	 +tQP2Y/Wizn/rbsXYipYzwU0hJxq/xWF8LJSQdg0zq5PcdFCQ3+8W9/HldNsyvGe5NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfWc6RHa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4060A260D;
	Thu, 19 Nov 2026 02:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfWc6RHa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE49C1F000C4;
	Thu, 19 Nov 2026 02:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055576;
	bh=KkPtlF5u3FBunNrPnQ574FFHqAQ/i3KUYwu3gUke/n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfWc6RHay3jYr/UJBny3cJx7exzCT5xfJ5szu/wO2aCZY5olMKUdcSEQJVRgUJNAX
	 tndQDfgEJ+lPNypIwvpWRI9O+7axnEhlxP7R2VWbRxf6C5tBNkPrYIRkn3XyaO9rZv
	 yYfkFsc/Rmfe96yjxcSn/ZvPJGUAbfewtf9nHIGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1641/2214] spi: spi-rspi: Add support to deassert/assert reset line
Date: Wed, 18 Nov 2026 15:55:17 +0100
Message-ID: <20261118150117.572314149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit aadbff4af5c90919cbe67e2c4d77c68cdefa454e ]

On RZ/G2L SoC we need to explicitly deassert the reset line
for the device to work, use this opportunity to deassert/assert
reset line in spi-rspi driver.

This patch adds support to read the "resets" property (if available)
from DT and perform deassert/assert when required.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20211118031041.2312-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7b85114d47f6 ("spi: rspi: Fix DMA mode when the DMA controller is built as a module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index f634a405382cb..5d3c6fd09d903 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -21,6 +21,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/reset.h>
 #include <linux/sh_dma.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/rspi.h>
@@ -1226,8 +1227,14 @@ static const struct of_device_id rspi_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, rspi_of_match);
 
+static void rspi_reset_control_assert(void *data)
+{
+	reset_control_assert(data);
+}
+
 static int rspi_parse_dt(struct device *dev, struct spi_controller *ctlr)
 {
+	struct reset_control *rstc;
 	u32 num_cs;
 	int error;
 
@@ -1239,6 +1246,24 @@ static int rspi_parse_dt(struct device *dev, struct spi_controller *ctlr)
 	}
 
 	ctlr->num_chipselect = num_cs;
+
+	rstc = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(rstc))
+		return dev_err_probe(dev, PTR_ERR(rstc),
+					     "failed to get reset ctrl\n");
+
+	error = reset_control_deassert(rstc);
+	if (error) {
+		dev_err(dev, "failed to deassert reset %d\n", error);
+		return error;
+	}
+
+	error = devm_add_action_or_reset(dev, rspi_reset_control_assert, rstc);
+	if (error) {
+		dev_err(dev, "failed to register assert devm action, %d\n", error);
+		return error;
+	}
+
 	return 0;
 }
 #else
-- 
2.53.0



