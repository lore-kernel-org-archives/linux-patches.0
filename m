Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0984749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16186C433EF;
	Thu, 12 Jan 2023 14:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532479;
	bh=C7zSOxVWncV1jQ+W3PKDFJsLWUvmD7Grf3NtbQDWWqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdtcfthG6a2xMxIUV+ZlFl3hdFWGpfTRBW23L8e2y6fz4OTvtPEebZPwtEaQkdt0D
	 Ni/oZkeui6xl65kYAPh5b/oA9w98xKzkeITIMIvjARSR8kztCKlmEOQiI/bcVL5ZoE
	 4WmI1wEndj8rHSME33AG3OjcKJcDeld10suwQ6Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/783] media: platform: exynos4-is: fix return value check in fimc_md_probe()
Date: Thu, 12 Jan 2023 14:47:31 +0100
Message-Id: <20230112135530.583213499@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e38e42c078da4af962d322b97e726dcb2f184e3f ]

devm_pinctrl_get() may return ERR_PTR(-EPROBE_DEFER), add a minus sign
to fix it.

Fixes: 4163851f7b99 ("[media] s5p-fimc: Use pinctrl API for camera ports configuration")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 8603c578f55f..a9ab2a28fc26 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1470,7 +1470,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	pinctrl = devm_pinctrl_get(dev);
 	if (IS_ERR(pinctrl)) {
 		ret = PTR_ERR(pinctrl);
-		if (ret != EPROBE_DEFER)
+		if (ret != -EPROBE_DEFER)
 			dev_err(dev, "Failed to get pinctrl: %d\n", ret);
 		goto err_clk;
 	}
-- 
2.35.1



