Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F18FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE35C433EF;
	Mon, 15 May 2023 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173334;
	bh=67jMBgXnE4m972y0CrvABDfaDDFYYJZHcEc9tYU95vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUbyJCP92vaFPhYbySyIai4oL/m5HuOTrFvZOmXM4UzFk4bHhehRm+/7o+2y0JIM/
	 OzAX0kgtuBOGaIKE6xBGDL+dj6GTGs0Zgl2LiHJB/28JVaUDeramhV6l0ZNOBHVcaT
	 xJWdPhtg7rGiRBjct9oDU0kuhZrtm58uLxGmBYK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Huoqing <caihuoqing@baidu.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/282] media: rcar_fdp1: Make use of the helper function devm_platform_ioremap_resource()
Date: Mon, 15 May 2023 18:27:18 +0200
Message-Id: <20230515161724.044001233@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cai Huoqing <caihuoqing@baidu.com>

[ Upstream commit 736cce12fa630e28705de06570d74f0513d948d5 ]

Use the devm_platform_ioremap_resource() helper instead of
calling platform_get_resource() and devm_ioremap_resource()
separately

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: c766c90faf93 ("media: rcar_fdp1: Fix refcount leak in probe and remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 9caddc8387b46..90575a58ad880 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2260,7 +2260,6 @@ static int fdp1_probe(struct platform_device *pdev)
 	struct fdp1_dev *fdp1;
 	struct video_device *vfd;
 	struct device_node *fcp_node;
-	struct resource *res;
 	struct clk *clk;
 	unsigned int i;
 
@@ -2287,8 +2286,7 @@ static int fdp1_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, fdp1);
 
 	/* Memory-mapped registers */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	fdp1->regs = devm_ioremap_resource(&pdev->dev, res);
+	fdp1->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(fdp1->regs))
 		return PTR_ERR(fdp1->regs);
 
-- 
2.39.2



