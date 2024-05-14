Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B7E12D76E;
	Tue, 14 May 2024 10:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683965; cv=none; b=M5yXpp7eqWoLpD7XT5ZdaA1zft6WPNQqC9UQtUHvxr5Wyc3dxCiXmUPG/AkjxcdRM+GM9kB7j4HvUvLFN9NYtj7z+yn/pIN2nzENqHDSnYcHVz3G2tUsEVyi7KUyiOWEUV0qUIWxgWtHeoHfiypS8zeTILAG7fyknqruXS9H36A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683965; c=relaxed/simple;
	bh=whDZ0iYLuebg+OWHdOyFGXx3Bx8GMNSK76XK1O7pxC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOVh0ix2n9/TCti3aNj9hm/Ciw5hozsaWUkU2upmwF97giouwzkDOJfVTURL+OsxMmx+agPrSZJcvnsyKEy+a0jWKVGcWwkpWnALGoARhyVbO08YKRCWPvjkBBpufttkoPaS9VYElDUp8weaD5TIIi7DVBuXsX9oWdEk+EsdV58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1zw+eXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1zw+eXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15636C2BD10;
	Tue, 14 May 2024 10:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683965;
	bh=whDZ0iYLuebg+OWHdOyFGXx3Bx8GMNSK76XK1O7pxC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1zw+eXdTRI7LO3Q1gwpFz4zuW5V9cTNAX2xiLofV+AWAH7o+iWOKgddCBVDg2GBq
	 ZRVskv1qBE4wZg/rppFW/LADv1vZ4y2q1G9EZpFcZHeaaALNnjvkXQqgdq3Op+9P4I
	 NSeX7AMNafOEkuEMmqAvMUp6BX4JCHwYvSGGu+Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 302/336] drm/i915/audio: Fix audio time stamp programming for DP
Date: Tue, 14 May 2024 12:18:26 +0200
Message-ID: <20240514101050.019280700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit c66b8356273c8d22498f88e4223af47a7bf8a23c upstream.

Intel hardware is capable of programming the Maud/Naud SDPs on its
own based on real-time clocks. While doing so, it takes care
of any deviations from the theoretical values. Programming the registers
explicitly with static values can interfere with this logic. Therefore,
let the HW decide the Maud and Naud SDPs on it's own.

Cc: stable@vger.kernel.org # v5.17
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8097
Co-developed-by: Kai Vehmanen <kai.vehmanen@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Animesh Manna <animesh.manna@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240430091825.733499-1-chaitanya.kumar.borah@intel.com
(cherry picked from commit 8e056b50d92ae7f4d6895d1c97a69a2a953cf97b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_audio.c |  113 ++---------------------------
 1 file changed, 8 insertions(+), 105 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_audio.c
+++ b/drivers/gpu/drm/i915/display/intel_audio.c
@@ -76,19 +76,6 @@ struct intel_audio_funcs {
 				       struct intel_crtc_state *crtc_state);
 };
 
-/* DP N/M table */
-#define LC_810M	810000
-#define LC_540M	540000
-#define LC_270M	270000
-#define LC_162M	162000
-
-struct dp_aud_n_m {
-	int sample_rate;
-	int clock;
-	u16 m;
-	u16 n;
-};
-
 struct hdmi_aud_ncts {
 	int sample_rate;
 	int clock;
@@ -96,60 +83,6 @@ struct hdmi_aud_ncts {
 	int cts;
 };
 
-/* Values according to DP 1.4 Table 2-104 */
-static const struct dp_aud_n_m dp_aud_n_m[] = {
-	{ 32000, LC_162M, 1024, 10125 },
-	{ 44100, LC_162M, 784, 5625 },
-	{ 48000, LC_162M, 512, 3375 },
-	{ 64000, LC_162M, 2048, 10125 },
-	{ 88200, LC_162M, 1568, 5625 },
-	{ 96000, LC_162M, 1024, 3375 },
-	{ 128000, LC_162M, 4096, 10125 },
-	{ 176400, LC_162M, 3136, 5625 },
-	{ 192000, LC_162M, 2048, 3375 },
-	{ 32000, LC_270M, 1024, 16875 },
-	{ 44100, LC_270M, 784, 9375 },
-	{ 48000, LC_270M, 512, 5625 },
-	{ 64000, LC_270M, 2048, 16875 },
-	{ 88200, LC_270M, 1568, 9375 },
-	{ 96000, LC_270M, 1024, 5625 },
-	{ 128000, LC_270M, 4096, 16875 },
-	{ 176400, LC_270M, 3136, 9375 },
-	{ 192000, LC_270M, 2048, 5625 },
-	{ 32000, LC_540M, 1024, 33750 },
-	{ 44100, LC_540M, 784, 18750 },
-	{ 48000, LC_540M, 512, 11250 },
-	{ 64000, LC_540M, 2048, 33750 },
-	{ 88200, LC_540M, 1568, 18750 },
-	{ 96000, LC_540M, 1024, 11250 },
-	{ 128000, LC_540M, 4096, 33750 },
-	{ 176400, LC_540M, 3136, 18750 },
-	{ 192000, LC_540M, 2048, 11250 },
-	{ 32000, LC_810M, 1024, 50625 },
-	{ 44100, LC_810M, 784, 28125 },
-	{ 48000, LC_810M, 512, 16875 },
-	{ 64000, LC_810M, 2048, 50625 },
-	{ 88200, LC_810M, 1568, 28125 },
-	{ 96000, LC_810M, 1024, 16875 },
-	{ 128000, LC_810M, 4096, 50625 },
-	{ 176400, LC_810M, 3136, 28125 },
-	{ 192000, LC_810M, 2048, 16875 },
-};
-
-static const struct dp_aud_n_m *
-audio_config_dp_get_n_m(const struct intel_crtc_state *crtc_state, int rate)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(dp_aud_n_m); i++) {
-		if (rate == dp_aud_n_m[i].sample_rate &&
-		    crtc_state->port_clock == dp_aud_n_m[i].clock)
-			return &dp_aud_n_m[i];
-	}
-
-	return NULL;
-}
-
 static const struct {
 	int clock;
 	u32 config;
@@ -387,47 +320,17 @@ hsw_dp_audio_config_update(struct intel_
 			   const struct intel_crtc_state *crtc_state)
 {
 	struct drm_i915_private *i915 = to_i915(encoder->base.dev);
-	struct i915_audio_component *acomp = i915->display.audio.component;
 	enum transcoder cpu_transcoder = crtc_state->cpu_transcoder;
-	enum port port = encoder->port;
-	const struct dp_aud_n_m *nm;
-	int rate;
-	u32 tmp;
 
-	rate = acomp ? acomp->aud_sample_rate[port] : 0;
-	nm = audio_config_dp_get_n_m(crtc_state, rate);
-	if (nm)
-		drm_dbg_kms(&i915->drm, "using Maud %u, Naud %u\n", nm->m,
-			    nm->n);
-	else
-		drm_dbg_kms(&i915->drm, "using automatic Maud, Naud\n");
-
-	tmp = intel_de_read(i915, HSW_AUD_CFG(cpu_transcoder));
-	tmp &= ~AUD_CONFIG_N_VALUE_INDEX;
-	tmp &= ~AUD_CONFIG_PIXEL_CLOCK_HDMI_MASK;
-	tmp &= ~AUD_CONFIG_N_PROG_ENABLE;
-	tmp |= AUD_CONFIG_N_VALUE_INDEX;
-
-	if (nm) {
-		tmp &= ~AUD_CONFIG_N_MASK;
-		tmp |= AUD_CONFIG_N(nm->n);
-		tmp |= AUD_CONFIG_N_PROG_ENABLE;
-	}
-
-	intel_de_write(i915, HSW_AUD_CFG(cpu_transcoder), tmp);
-
-	tmp = intel_de_read(i915, HSW_AUD_M_CTS_ENABLE(cpu_transcoder));
-	tmp &= ~AUD_CONFIG_M_MASK;
-	tmp &= ~AUD_M_CTS_M_VALUE_INDEX;
-	tmp &= ~AUD_M_CTS_M_PROG_ENABLE;
-
-	if (nm) {
-		tmp |= nm->m;
-		tmp |= AUD_M_CTS_M_VALUE_INDEX;
-		tmp |= AUD_M_CTS_M_PROG_ENABLE;
-	}
+	/* Enable time stamps. Let HW calculate Maud/Naud values */
+	intel_de_rmw(i915, HSW_AUD_CFG(cpu_transcoder),
+		     AUD_CONFIG_N_VALUE_INDEX |
+		     AUD_CONFIG_PIXEL_CLOCK_HDMI_MASK |
+		     AUD_CONFIG_UPPER_N_MASK |
+		     AUD_CONFIG_LOWER_N_MASK |
+		     AUD_CONFIG_N_PROG_ENABLE,
+		     AUD_CONFIG_N_VALUE_INDEX);
 
-	intel_de_write(i915, HSW_AUD_M_CTS_ENABLE(cpu_transcoder), tmp);
 }
 
 static void


