Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDBB27456;
	Thu, 20 Jun 2024 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896884; cv=none; b=Ec+BDOacuQ8Jhj2/7XIhzrRhtdwhq+Z84d4omFYXqND6K7g9sHnPrG7ZHMyW2UwnxLliF4AVuWQJAcfwXM8r6DNWr8ejilOehsu0SNBH/dPvo6fL3RDoRZT9qlzuKAYsXqtb+fPiNptlzf57R+dur2FSn/DiiC0YhIdx7aDJdUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896884; c=relaxed/simple;
	bh=8/TFVK6BbkaFtuuCTEO1cNehJdCtbENbX/plMk2ZWeY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=cao5hXhXjz4uQnWJz3uQq1V/+s7mN68F8CresFtrDoPL+IiZDl5DF6ZiFGOAzjGctAKA7OtaNgfJgbLcYdjQMZM4OFT5N6EUEXRpDP8rMwi0CAEkBPJLys82Q6yPhorZpO/xki4AgThJZYYAkBekvacN+C2QmHBfJ1sZ4Zv/8TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1/bWsLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1/bWsLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53495C2BD10;
	Thu, 20 Jun 2024 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718896884;
	bh=8/TFVK6BbkaFtuuCTEO1cNehJdCtbENbX/plMk2ZWeY=;
	h=From:Date:Subject:To:Cc:From;
	b=n1/bWsLXWbvCjFPzJ3L6nFPy/fcfokpv2EoyJ5a9ffixVZ5V5GCAzoJfYNY0z0Q6X
	 OZtgsZy8IseX5K7xqNJ9QzTjYvEGtXUtB96hMBGZiKnRTHgc1/mHOgk0KBv4P8bG8K
	 KISGpyhrh8ys40BxwxSt0XUR0aZwg0yfCOXgDjeKjtUpJiKkX7v6cW5qSe9soZr4U7
	 ccPHjWbGMvChUJ/Xl8xQHFKQH2hVix1XRu1UKLC/2SUXR1v+/r0utmeCeHlKnz2RH9
	 RZW4nKKsRniIoxn5LMZzUOZ61oPD+ZzYUFtQ6r3bcbRuUwFUqMOx0R8aeP28HMy3qD
	 mKQNfrrwtck8A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 20 Jun 2024 08:21:15 -0700
Subject: [PATCH] phy: freescale: imx8qm-hsio: Include bitfield.h for
 FIELD_PREP
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240620-phy-fsl-imx8qm-hsio-add-bitfield-include-v1-1-5c7c09ed87e6@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOpIdGYC/x2NQQqDMBBFryKzdiAGKbVXKS4SZ9IMxNQmKhbx7
 h0Kb/MW7/8TKhfhCo/mhMK7VHlnla5tYIouvxiF1MEa25ubNbjEL4aaUObj/pkxaoCOCL2sQTg
 RSp7SRozODz0PvvMK6NxSOMjxv3qO1/UDMkIpiXoAAAA=
To: Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>, Frank Li <Frank.Li@nxp.com>, 
 Richard Zhu <hongxing.zhu@nxp.com>, linux-phy@lists.infradead.org, 
 imx@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1366; i=nathan@kernel.org;
 h=from:subject:message-id; bh=8/TFVK6BbkaFtuuCTEO1cNehJdCtbENbX/plMk2ZWeY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGklHp+vxvTuUeGex1hv+rdJrmmbxKkcPcnCo3zMe7U/V
 nZ90TrfUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTAC5yl5HhmtWXZ6cj8xyuPvlx
 eWHz5D0WR8OsbV4f+sbMs1Gl1ypwG8P/sqdL1jxjyUo8dCzEJyA6Zd3hr+17WQ+8FqtQX/1lU48
 GHwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

In various configurations/architectures, bitfield.h may not be
transitively included, which results in a compiler error because
FIELD_PREP is an unexpanded macro:

  drivers/phy/freescale/phy-fsl-imx8qm-hsio.c:459:8: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    459 |         val = FIELD_PREP(HSIO_MODE_MASK, val);
        |               ^
  1 error generated.

Include bitfield.h explicitly to fix the build.

Fixes: 82c56b6dd24f ("phy: freescale: imx8qm-hsio: Add i.MX8QM HSIO PHY driver support")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8qm-hsio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
index dcf9c45ff5d6..5dca93cd325c 100644
--- a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
+++ b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
@@ -3,6 +3,7 @@
  * Copyright 2024 NXP
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>

---
base-commit: 82c56b6dd24fcdf811f2b47b72e5585c8a79b685
change-id: 20240620-phy-fsl-imx8qm-hsio-add-bitfield-include-ab94e9b1bb1b

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

