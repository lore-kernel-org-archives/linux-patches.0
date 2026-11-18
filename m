Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017653;
	b=VvlZ1+P+vxLpGnhOGwBMn7jyq0HxuMNCNAU99nsH6UthNjdG+vdxTGKpMES2S6yabva4
	 9GluvdjnWhaKzO3W9AGMqgbB9MmHcKYK81PNpZ1JJZJSffI8xaAmC63sXA7Y6GjEVmXQq
	 WpbsN2LjR9SncUDgFy3hJ1eVOhu+EJnrDDcprC5E7uNjZwxEMCUzqMkmGjlqg/VZs4XUW
	 YxLqK8ZyvI0rNioUf8uezPqN0IN/odgqlvOBQmq8IN0K0Xi/d1kdjgN5wWO6+vCkW/aA7
	 fKsYo+9uVJPaazVA3KBxXVyTf5nO7qNk5XY87wWpeq+hvXscxOpZMCT8C1DIGWRXPMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6DkDKSda2at6HlXoGqv+JmG393wxOUm5J1+LtrbThA4=;
	b=d6r6OEmO/Wm1kqXNTGz11+HXpbdhwA40H/QTT+1JW+x+CPfYQcO58hTaUM2Jeyo+/sA6
	 +MVvdnRldYdT3ZeMcIHQfvagBR35UeECkVjIgMpkkYer6G4vECcWzn8PqXS4wTSzXMZiZ
	 IkRwkDuAWip9CwmQRerwpB+hyacnjBJPyQPJMrNOKI6s/YggwiqO1sW11pKMoYqT9pGFD
	 iPplBqTJXe8nNx+gh1m7KgQkYSjKiutBcxXkZ71B/HEtf3vqvOyuVCSHJxdBTKvbKxMW1
	 c7JKAa8KnlLkdCHw2m4EjKCvQQcrZeSC+EE8qjaXLmGsJTzOaLTU18dKq4SjhemUwCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJo4YiQ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFFB606A31C;
	Wed, 18 Nov 2026 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJo4YiQ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FC21F000C4;
	Wed, 18 Nov 2026 16:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017652;
	bh=6DkDKSda2at6HlXoGqv+JmG393wxOUm5J1+LtrbThA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJo4YiQ5gEiK1gD2RZ92aIWv7iKlm1sTKtwEF6KNKpXtJYVhN5F7S+Rk+nISk9GuF
	 DMgdZTJ9W/yb92WxCErNNS/9geXAQFcD1lWthkbRFwBtkh1slSnQ8zuTD4G4k6l3Hk
	 4cq5fqr3E40X6YpOZ7iTIpbewoLB+K8zaXjEsyl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Day <me@samcday.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0910/2651] drm/msm/a3xx: fix VBIF halt mask for A306/A306A
Date: Wed, 18 Nov 2026 15:35:50 +0100
Message-ID: <20261118150320.648356377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Day <me@samcday.com>

[ Upstream commit b5434691654441448c6d20a8ba887e29d3f81042 ]

A306 and A306A implement only three VBIF XIN halt request bits.
Consequently, waiting for the full 6-bit A3xx mask times out and
prevents runtime suspend.

This issue was reproduced on a DragonBoard 410c: the request reads back
as 0x7 and the acknowledgment as 0x00070007 - the poll eventually
returns -ETIMEDOUT, and a3xx_pm_suspend fails with -EBUSY.

The downstream kgsl driver corroborates this (see link). Since the
single-character difference between A3XX_VBIF_XIN_HALT_CTRL0_MASK and
A30X_VBIF_XIN_HALT_CTRL0_MASK could be confusing to read, the narrowed
GENMASK is instead defined inline in a3xx_vbif_halt().

Fixes: be0e82b8e0c9 ("drm/msm/a3xx: Drain VBIF before GPU suspend")
Link: https://android.googlesource.com/kernel/msm/+/c90c7feeca2f5839ad6824f816c0bd207602a2f4/drivers/gpu/msm/adreno_a3xx.c#637
Assisted-by: LLM
Signed-off-by: Sam Day <me@samcday.com>
Patchwork: https://patchwork.freedesktop.org/patch/756513/
Message-ID: <20260926-a306-vbif-mask-v1-1-2bae5e81c05a@samcday.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
index 0259e60b80115..f672abd5e15e4 100644
--- a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
@@ -500,14 +500,18 @@ static u64 a3xx_gpu_busy(struct msm_gpu *gpu, unsigned long *out_sample_rate)
 
 static int a3xx_vbif_halt(struct msm_gpu *gpu)
 {
+	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	u32 mask = A3XX_VBIF_XIN_HALT_CTRL0_MASK;
 	u32 ack;
 	int ret;
 
-	gpu_write(gpu, REG_A3XX_VBIF_XIN_HALT_CTRL0,
-		  A3XX_VBIF_XIN_HALT_CTRL0_MASK);
+	/* A306(A) only have three VBIF XIN ports. */
+	if (adreno_is_a306(adreno_gpu) || adreno_is_a306a(adreno_gpu))
+		mask = GENMASK(2, 0);
+
+	gpu_write(gpu, REG_A3XX_VBIF_XIN_HALT_CTRL0, mask);
 	ret = spin_until(((ack = gpu_read(gpu, REG_A3XX_VBIF_XIN_HALT_CTRL1)) &
-			  A3XX_VBIF_XIN_HALT_CTRL0_MASK) ==
-			 A3XX_VBIF_XIN_HALT_CTRL0_MASK);
+			  mask) == mask);
 	gpu_write(gpu, REG_A3XX_VBIF_XIN_HALT_CTRL0, 0);
 
 	if (ret)
-- 
2.53.0



