Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE81DF6B;
	Mon,  1 Apr 2024 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989367; cv=none; b=IQpkMjSIX2GRcf4CNFX/+zSpj8jyNuD+LHpKshQS5Iea4tBYq3wbBe2PYVjL0k0FXbP8EfYYkAKlwwcFJZSITskRSz7fnFpGJrn2l7dMO2C4qwZraEVs9gT3v394krjqD7c7bDxPuuHZ2XFry4hpAYN04XkKdjFF2pW3SFYGJYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989367; c=relaxed/simple;
	bh=uwk/EGGJ6ttcICvGrVBkH8YEmafEYZZZoZOLu135YtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAhVHgmB4IvaH6q5BBdwZY7TT9tQ1qYIllST5JWPBf4viU7DAL8TaAmKmO+6eWnZK2PeaCtVlfs/09fpkbP6FOk+V9YhVmECkz8H9sLA3nyKDbMFNYyh4BHHk7z/JqWxLACCeqxPshrStDoMA88dzrsljajFNOeGiB5v7yMri8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChNvUTY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChNvUTY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA9EC433F1;
	Mon,  1 Apr 2024 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989367;
	bh=uwk/EGGJ6ttcICvGrVBkH8YEmafEYZZZoZOLu135YtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChNvUTY4f4iZyRgSksjEED5NLnr1TYyswXlLXjWSpdqZ5+zvXjnDAigKnHZ0dlCKj
	 3tnH7Gbr4KXY1cp5lIFEtRaC3qkj8W9lA09O7E5Lv25C2kAZEFs9njBpmypcq2NbeH
	 30T3h3aIZRFRfQYitLMOkq8GiuWvwcOvmW/+4l6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/396] arm64: dts: qcom: sc7280: Add additional MSI interrupts
Date: Mon,  1 Apr 2024 17:40:56 +0200
Message-ID: <20240401152548.100861241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

[ Upstream commit b8ba66b40da3230a8675cb5dd5c2dea5bce24d62 ]

Current MSI's mapping doesn't have all the vectors. This platform
supports 8 vectors each vector supports 32 MSI's, so total MSI's
supported is 256.

Add all the MSI groups supported for this PCIe instance in this platform.

Fixes: 92e0ee9f83b3 ("arm64: dts: qcom: sc7280: Add PCIe and PHY related nodes")
cc: stable@vger.kernel.org
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Link: https://lore.kernel.org/r/20231218-additional_msi-v1-1-de6917392684@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 8e330d2e2e224..b75de7caaa7e5 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2098,8 +2098,16 @@ pcie1: pci@1c08000 {
 			ranges = <0x01000000 0x0 0x00000000 0x0 0x40200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x40300000 0x0 0x40300000 0x0 0x1fd00000>;
 
-			interrupts = <GIC_SPI 307 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "msi";
+			interrupts = <GIC_SPI 307 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 308 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 309 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 313 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 314 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 374 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 375 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "msi0", "msi1", "msi2", "msi3",
+					  "msi4", "msi5", "msi6", "msi7";
 			#interrupt-cells = <1>;
 			interrupt-map-mask = <0 0 0 0x7>;
 			interrupt-map = <0 0 0 1 &intc 0 0 0 434 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



