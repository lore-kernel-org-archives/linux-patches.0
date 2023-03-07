Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EF3BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDC3C433EF;
	Tue,  7 Mar 2023 19:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215701;
	bh=oDehS2ecHu9DUkquoaVe3JvE8OVuR+7t1Z0/smEHBfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4bqeilUEf8hSZYDoyxBYIWHqxP90AHuIpYAzZozBcfdRn3TcRZtBz9tv4xdoCRCe
	 EZ8tjDo0JHzsTFLqKaUjUo4xFh8WBcgWAO8wag5zFIYzmhzxy6gm9WSQ6425Oy1fXF
	 SqG33iHXjjeRze7nzpllRLQ6/gCSqAiOa1Agx85A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/567] media: platform: ti: Add missing check for devm_regulator_get
Date: Tue,  7 Mar 2023 18:01:22 +0100
Message-Id: <20230307165920.863646305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index 20f59c59ff8a2..3222c98b83630 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2306,7 +2306,16 @@ static int isp_probe(struct platform_device *pdev)
 
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



