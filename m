Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5445B1DFE04;
	Wed,  6 Nov 2024 12:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896525; cv=none; b=clyv7ZG/SVd3W1K7lI5SjOQEc7tGoLRdT/ELDrTgO5BubKUi6cV97g8OOpaueJ9f8QytVXrHxNgqXlCkDK8Hix2LacvTfjH4GzdHiBYGu1lNrr2Y2Rt4XWjABR1iEdq9lEY718p+rnwZvi+6VkyKgcL+YsVYNsk4/yMOXfNyIR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896525; c=relaxed/simple;
	bh=MRXAqxySOOSo/22oR+pstallKACL+M/osUDTykC5m5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D7DvE4PwZmML1GjjEhWr5x0BuUGQn4ncke3nk9/QUwxPdFCLP8M7/69jZEyBXrLTsrYYeoJRP1e4WhZGDTu6MSLvcwFchuFQayyufYompuA5rwSF9q3TyiFbBcgvy3trWkrVYKUhO6CfYkq8JINfZHRQNxgx/9FqRg4dqaXMClA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KiUjxcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KiUjxcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1589C4CECD;
	Wed,  6 Nov 2024 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896525;
	bh=MRXAqxySOOSo/22oR+pstallKACL+M/osUDTykC5m5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KiUjxcHACt0yHTnok6M1k3+V7BjWiELYH72I53RC4Dj1y9e6klIQQNUtDxaOBOUu
	 5Rw3wjHBo5RObRjLOK5Fheiyv8xjp8YrSh0G2J5YdFOMAGDXi7v1F2jseQ2KupVjas
	 ZwPWPIPDeSVojy9sfVCcSo/LEeZkVKarhbmIg/xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 230/245] drm/i915: move rawclk from runtime to display runtime info
Date: Wed,  6 Nov 2024 13:04:43 +0100
Message-ID: <20241106120324.922202761@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit a9556637a23311dea96f27fa3c3e5bfba0b38ae4 upstream.

It's mostly about display, so move it under display. This should also
fix rawclk freq initialization in the xe driver.

v2: Change the init location

Link: https://lore.kernel.org/r/20240819133138.147511-2-maarten.lankhorst@linux.intel.com
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/39330d09c48509e013f01fd0247a9b7c291173e2.1724144570.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_backlight.c          |   10 +++++-----
 drivers/gpu/drm/i915/display/intel_display_device.c     |    5 +++++
 drivers/gpu/drm/i915/display/intel_display_device.h     |    2 ++
 drivers/gpu/drm/i915/display/intel_display_power_well.c |    4 ++--
 drivers/gpu/drm/i915/display/intel_dp_aux.c             |    4 ++--
 drivers/gpu/drm/i915/display/intel_pps.c                |    2 +-
 drivers/gpu/drm/i915/intel_device_info.c                |    5 -----
 drivers/gpu/drm/i915/intel_device_info.h                |    2 --
 8 files changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_backlight.c
@@ -1011,7 +1011,7 @@ static u32 cnp_hz_to_pwm(struct intel_co
 {
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 
-	return DIV_ROUND_CLOSEST(KHz(RUNTIME_INFO(i915)->rawclk_freq),
+	return DIV_ROUND_CLOSEST(KHz(DISPLAY_RUNTIME_INFO(i915)->rawclk_freq),
 				 pwm_freq_hz);
 }
 
@@ -1073,7 +1073,7 @@ static u32 pch_hz_to_pwm(struct intel_co
 {
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 
-	return DIV_ROUND_CLOSEST(KHz(RUNTIME_INFO(i915)->rawclk_freq),
+	return DIV_ROUND_CLOSEST(KHz(DISPLAY_RUNTIME_INFO(i915)->rawclk_freq),
 				 pwm_freq_hz * 128);
 }
 
@@ -1091,7 +1091,7 @@ static u32 i9xx_hz_to_pwm(struct intel_c
 	int clock;
 
 	if (IS_PINEVIEW(i915))
-		clock = KHz(RUNTIME_INFO(i915)->rawclk_freq);
+		clock = KHz(DISPLAY_RUNTIME_INFO(i915)->rawclk_freq);
 	else
 		clock = KHz(i915->display.cdclk.hw.cdclk);
 
@@ -1109,7 +1109,7 @@ static u32 i965_hz_to_pwm(struct intel_c
 	int clock;
 
 	if (IS_G4X(i915))
-		clock = KHz(RUNTIME_INFO(i915)->rawclk_freq);
+		clock = KHz(DISPLAY_RUNTIME_INFO(i915)->rawclk_freq);
 	else
 		clock = KHz(i915->display.cdclk.hw.cdclk);
 
@@ -1133,7 +1133,7 @@ static u32 vlv_hz_to_pwm(struct intel_co
 			clock = MHz(25);
 		mul = 16;
 	} else {
-		clock = KHz(RUNTIME_INFO(i915)->rawclk_freq);
+		clock = KHz(DISPLAY_RUNTIME_INFO(i915)->rawclk_freq);
 		mul = 128;
 	}
 
--- a/drivers/gpu/drm/i915/display/intel_display_device.c
+++ b/drivers/gpu/drm/i915/display/intel_display_device.c
@@ -1474,6 +1474,9 @@ static void __intel_display_device_info_
 		}
 	}
 
+	display_runtime->rawclk_freq = intel_read_rawclk(i915);
+	drm_dbg_kms(&i915->drm, "rawclk rate: %d kHz\n", display_runtime->rawclk_freq);
+
 	return;
 
 display_fused_off:
@@ -1516,6 +1519,8 @@ void intel_display_device_info_print(con
 	drm_printf(p, "has_hdcp: %s\n", str_yes_no(runtime->has_hdcp));
 	drm_printf(p, "has_dmc: %s\n", str_yes_no(runtime->has_dmc));
 	drm_printf(p, "has_dsc: %s\n", str_yes_no(runtime->has_dsc));
+
+	drm_printf(p, "rawclk rate: %u kHz\n", runtime->rawclk_freq);
 }
 
 /*
--- a/drivers/gpu/drm/i915/display/intel_display_device.h
+++ b/drivers/gpu/drm/i915/display/intel_display_device.h
@@ -204,6 +204,8 @@ struct intel_display_runtime_info {
 		u16 step;
 	} ip;
 
+	u32 rawclk_freq;
+
 	u8 pipe_mask;
 	u8 cpu_transcoder_mask;
 	u16 port_mask;
--- a/drivers/gpu/drm/i915/display/intel_display_power_well.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power_well.c
@@ -1176,9 +1176,9 @@ static void vlv_init_display_clock_gatin
 		       MI_ARB_DISPLAY_TRICKLE_FEED_DISABLE);
 	intel_de_write(dev_priv, CBR1_VLV, 0);
 
-	drm_WARN_ON(&dev_priv->drm, RUNTIME_INFO(dev_priv)->rawclk_freq == 0);
+	drm_WARN_ON(&dev_priv->drm, DISPLAY_RUNTIME_INFO(dev_priv)->rawclk_freq == 0);
 	intel_de_write(dev_priv, RAWCLK_FREQ_VLV,
-		       DIV_ROUND_CLOSEST(RUNTIME_INFO(dev_priv)->rawclk_freq,
+		       DIV_ROUND_CLOSEST(DISPLAY_RUNTIME_INFO(dev_priv)->rawclk_freq,
 					 1000));
 }
 
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -84,7 +84,7 @@ static u32 g4x_get_aux_clock_divider(str
 	 * The clock divider is based off the hrawclk, and would like to run at
 	 * 2MHz.  So, take the hrawclk value and divide by 2000 and use that
 	 */
-	return DIV_ROUND_CLOSEST(RUNTIME_INFO(i915)->rawclk_freq, 2000);
+	return DIV_ROUND_CLOSEST(DISPLAY_RUNTIME_INFO(i915)->rawclk_freq, 2000);
 }
 
 static u32 ilk_get_aux_clock_divider(struct intel_dp *intel_dp, int index)
@@ -104,7 +104,7 @@ static u32 ilk_get_aux_clock_divider(str
 	if (dig_port->aux_ch == AUX_CH_A)
 		freq = i915->display.cdclk.hw.cdclk;
 	else
-		freq = RUNTIME_INFO(i915)->rawclk_freq;
+		freq = DISPLAY_RUNTIME_INFO(i915)->rawclk_freq;
 	return DIV_ROUND_CLOSEST(freq, 2000);
 }
 
--- a/drivers/gpu/drm/i915/display/intel_pps.c
+++ b/drivers/gpu/drm/i915/display/intel_pps.c
@@ -1483,7 +1483,7 @@ static void pps_init_registers(struct in
 {
 	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
 	u32 pp_on, pp_off, port_sel = 0;
-	int div = RUNTIME_INFO(dev_priv)->rawclk_freq / 1000;
+	int div = DISPLAY_RUNTIME_INFO(dev_priv)->rawclk_freq / 1000;
 	struct pps_registers regs;
 	enum port port = dp_to_dig_port(intel_dp)->base.port;
 	const struct edp_power_seq *seq = &intel_dp->pps.pps_delays;
--- a/drivers/gpu/drm/i915/intel_device_info.c
+++ b/drivers/gpu/drm/i915/intel_device_info.c
@@ -124,7 +124,6 @@ void intel_device_info_print(const struc
 #undef PRINT_FLAG
 
 	drm_printf(p, "has_pooled_eu: %s\n", str_yes_no(runtime->has_pooled_eu));
-	drm_printf(p, "rawclk rate: %u kHz\n", runtime->rawclk_freq);
 }
 
 #define ID(id) (id)
@@ -377,10 +376,6 @@ void intel_device_info_runtime_init(stru
 			 "Disabling ppGTT for VT-d support\n");
 		runtime->ppgtt_type = INTEL_PPGTT_NONE;
 	}
-
-	runtime->rawclk_freq = intel_read_rawclk(dev_priv);
-	drm_dbg(&dev_priv->drm, "rawclk rate: %d kHz\n", runtime->rawclk_freq);
-
 }
 
 /*
--- a/drivers/gpu/drm/i915/intel_device_info.h
+++ b/drivers/gpu/drm/i915/intel_device_info.h
@@ -207,8 +207,6 @@ struct intel_runtime_info {
 
 	u16 device_id;
 
-	u32 rawclk_freq;
-
 	struct intel_step_info step;
 
 	unsigned int page_sizes; /* page sizes supported by the HW */


