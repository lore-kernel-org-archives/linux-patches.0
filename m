Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEF134AB09;
	Tue, 16 Dec 2025 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885215; cv=none; b=BAwvsuksi0e663nTkMMRJSgMn7ejjuH3MLV/ejjv2XK0FUYeGmDjl4Rwtay/RnYg25U+YLHHw/evuSr6irsKZfv4Kvis6Gtf8xZIcH9dR3JNII036uMQd7gfQY12v2fpAYZcyltC2s5Up2Mn+VHZWvcKk7myyPYnYrK0F+EnXxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885215; c=relaxed/simple;
	bh=Dh09wL02e+KHuR8fDeUz5l/IM3JlyQWM68QP6CRiVsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdW/t6o+LG3fS18HSkKgTSCh/Z2qs09zO4XmemTz/6SXcw/gWm7+kDal/pHaqEByv77AAVkxj3ijOzyvEQ2tphkS14I4vLuCyXRF0jcLjFNBIb6zq0jGIImTEOG+78JdCtwb4L6jdX9xbCynKmGwIGPxm0eKN4eUonyw/pr5qaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyNiiXcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyNiiXcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC9EC4CEF1;
	Tue, 16 Dec 2025 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885215;
	bh=Dh09wL02e+KHuR8fDeUz5l/IM3JlyQWM68QP6CRiVsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyNiiXcq1wLAYpog5wpknA6ItZ/NJ2WW3q7tS0r4qQ3WWL6ykt+oGti/iYuIXWw4T
	 00C/UesOhFjmZufQXgzwCvc64SvFIyrHZoJsMlErgPoVr6jSTNOJkl3GNAVlmx7WxG
	 z/SxaKA5BWNIdalZUbnTmxGNt3sQePQJ9zTjQTMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 073/507] clk: qcom: rpmh: Define RPMH_IPA_CLK on QCS615
Date: Tue, 16 Dec 2025 12:08:34 +0100
Message-ID: <20251216111348.187774083@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1496fb3de4be8..8aad1676d8da8 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -850,6 +850,7 @@ static struct clk_hw *qcs615_rpmh_clocks[] = {
 	[RPMH_RF_CLK1_A]	= &clk_rpmh_rf_clk1_a_ao.hw,
 	[RPMH_RF_CLK2]		= &clk_rpmh_rf_clk2_a.hw,
 	[RPMH_RF_CLK2_A]	= &clk_rpmh_rf_clk2_a_ao.hw,
+	[RPMH_IPA_CLK]		= &clk_rpmh_ipa.hw,
 };
 
 static const struct clk_rpmh_desc clk_rpmh_qcs615 = {
-- 
2.51.0



