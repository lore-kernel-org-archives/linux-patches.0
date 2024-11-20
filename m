Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794721C305A;
	Wed, 20 Nov 2024 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107600; cv=none; b=MSr320GEkUzFDz+7wxk55aYXN1W2uMN1Buk6i14qvqIlVLfgJB3jfiaFfRpKHn/nlSsrEBq4yBaPk9sXiHWkA/ZN3nhxDIfNc3dHVUNb8Swx25BVEeYBhfDfIbJdGv7IVrFkzidZLXfT4WDk2lPT/i021ksgFc7zvrAEJ9yCtX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107600; c=relaxed/simple;
	bh=RGNApLX6C1IG50/0kYa/xefMh9p0cgyl2+I2sRXHKZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNlc6PqMUtFLxpXc5QfKdYAK1P007tM3jLiYuNUHbjgk41mZruJrLXudOORgkALErnbGeOMm00NTcAMQpuxYlNT94AMvk6QREOJ6InegGVSjzZewrn0lXaprXNmKw3sc8+S0EAup9dZyd66dZpZs8kiWugU2VFwGE7OMjzsmq/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELrJkS34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELrJkS34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B17DC4CED8;
	Wed, 20 Nov 2024 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107600;
	bh=RGNApLX6C1IG50/0kYa/xefMh9p0cgyl2+I2sRXHKZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELrJkS34bBLlRouYiAY/5jrfp9FbncwubS9RH8DqLa/gGSRT43Mqzl0dPqhp5IXzA
	 FDsfFrZSvoVPYGv3a0vC0ZfZ//PNGpA/16GjsQ07su+DfcJR65evQF0XIIffK1oQB4
	 JXoXGRB8zH9l2E0e5K6fuQgiS6jwiCDdsAbKFCUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Parthiban Nallathambi <parthiban@linumiz.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 49/82] mmc: sunxi-mmc: Fix A100 compatible description
Date: Wed, 20 Nov 2024 13:56:59 +0100
Message-ID: <20241120125630.716314454@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andre Przywara <andre.przywara@arm.com>

commit 85b580afc2c215394e08974bf033de9face94955 upstream.

It turns out that the Allwinner A100/A133 SoC only supports 8K DMA
blocks (13 bits wide), for both the SD/SDIO and eMMC instances.
And while this alone would make a trivial fix, the H616 falls back to
the A100 compatible string, so we have to now match the H616 compatible
string explicitly against the description advertising 64K DMA blocks.

As the A100 is now compatible with the D1 description, let the A100
compatible string point to that block instead, and introduce an explicit
match against the H616 string, pointing to the old description.
Also remove the redundant setting of clk_delays to NULL on the way.

Fixes: 3536b82e5853 ("mmc: sunxi: add support for A100 mmc controller")
Cc: stable@vger.kernel.org
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Parthiban Nallathambi <parthiban@linumiz.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Message-ID: <20241107014240.24669-1-andre.przywara@arm.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sunxi-mmc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1191,10 +1191,9 @@ static const struct sunxi_mmc_cfg sun50i
 	.needs_new_timings = true,
 };
 
-static const struct sunxi_mmc_cfg sun50i_a100_cfg = {
+static const struct sunxi_mmc_cfg sun50i_h616_cfg = {
 	.idma_des_size_bits = 16,
 	.idma_des_shift = 2,
-	.clk_delays = NULL,
 	.can_calibrate = true,
 	.mask_data0 = true,
 	.needs_new_timings = true,
@@ -1217,8 +1216,9 @@ static const struct of_device_id sunxi_m
 	{ .compatible = "allwinner,sun20i-d1-mmc", .data = &sun20i_d1_cfg },
 	{ .compatible = "allwinner,sun50i-a64-mmc", .data = &sun50i_a64_cfg },
 	{ .compatible = "allwinner,sun50i-a64-emmc", .data = &sun50i_a64_emmc_cfg },
-	{ .compatible = "allwinner,sun50i-a100-mmc", .data = &sun50i_a100_cfg },
+	{ .compatible = "allwinner,sun50i-a100-mmc", .data = &sun20i_d1_cfg },
 	{ .compatible = "allwinner,sun50i-a100-emmc", .data = &sun50i_a100_emmc_cfg },
+	{ .compatible = "allwinner,sun50i-h616-mmc", .data = &sun50i_h616_cfg },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, sunxi_mmc_of_match);


