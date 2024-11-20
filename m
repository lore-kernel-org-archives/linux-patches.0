Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9931C9EA7;
	Wed, 20 Nov 2024 13:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107674; cv=none; b=hVkItTwAJtQfC7Op0N0ZzcY89qzKvxkBKEB+cnDRgHKpwd3RWVPW7OdrSyY0dsxoiV8wtD2b5sYwU5oGQM9oet/9zMoKkKV9m29EfJ+dH4syD+ZjkKX7ldOzy9Jv8U1fpygxshAC0kYA2l2L0rk/HCrz14rv9wQJtug+kJx4wc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107674; c=relaxed/simple;
	bh=G8NfFuhqAXDA7LI78WSyCAFSUHqNefs59gJF47NrQHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjGnglyPujuYsMZNtAzD9K8kQ6yDwrKU5WQMIetpmVz06qFRoS3WFatiJKJUsLPebH8rzC67m48xNort6qh1xGgv/3wJdOGcEBF6achTMP3gSyaRzN4ne73ZzKHQmx65Sd3EHDq66k6XcHXAKljg0WSrPRMRPFW37PVp/nhf9YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyQDXXqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyQDXXqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5A2C4CED6;
	Wed, 20 Nov 2024 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107674;
	bh=G8NfFuhqAXDA7LI78WSyCAFSUHqNefs59gJF47NrQHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyQDXXqigUlRr10tWe944b9wHY1H9mF5nN1DArsCWoQj86sdT8Osi10kQqBR1QucJ
	 moeTgIC2j0+c5lAFRYuuSoVM4jRzN8Yiu+Wr37rpv5dBIqbKRG6ajngLzzFbOcqmT/
	 Jeqsreo82e16c2Er3u9dmHfG6zDgKSbhbaz8Nn7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Parthiban Nallathambi <parthiban@linumiz.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 31/73] mmc: sunxi-mmc: Fix A100 compatible description
Date: Wed, 20 Nov 2024 13:58:17 +0100
Message-ID: <20241120125810.359451084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


