Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231353EA9A;
	Wed,  7 Aug 2024 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043235; cv=none; b=RhQoDNRA3porCBYfs11VcjRBffdC4M7K3cmAwCcOu3jy0YHdCeTVCf59OBSVPpVFAoUGqF8x3vz0G+MJqQbwnogQt3QLjeiAnFG8keH9fgdUpXz4qSj9iwhDVPzxXs7MJo+QMy2F3x6AG4NaFrTXIgla7oA/ypoSqQpdgRH34r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043235; c=relaxed/simple;
	bh=tB2yq5Js/DKH/gHtvqeDgYSZ5eaWdQzNTOnFitxfvmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDPr9KKY743Fw+bqmoAu7yzhE26LXYJ4PnKSzN/V8SK23xEh6gHbIShFZQPHjdCzod2p7VR4wlMSJq4cv5vHCRLqxz3H+p3xLJOCpykWcMsxTx8y5VfYIJAv+2QenJsFYLDkdfm/E9Gt4bQA3wOZqRvVrZzPWL+4qOiOaUZ9sFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnIJXMmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnIJXMmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F62C32781;
	Wed,  7 Aug 2024 15:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043235;
	bh=tB2yq5Js/DKH/gHtvqeDgYSZ5eaWdQzNTOnFitxfvmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnIJXMmMc+9MDsz+gnw9zDsnrlOwqnK21IDNiUHPr9wvtLzLeTDc/9IMApEMNxemZ
	 0IrkyUuXsZ98bo5aS6lMRZmA+hyOBzXRdQmhcg1gXzFXoZRNbafq7fmxUf/xeYksTF
	 RqO9RbsYQZPpWbxrK1acqT8+8qKxhUmPO0XTdfpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@google.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/121] arm64: dts: qcom: sc7180: Disable SuperSpeed instances in park mode
Date: Wed,  7 Aug 2024 16:58:54 +0200
Message-ID: <20240807150019.487194587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Krishna Kurapati <quic_kriskura@quicinc.com>

[ Upstream commit 5b8baed4b88132c12010ce6ca1b56f00d122e376 ]

On SC7180, in host mode, it is observed that stressing out controller
results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instances in park mode for SC7180 to mitigate this issue.

Reported-by: Doug Anderson <dianders@google.com>
Cc: stable@vger.kernel.org
Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240604060659.1449278-2-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 18ef8fb5c8c7a..68b1c017a9fd5 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2981,6 +2981,7 @@ usb_1_dwc3: usb@a600000 {
 				iommus = <&apps_smmu 0x540 0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 				maximum-speed = "super-speed";
-- 
2.43.0



