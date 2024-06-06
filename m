Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804BD197551;
	Thu,  6 Jun 2024 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682986; cv=none; b=Iiio7udN03ZUY4bFgk49JyMuBhXpaHI654B2ViW7a2pOqPcQJ3b2tApbgrg29ySdq15XnnO9MruMGpZoVu2w2fEVMjSMc4/FiaWNjeXniJc9fZbRzJDcXS3kCj2wag8gb4AIkTHuXBK+6trCVfAat2HJHATsGzxr6y+R0u/gsZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682986; c=relaxed/simple;
	bh=eCFHJa1yOtpWXSxahxHozVYDw7HeprVMcpLcPqOQCao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cph+mw+DANcyIiMxuUY77/KxmEtXiHa17vx8bf6d2vxs95EkRskHNcRWgZtfrG8+ZxR/KVZedw6Z9UKDMwrdq7h1/SXxeHzw0SGl5xZAVoAOzOYq63hqsC1M1iLUp/IE5aOn8xtWETamcSzGPGu9sEN3k3T6cX5hoXRgf+RFCLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKPn1et/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKPn1et/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7D1C2BD10;
	Thu,  6 Jun 2024 14:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682986;
	bh=eCFHJa1yOtpWXSxahxHozVYDw7HeprVMcpLcPqOQCao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKPn1et/Q3acMe72/zeFR2vf7ociK2Rke/B6WQLPoykUu+SSkS9voYXu9ysIlh/gF
	 nuNxCocDUMWqW/i6Nd+MTVUq0yUdXTJ7VYthmcVh5BmWsRXnb9JNMb/mtQVIeJYoJE
	 PNURVjsOQmFCo4HZjEJ02pQLVs3iwiWlkKJj+bk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 173/374] drm/msm/dpu: Add callback function pointer check before its call
Date: Thu,  6 Jun 2024 16:02:32 +0200
Message-ID: <20240606131657.687757332@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 530f272053a5e72243a9cb07bb1296af6c346002 ]

In dpu_core_irq_callback_handler() callback function pointer is compared to NULL,
but then callback function is unconditionally called by this pointer.
Fix this bug by adding conditional return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c929ac60b3ed ("drm/msm/dpu: allow just single IRQ callback")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/588237/
Link: https://lore.kernel.org/r/20240408085523.12231-1-amishin@t-argos.ru
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index 6a0a74832fb64..b85881aab0478 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -223,9 +223,11 @@ static void dpu_core_irq_callback_handler(struct dpu_kms *dpu_kms, unsigned int
 
 	VERB("IRQ=[%d, %d]\n", DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 
-	if (!irq_entry->cb)
+	if (!irq_entry->cb) {
 		DRM_ERROR("no registered cb, IRQ=[%d, %d]\n",
 			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
+		return;
+	}
 
 	atomic_inc(&irq_entry->count);
 
-- 
2.43.0



