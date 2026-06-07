Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A431E84C;
	Sun,  7 Jun 2026 10:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827714; cv=none; b=TmiUU72oKJ1aUcQQnpwnrZYZ/pT1GMw9O6vOyQQxavco5eBK+SsuM1SSUstC3vDSS6ZpXLlHAX20wwAKG/PJcluR4q5mDt5h/IKv0h3xEtEI/uO+paQDINffV5bvBdBtSHebpAX7ke3jFw0Fq0MMx7uPQjE2klwkagbRtxwP7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827714; c=relaxed/simple;
	bh=IeI/rlpShz74CmwwuPYnMX86Y8ABhU/zYGiMrMV9qnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ri/A4h+Pg7T6l+zLuD0l56koZ3Bek2DZWidHzSp4lKVw25+GoHjf5CMMkAl6Zj3xBUWarLN7hkmdYCzAowdEiXqTRcQuCrl1YSB+Bkgq+VxD0Ez3GbKh2rasB3rq+yY/hS8w/dImTrBy5TP9mlzloh9OHmyKOPaxhFxMEhK4bNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3NdPLuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3NdPLuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2421F00898;
	Sun,  7 Jun 2026 10:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827712;
	bh=Ns83Nt0tBR2kd2fEJbuZP1mVRIo0FZHUWMlzlhrlrY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3NdPLuG8DzGWeTuOR2w1GNqEnxukDwHoHocvjvT1tka5IWQdnQopXVuDHB6B/JED
	 IzvzGFZ0hPAQPk9zCFziI3RiMugqoxgpngu1YFUe2o8tw1zOB5okhEo0QcLNnWtSEH
	 AsOCZ82IqFap1yADu+cisMyrxtnbDRXlN9d0II9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 116/332] drm/i915/psr: Read Intel DPCD workaround register
Date: Sun,  7 Jun 2026 11:58:05 +0200
Message-ID: <20260607095732.372226886@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/i915/display/intel_psr.c           | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_types.h b/drivers/gpu/drm/i915/display/intel_display_types.h
index ced0e5a5989b85..3596ed0ff151bf 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -583,6 +583,7 @@ struct intel_connector {
 
 		struct {
 			u8 dpcd[EDP_PSR_RECEIVER_CAP_SIZE];
+			u8 intel_wa_dpcd;
 
 			bool support;
 			bool su_support;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 8a7075c4a2480f..aa2ef49afa67a9 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -43,6 +43,7 @@
 #include "intel_display_utils.h"
 #include "intel_dmc.h"
 #include "intel_dp.h"
+#include "intel_dpcd.h"
 #include "intel_dp_aux.h"
 #include "intel_dsb.h"
 #include "intel_frontbuffer.h"
@@ -708,8 +709,14 @@ static void _psr_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *co
 			    connector->dp.psr_caps.su_support ? "" : "not ");
 	}
 
-	if (connector->dp.psr_caps.su_support)
+	if (connector->dp.psr_caps.su_support) {
+		ret = drm_dp_dpcd_read_byte(&intel_dp->aux,
+					    INTEL_DPCD_INTEL_WA_REGISTER_CAPS,
+					    &connector->dp.psr_caps.intel_wa_dpcd);
+		if (ret < 0)
+			return;
 		_psr_compute_su_granularity(intel_dp, connector);
+	}
 }
 
 void intel_psr_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *connector)
-- 
2.53.0



