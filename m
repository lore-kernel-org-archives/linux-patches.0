Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672747C0BE;
	Mon,  8 Apr 2024 13:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581896; cv=none; b=eTsBn7Knelh84qsGJ5SNHAoTJZ/2Ywq7UHm1Zt7MpmRMbGxcjMszOdbLbFuBZb/EKpdNEb2x0m+CYQFa/3r8UUS50hpFS35huYZvKQ0qNS3kVmVv/IUJ8PxOyWq5qMYp3tBxxPzg+x453hKh2KsLLcFWP9mwTI5VZMJy8Q0ks/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581896; c=relaxed/simple;
	bh=IaQlqgZmoruSz/ZpwZtKZW1lkQzm/fio3km6PDSAkK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxC5OHsA8/vWGVWgdq7zIoLuhjNfV1B7tZpAY+Y+6BAaamZokqavDoiE2B6N1eqJaFCvhyNUq2gpPDxn0kjli7h1kk/JbGBQV+Xic9D0TcjfaUCDpGZKJAvXwN6+OGNNANM98CBbDvXUDOVkhcZU0lIWE7V2M4V+1DGZmAmgH3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pD68NY0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pD68NY0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13C3C433F1;
	Mon,  8 Apr 2024 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581896;
	bh=IaQlqgZmoruSz/ZpwZtKZW1lkQzm/fio3km6PDSAkK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD68NY0hiXuTXvjMs9BjthkfcKohlYHmm1T5cX80QAnn77dbV2eeD5maloOVZyfga
	 pWMdASkc0vRr6wBGn+XbSHmic/mHkpeGWzVV3LqdlZukwAyjeUtsrQ99OW1+pLbFvd
	 p4sIaH8pH2+0U/2iTvZxssGmI9tsec7JSiGWUQAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/252] drm/i915/mtl: Update workaround 14016712196
Date: Mon,  8 Apr 2024 14:55:47 +0200
Message-ID: <20240408125308.128219188@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 7467e1da906468bcbd311023b30708193103ecf9 ]

Now this workaround is permanent workaround on MTL and DG2,
earlier we used to apply on MTL A0 step only.
VLK-45480

Fixes: d922b80b1010 ("drm/i915/gt: Add workaround 14016712196")
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Acked-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230828063450.2642748-1-tejas.upadhyay@intel.com
Stable-dep-of: 186bce682772 ("drm/i915/mtl: Update workaround 14018575942")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen8_engine_cs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
index 3ac3e12d9c524..ba4c2422b3402 100644
--- a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
@@ -226,8 +226,8 @@ u32 *gen12_emit_aux_table_inv(struct intel_engine_cs *engine, u32 *cs)
 static int mtl_dummy_pipe_control(struct i915_request *rq)
 {
 	/* Wa_14016712196 */
-	if (IS_GFX_GT_IP_STEP(rq->engine->gt, IP_VER(12, 70), STEP_A0, STEP_B0) ||
-	    IS_GFX_GT_IP_STEP(rq->engine->gt, IP_VER(12, 71), STEP_A0, STEP_B0)) {
+	if (IS_GFX_GT_IP_RANGE(rq->engine->gt, IP_VER(12, 70), IP_VER(12, 71)) ||
+	    IS_DG2(rq->i915)) {
 		u32 *cs;
 
 		/* dummy PIPE_CONTROL + depth flush */
@@ -819,8 +819,7 @@ u32 *gen12_emit_fini_breadcrumb_rcs(struct i915_request *rq, u32 *cs)
 		     PIPE_CONTROL_FLUSH_ENABLE);
 
 	/* Wa_14016712196 */
-	if (IS_GFX_GT_IP_STEP(gt, IP_VER(12, 70), STEP_A0, STEP_B0) ||
-	    IS_GFX_GT_IP_STEP(gt, IP_VER(12, 71), STEP_A0, STEP_B0))
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)) || IS_DG2(i915))
 		/* dummy PIPE_CONTROL + depth flush */
 		cs = gen12_emit_pipe_control(cs, 0,
 					     PIPE_CONTROL_DEPTH_CACHE_FLUSH, 0);
-- 
2.43.0



