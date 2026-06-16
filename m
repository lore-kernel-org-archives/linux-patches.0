Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FEE2F12AE;
	Tue, 16 Jun 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633280; cv=none; b=pMfD4f/zmqVFW3+f26LDuRNIIYIYEUPhUWM1K5sQYIbofPULrQ5+6TVZDEEaZoCNIj4lags6zXUx/qKDj2HYcRrGvU+67zx4zgsYDWx90un7SL3XetC/QvdXawCwaFHGVk3eNLtd9qQFipOYjHLF0noyajK8hKhKgktUi1whyp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633280; c=relaxed/simple;
	bh=VVA5aCvsh/Q9ewFiv0yLCR+YHsoS+sAK3+qvd2iX0G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iiGkNzPBFHbKoe4WmOiKY0WD+1i37kMYjMrpEv+xbLIccVWvGryDNoqPzUH2UNZHRJj3YRjKnk5d/8yzqNL7j+N/dAWQ8R6YHQHmQSErQkIy3gZsCwZJwYfA4ghznCCp7AWSep0TNHMnFwNo3uJqjdaAShEaTlr/Uhdnzy9SPIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuGN3Aml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuGN3Aml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026411F000E9;
	Tue, 16 Jun 2026 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633278;
	bh=YB3FAeJbyKe3OSB0qHW9Uom86Ie2QzvlLf5+NTKSfjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuGN3AmlfxcSL5HXZc/dFPqf+8Vq0/9PRA0vzc6P+JhdjTDbRgzg1ta8kAk+wl8dL
	 bvY3KwCHiX1b7Caw3Xf9mQ+Yh5JMyIcQzrNduEi+5jBNWFconEUycUKlvMKjIm9RvE
	 e52cPn8yMc/lcnLJFQClllRLJsZh3dzzHVvYumCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/411] drm/i915/psr: Read Intel DPCD workaround register
Date: Tue, 16 Jun 2026 20:24:45 +0530
Message-ID: <20260616145102.784739318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 90e055f0569940..ef4c280d2cb630 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1554,6 +1554,7 @@ struct intel_dp {
 	u8 lttpr_phy_caps[DP_MAX_LTTPR_COUNT][DP_LTTPR_PHY_CAP_SIZE];
 	u8 fec_capable;
 	u8 pcon_dsc_dpcd[DP_PCON_DSC_ENCODER_CAP_SIZE];
+	u8 intel_wa_dpcd;
 	/* source rates */
 	int num_source_rates;
 	const int *source_rates;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 93d2fd4cd16b7c..aa00e062a2a6aa 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -30,6 +30,7 @@
 #include "intel_atomic.h"
 #include "intel_de.h"
 #include "intel_display_types.h"
+#include "intel_dpcd.h"
 #include "intel_dp_aux.h"
 #include "intel_hdmi.h"
 #include "intel_psr.h"
@@ -363,6 +364,12 @@ void intel_psr_init_dpcd(struct intel_dp *intel_dp)
 			intel_dp_get_su_granularity(intel_dp);
 		}
 	}
+
+	if (intel_dp->psr.sink_psr2_support)
+		drm_dp_dpcd_read(&intel_dp->aux,
+				 INTEL_DPCD_INTEL_WA_REGISTER_CAPS,
+				 &intel_dp->intel_wa_dpcd,
+				 sizeof(intel_dp->intel_wa_dpcd));
 }
 
 static void hsw_psr_setup_aux(struct intel_dp *intel_dp)
-- 
2.53.0



