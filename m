Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A011A7045;
	Wed, 20 Nov 2024 12:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107567; cv=none; b=U89+cvEw089A0qPnO8LnsV2fVu1XOOqj6V09ralf6Z3tLlEF0qjQaq1hoCEjpOIw6hlcaQOQi30+K8LtPeQNFw9Cj1yI8SdR0xL9ehdC7pSA2gbFy5ym7kDGAfLkU+KkwvCfAg50KVZ6olQ2J42V0bguVaPIK2EQ9kfuLtS461U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107567; c=relaxed/simple;
	bh=Sz4w4gwHdhPKkfckhkeaTYUx8na9vXn8b2Kp5aB/vUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+BB4E8nb9QD5JYG6UWi3TfIvK/y6ZeNh2PGfUfGCUIufdY52BsYoz/BQikdLqNpt2GZfGzeN8LZfzGLjcqyodqpecr01YpMtKVE0J33hOEXjHuUuJ01HPww8fS1shKqMIpoTUOlclqmQGNdZhyOJJZuz+2dxfPAjLGcGJvkEiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+obKvZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+obKvZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8E9C4CED1;
	Wed, 20 Nov 2024 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107567;
	bh=Sz4w4gwHdhPKkfckhkeaTYUx8na9vXn8b2Kp5aB/vUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+obKvZ3OJZ4w979cXzNYnEkd73CpB/Ke5yueFx7RJcMH6JlulnSdDRWDKLvdHaDW
	 MtsCTk9p3F09+BiYOH4oTEzwYu1SjWkratrb5xF4KfuUMRzecLfrqed/BnynIaZzbq
	 H/jf+tYTth6t3oipEdJdqZgJZJDz0JwKIzSjgVGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Parthiban Nallathambi <parthiban@linumiz.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 082/107] mmc: sunxi-mmc: Fix A100 compatible description
Date: Wed, 20 Nov 2024 13:56:57 +0100
Message-ID: <20241120125631.538027637@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


