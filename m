Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D6C16DEB1;
	Wed,  5 Feb 2025 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767350; cv=none; b=fukmQAKUQaOVosrfAmwXUofoxijU22c4BP9vpgs8YIxObkIS+M94emGDchvvY7X0cJdIGb/m/8ekdExBBYPByljzZSSIxUvIMryd1uQ3U3j/bMr1SHSuJQI3UYq1Og3+2WL7p+IyDTc6BupYtjGVQsxhGih4gDUlC69v+mXyRHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767350; c=relaxed/simple;
	bh=9bjGI3HxAsAV39WIMD4S/mHPXRFdvFHYcBgGEzKbmZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0WVfIknZ2l43ODXg3fF8wInOEiQoZ3V8hkIb4n/uUxRjZOyQt3n2Bozpt/psdM/8SRQq7WwvVtOZvD+P1YJtBjjzq5bNuD3lUJ3Wicch1KQb5rOOb09n+zDaO5uF+xHvaSNKXGe+xrKzFOzSIugoGlW+rsRKqWM7AS9LnI1PCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7a3Udr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7a3Udr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE52C4CED1;
	Wed,  5 Feb 2025 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767349;
	bh=9bjGI3HxAsAV39WIMD4S/mHPXRFdvFHYcBgGEzKbmZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7a3Udr89tycrniPdGwM0pn0c0wpmZPQ4Pwj3U2S/E0NN/uLPsVhFupdZW6VpBctU
	 7G8Rgw1ZxQFI9BE+0CGoLhLIFhRYHbQlzLYPp89XHv35RqgbEXNpEDMssTDGtmxYHs
	 LTAJcAK59wzouEdwblnqJRYzh5pIgMtL7byVHfW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 369/623] arm64: dts: qcom: sa8775p: Use a SoC-specific compatible for GPI DMA
Date: Wed,  5 Feb 2025 14:41:51 +0100
Message-ID: <20250205134510.337299509@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit a8d18df5a5a114f948a3526537de2de276c9fa7d ]

The commit adding these nodes did not use a SoC-specific node, fix that
to comply with bindings guidelines.

Fixes: 34d17ccb5db8 ("arm64: dts: qcom: sa8775p: Add GPI configuration")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241108-topic-sa8775_dma2-v1-2-1d3b0d08d153@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 9da62d7c4d27f..d9482124f0d3b 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -855,7 +855,7 @@
 		};
 
 		gpi_dma2: qcom,gpi-dma@800000  {
-			compatible = "qcom,sm6350-gpi-dma";
+			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00800000 0x0 0x60000>;
 			#dma-cells = <3>;
 			interrupts = <GIC_SPI 588 IRQ_TYPE_LEVEL_HIGH>,
@@ -1346,7 +1346,7 @@
 		};
 
 		gpi_dma0: qcom,gpi-dma@900000  {
-			compatible = "qcom,sm6350-gpi-dma";
+			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00900000 0x0 0x60000>;
 			#dma-cells = <3>;
 			interrupts = <GIC_SPI 244 IRQ_TYPE_LEVEL_HIGH>,
@@ -1771,7 +1771,7 @@
 		};
 
 		gpi_dma1: qcom,gpi-dma@a00000  {
-			compatible = "qcom,sm6350-gpi-dma";
+			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00a00000 0x0 0x60000>;
 			#dma-cells = <3>;
 			interrupts = <GIC_SPI 279 IRQ_TYPE_LEVEL_HIGH>,
@@ -2226,7 +2226,7 @@
 		};
 
 		gpi_dma3: qcom,gpi-dma@b00000  {
-			compatible = "qcom,sm6350-gpi-dma";
+			compatible = "qcom,sa8775p-gpi-dma", "qcom,sm6350-gpi-dma";
 			reg = <0x0 0x00b00000 0x0 0x58000>;
 			#dma-cells = <3>;
 			interrupts = <GIC_SPI 368 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.39.5



