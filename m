Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F541F76AC;
	Tue, 17 Dec 2024 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455990; cv=none; b=BCdigXXL5ZB3sCwu8mgNFScCJ7f0zf0X6xY8cWJFhoy5Z37RxJ9em8EUhGcqwJ2MWFMZXDt6xPSL/kIpY8zRyfhu5HgkhCoTEOrufUmLpUYUKOTpbac4FEjjmFDewjhbc14H6W+BfhMigOs5uOpjTP9FPU8n2uIAophe5lGa62I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455990; c=relaxed/simple;
	bh=tS3kBuKeFeGDUU9OYgkdFAoLviy+hFvNs7J0O/Daa0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRPKPAxglk4nxQaiI90NKg2Q4XN43W2vD801jgeALCeg86XQV495JHJNx1RKCdVoem/9IjkJiM0y+MzRMZdKeDtg0KcrESbUbiVKCgnxzHI12dH4nnRCx9MfBdY/hA6UIWHlhhtlMawrMsmnIcOylAijLGM/H7rOzESzgpESypM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFLfuuQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFLfuuQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31EDC4CED3;
	Tue, 17 Dec 2024 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455990;
	bh=tS3kBuKeFeGDUU9OYgkdFAoLviy+hFvNs7J0O/Daa0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFLfuuQHm+YeOGSwlWui5aWfc4us0rxYsz9fYua1Wc+/chQXNY5sEzWGb4JGG/Zzj
	 olXf/UY8UOpFFOd1eimVKUppF9drNHEt+30yHX/FFYJU/nIdRBiUbWl5fsnm+IFxEr
	 HgtUQaSJ2gHkw3KKRPz7BKlS7cOFTyrt9KKIFlqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Eugene Kobyak <eugene.kobyak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.6 023/109] drm/i915: Fix NULL pointer dereference in capture_engine
Date: Tue, 17 Dec 2024 18:07:07 +0100
Message-ID: <20241217170534.335512649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Eugene Kobyak <eugene.kobyak@intel.com>

commit da0b986256ae9a78b0215214ff44f271bfe237c1 upstream.

When the intel_context structure contains NULL,
it raises a NULL pointer dereference error in drm_info().

Fixes: e8a3319c31a1 ("drm/i915: Allow error capture without a request")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12309
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Eugene Kobyak <eugene.kobyak@intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/xmsgfynkhycw3cf56akp4he2ffg44vuratocsysaowbsnhutzi@augnqbm777at
(cherry picked from commit 754302a5bc1bd8fd3b7d85c168b0a1af6d4bba4d)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_gpu_error.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -1638,9 +1638,21 @@ capture_engine(struct intel_engine_cs *e
 		return NULL;
 
 	intel_engine_get_hung_entity(engine, &ce, &rq);
-	if (rq && !i915_request_started(rq))
-		drm_info(&engine->gt->i915->drm, "Got hung context on %s with active request %lld:%lld [0x%04X] not yet started\n",
-			 engine->name, rq->fence.context, rq->fence.seqno, ce->guc_id.id);
+	if (rq && !i915_request_started(rq)) {
+		/*
+		 * We want to know also what is the guc_id of the context,
+		 * but if we don't have the context reference, then skip
+		 * printing it.
+		 */
+		if (ce)
+			drm_info(&engine->gt->i915->drm,
+				 "Got hung context on %s with active request %lld:%lld [0x%04X] not yet started\n",
+				 engine->name, rq->fence.context, rq->fence.seqno, ce->guc_id.id);
+		else
+			drm_info(&engine->gt->i915->drm,
+				 "Got hung context on %s with active request %lld:%lld not yet started\n",
+				 engine->name, rq->fence.context, rq->fence.seqno);
+	}
 
 	if (rq) {
 		capture = intel_engine_coredump_add_request(ee, rq, ATOMIC_MAYFAIL);


