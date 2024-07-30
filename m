Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3818454A;
	Tue, 30 Jul 2024 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355538; cv=none; b=eikGQQ3/OIAClDEl/xxawOLsOZr1yHbiPrwm91KbxYLJP/4WOOT23bF7C62mKDMFS+bowIQ3Hv39g+LufpdzdFeai13IC9RSKRSBn3zCAny1fBgn0EgNRU7/WeDLVkneJktEQmQQ6h9yyuP7dw3Y+7tVl+Lh31wDDJGd9bw+Wks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355538; c=relaxed/simple;
	bh=mfYnIeMms952HXl1yC5JXYYvRd+NMbrfi8VSIf8Ft90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V66jpzMGpa7BRGHrFjYSboLy+FOoZqxK+5TV2tsUUqvlsjW+qc/DXteGbKWd8GJNK4iPkFo9VFtA9BgDn6ubMBeebwHPvobR92kQuRvtP3hPgeeYRp3nmmEkDu0mEy9OcI30gkfbkXSUi3OTBb24Um/3Dn7zNCo7zPNTSQ+n7pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYxz7uxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYxz7uxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD40C32782;
	Tue, 30 Jul 2024 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355538;
	bh=mfYnIeMms952HXl1yC5JXYYvRd+NMbrfi8VSIf8Ft90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYxz7uxDC1yUHyAMaOSLvWhUidrEog/MzNAOFrRbze6BsL8z3zhkpL6XUrgEQP3na
	 EMecUvHTu+eYQtPek+4pMouyjrgcvkBKCFLIRcUJ8QB5B8JI/n73NYXNHpox60FMOI
	 SF2UsM+R0YdDAWRd1ZMjDYBrPatQSUC6nk323AOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 064/809] arm64: dts: qcom: msm8996: specify UFS core_clk frequencies
Date: Tue, 30 Jul 2024 17:39:00 +0200
Message-ID: <20240730151727.172256377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 02f838b7f8cdfb7a96b7f08e7f6716f230bdecba ]

Follow the example of other platforms and specify core_clk frequencies
in the frequency table in addition to the core_clk_src frequencies. The
driver should be setting the leaf frequency instead of some interim
clock freq.

Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240408-msm8996-fix-ufs-v4-1-ee1a28bf8579@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 6e7a4bb08b35c..0717605ac5a0e 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2102,7 +2102,7 @@ ufshc: ufshc@624000 {
 				<&gcc GCC_UFS_RX_SYMBOL_0_CLK>;
 			freq-table-hz =
 				<100000000 200000000>,
-				<0 0>,
+				<100000000 200000000>,
 				<0 0>,
 				<0 0>,
 				<0 0>,
-- 
2.43.0



