Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC4682871;
	Wed, 19 Jun 2024 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802314; cv=none; b=L/06NlXbbdSQ3loW7ojUecIN6PmGrWGeNPtBWiiVHErKPjVEWTaUnnLHyl9Frq+GyKlyYXbthf4Uzah6fBLd6TrrcjQt1OCQbZ6Q9G+B/0xtYEFN+cSaLIPUQLmaZ0emlt4DN4/BAXOZetVQS8nOaxxFB3EgIAOj4ClvqPeS8JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802314; c=relaxed/simple;
	bh=Kcc2u825nY2vuDluT9UqFoN+CgEuL4/rv3eZbf+ZofI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRPac+4Pdj5/QtzMAIjTSzbM7abe9udsSBTm4rtg2ITrr4aeAVwcoqkNUtNSzDXmcuU5GF3UyGCBorzq60San4PXtFWk7KMFoVbSRkXfXB/ub+T7pn2vFnjtDzNILNl9Bf9a8DGnQ5G3v783TBCxHpeNHNoZ6cLByx61eq7mbAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDI33j5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDI33j5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26E0C4AF1A;
	Wed, 19 Jun 2024 13:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802314;
	bh=Kcc2u825nY2vuDluT9UqFoN+CgEuL4/rv3eZbf+ZofI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDI33j5Bm16BL+i0cymBA2HqLtXMddtl01ZpjlWJcOVymotIfmb3aoZZn9axepRTn
	 o1cSSKlqNMGQM8/KsHxSSYpAoRDT327M5ibvhZjJVSzBflE3t0QWMClcyp+8Ho81dw
	 WBS/EViNXjNDrhsa8/T1qMSZauSEb8YH4s54sek8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Michael Riesch <michael.riesch@wolfvision.net>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/267] drm/panel: sitronix-st7789v: Add check for of_drm_get_panel_orientation
Date: Wed, 19 Jun 2024 14:54:34 +0200
Message-ID: <20240619125611.069694355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 629f2b4e05225e53125aaf7ff0b87d5d53897128 ]

Add check for the return value of of_drm_get_panel_orientation() and
return the error if it fails in order to catch the error.

Fixes: b27c0f6d208d ("drm/panel: sitronix-st7789v: add panel orientation support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Michael Riesch <michael.riesch@wolfvision.net>
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20240528030832.2529471-1-nichen@iscas.ac.cn
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240528030832.2529471-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
index e8f385b9c6182..28bfc48a91272 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
@@ -643,7 +643,9 @@ static int st7789v_probe(struct spi_device *spi)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
 
-	of_drm_get_panel_orientation(spi->dev.of_node, &ctx->orientation);
+	ret = of_drm_get_panel_orientation(spi->dev.of_node, &ctx->orientation);
+	if (ret)
+		return dev_err_probe(&spi->dev, ret, "Failed to get orientation\n");
 
 	drm_panel_add(&ctx->panel);
 
-- 
2.43.0



