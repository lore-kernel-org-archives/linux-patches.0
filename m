Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829681;
	b=Gza45roKMvpMAseGNlKhx2on14n74279JSe/t+p4Ev2E5CrKFLmeD4OpMBdzuVJlXmwq
	 I571Bb2EXpIaFrCVKqpfQJiQS/2KTQ5zzLnl/ONxM+HK71eK/37rtrqiMv//biWMn6YN3
	 uImM3lMvYvMVC63yhYWujqQP05mpyRsYctPY/G+ynYJdeimLw5cR6pz3eS90lpTc+ZBd3
	 +Lq6H2h1GzgGgzum1AVToI5as7feTZLFZ2XFLY3h+C52ipBjD2QMpzWm6nyxZ0bn7KtRi
	 EhgDbaDGl6x+GzbA2L9VvTIidJ0opGdhua/xUEd1yB7td3/0dg5ljBPM9uSRh0nEJqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gnTkOLtaGdJt7xbw0sj/99bKl8RPa4iX3wNopFw2ldk=;
	b=kDktI3QXUyXFvuZZVQPy8dls6bjYOmeD6r9MG6mjUfWUFge+NUf7h+c45JkbReYUX40H
	 TCD0LzgJnFjgmwAllY31thfV7UAtmN2lv2mypLN4pguuNLoJp0SkWhHseYjzx3ONIsYCA
	 AMt6s9NbGKPk19LFwI6+52yT1gd8QpCUH+48GBGjVDic2FT0MV0NJP0BEr5y+PRv1hJmg
	 M8/3IWLp7Lt2hrQbegzPnYIO85n+mAjgqbnDSOlNYQEnwuXURCOQIapCi9YycIB1tY5bf
	 1O7WVKPxlo4oLKtLT2LkkLR1rvPBfLRqyVtj4WGAuzpYjzQX1T6IubD2w4VaTO4LdXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr4SsAuJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2215E606C58E;
	Wed,  4 Nov 2026 22:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr4SsAuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E5C1F000C1;
	Wed,  4 Nov 2026 22:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829681;
	bh=gnTkOLtaGdJt7xbw0sj/99bKl8RPa4iX3wNopFw2ldk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vr4SsAuJpAHBOW3EbkUpG2RIUpZ0/wkp2RWwVZ4nHdqgyY86vhcjskKIX3C9a/8nk
	 o2QzQ0OCNfBViEqOrdV1l1P6bDSfU07Tn9bWpTHpsFU0gTD/zS8PC10zQqTqXjhzeN
	 grFw0mfuNUtzqEXfhokA37+LDP+oQlhqMF+Mn6HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0277/1005] drm/msm: Fix barriers accessing ctx vm
Date: Wed,  4 Nov 2026 16:00:10 -0500
Message-ID: <20261104211051.649707079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit ae88499d71ce80ecd25c055eddddace108266321 ]

Don't rely on store ordering to protect us from caller seeing a
partially initialized vm.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/743079/
Message-ID: <20260729155609.20190-2-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index c2a8aaa33f84a..8094e5e7e9a54 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -226,18 +226,19 @@ struct drm_gpuvm *msm_context_vm(struct drm_device *dev, struct msm_context *ctx
 {
 	static DEFINE_MUTEX(init_lock);
 	struct msm_drm_private *priv = dev->dev_private;
+	struct drm_gpuvm *vm = smp_load_acquire(&ctx->vm);
 
 	/* Once ctx->vm is created it is valid for the lifetime of the context: */
-	if (ctx->vm)
-		return ctx->vm;
+	if (vm)
+		return vm;
+
+	guard(mutex)(&init_lock);
 
-	mutex_lock(&init_lock);
 	if (!ctx->vm) {
-		ctx->vm = msm_gpu_create_private_vm(
+		vm = msm_gpu_create_private_vm(
 			priv->gpu, current, !ctx->userspace_managed_vm);
-
+		smp_store_release(&ctx->vm, vm);
 	}
-	mutex_unlock(&init_lock);
 
 	return ctx->vm;
 }
-- 
2.53.0



