Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE7180BF8;
	Wed,  7 Aug 2024 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043375; cv=none; b=oq4ofn7XCR5MuDmnhZ42rew561SYAOeOnLqn1D1iKKY3wXOIVG5V+5B3Iv7iRaBueNvD/bKTPou+QVWiO8zN7Vn+ZuQAfNBxDsKduoshwuDAPOBVKY/PHBfF+f8/MzwOP1uuh90zs7IYzQ/iceXNNVTVP4CkjdwfNVTszc/0J9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043375; c=relaxed/simple;
	bh=ShFikJvj4zPtrUf8xiGj6Cu5qbxeELEmft69mrLqFcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKiWe1QF6Suqvq6Tg7QVUOGBy2Nxab0OxqbOd7WW/r2B/ysnA8eQh1Ow4h1+gw8MQh4dpAv6dcamfu6VN3eJgfpk6AMXnmYgQ7TYUjF2np7Cp6E4rn7c8GhfMqPsnyzLW0mqZYQeMb2tOu9NfRcav2FMsu5b7PE4ObOcSghHt6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySbTMqhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySbTMqhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFB3C32781;
	Wed,  7 Aug 2024 15:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043375;
	bh=ShFikJvj4zPtrUf8xiGj6Cu5qbxeELEmft69mrLqFcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySbTMqheOEu6aKdidqoxXhY/74r3v0AcVM7kuUYffO71yAsvkiF4Ft0vuK1HaIJ1U
	 jCcRMgqqqxS/rQU2WL9nTUBO6jyEyA9XxZ/VrbgZihm5QybnflrUOx+5YXO8MUYYlq
	 lKuy5+mGybzkP6RYd6vlH2y8aoZdDhEqE7eG2a9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/121] i915/perf: Remove code to update PWR_CLK_STATE for gen12
Date: Wed,  7 Aug 2024 17:00:00 +0200
Message-ID: <20240807150021.632050322@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 4bc14b9cfaa2149d41baef2f2620e9f82d9847d7 ]

PWR_CLK_STATE only needs to be modified up until gen11. For gen12 this
code is not applicable. Remove code to update context image with
PWR_CLK_STATE for gen12.

Fixes: 00a7f0d7155c ("drm/i915/tgl: Add perf support on TGL")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240629005643.3050678-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 7b5bdae7740eb6a3d09f9cd4e4b07362a15b86b3)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 33 --------------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 3f90403d86cb4..0808b54d3c518 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -2781,26 +2781,6 @@ oa_configure_all_contexts(struct i915_perf_stream *stream,
 	return 0;
 }
 
-static int
-gen12_configure_all_contexts(struct i915_perf_stream *stream,
-			     const struct i915_oa_config *oa_config,
-			     struct i915_active *active)
-{
-	struct flex regs[] = {
-		{
-			GEN8_R_PWR_CLK_STATE(RENDER_RING_BASE),
-			CTX_R_PWR_CLK_STATE,
-		},
-	};
-
-	if (stream->engine->class != RENDER_CLASS)
-		return 0;
-
-	return oa_configure_all_contexts(stream,
-					 regs, ARRAY_SIZE(regs),
-					 active);
-}
-
 static int
 lrc_configure_all_contexts(struct i915_perf_stream *stream,
 			   const struct i915_oa_config *oa_config,
@@ -2907,7 +2887,6 @@ gen12_enable_metric_set(struct i915_perf_stream *stream,
 {
 	struct drm_i915_private *i915 = stream->perf->i915;
 	struct intel_uncore *uncore = stream->uncore;
-	struct i915_oa_config *oa_config = stream->oa_config;
 	bool periodic = stream->periodic;
 	u32 period_exponent = stream->period_exponent;
 	u32 sqcnt1;
@@ -2951,15 +2930,6 @@ gen12_enable_metric_set(struct i915_perf_stream *stream,
 
 	intel_uncore_rmw(uncore, GEN12_SQCNT1, 0, sqcnt1);
 
-	/*
-	 * Update all contexts prior writing the mux configurations as we need
-	 * to make sure all slices/subslices are ON before writing to NOA
-	 * registers.
-	 */
-	ret = gen12_configure_all_contexts(stream, oa_config, active);
-	if (ret)
-		return ret;
-
 	/*
 	 * For Gen12, performance counters are context
 	 * saved/restored. Only enable it for the context that
@@ -3014,9 +2984,6 @@ static void gen12_disable_metric_set(struct i915_perf_stream *stream)
 				   _MASKED_BIT_DISABLE(GEN12_DISABLE_DOP_GATING));
 	}
 
-	/* Reset all contexts' slices/subslices configurations. */
-	gen12_configure_all_contexts(stream, NULL, NULL);
-
 	/* disable the context save/restore or OAR counters */
 	if (stream->ctx)
 		gen12_configure_oar_context(stream, NULL);
-- 
2.43.0



