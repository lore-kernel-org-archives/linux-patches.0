Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8DF1A6161;
	Tue, 30 Jul 2024 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357034; cv=none; b=Ol9PeRWraExoVZ6T6bvY5wIwr/zbhC0XGkXC9wkJUbqS3Y2/W1SgBisowd448tq0QbiSSnt0kfQKXHAZT49djDm0I77/czc5N+zy0TXNjqJ+cEfiQKKErXBA4Yf2RE1t/5uQitfepjMQrxkpyrHCu16r9mbLz5wolFpJVYsg6Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357034; c=relaxed/simple;
	bh=H/EUxOJ2GRzx8bFzlZohBmCV6Q7TmrACmQTpP661G1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoLHRiVZHW5dBlUfr1QEqXOB2SdHN2CK6DJVsH0ovCuuFJaUafNH+ljELSlkxJUPY2XzXJlpR3G1gQZB807Sg4GPPI9yL0dJB5gdT/LX112cEq0/jR0SyE33ICSyajfWK31Oi6Y7HVe81WgJ2TJANi/tuzILFSBAfv/vFhYaUeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RI91htMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RI91htMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E00C32782;
	Tue, 30 Jul 2024 16:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357033;
	bh=H/EUxOJ2GRzx8bFzlZohBmCV6Q7TmrACmQTpP661G1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI91htMglJB2BdHm4S8Qd0ge61DdP0mM8soAceAo7aTzBFd84OG9X/HFjdZL63LBA
	 ZHKmTHYf2sjjD1dwqCqUwUwhP2Uc+TEpnmqGwuVRqaTnsYncBmMhaxu+mh1yQWxELh
	 IJtJKEUpUfRoQhSMbftLoNKa65AbKDkKVVNoesMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/440] pinctrl: renesas: r8a779g0: Fix CANFD5 suffix
Date: Tue, 30 Jul 2024 17:48:05 +0200
Message-ID: <20240730151625.691272562@linuxfoundation.org>
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
index acf7664ea835b..245212ebbfc9c 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779g0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779g0.c
@@ -335,8 +335,8 @@
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
@@ -890,11 +890,11 @@ static const u16 pinmux_data[] = {
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
@@ -1507,15 +1507,14 @@ static const unsigned int canfd4_data_mux[] = {
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
@@ -2551,8 +2550,8 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
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
@@ -2756,8 +2755,7 @@ static const char * const canfd4_groups[] = {
 };
 
 static const char * const canfd5_groups[] = {
-	/* suffix might be updated */
-	"canfd5_data",
+	"canfd5_data_a",
 	"canfd5_data_b",
 };
 
-- 
2.43.0



