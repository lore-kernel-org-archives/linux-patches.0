Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0B414D29B;
	Tue, 30 Jul 2024 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357047; cv=none; b=tY56zMSucSUuRd+pKUzXG/Wm564h0IsX9P2zhd/q8zt8JejQTSjzTlkfi9RwPH5+d24zC3W5y61Ck5wn+JN7HnD6EwoPe3Z/3UZsiqWb80HoHa367ZFVlf4GKvPcgw9BDXazS1IJvUratQwE0lL20gOVdAzCcs2w5ADvYWbEBtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357047; c=relaxed/simple;
	bh=koQ96DwLH7CMURN+Lj5USIf0E6e2U0NqrhfAETW+pbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE7xyjyR0r+hr+LugQ8+lh/zTYLd4nBb0O5/Z0ha6qELwLZIVRZpTsxeJauEkjOcrAiW2y/GuJpEhqmuCzsq4w+Uzpnjr8z1kCd/cLz6FOM2astBpDgMdcuGpcT7J9I5qmU9v/RRwBew3P+bvEWn2kgQey68K11+8od4CpLRDE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yp0laS7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yp0laS7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BF0C32782;
	Tue, 30 Jul 2024 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357046;
	bh=koQ96DwLH7CMURN+Lj5USIf0E6e2U0NqrhfAETW+pbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yp0laS7zMomJj6LzmVLpGkYbAu6QZfO0XfaHEFzh5vFC66W8/ETgZmIGNZ7imUfQ9
	 kXTRXEq98F7KqTS1kpo8v7Nyl6yBqB1L6CgUV8Kfe3kJcFemWAWsTYK7WD3br4AKsk
	 SJjmTfw6BcmiaCpkuZKSajotPFb5vFObEAAidBLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/440] pinctrl: renesas: r8a779g0: Fix FXR_TXEN[AB] suffixes
Date: Tue, 30 Jul 2024 17:48:06 +0200
Message-ID: <20240730151625.728728533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4976d61ca39ce51f422e094de53b46e2e3ac5c0d ]

The Pin Multiplex attachment in Rev.1.10 of the R-Car V4H Series
Hardware User's Manual still has two alternate pins named both
"FXR_TXEN[AB]".  To differentiate, the pin control driver uses
"FXR_TXEN[AB]" and "FXR_TXEN[AB]_X", which were considered temporary
names until the conflict was sorted out.

Fix this by adopting R-Car V4M naming:
  - Rename "FXR_TXEN[AB]" to "FXR_TXEN[AB]_A",
  - Rename "FXR_TXEN[AB]_X" to "FXR_TXEN[AB]_B".

Fixes: ad9bb2fec66262b0 ("pinctrl: renesas: Initial R8A779G0 (R-Car V4H) PFC support")
Fixes: 1c2646b5cebfff07 ("pinctrl: renesas: r8a779g0: Add missing FlexRay")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/5e1e9abb46c311d4c54450d991072d6d0e66f14c.1717754960.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a779g0.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/renesas/pfc-r8a779g0.c b/drivers/pinctrl/renesas/pfc-r8a779g0.c
index 245212ebbfc9c..1f64aeab186fc 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779g0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779g0.c
@@ -116,11 +116,11 @@
 #define GPSR2_8		F_(TPU0TO0,		IP1SR2_3_0)
 #define GPSR2_7		F_(TPU0TO1,		IP0SR2_31_28)
 #define GPSR2_6		F_(FXR_TXDB,		IP0SR2_27_24)
-#define GPSR2_5		F_(FXR_TXENB_N,		IP0SR2_23_20)
+#define GPSR2_5		F_(FXR_TXENB_N_A,	IP0SR2_23_20)
 #define GPSR2_4		F_(RXDB_EXTFXR,		IP0SR2_19_16)
 #define GPSR2_3		F_(CLK_EXTFXR,		IP0SR2_15_12)
 #define GPSR2_2		F_(RXDA_EXTFXR,		IP0SR2_11_8)
-#define GPSR2_1		F_(FXR_TXENA_N,		IP0SR2_7_4)
+#define GPSR2_1		F_(FXR_TXENA_N_A,	IP0SR2_7_4)
 #define GPSR2_0		F_(FXR_TXDA,		IP0SR2_3_0)
 
 /* GPSR3 */
@@ -334,18 +334,18 @@
 /* SR2 */
 /* IP0SR2 */		/* 0 */			/* 1 */			/* 2 */			/* 3		4	 5	  6	   7	    8	     9	      A	       B	C	 D	  E	   F */
 #define IP0SR2_3_0	FM(FXR_TXDA)		FM(CANFD1_TX)		FM(TPU0TO2_A)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR2_7_4	FM(FXR_TXENA_N)		FM(CANFD1_RX)		FM(TPU0TO3_A)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR2_7_4	FM(FXR_TXENA_N_A)	FM(CANFD1_RX)		FM(TPU0TO3_A)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_11_8	FM(RXDA_EXTFXR)		FM(CANFD5_TX_A)		FM(IRQ5)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_15_12	FM(CLK_EXTFXR)		FM(CANFD5_RX_A)		FM(IRQ4_B)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_19_16	FM(RXDB_EXTFXR)		F_(0, 0)		F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR2_23_20	FM(FXR_TXENB_N)		F_(0, 0)		F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR2_23_20	FM(FXR_TXENB_N_A)	F_(0, 0)		F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_27_24	FM(FXR_TXDB)		F_(0, 0)		F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_31_28	FM(TPU0TO1)		FM(CANFD6_TX)		F_(0, 0)		FM(TCLK2_B)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 
 /* IP1SR2 */		/* 0 */			/* 1 */			/* 2 */			/* 3		4	 5	  6	   7	    8	     9	      A	       B	C	 D	  E	   F */
 #define IP1SR2_3_0	FM(TPU0TO0)		FM(CANFD6_RX)		F_(0, 0)		FM(TCLK1_A)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP1SR2_7_4	FM(CAN_CLK)		FM(FXR_TXENA_N_X)	F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP1SR2_11_8	FM(CANFD0_TX)		FM(FXR_TXENB_N_X)	F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP1SR2_7_4	FM(CAN_CLK)		FM(FXR_TXENA_N_B)	F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP1SR2_11_8	FM(CANFD0_TX)		FM(FXR_TXENB_N_B)	F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP1SR2_15_12	FM(CANFD0_RX)		FM(STPWT_EXTFXR)	F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP1SR2_19_16	FM(CANFD2_TX)		FM(TPU0TO2)		F_(0, 0)		FM(TCLK3_A)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP1SR2_23_20	FM(CANFD2_RX)		FM(TPU0TO3)		FM(PWM1_B)		FM(TCLK4_A)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
@@ -885,7 +885,7 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_GPSR(IP0SR2_3_0,	CANFD1_TX),
 	PINMUX_IPSR_GPSR(IP0SR2_3_0,	TPU0TO2_A),
 
-	PINMUX_IPSR_GPSR(IP0SR2_7_4,	FXR_TXENA_N),
+	PINMUX_IPSR_GPSR(IP0SR2_7_4,	FXR_TXENA_N_A),
 	PINMUX_IPSR_GPSR(IP0SR2_7_4,	CANFD1_RX),
 	PINMUX_IPSR_GPSR(IP0SR2_7_4,	TPU0TO3_A),
 
@@ -899,7 +899,7 @@ static const u16 pinmux_data[] = {
 
 	PINMUX_IPSR_GPSR(IP0SR2_19_16,	RXDB_EXTFXR),
 
-	PINMUX_IPSR_GPSR(IP0SR2_23_20,	FXR_TXENB_N),
+	PINMUX_IPSR_GPSR(IP0SR2_23_20,	FXR_TXENB_N_A),
 
 	PINMUX_IPSR_GPSR(IP0SR2_27_24,	FXR_TXDB),
 
@@ -913,10 +913,10 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_GPSR(IP1SR2_3_0,	TCLK1_A),
 
 	PINMUX_IPSR_GPSR(IP1SR2_7_4,	CAN_CLK),
-	PINMUX_IPSR_GPSR(IP1SR2_7_4,	FXR_TXENA_N_X),
+	PINMUX_IPSR_GPSR(IP1SR2_7_4,	FXR_TXENA_N_B),
 
 	PINMUX_IPSR_GPSR(IP1SR2_11_8,	CANFD0_TX),
-	PINMUX_IPSR_GPSR(IP1SR2_11_8,	FXR_TXENB_N_X),
+	PINMUX_IPSR_GPSR(IP1SR2_11_8,	FXR_TXENB_N_B),
 
 	PINMUX_IPSR_GPSR(IP1SR2_15_12,	CANFD0_RX),
 	PINMUX_IPSR_GPSR(IP1SR2_15_12,	STPWT_EXTFXR),
-- 
2.43.0



