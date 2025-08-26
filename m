Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B838C233128;
	Tue, 26 Aug 2025 11:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207979; cv=none; b=kD7PTpUCKJY5tS6DRxsNZB+guo+txlSSMa6Y1IHJ/EKNqxiG+4jhS1RhvKMESX4hHun1WX91aTp3dEj3oBH2KbiBqWwv9wQ/3GLOlI8OajhAIt2VVc8sKy1bV9MYWjXOmxkqe1GbuZ8YvwgWgtRJCsDxQi5KNOyHUsU0a4dH+Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207979; c=relaxed/simple;
	bh=MBNcs4ghxD+LCO25sZQKxqLYkTqaozmb6ChHvfiQp9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeBTki3fKOjSHM/5ugmh9z5FPDEFI3KVAsY/RlkwuLBZgdq8ePdPnPuKq37VBxcfNnvw9IeCBk9ikS6G6jzfgJIyRVKGYIEWwTcT9wh02fyRhuT0SGlOD6M8PkXKtRyTwK8ubQB1pa6sKYEaceWJA9T3+0DQgYDzeTFaY/UbDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lH5x+mW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lH5x+mW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47586C4CEF1;
	Tue, 26 Aug 2025 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207979;
	bh=MBNcs4ghxD+LCO25sZQKxqLYkTqaozmb6ChHvfiQp9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lH5x+mW93kyEze6wQqpJVVKnpAevsnHpBO8l5uf7NXSq9jXC3OWhA3PpwP36vuUS6
	 veagJ9PeMb5XvddkLdP+HTZS0EOIP1xvrR9jg3IhX9WhlWx3RbH+yIoLNrGBFC9/si
	 fwE33nU/LbdgFf3R0lKmq1F0UR32QVXg7Jef+IYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 392/457] drm/hisilicon/hibmc: fix dp and vga cannot show together
Date: Tue, 26 Aug 2025 13:11:16 +0200
Message-ID: <20250826110946.982525469@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit 3271faf42d135bcf569c3ff6af55c21858eec212 ]

If VGA and DP connected together, there will be only one can get crtc.
Add encoder possible_clones to support two connectors enable.

Fixes: 3c7623fb5bb6 ("drm/hisilicon/hibmc: Enable this hot plug detect of irq feature")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250813094238.3722345-8-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
index ac552c339671..289304500ab0 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -115,6 +115,8 @@ static const struct drm_mode_config_funcs hibmc_mode_funcs = {
 static int hibmc_kms_init(struct hibmc_drm_private *priv)
 {
 	struct drm_device *dev = &priv->dev;
+	struct drm_encoder *encoder;
+	u32 clone_mask = 0;
 	int ret;
 
 	ret = drmm_mode_config_init(dev);
@@ -154,6 +156,12 @@ static int hibmc_kms_init(struct hibmc_drm_private *priv)
 		return ret;
 	}
 
+	drm_for_each_encoder(encoder, dev)
+		clone_mask |= drm_encoder_mask(encoder);
+
+	drm_for_each_encoder(encoder, dev)
+		encoder->possible_clones = clone_mask;
+
 	return 0;
 }
 
-- 
2.50.1



