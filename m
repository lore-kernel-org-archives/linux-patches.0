Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AF413DDB8;
	Thu, 25 Jul 2024 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918824; cv=none; b=aFE//d1BZn1gq+Y7Zp194DaRE3KvzFIgGqrYML6JHFvH1x45IqwlmPt3RiyUcBMiBEX82n/ah+bNCYUlKrKpggLRVl25f0MrNoinOLvP+KGJRtTsGioKoyeFicpMm2zu10elRnBuC7u/Y6kbw7A4IiMgc7s/HpzsbZr6fGuAQO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918824; c=relaxed/simple;
	bh=8TjwsOmGMogMh/9JtBx2QeKSZRanlMIT/GAwY0RZ04U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYBrrLLa0eKlrHO/Q1r5e3ZxycKxE4vQPyRcyHNoo5nbfmacjp0ngSiogGaP16PK6AI7iXXYe9ySkM+9djo3m9bT+zhg4aSjuZ2CP7tIEClM2rLBu6amWe8RAHyei/Gz9pubxEqXzRlTxtyK9kgYaaHvr9U/OUNu91u5CwVdFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYYkKB43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYYkKB43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF684C116B1;
	Thu, 25 Jul 2024 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918824;
	bh=8TjwsOmGMogMh/9JtBx2QeKSZRanlMIT/GAwY0RZ04U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYYkKB43g94w8dgh53w7p5mT5EVSW9yoJiBUkY1fpK8IZ8e5YB4ssFVQWxl3WPoZm
	 bMwcDEQmqAU6bIXQo1N8uDqViDxYRhLPtLkzHTArJvVAXhn5UvE73JdI00iThFTsT2
	 ybqQ1Rw4A+ShvmB6pBvY0jJCOY/uVAck2boRAbpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 21/29] arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:31 +0200
Message-ID: <20240725142732.475146018@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 0046325ae52079b46da13a7f84dd7b2a6f7c38f8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2154,6 +2154,7 @@
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&qusb2phy>, <&usb3phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;


