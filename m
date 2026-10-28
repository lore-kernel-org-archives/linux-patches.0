Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211482;
	b=SpTuk8bn41L3+sflcn5HwE9GVODplHlf9zQ6EGy5QXSJvevruUoy7yGCJOQc1jGJik8F
	 KNFAIvdbRwmBDoJ49EW3lcbptoCpT5sXgBUzDfi739uRT/q6+PHhMkI3n4tXe6f6h0oOR
	 Ps+mXnSlxUc8wB90OT63n1bF61o/4aecbwnPCNCjpV/oVp9O/Il5R2XyqNRA6bvEW8QH1
	 QkZvIC7nO7qHQBIiGf3KL1q2Yh6wLHbrqua0PsOHOQ0BVcVbo+XZHiaU9/T8Zgq6MmQQS
	 E+dRCvEjE2OuwGm7gu28W/sPQzTyGuIUxeILqtFph0r9eHbLJdKHZF5X0uD3LZ7qMsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IentTWjEdXcIZZXuWYl12iJo4HmRDhvR2LFqtyNqh5o=;
	b=5fUhswtrbrHMUrUd3J2FHvQXwQR/UvrYMP9au57HrHvR5ZsAuFnvHqqmAtevj+u1BRoh
	 nThqrgWX6DhrO9e1Rt0Ota8IMAhcPTJ/4ZC77BtXT3vkXUIV+Ul8rijRHtH+/Yxjl62LC
	 Kj4Dp8YPVeGC2ezvvp3/+VZ/i7RVeVqhHCjgQ2Wwx3VNLQv42yuJPWMGDwFxYV1aN38J/
	 vhlRdiLxEp0tKTnE/EoxEV3Av2H5Q0HYzCAAXlsDYHvTPxzwoggZXy2pzo0mnDwPKiNq+
	 Bbg/xeOOJ3awLaHVQitg38rHsb4cgHnPbR7qh9PW63aqx7JrMrqDBYd1p9wj56014ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUZIrKv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85B0606A31F;
	Wed, 28 Oct 2026 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUZIrKv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1506F1F01825;
	Wed, 28 Oct 2026 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211481;
	bh=IentTWjEdXcIZZXuWYl12iJo4HmRDhvR2LFqtyNqh5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUZIrKv5Ac1gGDNgHWsZzNZS49KjUIYHtyab52AuXK3Bqi1K+324cuRAgUMywJNtr
	 pMUhj/8I7y64cNUGEQeNFX0ybvid4zE9Uaq66iBTO4EbG/jhu/37BcIzn6iedgSRHh
	 cR1xo3+ru4THfOt5FohzY7XP97T/BCQSdMOsF5S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/571] drm/vc4: Free the BO cache size list on teardown
Date: Wed, 28 Oct 2026 17:59:00 +0100
Message-ID: <20261028170017.339124777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit b41ff8b529278216cba22a5dcdc93fea2a3a9619 ]

vc4_bo_cache_destroy() purges the cached BOs but never frees the size
list, leaking it on every unbind.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Assisted-by: LLM
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20260930190721.1897264-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 4703f180cde60..f09f1f062e31b 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -994,6 +994,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
+	kfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0



