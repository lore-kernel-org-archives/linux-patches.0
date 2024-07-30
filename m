Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84171898E0;
	Tue, 30 Jul 2024 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359553; cv=none; b=TVIdclqkOxa4Zgz4I3jQb7y9Jc5hFHQlz8YbLC64XnUUecBnXErDLpB9HXLq00IhwBFDaUjDB6OgOnaXxwICBa67tyZ9fz2CBl58uNsyBG0B7NzrPdZNpP1AtJQYEAnNM/y8n2ZLsxtH8TwbASyxqpDG7+GYO9KK/y0pa++eleo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359553; c=relaxed/simple;
	bh=h/GN1qafrlp0irfiDzAsPH55zbXfsKxeh4iSK0mx1tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFfwn4PGQQvLzVzRnC4xK72M+PfSIf/Oq9a+MPvkFn4L+0iFvPguJrDPRJnvF4AXHQfR8FMZikAcq98yzNhsrLVD/4y+o5E2wA1q3RXF9BYFwpRNaA9JRQ9romw0741yFynkTrJ/0VbN0i0IuPJLkm+pAhpgU6WYoiF3eRJ45CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+19jpX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+19jpX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A16FC4AF0C;
	Tue, 30 Jul 2024 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359553;
	bh=h/GN1qafrlp0irfiDzAsPH55zbXfsKxeh4iSK0mx1tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+19jpX98Sl1jsGyG83FmVOAwsv1DHZlxTBRDF2HBzdhspsfrBw2dS7jzRTmUBzX+
	 NsS2xx1YahHS3VWrk4Ao+N7SemqpAS5Rj2CGFIkYPh6xUXc63IcreNo1ZunT101uph
	 6CJNgqM+Kn8J4h6eaJoyORW16NzRAqmL0vCRQh/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 500/809] pinctrl: renesas: r8a779g0: Fix CANFD5 suffix
Date: Tue, 30 Jul 2024 17:46:16 +0200
Message-ID: <20240730151744.485395361@linuxfoundation.org>
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

[ Upstream commit 77fa9007ac31e80674beadc452d3f3614f283e18 ]

CAN-FD instance 5 has two alternate pin groups: "canfd5" and "canfd5_b".
Rename the former to "canfd5_a" to increase uniformity.

While at it, remove the unneeded separator.

Fixes: ad9bb2fec66262b0 ("pinctrl: renesas: Initial R8A779G0 (R-Car V4H) PFC support")
Fixes: 050442ae4c74f830 ("pinctrl: renesas: r8a779g0: Add pins, groups and functions")
Fixes: c2b4b2cd632d17e7 ("pinctrl: renesas: r8a779g0: Add missing CANFD5_B")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/10b22d54086ed11cdfeb0004583029ccf249bdb9.1717754960.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a779g0.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/renesas/pfc-r8a779g0.c b/drivers/pinctrl/renesas/pfc-r8a779g0.c
index d2de526a3b588..d90ba8b6b4b42 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779g0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779g0.c
@@ -341,8 +341,8 @@
 /* IP0SR2 */		/* 0 */			/* 1 */			/* 2 */			/* 3		4	 5	  6	   7	    8	     9	      A	       B	C	 D	  E	   F */
 #define IP0SR2_3_0	FM(FXR_TXDA)		FM(CANFD1_TX)		FM(TPU0TO2_A)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_7_4	FM(FXR_TXENA_N)		FM(CANFD1_RX)		FM(TPU0TO3_A)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR2_11_8	FM(RXDA_EXTFXR)		FM(CANFD5_TX)		FM(IRQ5)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR2_15_12	FM(CLK_EXTFXR)		FM(CANFD5_RX)		FM(IRQ4_B)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR2_11_8	FM(RXDA_EXTFXR)		FM(CANFD5_TX_A)		FM(IRQ5)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR2_15_12	FM(CLK_EXTFXR)		FM(CANFD5_RX_A)		FM(IRQ4_B)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_19_16	FM(RXDB_EXTFXR)		F_(0, 0)		F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_23_20	FM(FXR_TXENB_N)		F_(0, 0)		F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR2_27_24	FM(FXR_TXDB)		F_(0, 0)		F_(0, 0)		F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
@@ -896,11 +896,11 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_GPSR(IP0SR2_7_4,	TPU0TO3_A),
 
 	PINMUX_IPSR_GPSR(IP0SR2_11_8,	RXDA_EXTFXR),
-	PINMUX_IPSR_GPSR(IP0SR2_11_8,	CANFD5_TX),
+	PINMUX_IPSR_GPSR(IP0SR2_11_8,	CANFD5_TX_A),
 	PINMUX_IPSR_GPSR(IP0SR2_11_8,	IRQ5),
 
 	PINMUX_IPSR_GPSR(IP0SR2_15_12,	CLK_EXTFXR),
-	PINMUX_IPSR_GPSR(IP0SR2_15_12,	CANFD5_RX),
+	PINMUX_IPSR_GPSR(IP0SR2_15_12,	CANFD5_RX_A),
 	PINMUX_IPSR_GPSR(IP0SR2_15_12,	IRQ4_B),
 
 	PINMUX_IPSR_GPSR(IP0SR2_19_16,	RXDB_EXTFXR),
@@ -1531,15 +1531,14 @@ static const unsigned int canfd4_data_mux[] = {
 };
 
 /* - CANFD5 ----------------------------------------------------------------- */
-static const unsigned int canfd5_data_pins[] = {
-	/* CANFD5_TX, CANFD5_RX */
+static const unsigned int canfd5_data_a_pins[] = {
+	/* CANFD5_TX_A, CANFD5_RX_A */
 	RCAR_GP_PIN(2, 2), RCAR_GP_PIN(2, 3),
 };
-static const unsigned int canfd5_data_mux[] = {
-	CANFD5_TX_MARK, CANFD5_RX_MARK,
+static const unsigned int canfd5_data_a_mux[] = {
+	CANFD5_TX_A_MARK, CANFD5_RX_A_MARK,
 };
 
-/* - CANFD5_B ----------------------------------------------------------------- */
 static const unsigned int canfd5_data_b_pins[] = {
 	/* CANFD5_TX_B, CANFD5_RX_B */
 	RCAR_GP_PIN(1, 8), RCAR_GP_PIN(1, 9),
@@ -2578,8 +2577,8 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(canfd2_data),
 	SH_PFC_PIN_GROUP(canfd3_data),
 	SH_PFC_PIN_GROUP(canfd4_data),
-	SH_PFC_PIN_GROUP(canfd5_data),		/* suffix might be updated */
-	SH_PFC_PIN_GROUP(canfd5_data_b),	/* suffix might be updated */
+	SH_PFC_PIN_GROUP(canfd5_data_a),
+	SH_PFC_PIN_GROUP(canfd5_data_b),
 	SH_PFC_PIN_GROUP(canfd6_data),
 	SH_PFC_PIN_GROUP(canfd7_data),
 	SH_PFC_PIN_GROUP(can_clk),
@@ -2788,8 +2787,7 @@ static const char * const canfd4_groups[] = {
 };
 
 static const char * const canfd5_groups[] = {
-	/* suffix might be updated */
-	"canfd5_data",
+	"canfd5_data_a",
 	"canfd5_data_b",
 };
 
-- 
2.43.0



