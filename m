Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3EA7D3E4;
	Wed,  7 Aug 2024 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043245; cv=none; b=kejM+jXQV08VInnlNATJeUgAwMyhhi2k71xzczFK47V9bVO5zXTB0MvAVcllpm1Qf4gLCFJLXxDjYzHZFSuKDL1vR3FbilViIyOFRpbA0VGm4oQadX0/J5ZFfRqll8QPwNpSzVNzRRHDMr3FPTmw4yzztfaStTCJQiogxeANsZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043245; c=relaxed/simple;
	bh=heTJfN2CNzgVyTkSI3MB73GhnZVpt186PVtLsCBa6SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4c6xjYQUPWtDaBoxzO9APld7dQcRtKxJyJR0iW9ulMot+alElyRLf0Om0NtF4pYiIxJpLp4rj432Hvms1Emj21TXLLnPmb3f8qWVkLB9+n/6xmqkgClYzhdGCgYesKYN5JyWAjn1yOTv3FeNCVaLMbPFm3OroVctlydfPE73Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzT/tImT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzT/tImT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8BCC32781;
	Wed,  7 Aug 2024 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043245;
	bh=heTJfN2CNzgVyTkSI3MB73GhnZVpt186PVtLsCBa6SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzT/tImTXfXr0qndCxqxIMv1Ys5LMf2s+Q9Qp/TAOqCA9IpsTXNc5jxeS9/hE9o0L
	 SrdpXZ0RulV299g9P7JOiEdXxVVW6l1iqQVqjfaBkcwNZa1FKlfELgHgmk8djsQBYA
	 EFndoQ484ka4eMBRjoBLK3SEi0nX/iMqMGXu1cMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/121] arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB
Date: Wed,  7 Aug 2024 16:58:58 +0200
Message-ID: <20240807150019.599447206@linuxfoundation.org>
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

[ Upstream commit 0046325ae52079b46da13a7f84dd7b2a6f7c38f8 ]

For Gen-1 targets like MSM8998, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for MSM8998 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 026dad8f5873 ("arm64: dts: qcom: msm8998: Add USB-related nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-4-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index d49764eeab9c9..7fcc15b6946ae 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2159,6 +2159,7 @@ usb3_dwc3: usb@a800000 {
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&qusb2phy>, <&usb3phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;
-- 
2.43.0



