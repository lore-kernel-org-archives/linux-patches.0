Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622780;
	b=dFoKBrwKQxkQhi8KE2++1Tqfjuk49JVWFO9Bn7LHlVSVewp4xOdppP9Sw9ln7TrJqqWL
	 U4ctPi1Ez6I6X+hKuxP5YDvc3k6PAvFUlJNWToJfGNT3w7FfVzySIewyeHwLzSC4QCjIn
	 ug8ujKm8fSTaOxWNO6h9hVjSa0ZZHhliVR9L94C3FBcet35b+Q/FyhO0hcGCWm+ZQrlFY
	 jHT8BnyVMiOKZ+zTX4dwWQPvgd64vRi5SaTlAYxxONnwo/hVDPMnnKVZej/MAbgNrRLhc
	 Z0qxrfjD0uCO0HIh6ukrFgHKtP6jrbWKUMQaBbdKq5KlHXri33BmfHK70qZT4vkYrZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vP2aiMFz5Rmzx9TJU2bcyxxba/+DgHsjfXlXfR+9YPU=;
	b=4sT06ZOITw7s4uuINh0FOrpO1D4fkMx2A7ggCA111DFjJ64Q8V9pPR5Us6lcf4Du48AY
	 L8AQe8oHW7ZbzG9l1gs6fsR5TC4sMZO5IzxjUlifchgl15ANg5gR7rezDYWN7hfDiKrw7
	 Nw/HaJrWBaEGSb0ZOkZ7eqVWT65Qb+dZelo5Rq/aiWbmFiVbtx99/r5LP6pyiC6lzy29g
	 ivuOMXpBaVd4T8WOsbLpUr5SjkF8j9i/U8FwIuG/gM7BMPdGaQvLTj+LeIoawSFehEqDp
	 x5mV5h9EVx7Z3aDYP/7dRnzlMa37l0cGgwXHLi9tBCGOHXuYLyKJDS5+uZqG1KGtK+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmRbEM0q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45BC606A326;
	Wed, 25 Nov 2026 16:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmRbEM0q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ECC1F000C6;
	Wed, 25 Nov 2026 16:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622780;
	bh=vP2aiMFz5Rmzx9TJU2bcyxxba/+DgHsjfXlXfR+9YPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmRbEM0qR61Y/dw7Pp5f9btDEFifXpR8zzjODFDmfnrmEmSNr4+vIHpDYB1mKFKHv
	 OeQXoEe8YG/utc5jyWEa0r9k6D7ZBEwd96zyz7zw2yr8E872X0IgE3ReMu4ForIcy1
	 dW8KRX4YTQ023j5SFLxEaoGCu5aPWsm6rU8V0/60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 600/990] dpll: zl3073x: make embedded sync follow the output carrier frequency
Date: Wed, 25 Nov 2026 15:32:47 +0100
Message-ID: <20261125143836.146991086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: adapted new eSync helpers in out.h to open-code clock type get/set with FIELD_GET/FIELD_PREP, and rebased esync_get/esync_set onto the older open-coded form, since the clock type accessors are missing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 56 ++++++++++++++++++-------------------
 drivers/dpll/zl3073x/out.h  | 40 ++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 29 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index c2ea96df3bcb6..75a8584e6368f 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -771,7 +771,7 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	const struct zl3073x_synth *synth;
 	const struct zl3073x_out *out;
 	u32 synth_freq, out_freq;
-	u8 clock_type, out_id;
+	u8 out_id;
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = zl3073x_out_state_get(zldev, out_id);
@@ -794,8 +794,7 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	esync->range = esync_freq_ranges;
 	esync->range_num = ARRAY_SIZE(esync_freq_ranges);
 
-	clock_type = FIELD_GET(ZL_OUTPUT_MODE_CLOCK_TYPE, out->mode);
-	if (clock_type != ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC) {
+	if (!zl3073x_out_esync_is_enabled(out)) {
 		/* No need to read esync data if it is not enabled */
 		esync->freq = 0;
 		esync->pulse = 0;
@@ -811,7 +810,7 @@ zl3073x_dpll_output_pin_esync_get(const struct dpll_pin *dpll_pin,
 	 * Note that half pulse width is in units of half synth cycles, which
 	 * is why it reduces down to be output_div.
 	 */
-	esync->pulse = (50 * out->esync_n_width) / out->div;
+	esync->pulse = div_u64(mul_u32_u32(50, out->esync_n_width), out->div);
 
 	return 0;
 }
@@ -828,7 +827,7 @@ zl3073x_dpll_output_pin_esync_set(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dpll_pin *pin = pin_priv;
 	const struct zl3073x_synth *synth;
 	struct zl3073x_out out;
-	u8 clock_type, out_id;
+	u8 out_id;
 	u32 synth_freq;
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
@@ -841,36 +840,18 @@ zl3073x_dpll_output_pin_esync_set(const struct dpll_pin *dpll_pin,
 	if (zl3073x_out_is_ndiv(&out))
 		return -EOPNOTSUPP;
 
-	/* Select clock type */
-	if (freq)
-		clock_type = ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC;
-	else
-		clock_type = ZL_OUTPUT_MODE_CLOCK_TYPE_NORMAL;
-
-	/* Update clock type in output mode */
-	out.mode &= ~ZL_OUTPUT_MODE_CLOCK_TYPE;
-	out.mode |= FIELD_PREP(ZL_OUTPUT_MODE_CLOCK_TYPE, clock_type);
-
-	/* If esync is being disabled just write mailbox and finish */
-	if (!freq)
-		goto write_mailbox;
+	if (!freq) {
+		zl3073x_out_esync_disable(&out);
+		return zl3073x_out_state_set(zldev, out_id, &out);
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
 
-write_mailbox:
 	/* Commit output configuration */
 	return zl3073x_out_state_set(zldev, out_id, &out);
 }
@@ -924,6 +905,23 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
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
index 318f9bb8da3a0..1f2cda4d37fcf 100644
--- a/drivers/dpll/zl3073x/out.h
+++ b/drivers/dpll/zl3073x/out.h
@@ -107,4 +107,44 @@ static inline u8 zl3073x_out_synth_get(const struct zl3073x_out *out)
 	return FIELD_GET(ZL_OUTPUT_CTRL_SYNTH_SEL, out->ctrl);
 }
 
+static inline bool zl3073x_out_esync_is_enabled(const struct zl3073x_out *out)
+{
+	u8 clock_type = FIELD_GET(ZL_OUTPUT_MODE_CLOCK_TYPE, out->mode);
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
+	out->mode &= ~ZL_OUTPUT_MODE_CLOCK_TYPE;
+	out->mode |= FIELD_PREP(ZL_OUTPUT_MODE_CLOCK_TYPE,
+				ZL_OUTPUT_MODE_CLOCK_TYPE_ESYNC);
+}
+
+static inline
+void zl3073x_out_esync_disable(struct zl3073x_out *out)
+{
+	/* Just update the clock type. The eSync period and width are
+	 * ignored for this clock type.
+	 */
+	out->mode &= ~ZL_OUTPUT_MODE_CLOCK_TYPE;
+	out->mode |= FIELD_PREP(ZL_OUTPUT_MODE_CLOCK_TYPE,
+				ZL_OUTPUT_MODE_CLOCK_TYPE_NORMAL);
+}
+
 #endif /* _ZL3073X_OUT_H */
-- 
2.53.0



