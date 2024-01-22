Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFB2605B2;
	Tue, 23 Jan 2024 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974699; cv=none; b=LdWV8N1LxRXRJQL1mlEKE7kClJ5X0sva0ylugyCRlbBLlZTXnsrR/AJDCrNZ8hi2G3C3TBljC8mJJlXCAo1DB0EWHnViHKGm5Bt0EAQJKfW5VyoSiK1LiQ8cTd43OLULOxotVEW5JB6xnr91A9r/D2mGIJDg/DnyV8T+SIGLzKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974699; c=relaxed/simple;
	bh=oW/h7ONBzym5d6QtylIPTt7L7RspoAcX8C1i10MNBJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=id/JP2BDOQUlvIq8ubvxgxvz2IDJpW0flLaJlQ41OQVFW2jZKqQzAzOcSGKI8+wgEj7yI4jilGHVEUQoCJbXZ8NihIar6VykS7jGUAJMwtiNczL//bX3A1+/XydYt+r+E1+rVQ2j22Kzd64Nape6IFGTTiIi6Zhfw1adA0gc0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLnvfzlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLnvfzlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37B3C43390;
	Tue, 23 Jan 2024 01:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974698;
	bh=oW/h7ONBzym5d6QtylIPTt7L7RspoAcX8C1i10MNBJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLnvfzlJ8rZ743iq/cg1q9iYoXmEyqfXnYYZguaJSX26NIrFH2NLbe+tmPA0fvLT4
	 g1dCii6ivm8SzhChmAGg0lvu1lZkZJTtExEEo/Q64MxEmMrpJjtkBjwV5VEwya3o3d
	 t4/bGILzDkg0lEK8kWMLHc/Ceiv7ih3PaQcBUvrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Nia Espera <nespera@igalia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/583] arm64: dts: qcom: sm8350: Fix DMA0 address
Date: Mon, 22 Jan 2024 15:53:00 -0800
Message-ID: <20240122235816.085984645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Nia Espera <nespera@igalia.com>

[ Upstream commit 01a9e9eb6cdbce175ddea3cbe1163daed6d54344 ]

DMA0 node downstream is specified at 0x900000, so fix the typo. Without
this, enabling any i2c node using DMA0 causes a hang.

Fixes: bc08fbf49bc8 ("arm64: dts: qcom: sm8350: Define GPI DMA engines")
Fixes: 41d6bca799b3 ("arm64: dts: qcom: sm8350: correct DMA controller unit address")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Nia Espera <nespera@igalia.com>
Link: https://lore.kernel.org/r/20231111-nia-sm8350-for-upstream-v4-2-3a638b02eea5@igalia.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index a94e069da83d..a7cf506f24b6 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -918,9 +918,9 @@ spi19: spi@894000 {
 			};
 		};
 
-		gpi_dma0: dma-controller@9800000 {
+		gpi_dma0: dma-controller@900000 {
 			compatible = "qcom,sm8350-gpi-dma", "qcom,sm6350-gpi-dma";
-			reg = <0 0x09800000 0 0x60000>;
+			reg = <0 0x00900000 0 0x60000>;
 			interrupts = <GIC_SPI 244 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 245 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 246 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



