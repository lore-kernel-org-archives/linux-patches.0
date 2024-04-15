Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AB13BBE1;
	Mon, 15 Apr 2024 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191106; cv=none; b=qXLisMpNeWWkaGcxK96ObhpZK+s/L5sWj9LVg+X12Z6hV/vj3zXrXaBG1Z+/dev9jOCp6IQ4P6sWmnyQVyTfDwXa3mjzK3GRz7zEwSG8KCf8TIHpTrBKl/wF3t/u9Wk7bEwWjY58JnYvFCyTuH0FrQUvyjnMLKqAr43cq1/1DcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191106; c=relaxed/simple;
	bh=EA4GnfbxJ8/lEkX3P1KDDm4pDJVSVEd+6wAFtxFMjtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKs9VKNmfRkB6spa5KFDhaZ7zgAjf6/WpuctjtsWzpo6VXaOE7T1kOyDkPObNdvwG32+ocbg05vGJeBIt6MzAVhIDrmFk5hRZCWaA7Vjjp9BhibRAyhY+k3D46PrVGfjlwu4WwsaBqumyV15TO8dv7uRk2j5UqnTQ8G4l3uJgR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYtFL1CH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYtFL1CH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2946DC113CC;
	Mon, 15 Apr 2024 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191106;
	bh=EA4GnfbxJ8/lEkX3P1KDDm4pDJVSVEd+6wAFtxFMjtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYtFL1CHXeU1T2w0wyvuzvruOWRbM9gjBSQohrc1dBtZog1kyrI2nJeoi5hlbZkLH
	 4PXZxPbDWW++pIMk3Vl9CHcdk4CBcIXbaYXqZlCPM0k1MbRQvB6rqGTDnCR7HA5lSV
	 e6UbVPsiUhAeYTtAF8g9dvAZ37QEVQb55hAbpcLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 034/172] drm/msm/dpu: make error messages at dpu_core_irq_register_callback() more sensible
Date: Mon, 15 Apr 2024 16:18:53 +0200
Message-ID: <20240415142001.467517239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 8844f467d6a58dc915f241e81c46e0c126f8c070 ]

There is little point in using %ps to print a value known to be NULL. On
the other hand it makes sense to print the callback symbol in the
'invalid IRQ' message. Correct those two error messages to make more
sense.

Fixes: 6893199183f8 ("drm/msm/dpu: stop using raw IRQ indices in the kernel output")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/585565/
Link: https://lore.kernel.org/r/20240330-dpu-irq-messages-v1-1-9ce782ae35f9@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index 946dd0135dffc..6a0a74832fb64 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -525,14 +525,14 @@ int dpu_core_irq_register_callback(struct dpu_kms *dpu_kms,
 	int ret;
 
 	if (!irq_cb) {
-		DPU_ERROR("invalid IRQ=[%d, %d] irq_cb:%ps\n",
-			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx), irq_cb);
+		DPU_ERROR("IRQ=[%d, %d] NULL callback\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
 		return -EINVAL;
 	}
 
 	if (!dpu_core_irq_is_valid(irq_idx)) {
-		DPU_ERROR("invalid IRQ=[%d, %d]\n",
-			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx));
+		DPU_ERROR("invalid IRQ=[%d, %d] irq_cb:%ps\n",
+			  DPU_IRQ_REG(irq_idx), DPU_IRQ_BIT(irq_idx), irq_cb);
 		return -EINVAL;
 	}
 
-- 
2.43.0



