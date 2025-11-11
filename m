Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF0632BF46;
	Tue, 11 Nov 2025 01:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824528; cv=none; b=ZDTqtpkb0Fe626r8lCeQzjcYjdjvd4MckF2Ja/sEEZ8uhzbjPSgHWEi4cDk4UQjwkpfGBPmIV1UKxpPqbZpMB+OO4Py99ETxY5IKpLkK+eWdZpYaVv5YjKm7vY5gNCWnzTi04/7ta9SOQ6s/kXoY9t/CdhtauaDugUxD/TW8p5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824528; c=relaxed/simple;
	bh=TqlPQlwoV5qt/5sq0b7YRA3hi+m6rzFiiWB7pmczQs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SXySAziMPnemfKhdvZJDAatyNTETvJBXIY1tPT9r1I7gLh/BqCpc5Fu6DJQF8LRoy8Ip+Xvu491RXWBunYaxla4krnFXEqPT7QyQaDi46o54MhPbFiVhwiptvhTRV2lsSV4ADmFTkH62joKapX0oE2bpHfK8SYlzgnnYYg/zD5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxIRyrjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxIRyrjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886D3C16AAE;
	Tue, 11 Nov 2025 01:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824527;
	bh=TqlPQlwoV5qt/5sq0b7YRA3hi+m6rzFiiWB7pmczQs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxIRyrjkw9Ltrq2sDBV25YCYNnlGLwGKyfpu7ZD4E8bWy2vPg4Mzw+8fXtI1xN0hI
	 fYVWeaedSVzaYGse4hocpM6G0iWffo6jtUjNrocRUbN2tc6y37w+qweYBE8DVyhIF8
	 SxFgwFioi+1nCKYsbnbRs4fT3MmBVyYnO+BAbRE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marko=20M=C3=A4kel=C3=A4?= <marko.makela@iki.fi>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 463/565] clk: qcom: gcc-ipq6018: rework nss_port5 clock to multiple conf
Date: Tue, 11 Nov 2025 09:45:19 +0900
Message-ID: <20251111004537.316726975@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marko Mäkelä <marko.makela@iki.fi>

[ Upstream commit 2f7b168323c22faafb1fbf94ef93b7ce5efc15c6 ]

Rework nss_port5 to use the new multiple configuration implementation
and correctly fix the clocks for this port under some corner case.

In OpenWrt, this patch avoids intermittent dmesg errors of the form
nss_port5_rx_clk_src: rcg didn't update its configuration.

This is a mechanical, straightforward port of
commit e88f03230dc07aa3293b6aeb078bd27370bb2594
("clk: qcom: gcc-ipq8074: rework nss_port5/6 clock to multiple conf")
to gcc-ipq6018, with two conflicts resolved: different frequency of the
P_XO clock source, and only 5 Ethernet ports.

This was originally developed by JiaY-shi <shi05275@163.com>.

Link: https://lore.kernel.org/all/20231220221724.3822-4-ansuelsmth@gmail.com/
Signed-off-by: Marko Mäkelä <marko.makela@iki.fi>
Tested-by: Marko Mäkelä <marko.makela@iki.fi>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250802095546.295448-1-marko.makela@iki.fi
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq6018.c | 60 +++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq6018.c b/drivers/clk/qcom/gcc-ipq6018.c
index ab0f7fc665a97..c04a7a961a24a 100644
--- a/drivers/clk/qcom/gcc-ipq6018.c
+++ b/drivers/clk/qcom/gcc-ipq6018.c
@@ -511,15 +511,23 @@ static struct clk_rcg2 apss_ahb_clk_src = {
 	},
 };
 
-static const struct freq_tbl ftbl_nss_port5_rx_clk_src[] = {
-	F(24000000, P_XO, 1, 0, 0),
-	F(25000000, P_UNIPHY1_RX, 12.5, 0, 0),
-	F(25000000, P_UNIPHY0_RX, 5, 0, 0),
-	F(78125000, P_UNIPHY1_RX, 4, 0, 0),
-	F(125000000, P_UNIPHY1_RX, 2.5, 0, 0),
-	F(125000000, P_UNIPHY0_RX, 1, 0, 0),
-	F(156250000, P_UNIPHY1_RX, 2, 0, 0),
-	F(312500000, P_UNIPHY1_RX, 1, 0, 0),
+static const struct freq_conf ftbl_nss_port5_rx_clk_src_25[] = {
+	C(P_UNIPHY1_RX, 12.5, 0, 0),
+	C(P_UNIPHY0_RX, 5, 0, 0),
+};
+
+static const struct freq_conf ftbl_nss_port5_rx_clk_src_125[] = {
+	C(P_UNIPHY1_RX, 2.5, 0, 0),
+	C(P_UNIPHY0_RX, 1, 0, 0),
+};
+
+static const struct freq_multi_tbl ftbl_nss_port5_rx_clk_src[] = {
+	FMS(24000000, P_XO, 1, 0, 0),
+	FM(25000000, ftbl_nss_port5_rx_clk_src_25),
+	FMS(78125000, P_UNIPHY1_RX, 4, 0, 0),
+	FM(125000000, ftbl_nss_port5_rx_clk_src_125),
+	FMS(156250000, P_UNIPHY1_RX, 2, 0, 0),
+	FMS(312500000, P_UNIPHY1_RX, 1, 0, 0),
 	{ }
 };
 
@@ -547,26 +555,34 @@ gcc_xo_uniphy0_rx_tx_uniphy1_rx_tx_ubi32_bias_map[] = {
 
 static struct clk_rcg2 nss_port5_rx_clk_src = {
 	.cmd_rcgr = 0x68060,
-	.freq_tbl = ftbl_nss_port5_rx_clk_src,
+	.freq_multi_tbl = ftbl_nss_port5_rx_clk_src,
 	.hid_width = 5,
 	.parent_map = gcc_xo_uniphy0_rx_tx_uniphy1_rx_tx_ubi32_bias_map,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "nss_port5_rx_clk_src",
 		.parent_data = gcc_xo_uniphy0_rx_tx_uniphy1_rx_tx_ubi32_bias,
 		.num_parents = 7,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_fm_ops,
 	},
 };
 
-static const struct freq_tbl ftbl_nss_port5_tx_clk_src[] = {
-	F(24000000, P_XO, 1, 0, 0),
-	F(25000000, P_UNIPHY1_TX, 12.5, 0, 0),
-	F(25000000, P_UNIPHY0_TX, 5, 0, 0),
-	F(78125000, P_UNIPHY1_TX, 4, 0, 0),
-	F(125000000, P_UNIPHY1_TX, 2.5, 0, 0),
-	F(125000000, P_UNIPHY0_TX, 1, 0, 0),
-	F(156250000, P_UNIPHY1_TX, 2, 0, 0),
-	F(312500000, P_UNIPHY1_TX, 1, 0, 0),
+static const struct freq_conf ftbl_nss_port5_tx_clk_src_25[] = {
+	C(P_UNIPHY1_TX, 12.5, 0, 0),
+	C(P_UNIPHY0_TX, 5, 0, 0),
+};
+
+static const struct freq_conf ftbl_nss_port5_tx_clk_src_125[] = {
+	C(P_UNIPHY1_TX, 2.5, 0, 0),
+	C(P_UNIPHY0_TX, 1, 0, 0),
+};
+
+static const struct freq_multi_tbl ftbl_nss_port5_tx_clk_src[] = {
+	FMS(24000000, P_XO, 1, 0, 0),
+	FM(25000000, ftbl_nss_port5_tx_clk_src_25),
+	FMS(78125000, P_UNIPHY1_TX, 4, 0, 0),
+	FM(125000000, ftbl_nss_port5_tx_clk_src_125),
+	FMS(156250000, P_UNIPHY1_TX, 2, 0, 0),
+	FMS(312500000, P_UNIPHY1_TX, 1, 0, 0),
 	{ }
 };
 
@@ -594,14 +610,14 @@ gcc_xo_uniphy0_tx_rx_uniphy1_tx_rx_ubi32_bias_map[] = {
 
 static struct clk_rcg2 nss_port5_tx_clk_src = {
 	.cmd_rcgr = 0x68068,
-	.freq_tbl = ftbl_nss_port5_tx_clk_src,
+	.freq_multi_tbl = ftbl_nss_port5_tx_clk_src,
 	.hid_width = 5,
 	.parent_map = gcc_xo_uniphy0_tx_rx_uniphy1_tx_rx_ubi32_bias_map,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "nss_port5_tx_clk_src",
 		.parent_data = gcc_xo_uniphy0_tx_rx_uniphy1_tx_rx_ubi32_bias,
 		.num_parents = 7,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_fm_ops,
 	},
 };
 
-- 
2.51.0



