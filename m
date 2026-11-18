Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027196;
	b=zXDjHsTAUbuNFJwrAVONJxUSHPYUxyAcJvHqxEkuOdO04iXY0+szL+4HvFvS/PHg9pNh
	 SQX/DR6k4kWjYUeiKMuI5tnIxSTZvJj3POOhevR5MhSuTAPpdz11ub3YPZEOgQXEev1iJ
	 W91xW/xXadDijclXlAX4kOXj3E86HDjod35g6mRplm7kLy9d7s2Y9hIGvr2e0X75imK6l
	 83TqUaWHhVohW4MiYtd6pJeKSTNwm5ZECLBb1xekrkY828lymXKjv2iEpDVJgtgwk+t12
	 n5+6gDWLftlozJkKJMfUyskv+p2TbmG5ej0RUzW7dy+HYIIa7dUzlVGkhVDfqG/eM6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZNEZsNHl1VFrElMSEWNJI6Szdid+ZfOSXhRzaygNxdM=;
	b=Sh7LmYF2kKg6ee+PY9prlxHLc2xJ38DuMtRoGsnTNBHLfkRXlaCnL1rA12rzwuhIb8yl
	 UD2khwBeNMfosek0WcvtNEzux+p4L/nLv1nrEMdVsdsyIE8TYFwIHQgYPdxnCjkyf9+5H
	 Rw1VQtTDnfyjO84/eT0YHiJADBT95WLHv+LunzXTjDurbCD/XTg7t3FM+eWx+WR2bYkE1
	 XStGHsk9Vw8zMYajJfPN0xaI03ZguBsCnUAfE7Fa63WC58JQnGFTjn9UcbUxlfXYxVvYi
	 8SBGBSgBFZBmUsuv7td91+5A0sqsux96SAAjMX39ZddoJsAJFwYbp435ZAnPYMhLddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSwId1EP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81802606A31C;
	Wed, 18 Nov 2026 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSwId1EP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE491F000C4;
	Wed, 18 Nov 2026 18:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027196;
	bh=ZNEZsNHl1VFrElMSEWNJI6Szdid+ZfOSXhRzaygNxdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSwId1EPxrZ8shiSBcAmd7MhydtZF91Z/TXxSRCSCnrgVOcfrSTw73S8KQm0ZqWu6
	 84v3dKCErMHDzvV8Ubj3EH7+53wwSd5srXjr/WfR1dPP0Zz/O8lo+coI2cgbrDP8kH
	 cs4E4hIcFZHQQdku1BUxH9PX7ygjU/YtppdAAetU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1705/2151] dpll: zl3073x: reject inexact frequencies for N-divided outputs
Date: Wed, 18 Nov 2026 15:57:20 +0100
Message-ID: <20261118150223.928354532@linuxfoundation.org>
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
index 83d37e3eae789..c2ea96df3bcb6 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -903,6 +903,7 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	const struct zl3073x_synth *synth;
 	u32 new_div, synth_freq;
 	struct zl3073x_out out;
+	u64 n_period, rem;
 	u8 out_id;
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
@@ -928,16 +929,11 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
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
@@ -945,17 +941,31 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
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



