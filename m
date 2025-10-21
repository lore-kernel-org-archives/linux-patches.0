Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EB52773F1;
	Tue, 21 Oct 2025 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077459; cv=none; b=hUAc8HzPw7tUvJu2mJify/6uHN+g9/GePFucQ5I8mxjK8LHgDhy+anyFBChz688PbFtVJFLTUz3Untm8ivQWBEKfTWEcxPyhYjbZIYxNCtZDI6BJ1jhb4hzPs9+4AZo1vIRfr+egK2n5OQevseTwhGR9fEw4EbEWUlbTBnHnLro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077459; c=relaxed/simple;
	bh=To6xkbsE9hOoyTPRGXO37Jy6h9h4kmXdTXmFwg2AZYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRsrb5NFg+0aybNZ34Zqcf5JNgHJvSEQuNJipSB9t1gdSLJYu2fSy77SU/jS55wmyJnqxWxIf0utB7chlPOPezmZxauToNE8+R+P3oyETYeFcwkJuCCsv2aFehpMt7ZBYZ+zE7CZkj0IZ8Md2xysa1r+/EJjrO3yXHD5eQi/nzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2eCD23W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2eCD23W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CAEC4CEF1;
	Tue, 21 Oct 2025 20:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077459;
	bh=To6xkbsE9hOoyTPRGXO37Jy6h9h4kmXdTXmFwg2AZYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2eCD23WOCJlDr5aOEPoX7vnJQOhEBAQy1JrBmYxNw81LCOhglEh/x6d+zr6SMr1E
	 pCklka9mkcceqwsWnvgPssa5S99MmxxBeeFbXHqaFVBmC4uCgxwTCg4UjeSz5bOpxb
	 xvpwpf4R/tEFHWjsHd9mTMnkX1N3t1pOgQUxLQiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 112/159] drm/xe: Enable media sampler power gating
Date: Tue, 21 Oct 2025 21:51:29 +0200
Message-ID: <20251021195045.861637242@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 1852d27aa998272696680607b65a2ceac966104e ]

Where applicable, enable media sampler power gating. Also, add
it to the powergate_info debugfs.

v2: Remove the sampler powergate status since it is cleared quickly anyway.
v3: Use vcs mask (Rodrigo) and fix the version check for media
v4: Remove extra spaces
v5: Media samplers are independent of vcs mask,
    use Media version 1255 (Matt Roper)

Fixes: 38e8c4184ea0 ("drm/xe: Enable Coarse Power Gating")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://lore.kernel.org/r/20251010011047.2047584-1-vinay.belgaumkar@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 4cbc08649a54c3d533df9832342d52d409dfbbf0)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_gt_idle.c      | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 5cd5ab8529c5c..9994887fc73f9 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -342,6 +342,7 @@
 #define POWERGATE_ENABLE			XE_REG(0xa210)
 #define   RENDER_POWERGATE_ENABLE		REG_BIT(0)
 #define   MEDIA_POWERGATE_ENABLE		REG_BIT(1)
+#define   MEDIA_SAMPLERS_POWERGATE_ENABLE	REG_BIT(2)
 #define   VDN_HCP_POWERGATE_ENABLE(n)		REG_BIT(3 + 2 * (n))
 #define   VDN_MFXVDENC_POWERGATE_ENABLE(n)	REG_BIT(4 + 2 * (n))
 
diff --git a/drivers/gpu/drm/xe/xe_gt_idle.c b/drivers/gpu/drm/xe/xe_gt_idle.c
index ffb210216aa99..9bd197da60279 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -124,6 +124,9 @@ void xe_gt_idle_enable_pg(struct xe_gt *gt)
 	if (xe_gt_is_main_type(gt))
 		gtidle->powergate_enable |= RENDER_POWERGATE_ENABLE;
 
+	if (MEDIA_VERx100(xe) >= 1100 && MEDIA_VERx100(xe) < 1255)
+		gtidle->powergate_enable |= MEDIA_SAMPLERS_POWERGATE_ENABLE;
+
 	if (xe->info.platform != XE_DG1) {
 		for (i = XE_HW_ENGINE_VCS0, j = 0; i <= XE_HW_ENGINE_VCS7; ++i, ++j) {
 			if ((gt->info.engine_mask & BIT(i)))
@@ -246,6 +249,11 @@ int xe_gt_idle_pg_print(struct xe_gt *gt, struct drm_printer *p)
 				drm_printf(p, "Media Slice%d Power Gate Status: %s\n", n,
 					   str_up_down(pg_status & media_slices[n].status_bit));
 	}
+
+	if (MEDIA_VERx100(xe) >= 1100 && MEDIA_VERx100(xe) < 1255)
+		drm_printf(p, "Media Samplers Power Gating Enabled: %s\n",
+			   str_yes_no(pg_enabled & MEDIA_SAMPLERS_POWERGATE_ENABLE));
+
 	return 0;
 }
 
-- 
2.51.0



