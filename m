Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D984227EB2;
	Mon,  2 Jun 2025 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876657; cv=none; b=d83Oqco7KYCSEIduDtfW25Hwu2cBFM3dJ3qPX66arxc3Y6Bu4SVfqf9i8OgFMn93GLxNGze4/CslznTNIXcoSewE4N/QZboHW2x8hIy11ZIScvXA1JSy5jsrq5Nam5pxCd+78skNamfVFR/xMf1y4DuiMyCE4I2Y3015sWuBdOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876657; c=relaxed/simple;
	bh=uhPuurN+3eVIS+j+nFmWDRdAEAtPtVqQlYVSiSuiL5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITJcOdx8uBKPEZpa5YVgy2tQSGdNIJRbQpPicZl8Cc2b1gyp44MXZuwo/So3Aq1wAA2Dw0L7C87lOodClKN40/rgJlKtnjURCkIGKl2FpJttxSYxn8mkgI/91xdZu1LDy8nEL5PMo9oFWeilRZRnCo5pv35Tjddu4nhQxrOxfKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQM5q7Rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQM5q7Rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482A5C4AF0F;
	Mon,  2 Jun 2025 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876653;
	bh=uhPuurN+3eVIS+j+nFmWDRdAEAtPtVqQlYVSiSuiL5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQM5q7RkuSMGiB4sUpxGXmeqfpWiDdQ5vLfLTBgGJPTSUgJAx7cyVy0cHTEr9aPAI
	 XYNnOoX0DtICpZ3krI2frJ8PxvMStTnNZESwvR1bKeLlcq/eGl2JM/0jyc3Vrbey82
	 /6TUhl65aUNyVELIFfBILPXPU3Rixe9pz+jarQdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/325] fbdev: fsl-diu-fb: add missing device_remove_file()
Date: Mon,  2 Jun 2025 15:45:07 +0200
Message-ID: <20250602134321.011932748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 86d16cd12efa547ed43d16ba7a782c1251c80ea8 ]

Call device_remove_file() when driver remove.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/fsl-diu-fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/fsl-diu-fb.c b/drivers/video/fbdev/fsl-diu-fb.c
index ce3c5b0b8f4ef..53be4ab374cc3 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1829,6 +1829,7 @@ static int fsl_diu_remove(struct platform_device *pdev)
 	int i;
 
 	data = dev_get_drvdata(&pdev->dev);
+	device_remove_file(&pdev->dev, &data->dev_attr);
 	disable_lcdc(&data->fsl_diu_info[0]);
 
 	free_irq(data->irq, data->diu_reg);
-- 
2.39.5



