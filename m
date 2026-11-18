Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023620;
	b=le7Kvp2SSc/Mk4aEuzG4xBJ7z9p9OvOw1bBaSqYdVqy8Q9JQ1+dXOCYeQK/Z6PZA+nTQ
	 /nJW8Fbipj6F4nSGyDW3UOo6BAUgJuovSJi9SHVg0UDz71vgePr0bT7/pTCdJXAsVc7WD
	 jiowlUR3c6zWBgh5HALQUdX6aZtCM9cg5Qd49X7uBYiR5JzYWVXDVDZEyta2i0erzDOov
	 2nz5wH9yfkEKBUUqqXMbvz6S/O5ZaCtdlnVEko0xWoVOFenJthwTv4Bg1rxZOw+niotSY
	 ASlxXQYUvBzpcxwrGSOEM3NYItv+vG46Jgnfkkq3oDJ7eZT7dDROzMVh0MbmhTt3Q7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WSR4Zob0CdAb63E69GOn07leErQ8FGeG/fQPrhr00fQ=;
	b=LhXlAiWSH+TPc5Ak4Yzj1mPz/2x7IdCvR/O5zJ6JnFMFhflMWZpjX8nzGC8bZwgrmVGR
	 seUgrWc/qk4aM2MuhCWKtJLBsJP0MDdSMT753mPaO5+8wF1IFOvCktlGvWCDni/c7PrWm
	 SYH0SFVl6k8BKk1XbQpJAmyCJZXN66Q+9UNd2g8CEMRxXDbxvbR4kpjkJoA+ufqih8v8F
	 kjIkgoVuO0nGXB8hdXd6MGrwDPLYX+kkY6ie0be/yZ0owJnxF/cb/K0ENEHzWIcDEvdo+
	 ORIKz+X6PkwFAm4ZUDeyIZDn7pBqONFJGOjGRLTWeDjdha1akca5IFpLPV+/Bp0cS5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uS8L4E0+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5154C606A320;
	Wed, 18 Nov 2026 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uS8L4E0+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29331F000C4;
	Wed, 18 Nov 2026 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023620;
	bh=WSR4Zob0CdAb63E69GOn07leErQ8FGeG/fQPrhr00fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uS8L4E0+lCmo94Ryx4MuleH8XEHGWwEoxWk4Orq00DORxM0gpcc7EyfGO07RiKb4L
	 /GI5IQ25KC7Pqo6Ls59SgFUxwOC6yb7M/YZNKZDCaGKncIsYZtmOXPHstV8p4aYfhB
	 jzu1MYu91oV4OlB8X+xSmJydkKNCeNMt9/1SeTpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0427/2151] clk: sunxi-ng: sun55i-a523-ccu: Use P-only clocks for high-speed timers
Date: Wed, 18 Nov 2026 15:36:02 +0100
Message-ID: <20261118150137.609938737@linuxfoundation.org>
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

[ Upstream commit f2aee33d06d5e1363596ae166459aa4354a8b5ae ]

The high-speed timer clocks only have a P divider, but are currently
modeled as MP clocks with a zero-width M divider.

ccu_mp_set_rate() generates an invalid mask for the zero-width M
divider, clearing unrelated register fields. Model these clocks as
P-only clocks to avoid accessing a nonexistent M divider.

Fixes: 74b0443a0d0a ("clk: sunxi-ng: a523: add system mod clocks")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Link: https://patch.msgid.link/20260906-sunxi-clk-no-p-v1-3-cbde21c9fe69@pigmoral.tech
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun55i-a523.c | 83 +++++++++++---------------
 1 file changed, 36 insertions(+), 47 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun55i-a523.c b/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
index 9bc3ff0ab12d7..0714090cc3b08 100644
--- a/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
+++ b/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
@@ -512,58 +512,47 @@ static const struct clk_parent_data hstimer_parents[] = {
 	{ .fw_name = "losc" },
 	{ .hw = &pll_periph0_200M_clk.hw },
 };
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(hstimer0_clk, "hstimer0",
-				       hstimer_parents, 0x730,
-				       0, 0,	/* M */
-				       0, 3,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(hstimer0_clk, "hstimer0",
+				      hstimer_parents, 0x730,
+				      0, 3,	/* P */
+				      24, 3,	/* mux */
+				      BIT(31),	/* gate */
+				      0);
 
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(hstimer1_clk, "hstimer1",
-				       hstimer_parents,
-				       0x734,
-				       0, 0,	/* M */
-				       0, 3,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(hstimer1_clk, "hstimer1",
+				      hstimer_parents, 0x734,
+				      0, 3,	/* P */
+				      24, 3,	/* mux */
+				      BIT(31),	/* gate */
+				      0);
 
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(hstimer2_clk, "hstimer2",
-				       hstimer_parents,
-				       0x738,
-				       0, 0,	/* M */
-				       0, 3,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(hstimer2_clk, "hstimer2",
+				      hstimer_parents, 0x738,
+				      0, 3,	/* P */
+				      24, 3,	/* mux */
+				      BIT(31),	/* gate */
+				      0);
 
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(hstimer3_clk, "hstimer3",
-				       hstimer_parents,
-				       0x73c,
-				       0, 0,	/* M */
-				       0, 3,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(hstimer3_clk, "hstimer3",
+				      hstimer_parents, 0x73c,
+				      0, 3,	/* P */
+				      24, 3,	/* mux */
+				      BIT(31),	/* gate */
+				      0);
 
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(hstimer4_clk, "hstimer4",
-				       hstimer_parents,
-				       0x740,
-				       0, 0,	/* M */
-				       0, 3,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(hstimer4_clk, "hstimer4",
+				      hstimer_parents, 0x740,
+				      0, 3,	/* P */
+				      24, 3,	/* mux */
+				      BIT(31),	/* gate */
+				      0);
 
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE(hstimer5_clk, "hstimer5",
-				       hstimer_parents,
-				       0x744,
-				       0, 0,	/* M */
-				       0, 3,	/* P */
-				       24, 3,	/* mux */
-				       BIT(31),	/* gate */
-				       0);
+static SUNXI_CCU_P_DATA_WITH_MUX_GATE(hstimer5_clk, "hstimer5",
+				      hstimer_parents, 0x744,
+				      0, 3,	/* P */
+				      24, 3,	/* mux */
+				      BIT(31),	/* gate */
+				      0);
 
 static SUNXI_CCU_GATE_HWS(bus_hstimer_clk, "bus-hstimer", ahb_hws, 0x74c,
 			  BIT(0), 0);
-- 
2.53.0



