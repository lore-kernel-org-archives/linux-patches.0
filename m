Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B08168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E8CC433EF;
	Mon,  8 May 2023 10:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540152;
	bh=kt4SL8s8/N0gTflDgFFe3rKG/F8ZNMjBOvhF1xQjP3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvKLG+9IDgqfe8L4j+KBf+A8pjnR3MJDBjU8t3Xz5Or0PtkBhBfadwpZaxoXfstgb
	 IM3SZnSoQBvfFCuGA6uk1d3bXOWymmVdzaM12UlqCJpj1u3wGi+T+Pk+KbPWMYwOGF
	 BCZUkVE1jr/s6mM35nJdoTL9+NJY1OWdE4/4sCgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 257/611] media: mediatek: vcodec: add remove function for decoder platform driver
Date: Mon,  8 May 2023 11:41:39 +0200
Message-Id: <20230508094430.774748211@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit e2a10b3801061d05d3e3415b9b824251451cfd6c ]

Need to disable decoder power when remove decoder hardware driver, adding
remove callback function in the definition of platform driver.

Fixes: c05bada35f01 ("media: mtk-vcodec: Add to support multi hardware decode")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/mtk_vcodec_dec_hw.c    | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_hw.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_hw.c
index 376db0e433d75..b753bf54ebd90 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_hw.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_hw.c
@@ -193,8 +193,16 @@ static int mtk_vdec_hw_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int mtk_vdec_hw_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
 static struct platform_driver mtk_vdec_driver = {
 	.probe	= mtk_vdec_hw_probe,
+	.remove = mtk_vdec_hw_remove,
 	.driver	= {
 		.name	= "mtk-vdec-comp",
 		.of_match_table = mtk_vdec_hw_match,
-- 
2.39.2



