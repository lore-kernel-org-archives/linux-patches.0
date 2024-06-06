Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE87B196D8C;
	Thu,  6 Jun 2024 14:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682921; cv=none; b=KMBdgn6RATjDjB65WJ9SC2GWvxziAD+7aXkKz3AADALkl5sThY0XD61EYelRpZnZA6QeqCUu3+wb8vDnHaOndzm8/kQVLpi7MyUE7/IA6L8aswuAiOo3doz+ffC+GQvoqNDP9Vd1ZnTdRGQKXOth3p6ovn4DQuzln2dvfYYN+iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682921; c=relaxed/simple;
	bh=RohI7eUCKElc195ywQ74OfIw1WRMywN0swFYfqG9scE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuepMmhv1S8YBzi3ciPws20ucA5FcE8rW0zGtS9W/z1yhUSVREvlVhJjX+91K4uw8mLT3nwIwRvjo/kLNinPC1WhUaPN9hWlijoo49HCfgpsLUVdUpRSPF2+jM+9uvPGzwX7cedTk3qFeibnwb4EQeRvFsTuqmXWYKhU1wAJre0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dkb2lEa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dkb2lEa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E91C2BD10;
	Thu,  6 Jun 2024 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682921;
	bh=RohI7eUCKElc195ywQ74OfIw1WRMywN0swFYfqG9scE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dkb2lEa4QlbgZl6tFACf7ej4YymSnsZSZoEoCgE37pkYw/Tq/ZIiZgkzqFE4akS6v
	 dZIcqJBe220H6c/+Urhzb2fUv9iHE1rcakj2qCxwr7fzEbOhsmFDFhMiqbos0/rTfK
	 RKMAsN2XuIUuiiuHcMfmxgIycBYOxyKRTDba9bCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 061/374] pinctrl: renesas: r8a779h0: Fix IRQ suffixes
Date: Thu,  6 Jun 2024 16:00:40 +0200
Message-ID: <20240606131653.904309605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit c3bec9547c1be0cce3060368dd92abf610c65f24 ]

The suffixes of the IRQ identifiers, as used for pins related to the
Interrupt Controller for External Devices (INTC-EX), are inconsistent.
Correct them to match the Pin Multiplex attachment in Rev.0.51 of the
R-Car V4M Series Hardware User's Manual.

Fixes: 291f7856fc451cbe ("pinctrl: renesas: Initial R8A779H0 (R-Car V4M) PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/7d3c7498d9e8eda5583b15f9163eb25bb797ed24.1713282028.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a779h0.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/renesas/pfc-r8a779h0.c b/drivers/pinctrl/renesas/pfc-r8a779h0.c
index afa8f06c85cf5..0cbfe7637fc97 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779h0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779h0.c
@@ -75,10 +75,10 @@
 #define GPSR0_9		F_(MSIOF5_SYNC,		IP1SR0_7_4)
 #define GPSR0_8		F_(MSIOF5_SS1,		IP1SR0_3_0)
 #define GPSR0_7		F_(MSIOF5_SS2,		IP0SR0_31_28)
-#define GPSR0_6		F_(IRQ0,		IP0SR0_27_24)
-#define GPSR0_5		F_(IRQ1,		IP0SR0_23_20)
-#define GPSR0_4		F_(IRQ2,		IP0SR0_19_16)
-#define GPSR0_3		F_(IRQ3,		IP0SR0_15_12)
+#define GPSR0_6		F_(IRQ0_A,		IP0SR0_27_24)
+#define GPSR0_5		F_(IRQ1_A,		IP0SR0_23_20)
+#define GPSR0_4		F_(IRQ2_A,		IP0SR0_19_16)
+#define GPSR0_3		F_(IRQ3_A,		IP0SR0_15_12)
 #define GPSR0_2		F_(GP0_02,		IP0SR0_11_8)
 #define GPSR0_1		F_(GP0_01,		IP0SR0_7_4)
 #define GPSR0_0		F_(GP0_00,		IP0SR0_3_0)
@@ -265,10 +265,10 @@
 #define IP0SR0_3_0	F_(0, 0)		FM(ERROROUTC_N_B)	FM(TCLK2_B)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR0_7_4	F_(0, 0)		FM(MSIOF3_SS1)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR0_11_8	F_(0, 0)		FM(MSIOF3_SS2)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR0_15_12	FM(IRQ3)		FM(MSIOF3_SCK)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR0_19_16	FM(IRQ2)		FM(MSIOF3_TXD)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR0_23_20	FM(IRQ1)		FM(MSIOF3_RXD)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
-#define IP0SR0_27_24	FM(IRQ0)		FM(MSIOF3_SYNC)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR0_15_12	FM(IRQ3_A)		FM(MSIOF3_SCK)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR0_19_16	FM(IRQ2_A)		FM(MSIOF3_TXD)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR0_23_20	FM(IRQ1_A)		FM(MSIOF3_RXD)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
+#define IP0SR0_27_24	FM(IRQ0_A)		FM(MSIOF3_SYNC)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 #define IP0SR0_31_28	FM(MSIOF5_SS2)		F_(0, 0)		F_(0, 0)	F_(0, 0)	F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0) F_(0, 0)
 
 /* IP1SR0 */		/* 0 */			/* 1 */			/* 2 */		/* 3		4	 5	  6	   7	    8	     9	      A	       B	C	 D	  E	   F */
@@ -672,16 +672,16 @@ static const u16 pinmux_data[] = {
 
 	PINMUX_IPSR_GPSR(IP0SR0_11_8,	MSIOF3_SS2),
 
-	PINMUX_IPSR_GPSR(IP0SR0_15_12,	IRQ3),
+	PINMUX_IPSR_GPSR(IP0SR0_15_12,	IRQ3_A),
 	PINMUX_IPSR_GPSR(IP0SR0_15_12,	MSIOF3_SCK),
 
-	PINMUX_IPSR_GPSR(IP0SR0_19_16,	IRQ2),
+	PINMUX_IPSR_GPSR(IP0SR0_19_16,	IRQ2_A),
 	PINMUX_IPSR_GPSR(IP0SR0_19_16,	MSIOF3_TXD),
 
-	PINMUX_IPSR_GPSR(IP0SR0_23_20,	IRQ1),
+	PINMUX_IPSR_GPSR(IP0SR0_23_20,	IRQ1_A),
 	PINMUX_IPSR_GPSR(IP0SR0_23_20,	MSIOF3_RXD),
 
-	PINMUX_IPSR_GPSR(IP0SR0_27_24,	IRQ0),
+	PINMUX_IPSR_GPSR(IP0SR0_27_24,	IRQ0_A),
 	PINMUX_IPSR_GPSR(IP0SR0_27_24,	MSIOF3_SYNC),
 
 	PINMUX_IPSR_GPSR(IP0SR0_31_28,	MSIOF5_SS2),
-- 
2.43.0



