Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016205;
	b=PhUntVbcTwaAlQBUcPQx/9ivMOmYqjteDzoxwa7mYNU6W6JP8b5nlYsGE7iLTtdO4gg1
	 uuBgqvXbp35AC72ivSP4MMlWUtk7LGDBoJXfQZjHkdXrXX4HISv45nE47hI5fXaO/nxWn
	 VBjPHcsUi/mGfvXlExnyOCIhgpM8fwx8Nke4Gy8amK1NT62IIv/ISDLo5FNN3oroyn9/X
	 jtbXss/khyi46i98Zc0BtM/qoq/KvSliyGTRGRAjd10wDYBwvQfezd9W8yIQWdyebbRaz
	 rXcaTyX7XGKMf2GYMIu85LKqrdUPXVkTB9bsTfeClPWe99wYhtQFoisPZxWIDlx85yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4usiko/rGMtvGcJB0ILyM0OGjPA+Pb/0CeoJzO3ucY=;
	b=LEsmecTp4Izw7uLPTOQLcNRoslKrxA4uMqG4SsQHiFWa0HctlbJIcETJs2+fWV5c1wle
	 q+jlvUri0N8KgdfZxoXgME+F+dLm4rvFFJc7oR6ofGvAmBQL3RGcGFvvpErXXEMYcPeC/
	 AoRavmWs5Lln79MLp9rexHkylLZDqHH+LBR7XHgt/Tz7ht/PZlwvkwJ0C53RsPP6Epk9C
	 l+MKI3ne5d1La2fQOU+CHeUOIrbX+uOboEeB6qGmt1TeqrZ9sRtdvMpKbs91MteO6tqr7
	 teSRnSgoMDbeD/LYwfFyqL6AED1MWFyo539Eaze2o/nsc9Ywo3LixoJIvVikdn0DXfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=023ldW52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D58606A320;
	Wed, 18 Nov 2026 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=023ldW52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA451F000C4;
	Wed, 18 Nov 2026 15:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016205;
	bh=V4usiko/rGMtvGcJB0ILyM0OGjPA+Pb/0CeoJzO3ucY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=023ldW524HK4qJcWxEINhRdc4XKID3wUn4Zh9C4B18Csj+d1Moes/H3oJ1lfbqDUo
	 a13dGOp6keRe9zolzAQJlSoXeI8qi2aj6CTvboPMR5MosX1ZXB5bU8mmWstbVRE3b8
	 ItebVztmJ9aNoxFEmsC9JmSj8WV3y5mORuyLuEGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0446/2651] clk: sunxi-ng: sun55i-a523-r-ccu: Use P-only clocks for timers
Date: Wed, 18 Nov 2026 15:28:06 +0100
Message-ID: <20261118150303.866403062@linuxfoundation.org>
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



