Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060963;
	b=bs3X5nsFBJRosoyehsjoKhtqAez12yjfbw9K1Qqur26ZQ3zmGmlqsDv9f8fk2eoTVLaZ
	 kuN11DB0eitLeOvbvo2Jvzf3oN9F6QScCXhLjrJzF5s1ge3Csmno1oy33MkkXhQlcF7YK
	 7X5CL0qcxYldIYd5va18fkwshHDwqRLE8GIn2AWm3t9W7S8Hfx2MA/0KwH7NVpkjkB5rG
	 OMpDWAVcAUqwckhYfYumPhX9IRLwWuFCfbLc+8vzfMgQRr5yLt8xu9FVbqYbJWFdsC9wl
	 B+XesdDyRkQPbTx8QL4G3DFTiXvsKC7FFirlYiMEh65K3W1f/LNzyqAyDbADQyEzndw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0bI3aReTV4IpZPfg7QtjO6JBm/oB/Bt7wvxbyg6+/bM=;
	b=UoW5Hwc9d4crZtjLqLPCEG2idNWTfO+jP9hJ1AAvGGbzFCRcUTjdDM8H6SorMC1piEhg
	 rcMII0HK6ctxyrcmOrtXhH8TdhO4rzsvzT1W2jhAYQG6+8TRjv0E64X5qgtEM7AlGA6iY
	 7+HpvY2rMrWSJ4cXkHFUt0DJH06MYPVaoRFw5CmqbELff5buYIpKc3wmujOt7WcGcTdvg
	 SwEzVf9GSgAMaNbznuPDvzF2rLh2h6xn0T4Pp6oI0CU2Imb0PqH1IC+2xW37b5qqktlQF
	 ynYaEPcIOewGX18Rcb/S2sTU0uZEsLvEB3tcMCVYEj4UEdOG4DTpgtw2aXbFegzE0XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yx7O0WbI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D910E606A320;
	Thu, 19 Nov 2026 04:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yx7O0WbI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70331F000C4;
	Thu, 19 Nov 2026 04:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060963;
	bh=0bI3aReTV4IpZPfg7QtjO6JBm/oB/Bt7wvxbyg6+/bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yx7O0WbItucWV+PYrkKtm4S+JwOAsSjTiIcO6OAJPXP8CSVGUAxtQyfx9lMVqqjNh
	 nD52crJ48Y7akP0/JDNrnSzUSsAjpzH5ZqrEw6hRTd9r27QCg0OSrJV3TUcV3UL7cy
	 +DAofKR52hdhP2VockisZ7+dNKQxd7/kOfU7G+Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1388/1848] spi: spi-rspi: Add support to deassert/assert reset line
Date: Wed, 18 Nov 2026 15:57:06 +0100
Message-ID: <20261118150017.563458186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 4600e3c9e49e4..7ff89313cae5b 100644
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



