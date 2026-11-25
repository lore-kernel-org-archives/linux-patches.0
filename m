Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618544;
	b=5lQOnuEre3JGMD2JLBv8TnN/5Z8MgPoPCpxwflYW+5sJz9f7gQjqC2X7kZ9bagRxti4M
	 LbsmrzmS0WeIveLWXo/GzC4Z6YptSjYvpcNPyLsOakC4RNXlVv/vjBkAhJztgVSUtWgnt
	 93En7apGKP+Z94yiYn93zZN7RNcxnzR/Ko3h4F8YCf8uWLne26wGrKjbINLsc00xOYmHl
	 FWnaDPT8mJkHUEtAU5EqRHHCXCXpVzjVfpROJPd9Ban7IRPA8zGaoNMKV+nP/g1ElK/Ba
	 /xeJhw9/KMO6Pwp3P7cyKkgiIBv8PeLntxqcSNI30OuKz/k2l6tOkNI2uP/OGz8GNqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66zieaoJp/dJUPMMC3t9gClaozobUABB+8cqd10M5X8=;
	b=vNqELe+dzN6J1w+Evyuyis9ao8y7d+LqdiLqhSiT8wKrHrMHYpOsHbDKypIDvu+pNfIK
	 ZnNaJv+mFxw9E55Ib3iw0aZ/8q6d4dd46+FA9IsosFhw6pAI63EmF9M4XmSOH8GqaXO+y
	 fsugRo0+FESrBU22VTOYnuYXVJbhbR/m+YvGghjsY95QVAtB8bpbIHWmQJ4qmNCUO9sJO
	 TiEo5+V5antNAXzUnl5eTUdvwhvY7zna5JXA6to09i272E6+i4WJzhSxD5t4bWLUMiKLP
	 ru/ddkN1u16mDkryShCrHplUZJV0qj71VUh22KrNdvOSVGJ1JzRm/8eBQwRGXqwVyZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Co0qX8UV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53827606A323;
	Wed, 25 Nov 2026 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Co0qX8UV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770A71F000CF;
	Wed, 25 Nov 2026 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618543;
	bh=66zieaoJp/dJUPMMC3t9gClaozobUABB+8cqd10M5X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Co0qX8UV/JkQI/GLEvzoC7jqcaOgORmS94PZnQFn/i6QlqccOQ2onDzSZzy9dIg33
	 HxFrVXx6nWANEfGdcQKoiHqS45rlyJApYdOhT7MdtJD/fTSqVtPS13r5hvSpFegEdB
	 38Pz67+Li6Il79Ov+qYrfEsPMdriqIP7+/FaTCO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Jacob Keller <Jacob.e.keller@intel.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0268/1005] net: ethernet: ti: am65-cpts: adjust perout genf following ptp changes
Date: Wed, 25 Nov 2026 15:26:46 +0100
Message-ID: <20261125143828.017139276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: James Clark <jjc@jclark.com>

[ Upstream commit 3f1054a0cb09552dd54db024694f74747f9f1d49 ]

A periodic output requested by PTP_PEROUT_REQUEST2 drifts away from
the PHC as soon as the PHC frequency is adjusted, for example by ptp4l
or ts2phc: at +10 ppm each edge is 10 us later than the one before.

The GenF that generates the output counts its period in ref_clk
cycles, which the PPM correction of the CPTS clock does not reach;
each GenF has its own PPM registers. am65_cpts_ptp_adjfine() programs
them only for the GenF used for PPS, and am65_cpts_perout_enable_hw()
starts every GenF with them cleared, so a GenF used for a periodic
output is never corrected.

Commit eb9233ce6751 ("net: ethernet: ti: am65-cpts: adjust pps following
ptp changes") added the correction for the PPS GenF, and
commit 7849c42da2ca ("net: ethernet: ti: am65-cpts: adjust estf following
ptp changes") passed the same values to the ESTFs.

In am65_cpts_ptp_adjfine(), update every enabled GenF the way the PPS
GenF was updated: read its control register, set or clear the PPM
direction bit and write it back with the PPM value. The PPS GenF and the
ESTFs get exactly the values they got before. In
am65_cpts_perout_enable_hw(), start a GenF with the current correction
instead of none; this applies to the PPS GenF too.

Tested on a BeagleY-AI (J722S) with the GENF0 output looped back to
the HW1_TS_PUSH input (EXTTS 0). With the PHC frequency adjusted by
+10 ppm before the periodic output is started, the edges drift 10 us
per second against the PHC without this patch (290 us after 29 s);
with it, they stay 20 to 23 ns after the PHC second. This also works
if the frequency is adjusted after the periodic output has started.

Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
Signed-off-by: James Clark <jjc@jclark.com>
Reviewed-by: Jacob Keller <Jacob.e.keller@intel.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 67 +++++++++++++++++++----------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index df5659ead72f6..0d71147f3c291 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -176,6 +176,9 @@ struct am65_cpts {
 	struct mutex ptp_clk_lock; /* PHC access sync */
 	u64 timestamp;
 	u32 genf_enable;
+	bool genf_neg_adj;
+	u32 genf_ppm_hi;
+	u32 genf_ppm_low;
 	u32 hw_ts_enable;
 	u32 estf_enable;
 	struct sk_buff_head txq;
@@ -436,9 +439,11 @@ static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct am65_cpts *cpts = container_of(ptp, struct am65_cpts, ptp_info);
 	u32 estf_ctrl_val = 0, estf_ppm_hi = 0, estf_ppm_low = 0;
+	u32 genf_ctrl_val[AM65_CPTS_GENF_MAX_NUM];
+	u32 genf_ppm_hi, genf_ppm_low;
 	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	int pps_index = cpts->pps_genf_idx;
-	u64 adj_period, pps_adj_period;
+	u64 adj_period, genf_adj_period;
 	u32 ctrl_val, ppm_hi, ppm_low;
 	unsigned long flags;
 	int neg_adj = 0, i;
@@ -470,20 +475,33 @@ static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	ppm_hi = upper_32_bits(adj_period) & 0x3FF;
 	ppm_low = lower_32_bits(adj_period);
 
+	/* GenF PPM will do correction using cpts refclk tick which is
+	 * (cpts->ts_add_val + 1) ns, so GenF length PPM adj period
+	 * need to be corrected.
+	 */
+	genf_adj_period = adj_period * (cpts->ts_add_val + 1);
+	genf_ppm_hi = upper_32_bits(genf_adj_period) & 0x3FF;
+	genf_ppm_low = lower_32_bits(genf_adj_period);
+	cpts->genf_neg_adj = neg_adj;
+	cpts->genf_ppm_hi = genf_ppm_hi;
+	cpts->genf_ppm_low = genf_ppm_low;
+
+	for (i = 0; i < AM65_CPTS_GENF_MAX_NUM; i++) {
+		if (cpts->genf_enable & BIT(i)) {
+			genf_ctrl_val[i] = am65_cpts_read32(cpts,
+							    genf[i].control);
+			if (neg_adj)
+				genf_ctrl_val[i] &= ~BIT(1);
+			else
+				genf_ctrl_val[i] |= BIT(1);
+		}
+	}
+
 	if (cpts->pps_enabled) {
-		estf_ctrl_val = am65_cpts_read32(cpts, genf[pps_index].control);
-		if (neg_adj)
-			estf_ctrl_val &= ~BIT(1);
-		else
-			estf_ctrl_val |= BIT(1);
-
-		/* GenF PPM will do correction using cpts refclk tick which is
-		 * (cpts->ts_add_val + 1) ns, so GenF length PPM adj period
-		 * need to be corrected.
-		 */
-		pps_adj_period = adj_period * (cpts->ts_add_val + 1);
-		estf_ppm_hi = upper_32_bits(pps_adj_period) & 0x3FF;
-		estf_ppm_low = lower_32_bits(pps_adj_period);
+		/* am65_cpts_perout_enable_hw() sets pps_index in genf_enable */
+		estf_ctrl_val = genf_ctrl_val[pps_index];
+		estf_ppm_hi = genf_ppm_hi;
+		estf_ppm_low = genf_ppm_low;
 	}
 
 	spin_lock_irqsave(&cpts->lock, flags);
@@ -500,10 +518,13 @@ static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	am65_cpts_write32(cpts, ppm_hi, ts_ppm_hi);
 	am65_cpts_write32(cpts, ppm_low, ts_ppm_low);
 
-	if (cpts->pps_enabled) {
-		am65_cpts_write32(cpts, estf_ctrl_val, genf[pps_index].control);
-		am65_cpts_write32(cpts, estf_ppm_hi, genf[pps_index].ppm_hi);
-		am65_cpts_write32(cpts, estf_ppm_low, genf[pps_index].ppm_low);
+	for (i = 0; i < AM65_CPTS_GENF_MAX_NUM; i++) {
+		if (cpts->genf_enable & BIT(i)) {
+			am65_cpts_write32(cpts, genf_ctrl_val[i],
+					  genf[i].control);
+			am65_cpts_write32(cpts, genf_ppm_hi, genf[i].ppm_hi);
+			am65_cpts_write32(cpts, genf_ppm_low, genf[i].ppm_low);
+		}
 	}
 
 	for (i = 0; i < AM65_CPTS_ESTF_MAX_NUM; i++) {
@@ -513,7 +534,6 @@ static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 			am65_cpts_write32(cpts, estf_ppm_low, estf[i].ppm_low);
 		}
 	}
-	/* All GenF/EstF can be updated here the same way */
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	mutex_unlock(&cpts->ptp_clk_lock);
@@ -679,9 +699,12 @@ static void am65_cpts_perout_enable_hw(struct am65_cpts *cpts,
 		val = lower_32_bits(cycles);
 		am65_cpts_write32(cpts, val, genf[req->index].length);
 
-		am65_cpts_write32(cpts, 0, genf[req->index].control);
-		am65_cpts_write32(cpts, 0, genf[req->index].ppm_hi);
-		am65_cpts_write32(cpts, 0, genf[req->index].ppm_low);
+		am65_cpts_write32(cpts, cpts->genf_neg_adj ? 0 : BIT(1),
+				  genf[req->index].control);
+		am65_cpts_write32(cpts, cpts->genf_ppm_hi,
+				  genf[req->index].ppm_hi);
+		am65_cpts_write32(cpts, cpts->genf_ppm_low,
+				  genf[req->index].ppm_low);
 
 		cpts->genf_enable |= BIT(req->index);
 	} else {
-- 
2.53.0



