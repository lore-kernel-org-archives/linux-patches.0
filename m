Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58B423F417;
	Sun,  7 Jun 2026 10:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828199; cv=none; b=eJ3uWKaPMXCVYC17OryrE7KPlAJk2QBNGGZsyZQjl17I/LbrLYffYNZ1vH0nEgWofYuBtJYwTcrgLRyMiuDInwkKGDEFr40+E8AsBquV2ya4R1VuK4PpKaxlTuol0ncYIy94qj3gahxtSgla8MDpfZW0iUhcTJHHXi2tStryNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828199; c=relaxed/simple;
	bh=Pe9QmS9yiEuqV7SlJh2tse+duT0MajL79YU9LuPbtdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qw5cN5eSphJerNRe1qrhulwNZvN9PmyUqFvsWgU5OfGwgXIOFPpiFSiWgFDFFcHLWwqRRBRegJ/pP2ylsJH/seLOKnVxfU1RDvbb1gCQ1SjzZXm7PuUvjJ6pTiAN7JHJCMLqaMpG2VJsgCPzXlt5uvY5yyrfRkUzEV58PAudIQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7hgPXHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7hgPXHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCFA1F00893;
	Sun,  7 Jun 2026 10:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828196;
	bh=l2mZ5/zBDxac8ag6azaHurYuhyhIAHkX17e0RBFIJl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7hgPXHgXRlPJ8+DHi+pmfeuVxY+KYlkzWKU3L7OCD37NVLj8CyToIggsfgQDmD/c
	 sMtk40dlWNHVYEtwOENf3ZfXPnate0s5LbmZMqXNEFoRYgU7GfVjCYUVLe81CbKk0N
	 vNz3hoNYDZXk7NTikgE6g4RlU+cDT7eICsmrcQIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/307] drm/i915/psr: Read Intel DPCD workaround register
Date: Sun,  7 Jun 2026 11:58:36 +0200
Message-ID: <20260607095732.134893579@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2039c17a9ee787..992945b37190e6 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1773,6 +1773,7 @@ struct intel_dp {
 	u8 lttpr_common_caps[DP_LTTPR_COMMON_CAP_SIZE];
 	u8 lttpr_phy_caps[DP_MAX_LTTPR_COUNT][DP_LTTPR_PHY_CAP_SIZE];
 	u8 pcon_dsc_dpcd[DP_PCON_DSC_ENCODER_CAP_SIZE];
+	u8 intel_wa_dpcd;
 	/* source rates */
 	int num_source_rates;
 	const int *source_rates;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 2a7f379c59fefd..9c38b957701675 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -35,6 +35,7 @@
 #include "intel_de.h"
 #include "intel_display_types.h"
 #include "intel_dp.h"
+#include "intel_dpcd.h"
 #include "intel_dp_aux.h"
 #include "intel_frontbuffer.h"
 #include "intel_hdmi.h"
@@ -665,6 +666,12 @@ static void _psr_init_dpcd(struct intel_dp *intel_dp)
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



