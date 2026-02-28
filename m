Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A121175A7E;
	Sat, 28 Feb 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301393; cv=none; b=LcekX2m51cNtNNoN/YBp/oQKLF/M9INXtMaqdYtulhVkoWG3hefOLra54bQib7cphbnM3XPjELF+RuuzB7nliPVm3UmOYQIFGn9sJqiXspegb7stmQA7K37+sYvJQXfWw5Hn7B5AVCl2si+dEbZlQspTkBEmMO1S+cxk4a2qKJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301393; c=relaxed/simple;
	bh=3N2WL6347zenZWHoCxHm+ZIceA41zQD5jFthGbV551c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOU5Ng5rv6DTiI9TD9tupk8XiFlB8yLsCs4qRtKDz1sKtZuRTjWKBOJ7e2m4eLRBYU7lyNg0NRFuuUPcXGVLB/hIBfpGYgF8o4p1n4FCAYP7U7qgk95T1v133Rpm6/ODLnxWCqlOaqzeQC/SQ69cbdaaWI5oEE0K3pTI9JifzFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrs79DPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrs79DPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852B1C116D0;
	Sat, 28 Feb 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301393;
	bh=3N2WL6347zenZWHoCxHm+ZIceA41zQD5jFthGbV551c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrs79DPHHjnu6GCvuNhQtVJXcCMSpFZfOs9WQgOddp9pK1eh548osfEANu7cFpERh
	 OQHuoYcX74OZxSQnepnnh7gGcAC6134eX8SS738ztfj4/W2oYXo6VwDzl040TLqudB
	 kqDipvzTIjQwAafEWA5g97UJvOkTg8OWsUJoG8dDd4+ykmvmBmXhf2zLXrY847mPrI
	 NoLLFN9f1ri2l8DffFmOxI3fMEOMiOMiq1TpCRidGsMEWxg50MVYrF0REKn87Nygm9
	 44LSU1suoFWrnRjfEBQ5TlJR2RRFsaHPcRQB18SHCWX1lIzo70JLiarTUGxv6MZSzH
	 pPEfuKUzvOwvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Xu Yang <xu.yang_2@nxp.com>,
	stable@vger.kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 581/752] phy: fsl-imx8mq-usb: set platform driver data
Date: Sat, 28 Feb 2026 12:44:52 -0500
Message-ID: <20260228174750.1542406-581-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit debf8326a435ac746f48173e4742a574810f1ff4 ]

Add missing platform_set_drvdata() as the data will be used in remove().

Fixes: b58f0f86fd61 ("phy: fsl-imx8mq-usb: add tca function driver for imx95")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260120111646.3159766-1-xu.yang_2@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
index bd37b6cb69cdc..8e7b6e10e1f0b 100644
--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -662,6 +662,8 @@ static int imx8mq_usb_phy_probe(struct platform_device *pdev)
 	if (!imx_phy)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, imx_phy);
+
 	imx_phy->clk = devm_clk_get(dev, "phy");
 	if (IS_ERR(imx_phy->clk)) {
 		dev_err(dev, "failed to get imx8mq usb phy clock\n");
-- 
2.51.0

