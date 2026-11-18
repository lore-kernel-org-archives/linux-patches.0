Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020759;
	b=oD6JdL2N2/RbeRrJigrFN3dmXdC1yeRHOEA0P5knV0goLsCHjFw+VcuNjdCXmaaGEq0I
	 l6JtQOqb03WFJGNVR8TRPmL32deYHtYjgfitdmqgh71vtILf2pCVO7fWj07k7lLXWWlN1
	 Q+5s5JW+oy8ualRwI9qLKiuAqk8161hckhB8qICwLhpjc/VTvaKblR1uoPqYtAmOMm1jz
	 VovXXKKVSrhxp9ZoFtRS0br7p6dTHOBrU1muaj73g1nbtX2+Je/y5dGN5jck+KLitMAGW
	 DrFG7CGJ491QAHCIFEAuLm+kMIc7UUWFXzCK0A/rVS9wOUTnMF1xkavJNeMSSqBSZdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ICTd9rheZBCgDIOCUbNQJi+ywV3OLRPU6HwGMwNLu0U=;
	b=CA0BoWPrP2E8ywj46HDx4eHzbe/+yzzI+bNsP82mcxK/XoWXUWygeijAZlLDs9RwmrrN
	 JjqYeibX9QRtIfX82VAcx+eaEn9NimjQCr5IrKHGDCYzthbkX4L/t1ylYOZKC7FmbwSX/
	 8t+iMwRS+tD2GjlSLeDLJxjcbooxqwTqYIBaAxf075MCTTuDn0ac9GjbYuc0tXJ/XCnnP
	 SjhK+g5x9b7JvoPBMmU808Tegb4iyohgnoVZb0R0APfQ1WFMyANjtl2SxnwO8/dDLs8rX
	 dNyZzPiLWWyCh9Qdc7Gez2+4oSvdZA/WZgrcdGrnPWr7ubWqrHWbq1aCCePvAEK2f/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7DttWaN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F573606A33F;
	Wed, 18 Nov 2026 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7DttWaN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B2A1F000C8;
	Wed, 18 Nov 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020758;
	bh=ICTd9rheZBCgDIOCUbNQJi+ywV3OLRPU6HwGMwNLu0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7DttWaN43JEjRENw83KrhV+P0VIEkqj2kO7uNjIwOdJp69UucUSaPVDNmQG4o8Ne
	 Ll9lyi0Ik7ulkqxS0cpR7tF0fM6Fr7m0lHyOP+fC/99ZMWhewIE2F1o98Uzh1WeRcF
	 msOLUtfQCtqvafW0YenebDCO5ROKV/unh0ymYX18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2067/2651] dpll: zl3073x: reject inexact frequencies for N-divided outputs
Date: Wed, 18 Nov 2026 15:55:07 +0100
Message-ID: <20261118150400.472049812@linuxfoundation.org>
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

[ Upstream commit f8993627d3101de0833022ac88083ac0147aae7d ]

For N-divided outputs the P-pin and N-pin share the output divisor and
the N-pin frequency is synth_freq / (div * esync_n_period). The frequency
set helper computed esync_n_period with a truncating division and only
rejected a zero result, so a frequency that does not divide evenly was
silently rounded. Setting the P-pin could then shift the N-pin frequency
too (e.g. 600 MHz synth, div=60, period=10 gives P=10 MHz, N=1 MHz;
setting P to 2.5 MHz moves N to 1.25 MHz). When setting the P-pin, the
product esync_n_period * div used for the rescale was computed in 32
bits and could wrap, so a wrong N divider was stored for low N-pin
frequencies.

Require esync_n_period >= 2 so the N-pin frequency stays below the P-pin
one, reject a P-pin frequency for which the esync_n_period keeping the
N-pin frequency does not fit into 32 bits, and check the division
remainder and reject the request if it is not exact.

Found by code inspection, not triggered at runtime.

Fixes: ce26d7ca50a5 ("dpll: zl3073x: Add support to get/set frequency on pins")
Reviewed-by: Petr Oros <poros@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20261011061211.448373-3-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 46 ++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index f2e137475b40f..7a617d9bd6712 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -987,6 +987,7 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	const struct zl3073x_synth *synth;
 	u32 new_div, synth_freq;
 	struct zl3073x_out out;
+	u64 n_period, rem;
 	u8 out_id;
 
 	guard(mutex)(&zldpll->lock);
@@ -1014,16 +1015,11 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	}
 
 	if (zl3073x_dpll_is_p_pin(pin)) {
-		/* We are going to change output frequency for P-pin but
-		 * if the requested frequency is less than current N-pin
-		 * frequency then indicate a failure as we are not able
-		 * to compute N-pin divisor to keep its frequency unchanged.
-		 *
-		 * Update divisor for N-pin to keep N-pin frequency.
+		/* Keep the N-pin frequency: the new P-pin frequency has to be
+		 * a multiple of it, at least twice as high.
 		 */
-		out.esync_n_period = (out.esync_n_period * out.div) / new_div;
-		if (!out.esync_n_period)
-			return -EINVAL;
+		n_period = mul_u32_u32(out.esync_n_period, out.div);
+		n_period = div64_u64_rem(n_period, new_div, &rem);
 
 		/* Update the output divisor */
 		out.div = new_div;
@@ -1031,17 +1027,31 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 		/* For 50/50 duty cycle the divisor is equal to width */
 		out.width = out.div;
 	} else {
-		/* We are going to change frequency of N-pin but if
-		 * the requested freq is greater or equal than freq of P-pin
-		 * in the output pair we cannot compute divisor for the N-pin.
-		 * In this case indicate a failure.
-		 *
-		 * Update divisor for N-pin
+		/* The N-pin frequency has to divide the P-pin frequency and
+		 * be at most half of it.
 		 */
-		out.esync_n_period = div64_u64(synth_freq, frequency * out.div);
-		if (!out.esync_n_period)
-			return -EINVAL;
+		n_period = frequency * out.div;
+		n_period = div64_u64_rem(synth_freq, n_period, &rem);
+	}
+	if (n_period < 2) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "OUT%uN freq must be at most half of OUT%uP freq",
+				   out_id, out_id);
+		return -EINVAL;
+	}
+	if (n_period > U32_MAX) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "OUT%uN freq is too low for OUT%uP freq",
+				   out_id, out_id);
+		return -EINVAL;
+	}
+	if (rem != 0) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "OUT%uN freq must divide OUT%uP freq",
+				   out_id, out_id);
+		return -EINVAL;
 	}
+	out.esync_n_period = n_period;
 
 	/* For 50/50 duty cycle the divisor is equal to width */
 	out.esync_n_width = out.esync_n_period;
-- 
2.53.0



