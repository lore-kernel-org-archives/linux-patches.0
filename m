Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019857;
	b=LQ7s8tBdFgr+J7asNzQx3MGRsgeUhrGrMrqtZNNQPKewRHcUI2a+HCHPsqdvTCY9uQgW
	 u+gUfM1loJQDQPaZZYDvPC/2grnYU2mO+/zCrALUWMmt8L++MQXzF7M0OtxEnaaH9uyqZ
	 bhfOX+XUXoR1JFWePkdjeftUnl148KxpEIPfH8A6oZ29xDoccsCK4NhffybIxk3atKal7
	 RFCEXnSqYFd4QuhQUFQu/yEVvW0WYY7KPjYMva1KfWwf25K2EqAzPs5XSHZ1GzpaoUCpQ
	 EvEtm81mWw7tXpwhlkH2DeWuVJD6HjY4uf0x6VXVgcrvRZgD1O7hwrCysDxMvt2JohQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ScOadTgcZcY3EXK/uHLv0yTA8z08yF57DPv4OV8lGwg=;
	b=Gn3tHC1/g4u86HIyV/fYJ5Y/sf8oVM/i80xvFfvzPnhyh7gWhuR8NlenVfIhndVJObJC
	 MjXxV3KeeED9y1p4eCPwFwuhwPlbY32VI0McLGu4gmoZ3TVkhThkdLulR1m6N1LT8Epwi
	 F709vL6/nrb7T0fHcPWby7ZQeMsLLTVb5uWDSH9LxYl3dmr9esuNUxjdlarcOehn6eWFm
	 blEZQ6WKX8vVzQlF890nwAzomycLVIe6kXV7Rv6jt+8lf7inmAWAF7CbMTGf6UHTXqh83
	 athJs3SM9ym7k6nEvVMPzLY3IfeyDiI4g/tJsNzuBI6OccBT9GpSeTOfIHULwDD8Wpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHq4nVsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEF860A260C;
	Wed, 18 Nov 2026 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHq4nVsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E1B1F000C4;
	Wed, 18 Nov 2026 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019856;
	bh=ScOadTgcZcY3EXK/uHLv0yTA8z08yF57DPv4OV8lGwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHq4nVsfxw1J1IKhrNRuMz/hwEIqadJPlWu0RQ0X6P0py0nC1gsdHW3sfziY9H5Te
	 dg+TfacfaiPnW/75npTZ6vpCGU+PKLWSm+utiDzupJwS9x74R4ayWyU9mjPIo4rJe/
	 jQngliAX28I+BIY5WXczoucDr8hf0X+G1jv21IUo=
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
Subject: [PATCH 7.3 1743/2651] clk: qcom: rpmhcc: Add LNBB clocks support for Glymur
Date: Wed, 18 Nov 2026 15:49:43 +0100
Message-ID: <20261118150350.304784086@linuxfoundation.org>
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
index a224a94ae2733..88e872e58f641 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -393,6 +393,7 @@ DEFINE_CLK_RPMH_VRM(clk2, _a1_e0, "C2A_E0", 1);
 DEFINE_CLK_RPMH_VRM(clk3, _a1_e0, "C3A_E0", 1);
 DEFINE_CLK_RPMH_VRM(clk4, _a1_e0, "C4A_E0", 1);
 DEFINE_CLK_RPMH_VRM(clk5, _a1_e0, "C5A_E0", 1);
+DEFINE_CLK_RPMH_VRM(clk7, _a1_e0, "C7A_E0", 1);
 DEFINE_CLK_RPMH_VRM(clk8, _a1_e0, "C8A_E0", 1);
 
 DEFINE_CLK_RPMH_VRM(clk3, _a2_e0, "C3A_E0", 2);
@@ -902,6 +903,10 @@ static struct clk_hw *glymur_rpmh_clocks[] = {
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



