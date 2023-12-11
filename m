Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D36151C37;
	Mon, 11 Dec 2023 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLGqZ7XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFEAC433C7;
	Mon, 11 Dec 2023 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320789;
	bh=LovYzxv90se7jLuK48lyOhj1LY53aezffhITIMjfETU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLGqZ7XZ4+GfDk3/qqerJTMcWwFax1Va6Yxa0scmoG3safNdu5vRZ+EwHKZfbjHmW
	 UPJo74BnNJFdzlz0PCHvX8PPdhdsRhFWndHLNNmxZvzbZrD+ANL/AUPc1FZwrXBOIQ
	 4z4fAnLDTUopcty9BG47op6yB98n12j1/AAG+cO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/194] drm/i915/display: Drop check for doublescan mode in modevalid
Date: Mon, 11 Dec 2023 19:23:01 +0100
Message-ID: <20231211182045.229177569@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit 9d04eb20bc71a383b4d4e383b0b7fac8d38a2e34 ]

Since the DP/HDMI connector do not set connector->doublescan_allowed,
the doublescan modes will get automatically filtered during
drm_helper_probe_single_connector_modes().

Therefore check for double scan modes is not required and is dropped
from modevalid functions for both DP and HDMI.

Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221017143038.1748319-2-ankit.k.nautiyal@intel.com
Stable-dep-of: 20c2dbff342a ("drm/i915: Skip some timing checks on BXT/GLK DSI transcoders")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c   | 3 ---
 drivers/gpu/drm/i915/display/intel_hdmi.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 594ea037050a9..fd7c360bb44d7 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -973,9 +973,6 @@ intel_dp_mode_valid(struct drm_connector *_connector,
 	enum drm_mode_status status;
 	bool dsc = false, bigjoiner = false;
 
-	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
-		return MODE_NO_DBLESCAN;
-
 	if (mode->flags & DRM_MODE_FLAG_DBLCLK)
 		return MODE_H_ILLEGAL;
 
diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 7816b2a33feeb..4f31355d09a4e 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1987,9 +1987,6 @@ intel_hdmi_mode_valid(struct drm_connector *connector,
 	bool has_hdmi_sink = intel_has_hdmi_sink(hdmi, connector->state);
 	bool ycbcr_420_only;
 
-	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
-		return MODE_NO_DBLESCAN;
-
 	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
 		clock *= 2;
 
-- 
2.42.0



