Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A52A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BEDC433EF;
	Wed, 28 Dec 2022 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241442;
	bh=G/PD4AGUbPR3bk8hGVzUX5sR/bCPF6IaOvTccxBu8Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEq2KP2hr1m6/v/oUWtNwOWak0vz0Zm7J+GLnrVjyMERFkavdGk/hLhC/ime3ZjbK
	 z3GsyRr1o1vgXwF9VtwKefyP/TWtYey1g1e2KfL7yA6JkzYTja5lixvPRNLNHAX4OD
	 wdkDniPnjSvKNA3WHuXOvw3svojITlzYyd9wwUbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0284/1073] media: platform: exynos4-is: fix return value check in fimc_md_probe()
Date: Wed, 28 Dec 2022 15:31:12 +0100
Message-Id: <20221228144335.732584855@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
 drivers/media/platform/samsung/exynos4-is/media-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/media-dev.c b/drivers/media/platform/samsung/exynos4-is/media-dev.c
index 412213b0c384..383a1e0ab912 100644
--- a/drivers/media/platform/samsung/exynos4-is/media-dev.c
+++ b/drivers/media/platform/samsung/exynos4-is/media-dev.c
@@ -1472,7 +1472,7 @@ static int fimc_md_probe(struct platform_device *pdev)
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



