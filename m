Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CD31AF0BC;
	Tue, 15 Oct 2024 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996927; cv=none; b=C+C5GbJCGsJ/fpYRSGiLyZnvUxXr+AcvPGue4hbG++hPL7//4oKVCHffQIlwNUM3Dla6LV/0xbXiwFDCyGhGrP8AK+5w4OaqqFm9m/Gda4qJPeC1uaLun2BC5NG4KTU4wGqdYrlC3Q98+VkE6LQy+n9wkMHthtZtImT1iBPbbjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996927; c=relaxed/simple;
	bh=lTON//Up3WMuqmR414u00eg5gW2/FNWFC4FMHBiKKOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wm3JwVKkKcT+QlOxYPM+MkJIdwwhG02b5vOw05AIZvMV1bQMSEHRw8WA4rKnLSQ29HaAirgW0LU97ceqwkfEpd8fQbx+9FhlI/Zj8yM5pG9JyefDrCtcngDsecVrEDzE+4X1dYdjlB1lwkmg5U0+ZCFhtrIohvBGTiLONyBbkzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OCRlTT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OCRlTT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103A8C4CEC6;
	Tue, 15 Oct 2024 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996926;
	bh=lTON//Up3WMuqmR414u00eg5gW2/FNWFC4FMHBiKKOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OCRlTT/VBNedXgE6bg2ZpwXPC0a1OB+n8zdDHQ0F4R5L5bNJ0+wZWgUnyVcgyPqV
	 +WplLPGDlB9qQlbuuz7c03j6mc3XCRUkn3+d83717HCui0pCWXWRLv9oKKS/snTEJW
	 6M6vJeS39TfIez3YXk4zkiUVAPN1STxKQKw8h+NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/518] spi: bcm63xx: Enable module autoloading
Date: Tue, 15 Oct 2024 14:39:04 +0200
Message-ID: <20241015123918.550619835@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 709df70a20e990d262c473ad9899314039e8ec82 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240831094231.795024-1-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index d36384fef0d71..5f7eb0e613cda 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -482,6 +482,7 @@ static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6358-spi", .data = &bcm6358_spi_reg_offsets },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, bcm63xx_spi_of_match);
 
 static int bcm63xx_spi_probe(struct platform_device *pdev)
 {
-- 
2.43.0



