Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023651;
	b=F7j2eAS5j3z72lnx75yE8bpMOxIqP114SgqAQoIoCUPGIhSC0VLC7e/uZlEjQ4MQ3GBN
	 64+4krDNNbm2DknG5s4tdblinzRZx5e2bJ+1tDueaLBGk4kmckArg2IM0GYgcmXiwDYcu
	 w2y3M0QPZjta/srDLJV67X/eCgN1rnvtS2wKbk0pLvc5tFo/JnPvfqzvWK00r6MiK91Tf
	 2e6mZUk82OL1STyvFEOFz4mLB4IzUzzLUtSGSL39H6ZV9u3wmDxNIcJOnIZaSh05g0Kiw
	 BtLhsSSNDwnXK7mXbucZgLqQL9SgB6R7KuATUym6gC/fA3cumO+ZQsSMQNfmQIkj44A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bRSa4cyp052X/zyi8BDwG3F/DGvMvki5pkF8rLCHGzs=;
	b=RTutJQRH0zHXJxT4d0deXSE/ore+AOGm4XS5r2v3di8qiJtByiRSJobSFvXnAEksLmoF
	 /t3tLRuhu5EpySJPc0XL/65pGREASHyL//SXxUfg/WZmVnjcR5eHCadMcNKzQGnTgIP4f
	 j/IbnIRixAkjnfCJIOpE18u602e5eJ69bOaaTyFCaBYHiOEZ1mkDWGgb4nUdpCIswCQyP
	 E/NpxNzvmrBz97aq4SBMhT5M+FAGDDz0R/2R+TEg7tWvA/lK/L6U3IXF735s0l027zBoM
	 UboOFG++y9pxxLZ+TDZURWzfL0vNjiCcST05c8iKmWnG2OufUvtgdmKS4QdnbFzPaxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+RIZUL+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1E8606A325;
	Wed, 18 Nov 2026 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+RIZUL+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479201F000C4;
	Wed, 18 Nov 2026 17:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023650;
	bh=bRSa4cyp052X/zyi8BDwG3F/DGvMvki5pkF8rLCHGzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+RIZUL+zYfSK9SL2SdQb9P6HF4utS06Q52nmdyCkpeCqih7iBAswnMta4puf1A6T
	 diXfy5jcYB6Iog5XF6lEccTEHTyeVsGzfK7F9Sx3HWxf9LTDWzmestsPaa4mLxbHLQ
	 seXCvXFia70k2VaHTXbG7HZ/dxk3ZXP2KUU4yH9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0428/2151] clk: sunxi-ng: sun55i-a523-r-ccu: Use P-only clocks for timers
Date: Wed, 18 Nov 2026 15:36:03 +0100
Message-ID: <20261118150137.643402220@linuxfoundation.org>
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

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit 1002cc9d60942f8f294d8de7f2805f82f4ebdda0 ]

The R timer clocks only have a P divider, but are currently modeled as
MP clocks with a zero-width M divider.

ccu_mp_set_rate() generates an invalid mask for the zero-width M
divider, clearing unrelated register fields. Model these clocks as
P-only clocks to avoid accessing a nonexistent M divider.

Fixes: 8cea339cfb81 ("clk: sunxi-ng: add support for the A523/T527 PRCM CCU")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Link: https://patch.msgid.link/20260906-sunxi-clk-no-p-v1-4-cbde21c9fe69@pigmoral.tech
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c | 37 +++++++++++-------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c b/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
index db0e36d8838e7..349230e28c1c3 100644
--- a/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
+++ b/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
@@ -43,27 +43,24 @@ static SUNXI_CCU_M_DATA_WITH_MUX(r_apb1_clk, "r-apb1",
 				 24, 3,	/* mux */
 				 0);
 
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(r_cpu_timer0, "r-timer0",
-				       r_ahb_apb_parents, 0x100,
-				       0, 0,	/* no M */
-				       1, 3,	/* P */
-				       4, 3,	/* mux */
-				       BIT(0),
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(r_cpu_timer0, "r-timer0",
+				      r_ahb_apb_parents, 0x100,
+				      1, 3,	/* P */
+				      4, 3,	/* mux */
+				      BIT(0),
+				      0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(r_cpu_timer1, "r-timer1",
+				      r_ahb_apb_parents, 0x104,
+				      1, 3,	/* P */
+				      4, 3,	/* mux */
+				      BIT(0),
+				      0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(r_cpu_timer2, "r-timer2",
+				      r_ahb_apb_parents, 0x108,
+				      1, 3,	/* P */
+				      4, 3,	/* mux */
+				      BIT(0),
 				      0);
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(r_cpu_timer1, "r-timer1",
-				       r_ahb_apb_parents, 0x104,
-				       0, 0,	/* no M */
-				       1, 3,	/* P */
-				       4, 3,	/* mux */
-				       BIT(0),
-				       0);
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(r_cpu_timer2, "r-timer2",
-				       r_ahb_apb_parents, 0x108,
-				       0, 0,	/* no M */
-				       1, 3,	/* P */
-				       4, 3,	/* mux */
-				       BIT(0),
-				       0);
 
 static SUNXI_CCU_GATE_HW(bus_r_timer_clk, "bus-r-timer", &r_ahb_clk.common.hw,
 			 0x11c, BIT(0), 0);
-- 
2.53.0



