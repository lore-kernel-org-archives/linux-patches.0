Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBBE384;
	Thu, 13 Jun 2024 12:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282837; cv=none; b=EM5Ne6q5pvtDcrtuQb3OKgMwFoxQZB4N5G+yQ0Z5IGzELfS2xWjtJTlmvf+KP6heNtKeQINVTJzHl1YFC7gL6IAy0yvlOe6Yt0M/BU8YNuBrz7Wov+Rhzr6bGxTNeqc1X2GTOn+xXomjxBE8s2dUcIFh1z0pD24L6o5jq1VraP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282837; c=relaxed/simple;
	bh=j8H0ixqbBBGK+Ww+uJpdeIcg+qmjeokywhY5nV3lY7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtubMLEHcZc0fNgeUjK2SMfQ0s8oWenYG2Y0i9EdcznZl0UHnjinLxRX9Sp1nduMuTnPUh4hrme9xBsPwu87fFEz28D+H1rPVtOlGxInF8SQNr5b3kXrU/JMqDQfhGszjRBOnjn3h/a4jQt+fnUo1lFc3al022MDnVUQ6Bo22JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0q5pVZvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q5pVZvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9101C32786;
	Thu, 13 Jun 2024 12:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282837;
	bh=j8H0ixqbBBGK+Ww+uJpdeIcg+qmjeokywhY5nV3lY7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q5pVZvxVO28TXwpJV7GnVotZ0OyVF0jypv6ItX/z2BvgJiI9Y4mEqT8xZGIRGn2W
	 YD2FUhLIvSh13z3kSwMQrqYhG2PsOQUnA/HbVwc4o1wTj0T68zf3eIZGCq8f2Ypo5M
	 gLh8UbjU+Oc85XWzwJ0JwKse9/w6V0HIwzjqa62c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 10/85] drm/i915/audio: Fix audio time stamp programming for DP
Date: Thu, 13 Jun 2024 13:35:08 +0200
Message-ID: <20240613113214.536018277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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
 drivers/gpu/drm/i915/display/intel_audio.c |  116 ++---------------------------
 1 file changed, 9 insertions(+), 107 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_audio.c
+++ b/drivers/gpu/drm/i915/display/intel_audio.c
@@ -73,19 +73,6 @@ struct intel_audio_funcs {
 				    const struct drm_connector_state *old_conn_state);
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
@@ -93,60 +80,6 @@ struct hdmi_aud_ncts {
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
@@ -392,48 +325,17 @@ static void
 hsw_dp_audio_config_update(struct intel_encoder *encoder,
 			   const struct intel_crtc_state *crtc_state)
 {
-	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
-	struct i915_audio_component *acomp = dev_priv->display.audio.component;
+	struct drm_i915_private *i915 = to_i915(encoder->base.dev);
 	enum transcoder cpu_transcoder = crtc_state->cpu_transcoder;
-	enum port port = encoder->port;
-	const struct dp_aud_n_m *nm;
-	int rate;
-	u32 tmp;
-
-	rate = acomp ? acomp->aud_sample_rate[port] : 0;
-	nm = audio_config_dp_get_n_m(crtc_state, rate);
-	if (nm)
-		drm_dbg_kms(&dev_priv->drm, "using Maud %u, Naud %u\n", nm->m,
-			    nm->n);
-	else
-		drm_dbg_kms(&dev_priv->drm, "using automatic Maud, Naud\n");
-
-	tmp = intel_de_read(dev_priv, HSW_AUD_CFG(cpu_transcoder));
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
-	intel_de_write(dev_priv, HSW_AUD_CFG(cpu_transcoder), tmp);
-
-	tmp = intel_de_read(dev_priv, HSW_AUD_M_CTS_ENABLE(cpu_transcoder));
-	tmp &= ~AUD_CONFIG_M_MASK;
-	tmp &= ~AUD_M_CTS_M_VALUE_INDEX;
-	tmp &= ~AUD_M_CTS_M_PROG_ENABLE;
-
-	if (nm) {
-		tmp |= nm->m;
-		tmp |= AUD_M_CTS_M_VALUE_INDEX;
-		tmp |= AUD_M_CTS_M_PROG_ENABLE;
-	}
 
-	intel_de_write(dev_priv, HSW_AUD_M_CTS_ENABLE(cpu_transcoder), tmp);
+	/* Enable time stamps. Let HW calculate Maud/Naud values */
+	intel_de_rmw(i915, HSW_AUD_CFG(cpu_transcoder),
+		     AUD_CONFIG_N_VALUE_INDEX |
+		     AUD_CONFIG_PIXEL_CLOCK_HDMI_MASK |
+		     AUD_CONFIG_UPPER_N_MASK |
+		     AUD_CONFIG_LOWER_N_MASK |
+		     AUD_CONFIG_N_PROG_ENABLE,
+		     AUD_CONFIG_N_VALUE_INDEX);
 }
 
 static void


