Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076D2364029;
	Tue, 16 Dec 2025 12:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886949; cv=none; b=TLAUP2XKYPdxwj9NBOfF6Vy9tmggaF/3azEgi43Ti8JIDsKQPro8pdNap69WWVuzlfEOtu7H0sR0LL+AOz+9IieuPBmy8GBbQ5093MUmte1qnYnLiBUgiE98lXBPUF2zilA4ak3FdutKw/veI4Anr6NUcwMNZkrnNQsGDGupDu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886949; c=relaxed/simple;
	bh=pBDeB3U5a71skskJyRpd49Bt0tAlUcRWRL+wi2KT688=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kfa/MS6sJsPFCZa0S0d1+Nlu0VNF9TLkFOr80GfJW3F1adBsRbsDMm/5POKXWSG3Jp8jNCEUkO8Smsojo3gFaper88VPXtDydfKk+zCKcpLatHSf/O8UP+sINwHs+boDCayxVw4Yh4imYE4zcHfMLv6ep6Ew7bmYs66YjpfmGeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYTwkq2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYTwkq2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BC4C4CEF1;
	Tue, 16 Dec 2025 12:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886948;
	bh=pBDeB3U5a71skskJyRpd49Bt0tAlUcRWRL+wi2KT688=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYTwkq2lMffIw/sqg7ovpBDctsh6b8aVP2k4X29BNEJPeV01MUlRQVjlbEvFtsARy
	 kK1LIPGUbn3x5A3XhIvB4JHc81M30fAZvyT/FL0Qd3TqBquV6DiizM5YgMxH1aMaUz
	 JmtsxRgQj1q1+x7V8h4TDF2S5qbH3LHkCk4kMRQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/614] clk: qcom: rpmh: Define RPMH_IPA_CLK on QCS615
Date: Tue, 16 Dec 2025 12:07:28 +0100
Message-ID: <20251216111404.251529265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 17e4db05930e455770b15b77708a07681ed24efc ]

This was previously (mis)represented in the interconnect driver, move
the resource under the clk-rpmh driver control, just like we did for
all platforms in the past, see e.g. Commit aa055bf158cd ("clk: qcom:
rpmh: define IPA clocks where required")

Fixes: 42a1905a10d6 ("clk: qcom: rpmhcc: Add support for QCS615 Clocks")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250627-topic-qcs615_icc_ipa-v1-4-dc47596cde69@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rpmh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index 63c38cb47bc45..1a98b3a0c528c 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -855,6 +855,7 @@ static struct clk_hw *qcs615_rpmh_clocks[] = {
 	[RPMH_RF_CLK1_A]	= &clk_rpmh_rf_clk1_a_ao.hw,
 	[RPMH_RF_CLK2]		= &clk_rpmh_rf_clk2_a.hw,
 	[RPMH_RF_CLK2_A]	= &clk_rpmh_rf_clk2_a_ao.hw,
+	[RPMH_IPA_CLK]		= &clk_rpmh_ipa.hw,
 };
 
 static const struct clk_rpmh_desc clk_rpmh_qcs615 = {
-- 
2.51.0



