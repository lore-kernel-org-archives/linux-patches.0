Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B7B7E583;
	Mon,  8 Apr 2024 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583815; cv=none; b=IOdvz69hWazrmb//ve6njkcJrdT1YCSL1ia/rLbk7bNlqs580riNvBYrBSpKG482TkrGkkv9F8aw712Egg6KkcWd3xQGaJGl4RXR/MJjh197jXE16ELkCHG/QjxraSkER9CC8RSxMgaX82vz0LJX6Sf6AQ87lIdi5EDs+P/rSCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583815; c=relaxed/simple;
	bh=Itse5ROsHxOAYxxoxpf11GSwa81KN2eUZiZ33MKx4zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjcIwkmirgVKpWvdblIl+GmyLHSNnuXkKgUyn1fShgW781mrmQb5GmF+SorOQgq0lJlFliz9OEJ6I7eaxIX99JzWjh3jNVRBdAMkEU24ZIVvS9CSCNuo4esT/mi2y1/QzBQY1ak60cG4Y63l/jqbOQQ6X21g0o/bHJcD38mWWOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guZ94K4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guZ94K4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF03C433F1;
	Mon,  8 Apr 2024 13:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583815;
	bh=Itse5ROsHxOAYxxoxpf11GSwa81KN2eUZiZ33MKx4zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guZ94K4ors5ho6FdjeHPlp6n5mYXaYhsNFpQpPfZK9IpQz2wrMHX1ceLD5Rq3Ux2I
	 lnIuSaE3srWzDTslZ4XQeMUPSteaEOaYOZWyxqcA9Np+ZfVysfVgnmmGzswttC4um+
	 SCImYfmikc0YoowImSa0Al/fKCyPyYQXSD5lPu6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Michal Mrozek <michal.mrozek@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.6 238/252] drm/i915/gt: Disable HW load balancing for CCS
Date: Mon,  8 Apr 2024 14:58:57 +0200
Message-ID: <20240408125314.036655983@linuxfoundation.org>
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

From: Andi Shyti <andi.shyti@linux.intel.com>

commit bc9a1ec01289e6e7259dc5030b413a9c6654a99a upstream.

The hardware should not dynamically balance the load between CCS
engines. Wa_14019159160 recommends disabling it across all
platforms.

Fixes: d2eae8e98d59 ("drm/i915/dg2: Drop force_probe requirement")
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: <stable@vger.kernel.org> # v6.2+
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Michal Mrozek <michal.mrozek@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240328073409.674098-2-andi.shyti@linux.intel.com
(cherry picked from commit f5d2904cf814f20b79e3e4c1b24a4ccc2411b7e0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     |    1 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -1468,6 +1468,7 @@
 #define   ECOBITS_PPGTT_CACHE4B			(0 << 8)
 
 #define GEN12_RCU_MODE				_MMIO(0x14800)
+#define   XEHP_RCU_MODE_FIXED_SLICE_CCS_MODE	REG_BIT(1)
 #define   GEN12_RCU_MODE_CCS_ENABLE		REG_BIT(0)
 
 #define CHV_FUSE_GT				_MMIO(VLV_GUNIT_BASE + 0x2168)
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -50,7 +50,8 @@
  *   registers belonging to BCS, VCS or VECS should be implemented in
  *   xcs_engine_wa_init(). Workarounds for registers not belonging to a specific
  *   engine's MMIO range but that are part of of the common RCS/CCS reset domain
- *   should be implemented in general_render_compute_wa_init().
+ *   should be implemented in general_render_compute_wa_init(). The settings
+ *   about the CCS load balancing should be added in ccs_engine_wa_mode().
  *
  * - GT workarounds: the list of these WAs is applied whenever these registers
  *   revert to their default values: on GPU reset, suspend/resume [1]_, etc.
@@ -2823,6 +2824,22 @@ add_render_compute_tuning_settings(struc
 		wa_write_clr(wal, GEN8_GARBCNTL, GEN12_BUS_HASH_CTL_BIT_EXC);
 }
 
+static void ccs_engine_wa_mode(struct intel_engine_cs *engine, struct i915_wa_list *wal)
+{
+	struct intel_gt *gt = engine->gt;
+
+	if (!IS_DG2(gt->i915))
+		return;
+
+	/*
+	 * Wa_14019159160: This workaround, along with others, leads to
+	 * significant challenges in utilizing load balancing among the
+	 * CCS slices. Consequently, an architectural decision has been
+	 * made to completely disable automatic CCS load balancing.
+	 */
+	wa_masked_en(wal, GEN12_RCU_MODE, XEHP_RCU_MODE_FIXED_SLICE_CCS_MODE);
+}
+
 /*
  * The workarounds in this function apply to shared registers in
  * the general render reset domain that aren't tied to a
@@ -2970,8 +2987,10 @@ engine_init_workarounds(struct intel_eng
 	 * to a single RCS/CCS engine's workaround list since
 	 * they're reset as part of the general render domain reset.
 	 */
-	if (engine->flags & I915_ENGINE_FIRST_RENDER_COMPUTE)
+	if (engine->flags & I915_ENGINE_FIRST_RENDER_COMPUTE) {
 		general_render_compute_wa_init(engine, wal);
+		ccs_engine_wa_mode(engine, wal);
+	}
 
 	if (engine->class == COMPUTE_CLASS)
 		ccs_engine_wa_init(engine, wal);


