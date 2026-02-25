Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841842C0F97;
	Wed, 25 Feb 2026 06:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002582; cv=none; b=nW44UAO4P17FTRLxH6bUnZo1rIijlKokzEyRmjCn14wApoGaNTLlqxjGjrALBQyqbdN+tQA6fdV9p3aqjKt2jXt+9ap2E/tHmzJ0DCi61xNCBwdUssGTf6h96jKVLfiVtrnjfp2EFZ/iiUUiJLomS5/i1lBT2hyzEvC6RcdlJAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002582; c=relaxed/simple;
	bh=X9kgN/V4aH4ZMcsz+7cZrpb+oBYCezwBYVNxhuYY2UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxqC3/RW3EhPTuhwPyGNogVbw4Bw1SP+eFanyRmzJGURhEYqVIN9VuGB1JvuBOM5H+uiakCGmyqfXgyHMiUdmEzm/46xePberdy4fztFgTRi7tKh8D+eAeEC9+3HRYacQXE1e1dWlUwaSmM9ldmuFjarpJgM1UMg02sAlzdfIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWh5Viib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWh5Viib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51135C19422;
	Wed, 25 Feb 2026 06:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002582;
	bh=X9kgN/V4aH4ZMcsz+7cZrpb+oBYCezwBYVNxhuYY2UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWh5ViibI1XihIii2oY6lVzgo2epXv/OkUEebLD10JrpExHnfsGf47T11LdV3Fks+
	 fU0kHFKBXh+tPEE2X5NpN4LeI6d3kMgAZ9Nk5gDcKQQYFNPPah864EaGIjDXFOC0Y0
	 29BNZsJInUf8lfOcop3ADvDr+Bu13zXYNWqq2Teo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Petr Oros <poros@redhat.com>,
	Prathosh Satish <Prathosh.Satish@microchip.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/641] dpll: zl3073x: Specify phase adjustment granularity for pins
Date: Tue, 24 Feb 2026 17:20:44 -0800
Message-ID: <20260225012356.420716009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 055a01b29fd643e33b9b1e88e24bbe1afe6fc6d9 ]

Output pins phase adjustment values in the device are expressed
in half synth clock cycles. Use this number of cycles as output
pins' phase adjust granularity and simplify both get/set callbacks.

Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Petr Oros <poros@redhat.com>
Tested-by: Prathosh Satish <Prathosh.Satish@microchip.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20251029153207.178448-3-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5d41f95f5d0b ("dpll: zl3073x: Fix output pin phase adjustment sign")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 58 +++++++++----------------------------
 drivers/dpll/zl3073x/prop.c | 11 +++++++
 2 files changed, 25 insertions(+), 44 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index f93f9a4583243..d90150671d374 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -35,6 +35,7 @@
  * @prio: pin priority <0, 14>
  * @selectable: pin is selectable in automatic mode
  * @esync_control: embedded sync is controllable
+ * @phase_gran: phase adjustment granularity
  * @pin_state: last saved pin state
  * @phase_offset: last saved pin phase offset
  * @freq_offset: last saved fractional frequency offset
@@ -49,6 +50,7 @@ struct zl3073x_dpll_pin {
 	u8			prio;
 	bool			selectable;
 	bool			esync_control;
+	s32			phase_gran;
 	enum dpll_pin_state	pin_state;
 	s64			phase_offset;
 	s64			freq_offset;
@@ -1388,25 +1390,14 @@ zl3073x_dpll_output_pin_phase_adjust_get(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dpll *zldpll = dpll_priv;
 	struct zl3073x_dev *zldev = zldpll->dev;
 	struct zl3073x_dpll_pin *pin = pin_priv;
-	u32 synth_freq;
 	s32 phase_comp;
-	u8 out, synth;
+	u8 out;
 	int rc;
 
-	out = zl3073x_output_pin_out_get(pin->id);
-	synth = zl3073x_out_synth_get(zldev, out);
-	synth_freq = zl3073x_synth_freq_get(zldev, synth);
-
-	/* Check synth freq for zero */
-	if (!synth_freq) {
-		dev_err(zldev->dev, "Got zero synth frequency for output %u\n",
-			out);
-		return -EINVAL;
-	}
-
 	guard(mutex)(&zldev->multiop_lock);
 
 	/* Read output configuration */
+	out = zl3073x_output_pin_out_get(pin->id);
 	rc = zl3073x_mb_op(zldev, ZL_REG_OUTPUT_MB_SEM, ZL_OUTPUT_MB_SEM_RD,
 			   ZL_REG_OUTPUT_MB_MASK, BIT(out));
 	if (rc)
@@ -1417,11 +1408,10 @@ zl3073x_dpll_output_pin_phase_adjust_get(const struct dpll_pin *dpll_pin,
 	if (rc)
 		return rc;
 
-	/* Value in register is expressed in half synth clock cycles */
-	phase_comp *= (int)div_u64(PSEC_PER_SEC, 2 * synth_freq);
-
-	/* Reverse two's complement negation applied during 'set' */
-	*phase_adjust = -phase_comp;
+	/* Convert value to ps and reverse two's complement negation applied
+	 * during 'set'
+	 */
+	*phase_adjust = -phase_comp * pin->phase_gran;
 
 	return rc;
 }
@@ -1437,39 +1427,18 @@ zl3073x_dpll_output_pin_phase_adjust_set(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dpll *zldpll = dpll_priv;
 	struct zl3073x_dev *zldev = zldpll->dev;
 	struct zl3073x_dpll_pin *pin = pin_priv;
-	int half_synth_cycle;
-	u32 synth_freq;
-	u8 out, synth;
+	u8 out;
 	int rc;
 
-	/* Get attached synth */
-	out = zl3073x_output_pin_out_get(pin->id);
-	synth = zl3073x_out_synth_get(zldev, out);
-
-	/* Get synth's frequency */
-	synth_freq = zl3073x_synth_freq_get(zldev, synth);
-
-	/* Value in register is expressed in half synth clock cycles so
-	 * the given phase adjustment a multiple of half synth clock.
-	 */
-	half_synth_cycle = (int)div_u64(PSEC_PER_SEC, 2 * synth_freq);
-
-	if ((phase_adjust % half_synth_cycle) != 0) {
-		NL_SET_ERR_MSG_FMT(extack,
-				   "Phase adjustment value has to be multiple of %d",
-				   half_synth_cycle);
-		return -EINVAL;
-	}
-	phase_adjust /= half_synth_cycle;
-
 	/* The value in the register is stored as two's complement negation
-	 * of requested value.
+	 * of requested value and expressed in half synth clock cycles.
 	 */
-	phase_adjust = -phase_adjust;
+	phase_adjust = -phase_adjust / pin->phase_gran;
 
 	guard(mutex)(&zldev->multiop_lock);
 
 	/* Read output configuration */
+	out = zl3073x_output_pin_out_get(pin->id);
 	rc = zl3073x_mb_op(zldev, ZL_REG_OUTPUT_MB_SEM, ZL_OUTPUT_MB_SEM_RD,
 			   ZL_REG_OUTPUT_MB_MASK, BIT(out));
 	if (rc)
@@ -1758,9 +1727,10 @@ zl3073x_dpll_pin_register(struct zl3073x_dpll_pin *pin, u32 index)
 	if (IS_ERR(props))
 		return PTR_ERR(props);
 
-	/* Save package label & esync capability */
+	/* Save package label, esync capability and phase adjust granularity */
 	strscpy(pin->label, props->package_label);
 	pin->esync_control = props->esync_control;
+	pin->phase_gran = props->dpll_props.phase_gran;
 
 	if (zl3073x_dpll_is_input_pin(pin)) {
 		rc = zl3073x_dpll_ref_prio_get(pin, &pin->prio);
diff --git a/drivers/dpll/zl3073x/prop.c b/drivers/dpll/zl3073x/prop.c
index 4cf7e8aefcb37..9e1fca5cdaf1e 100644
--- a/drivers/dpll/zl3073x/prop.c
+++ b/drivers/dpll/zl3073x/prop.c
@@ -208,7 +208,18 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 			DPLL_PIN_CAPABILITIES_PRIORITY_CAN_CHANGE |
 			DPLL_PIN_CAPABILITIES_STATE_CAN_CHANGE;
 	} else {
+		u8 out, synth;
+		u32 f;
+
 		props->dpll_props.type = DPLL_PIN_TYPE_GNSS;
+
+		/* The output pin phase adjustment granularity equals half of
+		 * the synth frequency count.
+		 */
+		out = zl3073x_output_pin_out_get(index);
+		synth = zl3073x_out_synth_get(zldev, out);
+		f = 2 * zl3073x_synth_freq_get(zldev, synth);
+		props->dpll_props.phase_gran = f ? div_u64(PSEC_PER_SEC, f) : 1;
 	}
 
 	props->dpll_props.phase_range.min = S32_MIN;
-- 
2.51.0



