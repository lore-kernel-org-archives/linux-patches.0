Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9A226F46F;
	Wed, 25 Feb 2026 01:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983943; cv=none; b=CDFnaRN1pM6jL0zMLREZl9F4PYMuuvc8hrIbrngMf0kyBiGvVbrqhNDmpy0nLGYDSb4OrI0alzo3Q+41l1q1mLmQr+KhtFiNCMU0DSootj14jofKhJQZgSTSP2Hdn1PUN73iLL2TKFPwLygnMfL46nvn1hLPbMKjlrvwlPZ4Teg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983943; c=relaxed/simple;
	bh=jQ4DRqcdheopcNFcig2hUsR+M8t3Y/iPe2nJXnvzlIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUvD5ZwnvaR47Z9XjIxS9SHKgdXOJMv1ZihKHkyIAVW2E5uI1rIDAiulYBSYgSVM/9III89GKL3/bv11Gbz79L7weYLpfsrOEgOOPb3bebGQt3AV9Lmyvaf2Jo7WlbEo7nnz3AB0hixCVNK1pCJ7AG6PMnNr4FqeQ6pyDGqDqd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYpb7xNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYpb7xNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CEFC116D0;
	Wed, 25 Feb 2026 01:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983943;
	bh=jQ4DRqcdheopcNFcig2hUsR+M8t3Y/iPe2nJXnvzlIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYpb7xNLLGJsTlDpnSD5WTqnvZEQ1RumoUK4AWQAv87+m/rHqpNKrDLkwdoZ9lbM0
	 fgcqJmWFtJCanOy10UCzz36dTp0IXQX16HC1aq4OR5rt6BqDIiMMwpioMCZMnZ/QGS
	 Ta6LmQg8PkgwWAYeL351tvFFEDyd4HFuK+C6FMNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Tao Tian <tiantao6@hisilicon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/641] drm/hisilicon/hibmc: fix no showing problem with loading hibmc manually
Date: Tue, 24 Feb 2026 17:18:53 -0800
Message-ID: <20260225012353.974552039@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit 0607052a6aee1e3d218a99fae70ba9f14b3b47ed ]

When using command rmmod and insmod, there is no showing in second time
insmoding. Because DP controller won't send HPD signals, if connection
doesn't change or controller isn't reset. So add reset before unreset
in hibmc_dp_hw_init().

And also need to move the HDCP cfg after DP controller de-resets, so
that HDCP configuration takes effect.

Fixes: 3c7623fb5bb6 ("drm/hisilicon/hibmc: Enable this hot plug detect of irq feature")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Tao Tian <tiantao6@hisilicon.com>
Link: https://patch.msgid.link/20251210023759.3944834-4-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
index 37549dafa06ca..8f8ca940b6b26 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
@@ -177,13 +177,16 @@ int hibmc_dp_hw_init(struct hibmc_dp *dp)
 	dp_dev->link.cap.lanes = 0x2;
 	dp_dev->link.cap.link_rate = DP_LINK_BW_8_1;
 
-	/* hdcp data */
-	writel(HIBMC_DP_HDCP, dp_dev->base + HIBMC_DP_HDCP_CFG);
 	/* int init */
 	writel(0, dp_dev->base + HIBMC_DP_INTR_ENABLE);
 	writel(HIBMC_DP_INT_RST, dp_dev->base + HIBMC_DP_INTR_ORIGINAL_STATUS);
 	/* rst */
+	writel(0, dp_dev->base + HIBMC_DP_DPTX_RST_CTRL);
+	usleep_range(30, 50);
+	/* de-rst */
 	writel(HIBMC_DP_DPTX_RST, dp_dev->base + HIBMC_DP_DPTX_RST_CTRL);
+	/* hdcp data */
+	writel(HIBMC_DP_HDCP, dp_dev->base + HIBMC_DP_HDCP_CFG);
 	/* clock enable */
 	writel(HIBMC_DP_CLK_EN, dp_dev->base + HIBMC_DP_DPTX_CLK_CTRL);
 
-- 
2.51.0



