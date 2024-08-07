Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7592585283;
	Wed,  7 Aug 2024 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043240; cv=none; b=L4rQDywMWYcLyOQO3vA+3FZUGfhGO7IO0JmEuJ2qTWgHRZCiggI8AbB+3Jn0pXCZ12A7JgG+LcMc5Y4QcR26dYYht5WsQppvdFo6lULVgG6OqzRRZs+BkmTzE1iiEqkaRVVroFkEevAottoGfNATy87su1mH7NCUVrnqFC/lnDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043240; c=relaxed/simple;
	bh=/0Lyhze7JnFfSfh0mw7/a92YKASoyxlQppj+T/q/FMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWapmEFtrWqAyuAFBBpWzTu9mESMKs5JfB2U3cS5MRN1rWNbwSaEcgdLaNgsmB38f/LuO856R1of9gQIOzU0uZGiiSWBYRXh6NiJNwJymUD1fzkoUasQdJG98NG3E+OjWXQ3wZeWSI61basZ0ByYGJzcSfic36khkX9XX4dlNtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+wqG+/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+wqG+/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DBAC4AF0B;
	Wed,  7 Aug 2024 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043240;
	bh=/0Lyhze7JnFfSfh0mw7/a92YKASoyxlQppj+T/q/FMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+wqG+/PkjZL0PjkgQ8VVQumsHA0MA8MmR/cANeyOgYuMHOWSPi0qg1I4IXo3nRad
	 rE9FTe8sibM6xlMTFe9yjfVbaK7ehaPDuwpgQ5yryMxmPdk8cJCYpmyJMoU/BEtkJ1
	 PTGjm76ur9QxyuYpuVOsYERZYy3GXHb7qHvMj40Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@google.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/121] arm64: dts: qcom: sc7280: Disable SuperSpeed instances in park mode
Date: Wed,  7 Aug 2024 16:58:56 +0200
Message-ID: <20240807150019.540249619@linuxfoundation.org>
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

[ Upstream commit 3d930f1750ce30a6c36dbc71f8ff7e20322b94d7 ]

On SC7280, in host mode, it is observed that stressing out controller
results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instances in park mode for SC7280 to mitigate this issue.

Reported-by: Doug Anderson <dianders@google.com>
Cc: stable@vger.kernel.org
Fixes: bb9efa59c665 ("arm64: dts: qcom: sc7280: Add USB related nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240604060659.1449278-3-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index dd1d9d10c6615..149c7962f2cbb 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3680,6 +3680,7 @@ usb_1_dwc3: usb@a600000 {
 				iommus = <&apps_smmu 0xe0 0x0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 				maximum-speed = "super-speed";
-- 
2.43.0



