Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017616;
	b=I+Fux3iKMXwjonOlu3TG5Q5Xl6lBBib6/TuQ6RQWd4Nt2BtlwjMvqQ3MujTchoTwP+Vc
	 MqsaNEdhfMu0mgJvLucVk1PwACLi6G9CoFVR4Y9Ha9Ux6auo3VpeNe0xFnGktmNX9ZQ5s
	 8v7V2VjH/dSN2zoUhB/xcGJxRA4oRhrBQJ3nS6tI3nk2asgGgtsT8VskkYJtVfT7WuPff
	 Vv98BIDdzP10UnVxyMDsaxTK2Jaq765Js5AB+1iOLIxyiVCqA+//v9r/52mPgzYrub9KJ
	 kc4KcGFGsjkzeMJav18r26Cp4nt2gRDrqQGRjfLH/V13HFywq+d4YadprWSN2w5jVuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BBnx6ZdjxTNHELOtYgyr+XwXonLfARGXq+Jt1KmR7Hs=;
	b=sNmkp94+eb76Fhu1xU1ZFabmYgXTciDKKK3ufOzyC3UP0ArHHnX8lke3/afQFe2mp7m5
	 xepHvMIZN2PrSw+SofDzLOPlJJgT5lFVGp/b734Ax6yVH7LcDWYc94cejt2Sz4ihBYNIP
	 C0vKSNrdSa4JllraXPw4mv/P67VxOQIs2sWbdQDofMTendnlKIeG6rOaNZq/hvNxFIwki
	 cl/sAjpQ6Ju2vhf2m8wVkI77SFwk7wlVcqSbxVpuinlkKboRYVu7YUztFzxUG2B61Qu7P
	 IzVV815x9B4sVz89XoTr4tiByq/0NtCdJVff8KSG82yJCQ1uOqCmyAQy8H2kYX3belg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWxDE0wW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E12606A31C;
	Wed, 18 Nov 2026 16:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWxDE0wW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A5C1F000C7;
	Wed, 18 Nov 2026 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017616;
	bh=BBnx6ZdjxTNHELOtYgyr+XwXonLfARGXq+Jt1KmR7Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWxDE0wWSK3VbWUQBKk4GFXxSQhd0u/vS5nwGlSjceKKCNRGDfVz+kgsH08SFL/VC
	 1JAz6xurGIfyUB/CSpiFv3lyjHOebNicCW34ouW0vlhveJNr3hfynJkYFFnE07ykqb
	 DC8G6foBgGr0hFL7Pb/SfbFu00d5LDiwV48FcErM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0947/2651] drm/exynos/fimd: fix register offset type in fimd_trigger()
Date: Wed, 18 Nov 2026 15:36:27 +0100
Message-ID: <20261118150321.997369626@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit f901c9b986b6355716822d5c6ad34ae5edd71085 ]

Sparse reports:

    exynos_drm_fimd.c:992:39: warning: incorrect type in initializer (different address spaces)
    exynos_drm_fimd.c:992:39:    expected void *timing_base
    exynos_drm_fimd.c:992:39:    got void [noderef] __iomem *
    exynos_drm_fimd.c:1005:33: warning: incorrect type in argument 1 (different address spaces)
    exynos_drm_fimd.c:1005:33:    expected void const volatile [noderef] __iomem *addr
    exynos_drm_fimd.c:1005:33:    got void *
    exynos_drm_fimd.c:1007:33: warning: incorrect type in argument 2 (different address spaces)
    exynos_drm_fimd.c:1007:33:    expected void volatile [noderef] __iomem *addr
    exynos_drm_fimd.c:1007:33:    got void *

Add "__iomem" to *timing_base to fix its type.

Fixes: 3854fab24e89 ("drm/exynos: fimd: support LCD I80 interface")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index b6abdc4f2b0a3..695d3515d4218 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -989,7 +989,7 @@ static void fimd_trigger(struct device *dev)
 {
 	struct fimd_context *ctx = dev_get_drvdata(dev);
 	const struct fimd_driver_data *driver_data = ctx->driver_data;
-	void *timing_base = ctx->regs + driver_data->timing_base;
+	void __iomem *timing_base = ctx->regs + driver_data->timing_base;
 	u32 reg;
 
 	 /*
-- 
2.53.0



