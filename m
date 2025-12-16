Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9274C34A3C5;
	Tue, 16 Dec 2025 12:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887616; cv=none; b=U8XXuLWJavTo1TzakKdhpPIoLdaC+r1ovwwkTou0wtCqPmz7+7ATEsAu2dG84ba7omOaF3FEPlWC4fuR8UAjgvfsZWajVfwcR8fP99UAVVSMpxoh0UGUPBPv/BGbyowk1AD0yX8rFvVt0mcFsmwuf6J04mrSItj+rVrjTDxnLAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887616; c=relaxed/simple;
	bh=hBnNpIVdXd8Wrf+Xx1x0Uz/iQwLK/8BVQqfvi8MBzVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keTjmmqYVv6WWSpSbdwmXY3n4IzFQZ35ZBtOq/P4fGZRJR5SX2n2VluAzMRDGyuhYzLTHN+1Mu3i1nCVuT4D5KIKbdXe6ez0qvx406Uf4FtplJFHSZ0VkVp7AVfJxMH7rB6e53vUfTvncAOj3fcFKtVl2u4TnzNdE0fL3hpezWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dH4eKsqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dH4eKsqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6B6C4CEF1;
	Tue, 16 Dec 2025 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887616;
	bh=hBnNpIVdXd8Wrf+Xx1x0Uz/iQwLK/8BVQqfvi8MBzVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH4eKsqNf2Cg1NSF4mW5NTXmKacDFR/BR9DQVfpev3J2Tzb1dM6YX6x8bGriw9qCu
	 b7lrnZohsZm80Na6FdTW0UTMH/nRqDYAkf147+HRZQzXVJNE6AS6x1MtL38/40lmAB
	 x4zET38hb1/uiHhf5OM7WtH87oWMDPpJZEOVtgck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 286/614] drm/msm/dpu: drop dpu_hw_dsc_destroy() prototype
Date: Tue, 16 Dec 2025 12:10:53 +0100
Message-ID: <20251216111411.733507227@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit d9792823d18ff9895eaf5769a29a54804f24bc25 ]

The commit a106ed98af68 ("drm/msm/dpu: use devres-managed allocation for
HW blocks") dropped all dpu_hw_foo_destroy() functions, but the
prototype for dpu_hw_dsc_destroy() was omitted. Drop it now to clean up
the header.

Fixes: a106ed98af68 ("drm/msm/dpu: use devres-managed allocation for HW blocks")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Jessica Zhang <jesszhan0024@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/683697/
Link: https://lore.kernel.org/r/20251027-dpu-drop-dsc-destroy-v1-1-968128de4bf6@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
index b7013c9822d23..cc7cc6f6f7cda 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h
@@ -71,12 +71,6 @@ struct dpu_hw_dsc *dpu_hw_dsc_init_1_2(struct drm_device *dev,
 				       const struct dpu_dsc_cfg *cfg,
 				       void __iomem *addr);
 
-/**
- * dpu_hw_dsc_destroy - destroys dsc driver context
- * @dsc:   Pointer to dsc driver context returned by dpu_hw_dsc_init
- */
-void dpu_hw_dsc_destroy(struct dpu_hw_dsc *dsc);
-
 static inline struct dpu_hw_dsc *to_dpu_hw_dsc(struct dpu_hw_blk *hw)
 {
 	return container_of(hw, struct dpu_hw_dsc, base);
-- 
2.51.0



