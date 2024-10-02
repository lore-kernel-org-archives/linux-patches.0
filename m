Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53418DF60;
	Wed,  2 Oct 2024 13:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876226; cv=none; b=YTtASfSrzYkDzMw1Oeb4df7NcNJTGIc8qiNkIbkaQLCUrmbB5B3gd5XaYXgcefEX+4cx+SG/6qtLGeWRDsSXGDvFpHtn9q64Ut0YcHQ1+R2bex19k4HbCj2WPn8w8LpJRo9ZXistCy4khgWAIMz5MUOoSYZA6SQu/UAvmOiF410=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876226; c=relaxed/simple;
	bh=Ot1WF+FVxFp5Q+ko5ylo042nhC9I3f4J/0bYPSDQ6Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtmOQNbKUkg9x97R44NNEp8rbEn4fLpn9MeyqzOhHv7WQfxS7KU2veTdFtbJVbLvChiDBNIGV3q6SUPPEFoQ59quPEqnkFGJ4PNSvcEOAtfmyrYr+xnORJvJfnIVAteYYUW5XRkkzkVNUyY4ffaJMJAL5ITq5RQZ4fop8oYfr14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZq3yyZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZq3yyZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FA2C4CEC5;
	Wed,  2 Oct 2024 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876226;
	bh=Ot1WF+FVxFp5Q+ko5ylo042nhC9I3f4J/0bYPSDQ6Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZq3yyZog6w1B2+AVeCQCReAWJ2Z5hw6mdVgzRFMzs7rxrICSIQUKTjfeXxI5kiY2
	 AMXzNiMilNZEZZpz23tdZB9aw8iEklcmpMQRKP7fiCaq7UXOM23VZU0X14oyXceKNM
	 2/BR1A9VH+A2JC6t8w/b7A/CXOidsgfOLnqVoqaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 372/695] clk: qcom: ipq5332: Register gcc_qdss_tsctr_clk_src
Date: Wed,  2 Oct 2024 14:56:10 +0200
Message-ID: <20241002125837.308872593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



