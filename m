Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215341;
	b=SacUcu/AC68cG9jyuKwgZi+RYAbKb4W1ZMPZpUjhbEWku3LgoRb3MqFsqNBwFnadeCoL
	 W0D5By3phsARmvJnG+0o/j2sWFKlSYdyugnOketC0ggDOt8Y8KKw2aWGsdnhd208vZveL
	 I7h+TOkyalC8MRDCNtA5UDB8HjV6XZFWcCJw6mQS94Gk1BacIwE2yxHae/6OxJiEBb5tE
	 GzRVGzdW3oCehqSSsVHQ/z9LXkvIAyolY9bwuRbwWBtDk4PtAscfIO/cFKyVLYM9+HZO2
	 sNjiLOokyVKQKssZD4/kWWEtzzZP6jTtRxitKbzGF3V55AKfBb9YlIyZWFKHg4Vjz2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WUlGrOZO4ewah58wcp3InYyDsZXzXGpyRwgIVqciZFA=;
	b=0yKgM2stUBIeKgGTL9RT8j+z7DGhf2pcdDft+Z++AWimJwqMOzWGUXmkkodIdb3BGpF9
	 rusl9Bm6EPnzJT9uyfbOJwwSLDKYBDwCx9rYu1FQcAS/g9vL3bawVqmcxV7p22QfRZ0NO
	 9Hl7cvrLAh7WQI6sAYIBLgOaY/SahEoaldy5InOLFcZCGQCSuA6bMsi8AnsOjjP+G2KCF
	 WR2Ct/7h5uGx6RE++Zj/Nyomp0iu9BvvBEmttdtmr0UCh9NBr5gKc2FzNugsrtZumpywb
	 3Q62X9wuDjukI2W6NvmQFWyOzUSo+Cy76SfHi/1gS/um1TQl4w4JnYh/cXcn34M5vNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fua7HIuu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A25606A31A;
	Wed, 28 Oct 2026 19:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fua7HIuu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFAC1F01825;
	Wed, 28 Oct 2026 19:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215340;
	bh=WUlGrOZO4ewah58wcp3InYyDsZXzXGpyRwgIVqciZFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fua7HIuuiFZxO9jXfDjSg5GWvYEzOzrcYZ6IuJvJk5U4lngKGgGclceo+lqUa4cCr
	 obKntP+XHLiDM7oHyoAQY+r9q+OzZH9nfKe2qIF/DH+r2JRuc1Gs+xFrlqm3+KCN0H
	 loilLrH3qj8x4DUYxXVI1PRqutuROj4yDpWOLsWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Zhu <James.Zhu@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1175/1887] drm/amdgpu: keep amdgpu_ctx_mgr in ctx structure
Date: Wed, 28 Oct 2026 17:54:31 +0100
Message-ID: <20261028170526.145437639@linuxfoundation.org>
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

From: James Zhu <James.Zhu@amd.com>

[ Upstream commit c30e326e488ec43f6b0931f16ddba16a3370ed4a ]

Keep amdgpu_ctx_mgr in ctx structure to track fpriv.

v2: add missing fpriv declaration lost in rebase

Signed-off-by: James Zhu <James.Zhu@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c1dc4ccb82c9 ("drm/amdgpu: Fix context pstate override handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index 3898b67c35bc3..c88dbba8b312b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -304,6 +304,7 @@ static int amdgpu_ctx_get_stable_pstate(struct amdgpu_ctx *ctx,
 static int amdgpu_ctx_init(struct amdgpu_ctx_mgr *mgr, int32_t priority,
 			   struct drm_file *filp, struct amdgpu_ctx *ctx)
 {
+	struct amdgpu_fpriv *fpriv = filp->driver_priv;
 	u32 current_stable_pstate;
 	int r;
 
@@ -332,6 +333,7 @@ static int amdgpu_ctx_init(struct amdgpu_ctx_mgr *mgr, int32_t priority,
 	else
 		ctx->stable_pstate = current_stable_pstate;
 
+	ctx->ctx_mgr = &(fpriv->ctx_mgr);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h
index 0fa0e56daf67e..f1e27b6e16f48 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h
@@ -57,6 +57,7 @@ struct amdgpu_ctx {
 	unsigned long			ras_counter_ce;
 	unsigned long			ras_counter_ue;
 	uint32_t			stable_pstate;
+	struct amdgpu_ctx_mgr		*ctx_mgr;
 };
 
 struct amdgpu_ctx_mgr {
-- 
2.53.0



