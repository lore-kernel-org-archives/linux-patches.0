Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249771F940B;
	Tue,  3 Dec 2024 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240418; cv=none; b=T9FgfSTb9ds2MnvcAwhAvaidHzprZhJBNhrZpdHXSDEmHMrsHehVFKfP2uGn5bXrwMIhYSdKa+drhf13gxgKQGMS/MjT00QjojkqDQz9QDJTw+wnIZKFBaCWbr/uqp5tWPD4YJaiICq8eHRYifm8LL+jvbU4CoMJZu+rfqqgLY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240418; c=relaxed/simple;
	bh=/J52so1E6Z1DTDSxgPE9CkRh1OMkBXbLUX0tkgpJArc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMuyvBYbM8gOjP3Qh6AUih3ohq0T64RPLWf47X+Ll4N6mtq4cCKKKBoS4CoF5K5Z0WtbtQkys5Yri5/hjQm/QYbQm3me5wHeJXo/767etKsOCkk+w2Jq0RLpE3XU+CPrRIXN2kWHOHqQ7Y017ODr3aVgsk/xwpq7LVq9VG5gw6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djDy13nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djDy13nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1A3C4CED6;
	Tue,  3 Dec 2024 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240418;
	bh=/J52so1E6Z1DTDSxgPE9CkRh1OMkBXbLUX0tkgpJArc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djDy13nlE84b1L1xZYVIUw8kSOfFAoN7vPQl3lGKZmRBKHkqVVgu2Z//JbBc/6Crj
	 yi+BhAc+rcfE0WfOU/n2bqLE8dcg4ABcGTj6mPz6mRHqIMceq6Y2/EPLRTdgEs88co
	 kXE+YjhUWkzW+VBonRI5rIoSFeziPsKK7UcLPudU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/826] arm64: dts: qcom: x1e80100: Resize GIC Redistributor register region
Date: Tue,  3 Dec 2024 15:37:35 +0100
Message-ID: <20241203144748.733790121@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 9ed1a2b8784262e85ec300792a1a37ebd8473be2 ]

Resize the GICR register region as it currently seeps into the CPU Control
Processor mailbox RX region.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Link: https://lore.kernel.org/r/20240612124056.39230-4-quic_sibis@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 0510abc0edf0f..a073336ca0bed 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -5752,7 +5752,7 @@ apps_smmu: iommu@15000000 {
 		intc: interrupt-controller@17000000 {
 			compatible = "arm,gic-v3";
 			reg = <0 0x17000000 0 0x10000>,     /* GICD */
-			      <0 0x17080000 0 0x480000>;    /* GICR * 12 */
+			      <0 0x17080000 0 0x300000>;    /* GICR * 12 */
 
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 
-- 
2.43.0



