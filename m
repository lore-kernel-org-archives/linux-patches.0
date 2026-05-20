Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3B73E2AAD;
	Wed, 20 May 2026 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302518; cv=none; b=kl2nVnb6dFIAx1oyaG6u9+3s2Zgqnuc7aLLUDC8z0rfLpdkmwx/Jagy4aShWuThM4A2OLmSduyP/XZ/wTMkHgCUQSxDqj/+8CYi39l+58sAm/6pZgS5reBqV2XiJGk9bjl5pSiLjmiHDxmbNGM7dX6E3YCxa4/d9wQAprjSdSQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302518; c=relaxed/simple;
	bh=y4Qpedpmhz8uThPPhGjqfbB43d8uDG6rmG3xVQzb6hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARANGml1gbbViZrncpGHVDGe3vNwn+xlA284DPeyIXq0JTNqyluYF7oKx1caRTUiqQkNsrjrkPibgClnLzqhVFWHGk863uRsGbifBVzi1IsJFaA7zvju99JLV8kwk6cHvLKtFQvKp3VwSqTvpJo4zVMl38Za+SeO/Ki39dQtC3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eh8BqGuq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eh8BqGuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939311F000E9;
	Wed, 20 May 2026 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302517;
	bh=7vp/GBjguv46Ks9JLcnSe1mRnquKKBwN5I4SwjAsCDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh8BqGuqOVYXJMqg8jEdgvZo2oLQXj2f+hCWwMezIiaIMBali3xgOtVunIQmPzwCA
	 O9IMrNdyUqYwViD3LEsktkbpIyLqhMaFkvofxYtIOfS+uVdoqEkV7EQBpII2+SsWiY
	 TrvqsHbDSYCKqZsRzOHoI7VxGiV1qMmUztkPWJdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 295/508] drm/i915: Constify watermark state checker
Date: Wed, 20 May 2026 18:21:58 +0200
Message-ID: <20260520162105.037194557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 487a2db8bc4eb79c53c9ff8fca65a7fc8350df6c ]

The skl+ wm state checker has no reason to modify the crtc state,
so make it const.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231004155607.7719-6-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: a97c88a176b6 ("drm/i915/wm: Verify the correct plane DDB entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 2 +-
 drivers/gpu/drm/i915/display/skl_watermark.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 063929a42a42f..8a82576ca0289 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3133,7 +3133,7 @@ static void skl_wm_get_hw_state_and_sanitize(struct drm_i915_private *i915)
 }
 
 void intel_wm_state_verify(struct intel_crtc *crtc,
-			   struct intel_crtc_state *new_crtc_state)
+			   const struct intel_crtc_state *new_crtc_state)
 {
 	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
 	struct skl_hw_state {
diff --git a/drivers/gpu/drm/i915/display/skl_watermark.h b/drivers/gpu/drm/i915/display/skl_watermark.h
index f91a3d4ddc075..3aa138d387900 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.h
+++ b/drivers/gpu/drm/i915/display/skl_watermark.h
@@ -39,7 +39,7 @@ bool skl_ddb_allocation_overlaps(const struct skl_ddb_entry *ddb,
 				 int num_entries, int ignore_idx);
 
 void intel_wm_state_verify(struct intel_crtc *crtc,
-			   struct intel_crtc_state *new_crtc_state);
+			   const struct intel_crtc_state *new_crtc_state);
 
 void skl_watermark_ipc_init(struct drm_i915_private *i915);
 void skl_watermark_ipc_update(struct drm_i915_private *i915);
-- 
2.53.0



