Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026535;
	b=wk6uQ23QPY5fFd8EfckBryYf0QECWaGNh/r6Ae7KCxTAQeb0XZ6Z04iOzXI0ViojSQBD
	 d6hXFPUqEGcGg3pPcz2mA2SGbRPvibzvMfQ+9HqK6i1BZ4EJQwQTRbviX9aes/QYF8hwz
	 05CpZUCZsUlRayfmaW6PcpvmCN2cUHMJbLujqlVmDsReHkCTt6Z6Vj73aGGI2cBXnQZQf
	 WJwGRZryOhyhb2akR7r941DsHlr9UFHqWh1Wi6RRLI4g2bv6Nr6JPbyK8Hn56vRHVzf1o
	 6AWF1bcuflKEUa/hvxZ8edb0f14+vuME4FizxGq7TKU9F4mQl4cjpW7aA9FcKy95bdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHpQAOPSkhxsFWY1+3kKOu/7Xil87aMdwntFVEgteEA=;
	b=lV9hKR+2P0+Mgwd7/i4PZpQ7WBOeIJT2rpuDT4DEyi16Jfiq3tJWpzp0525JvuxiKF+n
	 GN4xLWYKbKEsUv7WV/2a4Zgy5a/D/8h+Xhhiv0Y+B5lyqUfsdp3joXJhJ36ItKRwAff/V
	 sUTVDWwhhWuphwJRHhvukbkEHEwU3Ow3dUYJEOlf2YZhczJqvTHdLyJHQwNsP7DUmDSxT
	 nhSeng1j4+KGkWS85IAindnM+oE/7gjHV7VH8loBz1Z7a8mzaHvdcn29ks17tBhs6dUGS
	 Hh7VLULTO1HHGlW/FKAjdV/zaySLmSD/thlRBGjhw59hv/VERZT2CpXdth1tAxIUKTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nENuX6Al;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B461C606A31C;
	Wed, 18 Nov 2026 18:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nENuX6Al
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CD81F000C4;
	Wed, 18 Nov 2026 18:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026535;
	bh=nHpQAOPSkhxsFWY1+3kKOu/7Xil87aMdwntFVEgteEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nENuX6AlZbWpnTPbwXdZ5+yDpfdhELOEaYYGjpQzDPRaTeUi+dv8kjGTp+dAqr/kN
	 qqeNE28eKG/MkO7U/S6nQdqJXH41K4SjtFro9iJ3cTu4gzacBN86MJ5Jheme+YEydV
	 NHj0QnPDhld23uXS1dIhKIe8Bai0lEQkAHMkxOio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1428/2151] clk: qcom: rpmhcc: Add LNBB clocks support for Glymur
Date: Wed, 18 Nov 2026 15:52:43 +0100
Message-ID: <20261118150213.963998907@linuxfoundation.org>
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

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 1ebab545ee3acbbee22adecb858d5d1d001de0af ]

Add support for rpmh LN_BB_CLK2 and LN_BB_CLK3 clocks on Qualcomm Glymur
platform.

Fixes: ebcb9db98bda ("clk: qcom: rpmh: Add support for Glymur rpmh clocks")
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-glymur-ufs-clk-changes-v2-1-d0aa1c60c269@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rpmh.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index feeb288479b00..0f148bde109f0 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -391,6 +391,7 @@ DEFINE_CLK_RPMH_VRM(div_clk1, _div2, "divclka1", 2);
 DEFINE_CLK_RPMH_VRM(clk3, _a1_e0, "C3A_E0", 1);
 DEFINE_CLK_RPMH_VRM(clk4, _a1_e0, "C4A_E0", 1);
 DEFINE_CLK_RPMH_VRM(clk5, _a1_e0, "C5A_E0", 1);
+DEFINE_CLK_RPMH_VRM(clk7, _a1_e0, "C7A_E0", 1);
 DEFINE_CLK_RPMH_VRM(clk8, _a1_e0, "C8A_E0", 1);
 
 DEFINE_CLK_RPMH_BCM(ce, "CE0");
@@ -888,6 +889,10 @@ static struct clk_hw *glymur_rpmh_clocks[] = {
 	[RPMH_RF_CLK4_A]	= &clk_rpmh_clk4_a1_e0_ao.hw,
 	[RPMH_RF_CLK5]		= &clk_rpmh_clk5_a1_e0.hw,
 	[RPMH_RF_CLK5_A]	= &clk_rpmh_clk5_a1_e0_ao.hw,
+	[RPMH_LN_BB_CLK2]	= &clk_rpmh_clk7_a1_e0.hw,
+	[RPMH_LN_BB_CLK2_A]	= &clk_rpmh_clk7_a1_e0_ao.hw,
+	[RPMH_LN_BB_CLK3]	= &clk_rpmh_clk8_a1_e0.hw,
+	[RPMH_LN_BB_CLK3_A]	= &clk_rpmh_clk8_a1_e0_ao.hw,
 };
 
 static const struct clk_rpmh_desc clk_rpmh_glymur = {
-- 
2.53.0



