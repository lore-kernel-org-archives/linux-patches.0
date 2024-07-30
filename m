Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4112189522;
	Tue, 30 Jul 2024 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359561; cv=none; b=gfAkdeLAvQYA5gMxq6zrDEn7wn+kxGb3/qopxHOVrs8YJ41fajnBYVVUve3mPxghvZ6C/Y9UPa3r70Y03hn7vHPliNWo4jMlLysdaDmbtafgSGENKl8F781OMLdDl3LzuFN6I5TfWmQ2cvCDlpTRePyVxBqhWoztKKsIfGZclrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359561; c=relaxed/simple;
	bh=jCkTU8FXMHEd+qUQ8h2EZKNjgJvKYjQ5X2SmabFFAH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDJ3niK1kKm62CqWQM+mVF6sWD+dGCuPufN2yn36HzZlCKDDTBHlyllEoQxLquhz65KElst83/pESg8BtsWkjnux2Pyy6nV68jNqSp/noFnWm9eaONJjv5W3TtJdo81Bu6btPxnFkkJuW6QqFCnmfVNsqr9BMt8DK59eof+kpwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mM12QfmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mM12QfmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65768C32782;
	Tue, 30 Jul 2024 17:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359560;
	bh=jCkTU8FXMHEd+qUQ8h2EZKNjgJvKYjQ5X2SmabFFAH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM12QfmOSsgnrknx6RkN07S+RT+d5oNmqkTs7GNAiTLMD77IF0yY4Bcq1vvmWJOfG
	 UejMwfhyUeSP00tCg0MKQJlRcJtFmowuoqA9SFyfXD437MuV42I2xaaGUfcyG1pLRO
	 8N2RaAGXyfZPfELZlx1gFAZ9kZBktnyqBAzivHGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 501/809] pinctrl: renesas: r8a779g0: Fix FXR_TXEN[AB] suffixes
Date: Tue, 30 Jul 2024 17:46:17 +0200
Message-ID: <20240730151744.524122699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d90ba8b6b4b42..ba2ec8e042119 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779g0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779g0.c
@@ -122,11 +122,11 @@
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
@@ -340,18 +340,18 @@
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
@@ -891,7 +891,7 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_GPSR(IP0SR2_3_0,	CANFD1_TX),
 	PINMUX_IPSR_GPSR(IP0SR2_3_0,	TPU0TO2_A),
 
-	PINMUX_IPSR_GPSR(IP0SR2_7_4,	FXR_TXENA_N),
+	PINMUX_IPSR_GPSR(IP0SR2_7_4,	FXR_TXENA_N_A),
 	PINMUX_IPSR_GPSR(IP0SR2_7_4,	CANFD1_RX),
 	PINMUX_IPSR_GPSR(IP0SR2_7_4,	TPU0TO3_A),
 
@@ -905,7 +905,7 @@ static const u16 pinmux_data[] = {
 
 	PINMUX_IPSR_GPSR(IP0SR2_19_16,	RXDB_EXTFXR),
 
-	PINMUX_IPSR_GPSR(IP0SR2_23_20,	FXR_TXENB_N),
+	PINMUX_IPSR_GPSR(IP0SR2_23_20,	FXR_TXENB_N_A),
 
 	PINMUX_IPSR_GPSR(IP0SR2_27_24,	FXR_TXDB),
 
@@ -919,10 +919,10 @@ static const u16 pinmux_data[] = {
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



