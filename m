Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213770;
	b=Uk1IC/XvBRUGDfV9kcWxspUQHuR79ZJtyH/Zaz+ZEPvP8rdRreibAuAA0MdeT1RaJDRU
	 bvkZzHogZSXzgTwv632s2l5gxQhzQjYraUqtbu4gk8VbmLCCQqnogXoTsou8eSDR8NGrN
	 cucrL1vwFslDVFoWFp70oLUV/kgSvfuzxYuatwt6Lq5a5I+zCxIwHzeR+0BfIteyY3SwL
	 FoCd3faKwjFhVyTEL2CzkDIV4df+mtFO8ZRzv6PhhPrFL8cjK8039rPl2vMwK7QzYWjqX
	 y3qaUzognWT88BToeOmEPDYv9OCfSkvKM5xR2OJURRrweOowucDFjiTsJjcWI6ySE7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=itfHqFJTiwNBzBcxkxopnSjPqzS21jKJwwth4oYSKvA=;
	b=DofoVnYmNOEROanwfa5NZxOin4463WZqNpIB7/tlmjJRTy3SEchFhSoKFkBFbtpH1iZE
	 HvsUNzIE2+DmsQYwuoOHTKRS+cEP6Rpven+YqhTpXuXLkYWOfCuWVTRJCrghxjL2sF6HS
	 LbDwLb2/buWlQM+Bhhr8+I4J0JDMCAFWgvaWKX3Hnb+gcCcC9h8dMBwFzVg+48UfBvv8X
	 ejTodR70Vkrsm9ym2Z2FLmX58+MwXFmtzRxnTvipaWS98omI6Nyh3V8Ffu7YbUEj7ZHzC
	 l85w+1Mu0+qt3iwx1D5faj4nOu5iN4tOr9rhX158nuDnKbC2gyHeksIYHZeSLb8rGKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8aIGB0T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1D9606A31D;
	Wed, 28 Oct 2026 18:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8aIGB0T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93A51F01829;
	Wed, 28 Oct 2026 18:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213770;
	bh=itfHqFJTiwNBzBcxkxopnSjPqzS21jKJwwth4oYSKvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8aIGB0T+ZIjkUW4f3weUe96iP7dJvqqN1IlM0AfdCHfxUfB8ctVo1eL1g/08GVI0
	 VXv1ogn94BRT1GeYYC/X9iDnt0OwORoALKfuGqQe6aPQtXaQdbWL39Nqba3+R5kgFr
	 iE9ameY6NxlxPq74FGwWxjEY5bMtU4zH0tvikdws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0621/1887] drm/msm/dpu: Add callback function pointer check before its call
Date: Wed, 28 Oct 2026 17:45:17 +0100
Message-ID: <20261028170513.541855340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 75e1b89c9eacf..346bb684a35d0 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -156,8 +156,10 @@ static void dpu_core_irq_callback_handler(struct dpu_kms *dpu_kms, int irq_idx)
 {
 	VERB("irq_idx=%d\n", irq_idx);
 
-	if (!dpu_kms->hw_intr->irq_tbl[irq_idx].cb)
+	if (!dpu_kms->hw_intr->irq_tbl[irq_idx].cb) {
 		DRM_ERROR("no registered cb, idx:%d\n", irq_idx);
+		return;
+	}
 
 	atomic_inc(&dpu_kms->hw_intr->irq_tbl[irq_idx].count);
 
-- 
2.53.0



