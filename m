Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5D0481D1;
	Mon,  1 Apr 2024 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990608; cv=none; b=qohEKe7PSPvd9FCtFi1qiVkGDvX8+F8AalKE1PX+6gxY67T5LpunLs5nKE0C8A8x5pSuhb22WwciqYuxqlaZc/1+wg2M1eCZNya1ciHgVyJlsNM/yGiz9tEvpIUxz8MnGsL7+eIveXo+VPtvW2K38mA0rB6SxLhGWIZS2cfxf0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990608; c=relaxed/simple;
	bh=VKK0Xas/U/nEuJO1PTjpoVrXYRdBjPXIvGMmS3RqkEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKLFk+7HEDlYgyNX668RWrFqGl84zQpB80ufcGZSq4IAH6v9l0wQJWj90zaCIFDsqWc9+iAud+lVAZuzj9EWRAnqpx50pt/++w1XZYta83CCMCb8V84jRguSo5zoVjYzI/DiOCtSUieyBUq83VB3zq0KmTWJkTRZmS4+pCZZAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brE8QCSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brE8QCSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52DEC433F1;
	Mon,  1 Apr 2024 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990608;
	bh=VKK0Xas/U/nEuJO1PTjpoVrXYRdBjPXIvGMmS3RqkEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brE8QCSPL1FeHk+bRl3jy69WDHY728/fdFfsZZcmo7QY7S57OAcka45YfXGVG/CQI
	 GCijWXMx1vWf/vdA4zQc+ed71XlvW9xagUIA3KIjPJsacT8X4tuM0p6u1WohZBhXD0
	 OxXFJxbYKvTnSsLDpLX5k28GC5TKSpzR77qGjQcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/272] arm64: dts: qcom: sc7280: Add additional MSI interrupts
Date: Mon,  1 Apr 2024 17:43:21 +0200
Message-ID: <20240401152530.648613622@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index 04106d7254000..b5cd24d59ad9a 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2028,8 +2028,16 @@ pcie1: pci@1c08000 {
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



