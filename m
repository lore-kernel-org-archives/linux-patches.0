Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDAF47CC63;
	Tue, 16 Jun 2026 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630839; cv=none; b=skrRdS/PZhcorkocq62+CCvYUtUCYs3QTDE69bGSNNvYlSDMzxTs5ovzu735kncS8gAWrtbQdssVGtPUb4fk1V9hY87v/s/xtVIjTiZk17m0R3SxtKJSY+eWmdY2eh/Mb8RGC77xyheW+ly/r5PC13t/YUU7ZYsgMRR55kTEG20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630839; c=relaxed/simple;
	bh=wv1VihaZ0r/JH3VN1oFgAeFvGydBS6yxk4oRNE/Mfgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f7+3caQ9SSNUReirktrPPmd0cAjAdcWkBDhZMKLP7VPzQ7q+PAz3HwS/Do1I1iWI+2uU74/k2xk/+AvaVyrFx9ZMQII21tVq+zxibYzeDicjXp3rdvo3nI61n0Q8XVYx0Xzu30/dJDk32fbSgiBgs4yL2G+p33vkbnVvwRQAbFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/Y8L0xU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/Y8L0xU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965F31F000E9;
	Tue, 16 Jun 2026 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630834;
	bh=hqprzrcvLyALOVdLVsvaOH5OZrLZ7b5e8Po4mZyUj4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/Y8L0xUz3rkD7qYMfO/scNRvgN2yJg3BNALurw2Gy6qJXs7WyoHAadR6PyfjLqsf
	 BLrtlGH/4i/CcvMiOqmDQRq/qyMp/o6xb+sjIypC4f8U2KjVL178CPuw/6XZOnF5mV
	 EgNbsNmow+l//r2HjtHPkZkvzFSEmUuBtBk48Ygw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/522] drm/i915/psr: Read Intel DPCD workaround register
Date: Tue, 16 Jun 2026 20:23:39 +0530
Message-ID: <20260616145129.205875312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a8bf91a21cb246..a26c082bdc3289 100644
--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1637,6 +1637,7 @@ struct intel_dp {
 	u8 lttpr_phy_caps[DP_MAX_LTTPR_COUNT][DP_LTTPR_PHY_CAP_SIZE];
 	u8 fec_capable;
 	u8 pcon_dsc_dpcd[DP_PCON_DSC_ENCODER_CAP_SIZE];
+	u8 intel_wa_dpcd;
 	/* source rates */
 	int num_source_rates;
 	const int *source_rates;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index a465b192931085..01fadf300ff679 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -31,6 +31,7 @@
 #include "intel_crtc.h"
 #include "intel_de.h"
 #include "intel_display_types.h"
+#include "intel_dpcd.h"
 #include "intel_dp_aux.h"
 #include "intel_hdmi.h"
 #include "intel_psr.h"
@@ -388,6 +389,12 @@ void intel_psr_init_dpcd(struct intel_dp *intel_dp)
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
 
 static void intel_psr_enable_sink(struct intel_dp *intel_dp)
-- 
2.53.0



