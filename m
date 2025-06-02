Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2862248A6;
	Mon,  2 Jun 2025 14:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874650; cv=none; b=XscXC4uZwkG/qtd7KGnZc1mEi7JACcVtKS79N/rZgRfOJmkD54flx+VEoMfpSa/0DV491SHu/JdnJhDIy13h2n8WnKQxk0JeO/5O3H1CTYiIcZIevcatIoZkh2WJbm/PycoSw2FVcfGtSjW3VjC0UbddrZNpDyRaaiaZl2l0VY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874650; c=relaxed/simple;
	bh=DhmlS+BkoUZvh3Ga+BpLJZIxjIQqjcGeOVAQllg/rJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYS2LOLStsv1I/TtvA8eym6KKIZv2+Dhs0gWW1MT11gLVtkl7fortqw0gWRLjMRPH9GPHXDAuc06NCj1hI7X2XUT3rZT3Z0Xpvx44Ot2cg5F51Rj1sGsylzosA3YMP9ktbQohGH9RXTQ89bA6jOOyeRLerYb5h1/+7F6H4wPRxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajLdsEZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajLdsEZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2B3C4CEEB;
	Mon,  2 Jun 2025 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874650;
	bh=DhmlS+BkoUZvh3Ga+BpLJZIxjIQqjcGeOVAQllg/rJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajLdsEZ63Xvcx+J4f6fQ2oK5vmVUHviBW94e2FpC9ZRGNkyFmDpS7S6XySpwrTm28
	 cL+K46XqTtBFjQywlR6vztAKpjSDkXZCJPz8RRol49caiRrYGmo9qdAK2QaXDgl4AS
	 CwtpebKc8y+IK5f8OnZ9RqJq6lqQnyC5zibCHXQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/204] fbdev: fsl-diu-fb: add missing device_remove_file()
Date: Mon,  2 Jun 2025 15:47:04 +0200
Message-ID: <20250602134259.238891885@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d4c2a6b3839ec..3dc399704adc1 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1828,6 +1828,7 @@ static int fsl_diu_remove(struct platform_device *pdev)
 	int i;
 
 	data = dev_get_drvdata(&pdev->dev);
+	device_remove_file(&pdev->dev, &data->dev_attr);
 	disable_lcdc(&data->fsl_diu_info[0]);
 
 	free_irq(data->irq, data->diu_reg);
-- 
2.39.5



