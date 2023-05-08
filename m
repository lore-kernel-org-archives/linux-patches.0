Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07BC168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F993C433D2;
	Mon,  8 May 2023 10:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541582;
	bh=xpte1IpMh+UeUifrf8wnSheq913qXtR8z61NaIvvTCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEmeyC3v6RJ+/AZLtGi4bHyTMmJo6nXFgYMFdb5NP8AuD/sImYMfjGLm3y8UT7UTe
	 UFH7AQypN7KiywhWWh1iuWaFfdRlPGEqKFaifqPK8zv38LXSojsqKxQpsIUJUcSLMn
	 IRXQHTtsS54RGb5XlFZgPGYujoA2XTU2YvUK5HI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 161/663] arm64: dts: qcom: msm8998: Fix the PCI I/O port range
Date: Mon,  8 May 2023 11:39:47 +0200
Message-Id: <20230508094433.718554658@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit c30a27dcfe4545edbda1578b3a63ed6147519cdd ]

For 1MiB of the I/O region, the I/O ports of the legacy PCI devices are
located in the range of 0x0 to 0x100000. Hence, fix the bogus PCI address
(0x1b200000) specified in the ranges property for I/O region.

Fixes: b84dfd175c09 ("arm64: dts: qcom: msm8998: Add PCIe PHY and RC nodes")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-msm/7c5dfa87-41df-4ba7-b0e4-72c8386402a8@app.fastmail.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230228164752.55682-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 923017a4f9250..c8c76338ae18b 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -916,7 +916,7 @@
 			phy-names = "pciephy";
 			status = "disabled";
 
-			ranges = <0x01000000 0x0 0x1b200000 0x1b200000 0x0 0x100000>,
+			ranges = <0x01000000 0x0 0x00000000 0x1b200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x1b300000 0x1b300000 0x0 0xd00000>;
 
 			#interrupt-cells = <1>;
-- 
2.39.2



