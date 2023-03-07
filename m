Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A546EBA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61B7C4339B;
	Tue,  7 Mar 2023 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211647;
	bh=CTQge/NrzhBmvbY55gPnYq5RnVPHKKbzrJu6dLdWwnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igPR1ARJgSoe92Hu/PE9R9q+DdCYbdqXjNo6gah5Zvh6qb3BcDIr3sQa1YmmWO/eC
	 YRZIL8gHaRx1VtArks7BOptSyU+i/k4Fp6VkTiC0c1UMD1fXOO3ppfiIx5dBZkVS9e
	 pZ0hlFuUzZTk3r6dhBC2S1mEsbCYd7o60jg2wVBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Dhruva Gole <d-gole@ti.com>,
	Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 6.2 0898/1001] mtd: spi-nor: spansion: Consider reserved bits in CFR5 register
Date: Tue,  7 Mar 2023 18:01:10 +0100
Message-Id: <20230307170100.961629350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit 3f592a869f87723314f0cb1ac232bd3bf8245be8 upstream.

CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
definition, stop using magic numbers and describe the missing bit fields
in CFR5 register. This is useful for both readability and future possible
addition of Octal STR mode support.

Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
Cc: stable@vger.kernel.org
Reported-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Pratyush Yadav <ptyadav@amazon.de>
Tested-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/linux-mtd/20230110164703.83413-1-tudor.ambarus@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/spansion.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -21,8 +21,13 @@
 #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
 #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
 #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
+#define SPINOR_REG_CYPRESS_CFR5_BIT6		BIT(6)
+#define SPINOR_REG_CYPRESS_CFR5_DDR		BIT(1)
+#define SPINOR_REG_CYPRESS_CFR5_OPI		BIT(0)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN				\
+	(SPINOR_REG_CYPRESS_CFR5_BIT6 |	SPINOR_REG_CYPRESS_CFR5_DDR |	\
+	 SPINOR_REG_CYPRESS_CFR5_OPI)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	SPINOR_REG_CYPRESS_CFR5_BIT6
 #define SPINOR_OP_CYPRESS_RD_FAST		0xee
 
 /* Cypress SPI NOR flash operations. */


