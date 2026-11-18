Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016202;
	b=YKsz1FaM/4qPdoIRrMBr+qsaGekWsXM5eim61JL0qZdjNU7ECzSU4vX/hoF+1zZLXu0J
	 Xdt9rU63Px2HmI8qLSgX52tTaEt/sz8q3Iu45vsAQE6WT7ZKv1NvAcc6dJgv6itrwL0VC
	 ecivl2Qa2ErKNE1qEZeUD+v6qt1IdiERGnB3ua5/VJXZyTFtGPVVIS9vgteMgWmdznQx8
	 /iTz0szS4oJHCgnDchhdFEkG7Y/WuYen+geuMYXrvINCR+n1ehQ7Vpf4wXKA+78Z8ZST2
	 XPeV1WipuL+YT6O+8TH+2FR1bXiXZKPRrDnah3W9kEb8s0PZC76VNRmhj8X8Unh6Cig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G6RkvmsDSHTACiGKzsL+u6w4XWlNWH8/8hIKPcsUbvU=;
	b=qFVFFR10uPjoLDt3qSCPNlJNqExLTFnO1IFMS3ZBSBTv51j7mVMOvTN7HuVajAU3P+P9
	 9H+IezeI0vjosU9FbvVVImmEJC4tZNLzzyUS20NiF24YaKVsHo1davvqS4b4mVX9g/H4G
	 6TlD4/BRmBMW2o1icKaD+kgpAkSAKq9tb+W7k4UK/9ppOcTLKN5YhZchYQUaKYBo3kcDQ
	 t1pWGi7akIw0zwMJzxggQ1WT1PrOqVH1m//aXbNLCOZe+x5jPQfRzKq+mFAdvxXFQjvuR
	 9C4rEFXU/6kQUJOvQ6hbtfWqROm7clIOfOfHyRTgcIJQtg8tMSGh+Y0N8zbwOjVglRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUSX0KVJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F640606A31C;
	Wed, 18 Nov 2026 15:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUSX0KVJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A1D1F000C4;
	Wed, 18 Nov 2026 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016202;
	bh=G6RkvmsDSHTACiGKzsL+u6w4XWlNWH8/8hIKPcsUbvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUSX0KVJqYqWVD+KwmYl4AJ/XiP80a4hwCmt/h3WfJesR0HGouZeK0cXWWi1mce7Q
	 XlS4QIfpp5JSYUkMnJoS/nxuXVoPzbnSoE0YEIx/DlOHI2sdlP+IS8DUWklYs8kVCW
	 y0UNFcDky73osQxkPwYgysnHUnRMLWL1p+dAal+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0445/2651] clk: sunxi-ng: sun55i-a523-ccu: Use P-only clocks for high-speed timers
Date: Wed, 18 Nov 2026 15:28:05 +0100
Message-ID: <20261118150303.832108948@linuxfoundation.org>
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



