Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A31F47F53;
	Fri,  6 Dec 2024 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497181; cv=none; b=LCKMZssSyWUeQi6+oos4qEfQ8fIhOHmKYzQa7H2wF1APq8m63uc92jGdM8E3vxC30HOWRTBqzQ4xn6HjFbFuUhwlXhklBnfOnb2Wt0ZQGYsmqiMU5MYqjeKYxm136yGJJwBl9SYVWhLRhCKbwFPz4MHA/Bl/5wKNI4Wdy46iX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497181; c=relaxed/simple;
	bh=JUvawU68qudSwXDcEtvs5yHiJP9pB/BBrQVJ1ndjTBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv4CcMcwrxdOSMSL8X0OhedBddSmhXiaoN78AdEKC4Eqq44/tUN5qSynRhAdte6URW+Ixl1fEGWAQVzV2pZuSMNjA4p3wLq7hX0vs2qtSQ4TWEZYYiIfRXulJNgeSPg8OrPbvHpKENvlqLBmgjvtjJrUrY7O/zu9NqkS0lGdp9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heP36xz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heP36xz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEABAC4CED1;
	Fri,  6 Dec 2024 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497181;
	bh=JUvawU68qudSwXDcEtvs5yHiJP9pB/BBrQVJ1ndjTBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heP36xz5WIHRdUUyR7TrcoqtE8VtluB5GuXuyyI5pd1PBtxyZn4mVLtZPQnfcKzZ5
	 S5MauwecsQRKuKy8vTf68eMcrAwp/Zny8eMETdAIcGjrnj0SEH+zLFmiSnI4EYQNWf
	 Z6W0jOm0HzmllC6f4YUEKMRpU1yYoAue6tJaQ6Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/676] drm/imx/dcss: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Fri,  6 Dec 2024 15:29:54 +0100
Message-ID: <20241206143700.184492588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 1af01e14db7e0b45ae502d822776a58c86688763 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 9021c317b770 ("drm/imx: Add initial support for DCSS on iMX8MQ")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240912083020.3720233-2-ruanjinjie@huawei.com
[DB: fixed the subject]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dcss/dcss-crtc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imx/dcss/dcss-crtc.c b/drivers/gpu/drm/imx/dcss/dcss-crtc.c
index 31267c00782fc..af91e45b5d13b 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-crtc.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-crtc.c
@@ -206,15 +206,13 @@ int dcss_crtc_init(struct dcss_crtc *crtc, struct drm_device *drm)
 	if (crtc->irq < 0)
 		return crtc->irq;
 
-	ret = request_irq(crtc->irq, dcss_crtc_irq_handler,
-			  0, "dcss_drm", crtc);
+	ret = request_irq(crtc->irq, dcss_crtc_irq_handler, IRQF_NO_AUTOEN,
+			  "dcss_drm", crtc);
 	if (ret) {
 		dev_err(dcss->dev, "irq request failed with %d.\n", ret);
 		return ret;
 	}
 
-	disable_irq(crtc->irq);
-
 	return 0;
 }
 
-- 
2.43.0



