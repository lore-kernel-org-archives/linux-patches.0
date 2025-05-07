Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1C41CF5C6;
	Wed,  7 May 2025 19:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644835; cv=none; b=sQ3bv1aKCmcB47yWzeWDKeNUHxRbE0o0qqSaEBm0ySggvqxzPQFpGKsjGv7hF7H83YZ392R1340XfuYN10ZvFwjElZDbgndiAoExx1sfWNL51T80fZXbNcNO/XJE7nTWu+IjklrvY5SgMOO5Pxi+PNSSxamV5ghGyUvD1ovhcbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644835; c=relaxed/simple;
	bh=qeoG/nXleA38bu7RUdWDcGr5o4kNiXIKFSjpQ2mJiDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlOdViCVDl4J4NadEABvmemPpworLbn9YEtcFo3hae9jr6Tge6GrY0hXDd+fMgVG0lT/wbEUT626S85IeabYYb4j4F+7fDcozRxH+sVlGECGRJqnOk54xAsyh/cxN3uUqYdXtp98DE9N3ogsk+6iM1er/d9OE61V+VWYCqgbw1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjnHvMZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjnHvMZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3AFC4CEE2;
	Wed,  7 May 2025 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644835;
	bh=qeoG/nXleA38bu7RUdWDcGr5o4kNiXIKFSjpQ2mJiDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjnHvMZneanyvTFNJluHyINVXIZRSy3RludglN1lqZx9JGDCFgQQv6eGuZrUp314z
	 8HPpXLuVrOzZYq/YA9g3tDNJYIhmPW/209E6oYvIvGaolx3YfRrzOmV54HKLbeoHSQ
	 o/SUXheXcs9Q93c3+sIikl1WYCOZCd3PWh5WZasM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 152/164] drm/xe: Ensure fixed_slice_mode gets set after ccs_mode change
Date: Wed,  7 May 2025 20:40:37 +0200
Message-ID: <20250507183827.122450618@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

commit 262de94a3a7ef23c326534b3d9483602b7af841e upstream.

The RCU_MODE_FIXED_SLICE_CCS_MODE setting is not getting invoked
in the gt reset path after the ccs_mode setting by the user.
Add it to engine register update list (in hw_engine_setup_default_state())
which ensures it gets set in the gt reset and engine reset paths.

v2: Add register update to engine list to ensure it gets updated
after engine reset also.

Fixes: 0d97ecce16bd ("drm/xe: Enable Fixed CCS mode setting")
Cc: stable@vger.kernel.org
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250327185604.18230-1-niranjana.vishwanathapura@intel.com
(cherry picked from commit 12468e519f98e4d93370712e3607fab61df9dae9)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hw_engine.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -381,12 +381,6 @@ xe_hw_engine_setup_default_lrc_state(str
 				 blit_cctl_val,
 				 XE_RTP_ACTION_FLAG(ENGINE_BASE)))
 		},
-		/* Use Fixed slice CCS mode */
-		{ XE_RTP_NAME("RCU_MODE_FIXED_SLICE_CCS_MODE"),
-		  XE_RTP_RULES(FUNC(xe_hw_engine_match_fixed_cslice_mode)),
-		  XE_RTP_ACTIONS(FIELD_SET(RCU_MODE, RCU_MODE_FIXED_SLICE_CCS_MODE,
-					   RCU_MODE_FIXED_SLICE_CCS_MODE))
-		},
 		/* Disable WMTP if HW doesn't support it */
 		{ XE_RTP_NAME("DISABLE_WMTP_ON_UNSUPPORTED_HW"),
 		  XE_RTP_RULES(FUNC(xe_rtp_cfeg_wmtp_disabled)),
@@ -454,6 +448,12 @@ hw_engine_setup_default_state(struct xe_
 		  XE_RTP_ACTIONS(SET(CSFE_CHICKEN1(0), CS_PRIORITY_MEM_READ,
 				     XE_RTP_ACTION_FLAG(ENGINE_BASE)))
 		},
+		/* Use Fixed slice CCS mode */
+		{ XE_RTP_NAME("RCU_MODE_FIXED_SLICE_CCS_MODE"),
+		  XE_RTP_RULES(FUNC(xe_hw_engine_match_fixed_cslice_mode)),
+		  XE_RTP_ACTIONS(FIELD_SET(RCU_MODE, RCU_MODE_FIXED_SLICE_CCS_MODE,
+					   RCU_MODE_FIXED_SLICE_CCS_MODE))
+		},
 		{}
 	};
 


