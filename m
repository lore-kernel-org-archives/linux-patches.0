Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E088825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9ECC4339B;
	Fri, 10 Mar 2023 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460232;
	bh=C/RVIuRjnjhpAgk1NrCJdkNe5Mf50E0c27olJnMSPpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZoi1V8uMzi4heddIluMjQkpcbBFXPCE1jSrRX6vZb+9HgZ5IFGGdMXM0HpKVXbDC
	 xU0mGQwfXqsTDJ38MMD6c49dW6OgnLVHgwC+AQ5uxiVs7U/LsK/eMmlmsAgSEPCiJG
	 BlR3fXcudtO5tdyJSl3hUFyuPjUU9QkPSwpRafsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/529] media: platform: ti: Add missing check for devm_regulator_get
Date: Fri, 10 Mar 2023 14:36:49 +0100
Message-Id: <20230310133817.300886636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit da8e05f84a11c3cc3b0ba0a3c62d20e358002d99 ]

Add check for the return value of devm_regulator_get since it may return
error pointer.

Fixes: 448de7e7850b ("[media] omap3isp: OMAP3 ISP core")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1311b4996eceb..21c16698cc2db 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2297,7 +2297,16 @@ static int isp_probe(struct platform_device *pdev)
 
 	/* Regulators */
 	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy1");
+	if (IS_ERR(isp->isp_csiphy1.vdd)) {
+		ret = PTR_ERR(isp->isp_csiphy1.vdd);
+		goto error;
+	}
+
 	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy2");
+	if (IS_ERR(isp->isp_csiphy2.vdd)) {
+		ret = PTR_ERR(isp->isp_csiphy2.vdd);
+		goto error;
+	}
 
 	/* Clocks
 	 *
-- 
2.39.2



