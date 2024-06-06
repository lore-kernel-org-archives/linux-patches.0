Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5231C6163;
	Thu,  6 Jun 2024 14:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683683; cv=none; b=m+HBEz+8b7SlnVq0cmzEfmKjxL5QvC0KAI7trcWoUaqSSBIe+zdqto46PszNEAU16n9ydAie87AMp3Yr3+qFrQ9+/DJY9IzPOuzyfIc22v58GKLR7mv70DxASD/olSuGGylmh5Mr81q5URv5NO1XPyc2GRpAFyVdTMqXnVTk+jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683683; c=relaxed/simple;
	bh=poqKtsmatTtFZi+U+9I7kJ/w7infTaVFjH1K9Ifg/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTl8l8W8Ud9fPWfQixC8bJ4v9gRCRoqMUHrL/sbpcbpFlb856TpCdvrppCiCDqP6qX1dfCpy4tpXLK+gXMl4bidKtduX28Y1OT9VZN69/Yd288XdMJmFyK1lOHl4TcvHj8ZPjhg2mpA4wWvdD/Qh3qbAfnBc5gErGvIvmbyd4n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOFYixwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOFYixwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895CDC32786;
	Thu,  6 Jun 2024 14:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683683;
	bh=poqKtsmatTtFZi+U+9I7kJ/w7infTaVFjH1K9Ifg/1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOFYixwKFTWeU2RN5ojY1Q++pi2LY6VGaRrx0jcrOJOHSafL1wzJN8OZA5ms+FvhQ
	 WP51eMVAgYkjXJikjPlvnIxgq0VUKMtJ+DeSraMZl3jIJ2Voohmrqqc3sz1rypMgrd
	 KqhLJAPVnWz+6c271eyLOv1YH1gDOyRT+bEEefIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 587/744] drm/msm/dpu: Add callback function pointer check before its call
Date: Thu,  6 Jun 2024 16:04:19 +0200
Message-ID: <20240606131751.294543749@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index c413e9917d7eb..41f7c86bc2db9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -221,9 +221,11 @@ static void dpu_core_irq_callback_handler(struct dpu_kms *dpu_kms, int irq_idx)
 
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



