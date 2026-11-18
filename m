Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020764;
	b=lLBPw5LSS8vPnCEaqLLS86amvo/qnEGZXEOOwHnGTiGqmJ8qX/BsmHDR3QeFZU4Rz3Dq
	 K9ipkP8H/LoajHOKzp8odx0WZCPJstYiRkiIHBiiRj17POe0YakzPRoJhV6l1+2USEXM2
	 b764t/VCOFlcL6TmmtxOGg7Klp8nTpOzu7bF4SeU32ftitGpJXED0Wa604947FCUU83Vn
	 mHyqBYtlN8n3Rd1y69elGjX0YjdkkCXcJp04kGgt2gkeCuRNc4Df4KWXNYVorzdX1vham
	 5aJDY+EG0nM5PChMa1QY94Ar+bCZbiHm7xQdrp1K+kVPATSr7N325HAfdyCiyRviExQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ki3mi/P1/O3OKTcp2V1xRZW5bOJIAALZfcakCcaOk90=;
	b=3qGy8JaZVNa6pfXEwSiWnaPxHKoV9LnOW94bx/CxVyGyKFH/I2A4JxP6CMdHAbKnPd6C
	 tbh765ZquM5Vb5UbuIkLluH4mnhWLM0Y2a4pGc9JVGxgOES4HHLas+8VZxrKIhsJ3yHwz
	 +EzVo8c9BptKnehlRfvRh4PtFJKgiq6LaAN02QpGMIro0iJJ3V/F3IryWFHyHcym1tGlL
	 O98FBKZwga/npfmIYNmkMm9NNt5vl81O+r01os5wmEAd4nvCcwTWeIXa9aw5v6XU9uIBZ
	 YHbsdadDBZjhoEzZiMubeuuB/JGwuyxqZtwn9tsP3DooesNH/bCZJNslV/k/37sg4qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXY+Ia63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97D960A3831;
	Wed, 18 Nov 2026 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXY+Ia63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C1C1F000C7;
	Wed, 18 Nov 2026 16:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020764;
	bh=ki3mi/P1/O3OKTcp2V1xRZW5bOJIAALZfcakCcaOk90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXY+Ia63AUSMlqolJSUEvX9MI2sk9zS7qDLKpeZDlQ69xX0Yns4wuArKvfWFE3QuM
	 35a88Gkh6tvRj+movnceKCMyuwFPtikDOhHcL9fel+yTCijsQnfNS+zY0mpnr1wAeD
	 BzDUIEfJWI5uo8YLD8zkdONABmiDyWe+5Dmj3qXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2069/2651] dpll: zl3073x: make embedded sync follow the output carrier frequency
Date: Wed, 18 Nov 2026 15:55:09 +0100
Message-ID: <20261118150400.543632641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit bf6f105f2cb6477e36a9312477d0aa32a43aa13d ]

The eSync period and width are relative to the output carrier, but
changing the output frequency did not update them, so eSync ran at
a wrong frequency and duty cycle. For a 1 Hz carrier esync_get()
returns -EOPNOTSUPP, so eSync left enabled could not be disabled.

Factor out zl3073x_out_esync_{is_enabled,enable,disable}() helpers
and use them in frequency_set() to recompute the eSync period and
width for the new carrier, or to disable eSync for a 1 Hz carrier.

Also compute the reported pulse width in 64 bits, as
50 * esync_n_width overflows u32 for low carrier frequencies.

Hit during development, confirmed on an oscilloscope.

Fixes: ce26d7ca50a5 ("dpll: zl3073x: Add support to get/set frequency on pins")
Fixes: 634ca2cb06d2 ("dpll: zl3073x: Add support to get/set esync on pins")
Reviewed-by: Petr Oros <poros@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20261011061211.448373-5-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 46 +++++++++++++++++++------------------
 drivers/dpll/zl3073x/out.h  | 36 +++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index 7a617d9bd6712..6d9a6d21d30b7 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -878,7 +878,7 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	esync->range = esync_freq_ranges;
 	esync->range_num = ARRAY_SIZE(esync_freq_ranges);
 
-	if (zl3073x_out_clock_type_get(out) != ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC) {
+	if (!zl3073x_out_esync_is_enabled(out)) {
 		/* No need to read esync data if it is not enabled */
 		esync->freq = 0;
 		esync->pulse = 0;
@@ -894,7 +894,7 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	 * Note that half pulse width is in units of half synth cycles, which
 	 * is why it reduces down to be output_div.
 	 */
-	esync->pulse = (50 * out->esync_n_width) / out->div;
+	esync->pulse = div_u64(mul_u32_u32(50, out->esync_n_width), out->div);
 
 	return 0;
 }
@@ -926,32 +926,17 @@ zl3073x_dpll_output_pin_esync_set(const struct dpll_pin *dpll_pin,
 	if (zl3073x_out_is_ndiv(&out))
 		return -EOPNOTSUPP;
 
-	/* Update clock type in output mode */
-	if (freq)
-		zl3073x_out_clock_type_set(&out,
-					   ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC);
-	else
-		zl3073x_out_clock_type_set(&out,
-					   ZL_OUTPUT_MODE_CLOCK_TYPE_NORMAL);
-
-	/* If esync is being disabled just write mailbox and finish */
-	if (!freq)
+	if (!freq) {
+		zl3073x_out_esync_disable(&out);
 		return zl3073x_out_state_set(zldev, out_id, &out);
+	}
 
 	/* Get attached synth frequency */
 	synth = zl3073x_synth_state_get(zldev, zl3073x_out_synth_get(&out));
 	synth_freq = zl3073x_synth_freq_get(synth);
 
-	/* Compute and update esync period */
-	out.esync_n_period = synth_freq / (u32)freq / out.div;
-
-	/* Half of the period in units of 1/2 synth cycle can be represented by
-	 * the output_div. To get the supported esync pulse width of 25% of the
-	 * period the output_div can just be divided by 2. Note that this
-	 * assumes that output_div is even, otherwise some resolution will be
-	 * lost.
-	 */
-	out.esync_n_width = out.div / 2;
+	/* Enable 1PPS eSync for this pin frequency */
+	zl3073x_out_esync_enable(&out, synth_freq / out.div);
 
 	/* Commit output configuration */
 	return zl3073x_out_state_set(zldev, out_id, &out);
@@ -1010,6 +995,23 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 		/* For 50/50 duty cycle the divisor is equal to width */
 		out.width = new_div;
 
+		/* The embedded sync period and width are computed relative to
+		 * the output carrier so they have to be adjusted to follow the
+		 * new frequency.
+		 */
+		if (zl3073x_out_esync_is_enabled(&out)) {
+			if (frequency == 1) {
+				/* eSync cannot work on a 1 Hz carrier */
+				zl3073x_out_esync_disable(&out);
+			} else {
+				/* Update esync period and width according to
+				 * the new frequency.
+				 */
+				zl3073x_out_esync_enable(&out,
+							 synth_freq / out.div);
+			}
+		}
+
 		/* Commit output configuration */
 		return zl3073x_out_state_set(zldev, out_id, &out);
 	}
diff --git a/drivers/dpll/zl3073x/out.h b/drivers/dpll/zl3073x/out.h
index 660889c57bffa..d2b8b4eb5a76f 100644
--- a/drivers/dpll/zl3073x/out.h
+++ b/drivers/dpll/zl3073x/out.h
@@ -134,4 +134,40 @@ static inline u8 zl3073x_out_synth_get(const struct zl3073x_out *out)
 	return FIELD_GET(ZL_OUTPUT_CTRL_SYNTH_SEL, out->ctrl);
 }
 
+static inline bool zl3073x_out_esync_is_enabled(const struct zl3073x_out *out)
+{
+	u8 clock_type = zl3073x_out_clock_type_get(out);
+
+	return clock_type == ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC;
+}
+
+static inline
+void zl3073x_out_esync_enable(struct zl3073x_out *out, u32 base_freq)
+{
+	/* Period is expressed as the number of output divider clock cycles.
+	 * So for 1 Hz the period is equal to base frequency.
+	 */
+	out->esync_n_period = base_freq;
+
+	/* Half of the period in units of 1/2 synth cycle can be represented by
+	 * the output_div. To get the supported esync pulse width of 25% of the
+	 * period the output_div can just be divided by 2. Note that this
+	 * assumes that output_div is even, otherwise some resolution will be
+	 * lost.
+	 */
+	out->esync_n_width = out->div / 2;
+
+	/* Update the clock type */
+	zl3073x_out_clock_type_set(out, ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC);
+}
+
+static inline
+void zl3073x_out_esync_disable(struct zl3073x_out *out)
+{
+	/* Just update the clock type. The eSync period and width are
+	 * ignored for this clock type.
+	 */
+	zl3073x_out_clock_type_set(out, ZL_OUTPUT_MODE_CLOCK_TYPE_NORMAL);
+}
+
 #endif /* _ZL3073X_OUT_H */
-- 
2.53.0



