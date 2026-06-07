Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA7131F993;
	Sun,  7 Jun 2026 10:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827793; cv=none; b=FRh5llikEdnBNh21Bh8qGAYwrxECQJRHriSxBbdKu7du3e8mkbdxhJQWB+xRDFgRZ3ZVAZ4AeRTy1oEd7A6ft/nn/i24+Z3cUD0E7KWW/npIKRAPgTi7UVhxwo9mRRUdZ82hT/o+0W2/mSDz6R2U7+qCiwp9+FrQ4XpXj60KZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827793; c=relaxed/simple;
	bh=T2kZI8L5wiuspX/lOXXjYgIk4IXkYzTCWgeKhdFycxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGSKt7Uxx7S1BcdPUsT6KbJ4TLzRmtHuDCQkXmzITjxayq8bvxQqDpH6Slt/njeH8w5oq6tRRHmoScSVGpCehjy1RYOByxxeKBHfWKBT/QmmlNDNkaFep4pOxRmaGw/BdIk59PRUJn5cTwCr7gxVjxNotocWnnoYwSCubhA12Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InytbgY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InytbgY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5621F00893;
	Sun,  7 Jun 2026 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827792;
	bh=+/CgDUKqf2FM99tH5OZUOJCDQKMQquN+tYmHqxKfV9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InytbgY/NknMjwg2k87lpES2XpHwi0gtJPyuEwEJ6Ny8GRIkdM9/Ugl7Bu6CpxlsT
	 vmOp8rXzOjjHDw/H2eiMdPLec/qCDAkg5W0H+lKuO76VyNT9mPp+SQ/Eqbm0TEy15R
	 cuRs93KDoaT9HNUXcstACOt8l+kZvE+LRIgsY2L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/315] drm/i915/psr: Read Intel DPCD workaround register
Date: Sun,  7 Jun 2026 11:58:08 +0200
Message-ID: <20260607095731.356111500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit f30bece421a4ae34359254e1dc2a187a42b6af9b upstream.

Read Intel DPCD workaround register and store it into
intel_connector->dp.psr_caps. psr_caps was chosen as currently it contains
only PSR workaround for PSR2 SDP on prior scanline implementation.

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260515095756.2799483-3-jouni.hogander@intel.com
(cherry picked from commit c48ff24d0f4ab7ad696b2d35ad64ce7e049c668c)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h | 1 +
 drivers/gpu/drm/i915/display/intel_psr.c           | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index 39dd7389f1a71a..197bdb6592a7f9 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1710,6 +1710,7 @@ struct intel_dp {
 	u8 lttpr_common_caps[DP_LTTPR_COMMON_CAP_SIZE];
 	u8 lttpr_phy_caps[DP_MAX_LTTPR_COUNT][DP_LTTPR_PHY_CAP_SIZE];
 	u8 pcon_dsc_dpcd[DP_PCON_DSC_ENCODER_CAP_SIZE];
+	u8 intel_wa_dpcd;
 	/* source rates */
 	int num_source_rates;
 	const int *source_rates;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 1da20065ea7763..802a671b2afaaa 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -41,6 +41,7 @@
 #include "intel_display_types.h"
 #include "intel_dmc.h"
 #include "intel_dp.h"
+#include "intel_dpcd.h"
 #include "intel_dp_aux.h"
 #include "intel_dsb.h"
 #include "intel_frontbuffer.h"
@@ -679,6 +680,12 @@ static void _psr_init_dpcd(struct intel_dp *intel_dp)
 		drm_dbg_kms(display->drm, "PSR2 %ssupported\n",
 			    intel_dp->psr.sink_psr2_support ? "" : "not ");
 	}
+
+	if (intel_dp->psr.sink_psr2_support)
+		drm_dp_dpcd_read(&intel_dp->aux,
+				 INTEL_DPCD_INTEL_WA_REGISTER_CAPS,
+				 &intel_dp->intel_wa_dpcd,
+				 sizeof(intel_dp->intel_wa_dpcd));
 }
 
 void intel_psr_init_dpcd(struct intel_dp *intel_dp)
-- 
2.53.0



