Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027193;
	b=OZPkWSdVeI5PT6KS/nKJsfR+qspAP0i7WxENl7Hy38sWG9JG1EyESPzgOGypNkJp3pD4
	 DXAIvGeEuhNaCkC4eicgIyPRvmRlC/e8v92wBPzC+Gm2SO3vnT7cz2pQne5WBtiz5vXss
	 9Id6Wg1wK3WfYsq40MMSVwYpQcfTn7Mpv0gfFuF93ysjSL/weBqtIANtej6C6FEfA0L0C
	 0VnkRVjOXyTU2kFuY21OQdRaV3QjhVXE1W8Jy9tPeLl44CDtAEi33ggLUgDQlfyTyPSi/
	 6KIrctwVNwfx8PPaXWc/537AIa7CylYmQPtt7ab7tcGBPsrp1tvSGhHFIICmTDH9eCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HTfIlsPMuf4B7GynIwg2GVUG//jQ28sHurC24i43yzA=;
	b=waPRZHIyUaDXFZIckBeiI3OPdLuOYKtaJHfF7z1FJdEQTw0YbRBWNrITmtv5rfiRuROX
	 rvHcqpw3Ers/zZrAgtrsxieYyWY5B2sD2XTX1G+LmFQvhbRUkUCZ9TLg2O7GQwtpETkQ3
	 qOp+k4rQkUcfAOXrpUKSBxWE1QzN5NFOL1Q3EqAJcbRkr0TU4wuIoOAasWNEUtxtwhWPA
	 Eb2vaz67yaE3h/S/W7Jc4ftFm+lwPk0Z9wOpiUcZzlGHkRL/2Jrga4UcvEhx5GEqoy2GP
	 U+8tH/4NYCZyfqREuAjZEYjuxBDebbNivN26gRTSqSmQmbROoHIUIjEnocRp7ilnlPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nTwxP6H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77ED606A31C;
	Wed, 18 Nov 2026 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nTwxP6H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD33C1F000C4;
	Wed, 18 Nov 2026 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027193;
	bh=HTfIlsPMuf4B7GynIwg2GVUG//jQ28sHurC24i43yzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nTwxP6HVaoa2QZideCbFY9C9xoNpiX9oEt3OKnR+PFkvdM+S7qVU+FQT+ClI/c7d
	 uP0WZ2Tg3+6tneVGmEBllnQZMx82+iSIck6A5ZMqfPLkxKm49EzmX9GaNuHkzzHYNP
	 ws4uokvYCa9452wvBGgsKIlA2lXyCjphqDIIQWxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Prathosh Satish <Prathosh.Satish@microchip.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1704/2151] dpll: zl3073x: clean up esync get/set and use zl3073x_out_is_ndiv()
Date: Wed, 18 Nov 2026 15:57:19 +0100
Message-ID: <20261118150223.892326808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 3c8c39768b10867e4f630080785b602245f01760 ]

Return -EOPNOTSUPP early in esync_get callbacks when esync is not
supported instead of conditionally populating the range at the end.
This simplifies the control flow by removing the finish label/goto
in the output variant and the conditional range assignment in both
input and output variants.

Replace open-coded N-div signal format switch statements with
zl3073x_out_is_ndiv() helper in esync_get, esync_set and
frequency_set callbacks.

Reviewed-by: Petr Oros <poros@redhat.com>
Reviewed-by: Prathosh Satish <Prathosh.Satish@microchip.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20260408102716.443099-2-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f8993627d310 ("dpll: zl3073x: reject inexact frequencies for N-divided outputs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 64 ++++++++++++-------------------------
 1 file changed, 20 insertions(+), 44 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index 3baf7d5bcd0b7..83d37e3eae789 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -117,6 +117,12 @@ zl3073x_dpll_input_pin_esync_get(const struct dpll_pin *dpll_pin,
 	ref_id = zl3073x_input_pin_ref_get(pin->id);
 	ref = zl3073x_ref_state_get(zldev, ref_id);
 
+	if (!pin->esync_control || zl3073x_ref_freq_get(ref) <= 1)
+		return -EOPNOTSUPP;
+
+	esync->range = esync_freq_ranges;
+	esync->range_num = ARRAY_SIZE(esync_freq_ranges);
+
 	switch (FIELD_GET(ZL_REF_SYNC_CTRL_MODE, ref->sync_ctrl)) {
 	case ZL_REF_SYNC_CTRL_MODE_50_50_ESYNC_25_75:
 		esync->freq = ref->esync_n_div == ZL_REF_ESYNC_DIV_1HZ ? 1 : 0;
@@ -128,17 +134,6 @@ zl3073x_dpll_input_pin_esync_get(const struct dpll_pin *dpll_pin,
 		break;
 	}
 
-	/* If the pin supports esync control expose its range but only
-	 * if the current reference frequency is > 1 Hz.
-	 */
-	if (pin->esync_control && zl3073x_ref_freq_get(ref) > 1) {
-		esync->range = esync_freq_ranges;
-		esync->range_num = ARRAY_SIZE(esync_freq_ranges);
-	} else {
-		esync->range = NULL;
-		esync->range_num = 0;
-	}
-
 	return 0;
 }
 
@@ -775,8 +770,8 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dpll_pin *pin = pin_priv;
 	const struct zl3073x_synth *synth;
 	const struct zl3073x_out *out;
+	u32 synth_freq, out_freq;
 	u8 clock_type, out_id;
-	u32 synth_freq;
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = zl3073x_out_state_get(zldev, out_id);
@@ -785,17 +780,19 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	 * for N-division is also used for the esync divider so both cannot
 	 * be used.
 	 */
-	switch (zl3073x_out_signal_format_get(out)) {
-	case ZL_OUTPUT_MODE_SIGNAL_FORMAT_2_NDIV:
-	case ZL_OUTPUT_MODE_SIGNAL_FORMAT_2_NDIV_INV:
+	if (zl3073x_out_is_ndiv(out))
 		return -EOPNOTSUPP;
-	default:
-		break;
-	}
 
 	/* Get attached synth frequency */
 	synth = zl3073x_synth_state_get(zldev, zl3073x_out_synth_get(out));
 	synth_freq = zl3073x_synth_freq_get(synth);
+	out_freq = synth_freq / out->div;
+
+	if (!pin->esync_control || out_freq <= 1)
+		return -EOPNOTSUPP;
+
+	esync->range = esync_freq_ranges;
+	esync->range_num = ARRAY_SIZE(esync_freq_ranges);
 
 	clock_type = FIELD_GET(ZL_OUTPUT_MODE_CLOCK_TYPE, out->mode);
 	if (clock_type != ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC) {
@@ -803,11 +800,11 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 		esync->freq = 0;
 		esync->pulse = 0;
 
-		goto finish;
+		return 0;
 	}
 
 	/* Compute esync frequency */
-	esync->freq = synth_freq / out->div / out->esync_n_period;
+	esync->freq = out_freq / out->esync_n_period;
 
 	/* By comparing the esync_pulse_width to the half of the pulse width
 	 * the esync pulse percentage can be determined.
@@ -816,18 +813,6 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	 */
 	esync->pulse = (50 * out->esync_n_width) / out->div;
 
-finish:
-	/* Set supported esync ranges if the pin supports esync control and
-	 * if the output frequency is > 1 Hz.
-	 */
-	if (pin->esync_control && (synth_freq / out->div) > 1) {
-		esync->range = esync_freq_ranges;
-		esync->range_num = ARRAY_SIZE(esync_freq_ranges);
-	} else {
-		esync->range = NULL;
-		esync->range_num = 0;
-	}
-
 	return 0;
 }
 
@@ -853,13 +838,8 @@ zl3073x_dpll_output_pin_esync_set(const struct dpll_pin *dpll_pin,
 	 * for N-division is also used for the esync divider so both cannot
 	 * be used.
 	 */
-	switch (zl3073x_out_signal_format_get(&out)) {
-	case ZL_OUTPUT_MODE_SIGNAL_FORMAT_2_NDIV:
-	case ZL_OUTPUT_MODE_SIGNAL_FORMAT_2_NDIV_INV:
+	if (zl3073x_out_is_ndiv(&out))
 		return -EOPNOTSUPP;
-	default:
-		break;
-	}
 
 	/* Select clock type */
 	if (freq)
@@ -921,9 +901,9 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dev *zldev = zldpll->dev;
 	struct zl3073x_dpll_pin *pin = pin_priv;
 	const struct zl3073x_synth *synth;
-	u8 out_id, signal_format;
 	u32 new_div, synth_freq;
 	struct zl3073x_out out;
+	u8 out_id;
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = *zl3073x_out_state_get(zldev, out_id);
@@ -933,12 +913,8 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	synth_freq = zl3073x_synth_freq_get(synth);
 	new_div = synth_freq / (u32)frequency;
 
-	/* Get used signal format for the given output */
-	signal_format = zl3073x_out_signal_format_get(&out);
-
 	/* Check signal format */
-	if (signal_format != ZL_OUTPUT_MODE_SIGNAL_FORMAT_2_NDIV &&
-	    signal_format != ZL_OUTPUT_MODE_SIGNAL_FORMAT_2_NDIV_INV) {
+	if (!zl3073x_out_is_ndiv(&out)) {
 		/* For non N-divided signal formats the frequency is computed
 		 * as division of synth frequency and output divisor.
 		 */
-- 
2.53.0



