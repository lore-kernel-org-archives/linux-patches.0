Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063063;
	b=yV8dh5Kt7SY0Ef6/Loa/z/tk2VbkJYLpD5V4aq0vHC+9EXqe4+JDEImjwQB6pexkVYkX
	 UpxW9eb1COYtD0DEnYuKSfxl83xkAm6sRUtUSM9w0piGrvfQqXgrTF7Bjc+wFP/8XXARj
	 FU4c14NtrObEhiw4CJni8MmRO4w0cVH2aF7bS0tQ3F2L9cgAUE87m2hj18M4+raaLSbr3
	 ygyr9yeGthQV1BUuL27KlcYzwobWJ7aLHc3vm1Z0vvLpPqEAT2XDZJd7phzJurLpQZ31L
	 jGb77lhIrQT5Fsd6xUK8uA+jxpE8PJOCx5HU5RkqOeORlJygW+SQ6OHNAibvyXOZ6mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VM9VKYkVyiHUmhLMZ3QhNltE7NuKKtNvficHIgKAB0Y=;
	b=2jPdeFXCTaEBKQ99GT2fhL6nXcKcCjMgzYTQASqZQuq2nkQTK7QYED0hCVknagrVJT+c
	 czAkKsWSEt0QTJqVrPXtETBQfmqFnmpiRXjl74rwEvFwYBy178nBd30MtP2G0M1JivzJX
	 Pyk0vY8DyhRndHm80pvvuYv+k+9fRm7YGtHcpp+eR9yu4Jwejr2HdLZPLgOkjSsuKDWIP
	 LdVy9PHE8OBFTbDHaKG4d/j2d+IbnAWM6bOqrHX4uItyNDBFWRd9qz6tZi5goOVdDn9PG
	 qAHxOZfu2o4HPkWmUg00XpS1NIPXTYTwrV+BE+e6K3MzhvCtFNpuCfI/lZXaOV87B0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dpuehlMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF2F606D80E;
	Sat,  7 Nov 2026 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dpuehlMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBF81F0089F;
	Sat,  7 Nov 2026 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063062;
	bh=VM9VKYkVyiHUmhLMZ3QhNltE7NuKKtNvficHIgKAB0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpuehlMMjNj9YXqze42cFR78JMLFWZiRbpBAaawcs18sMJFny/KG0ZLbhMVWbKb6u
	 6KqU8veWH+LA2BGpoe+9WNqiKjE6pWUS8CsqQQTSsaTlF18yakvbB5fhf43m2JUhKb
	 r5bJPAifBAxGoPJyHfjqnAHExfWvyddTL3jCxrHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/869] drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure
Date: Sat,  7 Nov 2026 08:49:46 -0500
Message-ID: <20261107134902.864883742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit d27f831aaf20aaf06e41ceb1b260e10672269155 ]

If msm_hdmi_phy_resource_enable() fails, e.g. when enabling regulators,
it should reverse the state of things already changed.
msm_hdmi_phy_resource_enable() is used also in probe path, thus such
failure, which could be simple deferred probe, would leave these
resources permanently enabled for the rest of the runtime.

Cc: <stable@vger.kernel.org>
Fixes: 15b4a4523859 ("drm/msm/hdmi: Create a separate HDMI PHY driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752654/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-1-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
index 6777cba9255e2..bc603a79c0851 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -67,16 +67,28 @@ int msm_hdmi_phy_resource_enable(struct hdmi_phy *phy)
 	ret = regulator_bulk_enable(cfg->num_regs, phy->regs);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "failed to enable regulators: (%d)\n", ret);
-		return ret;
+		goto err_pm_put;
 	}
 
 	for (i = 0; i < cfg->num_clks; i++) {
 		ret = clk_prepare_enable(phy->clks[i]);
-		if (ret)
+		if (ret) {
 			DRM_DEV_ERROR(dev, "failed to enable clock: %s (%d)\n",
 				cfg->clk_names[i], ret);
+			goto err_clk_unprepare;
+		}
 	}
 
+	return 0;
+
+err_clk_unprepare:
+	for (; i > 0; i--)
+		clk_disable_unprepare(phy->clks[i - 1]);
+	regulator_bulk_disable(cfg->num_regs, phy->regs);
+
+err_pm_put:
+	pm_runtime_put_sync(dev);
+
 	return ret;
 }
 
-- 
2.53.0



