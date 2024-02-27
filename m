Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4476143C48;
	Tue, 27 Feb 2024 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042851; cv=none; b=bp7q7gXRN81dKmVVAGWPpXarE2s+oDQ+/rsR8O5f2Spe95ihnLMBIzFfFCGyd6nXcziBlmnzo68BvH0tsq79UyI46MToIoSBWNHWXK0ySKCo1dEFMec4Pi1tUhtUTBEOpXAFMVmm2nd313MHCDZrrqNuvFUCb/wjg5IVxBUHP5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042851; c=relaxed/simple;
	bh=7hLPtZrYID6SR7Se62Lp1PGntql64XcUxAGCDzl4ht0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1eoO0O9rRdUMfEFUcwErJPsOSorJ9unPXsNwd79W2LeuBxjh2Paifmwi27XfsMw4HBqNLpY+q88fAamA+QzsrsliHs6NaAvlRxsf7W2PQ0/LW9wkRxyXxkSRZDa+5sZWR8DXVDx2VaIgvxYS5asOZ7r/+hE/QeFUauiJdTkxSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3/VQXk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3/VQXk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717B0C433F1;
	Tue, 27 Feb 2024 14:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042850;
	bh=7hLPtZrYID6SR7Se62Lp1PGntql64XcUxAGCDzl4ht0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3/VQXk/QnuoqKnpK3CoZwzl5vICxI8eXHy6DaEanDP2Rvq453ou6sQOlAeNsRV7f
	 9GCNncwsUMCKxBsk5aXQZ6lN01n9MOop5az6QlCAp3GKWbd2stNfxn/fZP6eZSx4dr
	 3YFotPiY3yW0pe9sY6SIxobcSY4UGSTf46WOvp1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Chuansheng Liu <chuansheng.liu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/245] drm/i915/dg1: Update DMC_DEBUG3 register
Date: Tue, 27 Feb 2024 14:25:31 +0100
Message-ID: <20240227131619.870675226@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuansheng Liu <chuansheng.liu@intel.com>

[ Upstream commit b60668cb4c57a7cc451de781ae49f5e9cc375eaf ]

Current DMC_DEBUG3(_MMIO(0x101090)) address is for TGL,
it is wrong for DG1. Just like commit 5bcc95ca382e
("drm/i915/dg1: Update DMC_DEBUG register"), correct
this issue for DG1 platform to avoid wrong register
being read.

BSpec: 49788

v2: fix "not wrong" typo. (Jani)

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220211002933.84240-1-chuansheng.liu@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_debugfs.c | 4 ++--
 drivers/gpu/drm/i915/i915_reg.h                      | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_debugfs.c b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
index b136a0fc0963b..6b3e2e053f457 100644
--- a/drivers/gpu/drm/i915/display/intel_display_debugfs.c
+++ b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
@@ -571,8 +571,8 @@ static int i915_dmc_info(struct seq_file *m, void *unused)
 		 * reg for DC3CO debugging and validation,
 		 * but TGL DMC f/w is using DMC_DEBUG3 reg for DC3CO counter.
 		 */
-		seq_printf(m, "DC3CO count: %d\n",
-			   intel_de_read(dev_priv, DMC_DEBUG3));
+		seq_printf(m, "DC3CO count: %d\n", intel_de_read(dev_priv, IS_DGFX(dev_priv) ?
+					DG1_DMC_DEBUG3 : TGL_DMC_DEBUG3));
 	} else {
 		dc5_reg = IS_BROXTON(dev_priv) ? BXT_DMC_DC3_DC5_COUNT :
 						 SKL_DMC_DC3_DC5_COUNT;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 3c70aa5229e5a..906982d6370d0 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7841,7 +7841,8 @@ enum {
 #define TGL_DMC_DEBUG_DC6_COUNT	_MMIO(0x101088)
 #define DG1_DMC_DEBUG_DC5_COUNT	_MMIO(0x134154)
 
-#define DMC_DEBUG3		_MMIO(0x101090)
+#define TGL_DMC_DEBUG3		_MMIO(0x101090)
+#define DG1_DMC_DEBUG3		_MMIO(0x13415c)
 
 /* Display Internal Timeout Register */
 #define RM_TIMEOUT		_MMIO(0x42060)
-- 
2.43.0



