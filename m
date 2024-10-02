Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F31719409E;
	Wed,  2 Oct 2024 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879929; cv=none; b=V1mon2ot1fBKT7Xe1/0ER7XdW70Y/Z/IYJF4X+zlNF+tXccQGjKgA0uhPD0XIFBvqVaeARyqUEsMAb15DcadMwWPJPpl+cYl+yfplxY3/msCLgyyXnOEEuJnRvDVPbKgln1r6q4rPLKR2MzDtDDbQR+gWIF/fVT/RHzIZlWmagI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879929; c=relaxed/simple;
	bh=Pw0ugu+Mgjtg70VZ8BuRpU8TOmQNAfYQTUiHO5oexKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfpoorkleTVg5OoqmBBmGckXsNCrWi1kmcBAadpTjjL3VbNN+QUfiSm/AirjvgiRWJ/9SDdjYG1HCnq2fRRkcMIzO/fFPa1d/9ReDujsRAuXfRr6mUV3KJqEFhZWIYmNmsFRXbhOMu8x0RVZTC0qD6lhubI0bAVlcGRZgoIcvRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iuhc2vVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iuhc2vVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98EDC4CEC2;
	Wed,  2 Oct 2024 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879929;
	bh=Pw0ugu+Mgjtg70VZ8BuRpU8TOmQNAfYQTUiHO5oexKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iuhc2vVnf9XOTuaYVslcK/JyAcyH2QIgD3UDPvVPOR2wFctOsrTXRGO+22TF8Jh7B
	 fiUmuJeBb9xKQtDrcKGb7JwrrzQ0yMAhFDcrDwvRQPm1SOfVvgxR/pvPWL3fYje4AQ
	 VhWmp8I8QCVO7tgPrif0HtitPn/pZotYCcs4lsiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/538] clk: qcom: ipq5332: Register gcc_qdss_tsctr_clk_src
Date: Wed,  2 Oct 2024 14:58:45 +0200
Message-ID: <20241002125803.545085899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varadarajan Narayanan <quic_varada@quicinc.com>

[ Upstream commit 0e1ac23dfa3f635e486fdeb08206b981cb0a2a6b ]

gcc_qdss_tsctr_clk_src (enabled in the boot loaders and dependent
on gpll4_main) was not registered as one of the ipq5332 clocks.
Hence clk_disable_unused() disabled 'gpll4_main' assuming there
were no consumers for 'gpll4_main' resulting in system freeze or
reboots.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 3d89d52970fd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5332 SoC")
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://lore.kernel.org/r/20240730054817.1915652-4-quic_varada@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5332.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5332.c b/drivers/clk/qcom/gcc-ipq5332.c
index f98591148a976..6a4877d888294 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -3388,6 +3388,7 @@ static struct clk_regmap *gcc_ipq5332_clocks[] = {
 	[GCC_QDSS_DAP_DIV_CLK_SRC] = &gcc_qdss_dap_div_clk_src.clkr,
 	[GCC_QDSS_ETR_USB_CLK] = &gcc_qdss_etr_usb_clk.clkr,
 	[GCC_QDSS_EUD_AT_CLK] = &gcc_qdss_eud_at_clk.clkr,
+	[GCC_QDSS_TSCTR_CLK_SRC] = &gcc_qdss_tsctr_clk_src.clkr,
 	[GCC_QPIC_AHB_CLK] = &gcc_qpic_ahb_clk.clkr,
 	[GCC_QPIC_CLK] = &gcc_qpic_clk.clkr,
 	[GCC_QPIC_IO_MACRO_CLK] = &gcc_qpic_io_macro_clk.clkr,
-- 
2.43.0



