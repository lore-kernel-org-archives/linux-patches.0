Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD5C374CC;
	Wed,  7 Aug 2024 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043572; cv=none; b=Xu66gtxLnSvf83cg9SiAbIqV3Sk5HmFwJK/s9zbuObtMUS0MJA6WqgzZSdpy8DIU1O3yOmGaN/mhRCe8N3T/Oah5I7Vr/odeM4QD4z0awR3tfREV1AaPol21gJZHt2Vqv/0/Pg+mtl7nqZLmKL99SyNQgP/va/U4fnd1jZuL9ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043572; c=relaxed/simple;
	bh=jAb3dHpw6rZgjh0x3tvfS80p2qsknEjhIHbhKDiScSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/cGZMH/JAdYduLZVdIxeIvxtTYNtOCfAf60Th0HBU1lB3/vvNCoXFNdXVsAblGfZoj0tUZS3eiPRU35/YL4K/V5zLWlIXrfZvART+/an1YZpH+THLnqiZihheq6JLGOlkWPTFc64M6MViSSU5urdO/N1fHdrCSayPciYfaEkEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdTBsz5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdTBsz5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5FBC32781;
	Wed,  7 Aug 2024 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043572;
	bh=jAb3dHpw6rZgjh0x3tvfS80p2qsknEjhIHbhKDiScSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdTBsz5rh01i5Y2ApJBJ0tQ9pZ+NAW9wPg3wg+m3nV23DmKzMZ6Ic8s1XbpxzcRpj
	 aSBMsQtRZj5ipwtmtOVYtEgRyzdDjfMiua2lZ9FfLe0lLK6OZSv8bPtRUDS4rQt5Al
	 RX3BhKjM6kod2byfWwc4SImG/Sm+nxKxblDqb20w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/86] arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB
Date: Wed,  7 Aug 2024 16:59:41 +0200
Message-ID: <20240807150039.327066722@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c19fb8ae2da2a..4de9ff045ff52 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2029,6 +2029,7 @@ usb3_dwc3: usb@a800000 {
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&qusb2phy>, <&usb3phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;
-- 
2.43.0



