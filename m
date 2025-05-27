Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85242CCC0;
	Tue, 27 May 2025 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364466; cv=none; b=o+O4ciLtsAsM9GzTRuwA5VsitDduYhtmTOm9tk08XZnJaElRpEl03tl5LqkuYZWOKRHbDf9aLJNudSfFJIhiPgke7nBsTQge44C4vSIUPdm+QdEKfIKdaUpZPprXTkEBwnO396bRYYt+vcfsjyUGIbKaqZd75iJ2FMVbbEkABSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364466; c=relaxed/simple;
	bh=zL9UWgxS2hizKxfzMIdEZ9rr4cmSyxHzx7z3irw6gEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umHpc/dG+KfTFIWSeAm3gnlsVsebmrxGopxhD1YvAmHZDvYq6FghdqmqDPByqoa2aK9jjsCUQ+U4j58qA9RZt9z7iNS01BH2M6BnRadrzvFCe78yVP5ZnUrRbT6do+cDVmCdiMseXsDsRV5SouqntRa++s/GB68pLgfYfbFBqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6OGnD4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6OGnD4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FF3C4CEE9;
	Tue, 27 May 2025 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364466;
	bh=zL9UWgxS2hizKxfzMIdEZ9rr4cmSyxHzx7z3irw6gEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6OGnD4SyPjUFGx8n2SfDtEdRlry6V2IIj5TN2e92YE1oSaQoUpM+hOMEbUYI51d0
	 IrI5fbir1JZSEsv1UK8x6vV6vJYQobHiZ/al6/I5CFr8sXci9z3zPupbxQfDwiEdrx
	 D6VZzTt2ukM34mQERMup2iGET4qFiR0Xjz30sleE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/626] fbdev: fsl-diu-fb: add missing device_remove_file()
Date: Tue, 27 May 2025 18:19:18 +0200
Message-ID: <20250527162447.693986242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5ac8201c35337..b71d15794ce8b 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1827,6 +1827,7 @@ static void fsl_diu_remove(struct platform_device *pdev)
 	int i;
 
 	data = dev_get_drvdata(&pdev->dev);
+	device_remove_file(&pdev->dev, &data->dev_attr);
 	disable_lcdc(&data->fsl_diu_info[0]);
 
 	free_irq(data->irq, data->diu_reg);
-- 
2.39.5



