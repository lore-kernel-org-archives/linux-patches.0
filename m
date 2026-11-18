Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020762;
	b=yyNx0TN1Lmdz5odfGEmSPx12k39xs+KtDYQBnDKF7ogiMTB+AgqFyY5k4WR4JOmeIxVb
	 ZQ27sKeXMiCd4+aEoHtd2IeYJrvfNSVgh9auOGk63f3QxeTHrnjJBtj9SZp9DzoguHPm7
	 24hTzupZ/H9rCsqHQwpVxA6rkvOfhPq9PBSKf6VdFSf4GtP2EkycJa7pK66jnhPT5pk47
	 YFNUr20oCYqszqqwhgFECQSaHKujzC9UETZVROab5Bfx/DeQ7Nxc9ygJfWBg8Do8Vxuww
	 sa2tDUnCTsFkttBjODBpHHxesqAKzKQPc9oGxYP6d/8e+ityDR+X7pVngu1sxK78nbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nc0KOzDj1gQpuZXALkyoZ819Oj5uM8E2jC8fb7DaOd0=;
	b=mIQDcUgNEcAC3MbpDPcgAllB8pTwDZ5GZZIHuTFW2iJfFC6gdW37B5a/+EQTjMsWQKFv
	 Y/0EsoUvnNguDMmVPFR05IP4LORWGqyDqvo+exfYAbzIsfCC6rPtj2aOwHzey7kvBGd2g
	 dwfErEa75pLEeWZp3B3ALGKcP/rfBloY8K305TjtpiAfDC7cYL6auW7b1sWI0ZfZ8/zh4
	 cpLmD2cZzZgZ6sAxXdhC4berOjO/Yjg+R4O2IrxV9DjRyypPeQ5S85PhcEMtLYduhzQBq
	 9vJ8KXFNLpJZkWKGlGoRJj6XDv7Ul4+yco4+FdmW1Pquoo4uWftXHfBcxbOcRGS3VUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7NmLf7W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3C660A2629;
	Wed, 18 Nov 2026 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7NmLf7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473121F000C8;
	Wed, 18 Nov 2026 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020761;
	bh=Nc0KOzDj1gQpuZXALkyoZ819Oj5uM8E2jC8fb7DaOd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7NmLf7WUhGR6AoEkY1eq4r/uQYMrVPq+CeI4qal70AOae3Pt0Xbr1juVBjagYnuc
	 5Pf90t+4ySs16d7sKNmz+/DJ+MFkm+kD10Jo+oQFyy3ecjKuoTfBfNW7fjRJ6CToL9
	 g6bFOQ8mN9uCWPasscpXLoqfzsGQDkzmOLuvZysY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2068/2651] dpll: zl3073x: reject output frequencies with too small divisor
Date: Wed, 18 Nov 2026 15:55:08 +0100
Message-ID: <20261118150400.509661445@linuxfoundation.org>
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

[ Upstream commit 456027325c9cd2be94229687f2c412ae6f351bd8 ]

The output divisor has to be at least 2: a divisor of 1 bypasses the
divider and the hardware then ignores the pulse width and eSync
registers. For the N-pin of an N-divided output the N divider (>= 2)
applies on top, so its effective divisor has to be at least 4.

zl3073x_pin_check_freq() only checked that the frequency divides the
synth frequency. Require also the minimum divisor. For N-divided
outputs this is necessary but not sufficient, the rest is checked by
the frequency set callback.

Hit during development: an N-pin frequency that needs an N divider of 1
was accepted, and with esync_n_period = 1 the N-pin produced no output
on an oscilloscope.

Fixes: a99a9f0ebdaa ("dpll: zl3073x: Read DPLL types and pin properties from system firmware")
Reviewed-by: Petr Oros <poros@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20261011061211.448373-4-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/prop.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/dpll/zl3073x/prop.c b/drivers/dpll/zl3073x/prop.c
index 768e5424de2d2..4e006ed5950ad 100644
--- a/drivers/dpll/zl3073x/prop.c
+++ b/drivers/dpll/zl3073x/prop.c
@@ -22,7 +22,8 @@
  * The function checks the given frequency is valid for the device. For input
  * pins it checks that the frequency can be factorized using supported base
  * frequencies. For output pins it checks that the frequency divides connected
- * synth frequency without remainder.
+ * synth frequency without remainder and that the resulting divisor is not
+ * below the minimum the driver supports.
  *
  * Return: true if the frequency is valid, false if not.
  */
@@ -41,18 +42,38 @@ zl3073x_pin_check_freq(struct zl3073x_dev *zldev, enum dpll_pin_direction dir,
 		if (rc)
 			goto err_inv_freq;
 	} else {
-		u32 synth_freq;
-		u8 out, synth;
+		u32 synth_freq, div, min_div, rem;
+		const struct zl3073x_out *out;
+		u8 out_id, synth;
 
 		/* Get output pin synthesizer */
-		out = zl3073x_output_pin_out_get(id);
-		synth = zl3073x_dev_out_synth_get(zldev, out);
+		out_id = zl3073x_output_pin_out_get(id);
+		synth = zl3073x_dev_out_synth_get(zldev, out_id);
 
 		/* Get synth frequency */
 		synth_freq = zl3073x_dev_synth_freq_get(zldev, synth);
 
 		/* Check the frequency divides synth frequency */
-		if (synth_freq % (u32)freq)
+		div = div_u64_rem(synth_freq, freq, &rem);
+		if (rem)
+			goto err_inv_freq;
+
+		/* The driver requires an output divisor of at least 2 -
+		 * below that the hardware bypasses the divider and ignores
+		 * the pulse width and eSync registers the driver programs.
+		 * For the N-pin of an N-divided output the effective divisor
+		 * also includes the N divider (>= 2), so the minimum is 4.
+		 * For N-divided outputs this is only a necessary condition -
+		 * whether the frequency can be set also depends on the output
+		 * divisor shared by both pins, which is checked when the
+		 * frequency is set.
+		 */
+		out = zl3073x_out_state_get(zldev, out_id);
+		if (zl3073x_out_is_ndiv(out) && zl3073x_is_n_pin(id))
+			min_div = 4;
+		else
+			min_div = 2;
+		if (div < min_div)
 			goto err_inv_freq;
 	}
 
-- 
2.53.0



