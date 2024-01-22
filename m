Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A71339BC;
	Tue, 23 Jan 2024 00:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969308; cv=none; b=RrfqjRxgZxwSKKSHKqDzUOBL1c1ThD4bnu9tdiHTdA0rQxIuU+dgyFKuy7LrA/06ZKaREK6TA7RqFtwriiAPKmyoea1yJr+oTQosFZiaa4S+HzV+yZjH4WH7bUEYBVUEDwocEj5D64hhwJ1xgOi3uxP6+1lE0iTMiHwBEQoBGR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969308; c=relaxed/simple;
	bh=cB0m5WUgJTQ5K//99+ZUl4l4wMHGl48tNGi4DbCPXzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2fv3PLF5XQ1GpJqRAP0kr7ZZINEWpjNpJO2iOaTTK1VN6Ez4Z6ZNi/3rce2g/srRcQjcOklmeXMk1D/DRRIQq61tgAnKOKD46oCDI+Bj/lMgRIw2IzyY4u00cThi7qlfvbulBz4pMMCposj0LfZUkWprR1briF08WmeW1KeSFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpbRNdye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpbRNdye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067B3C433B1;
	Tue, 23 Jan 2024 00:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969308;
	bh=cB0m5WUgJTQ5K//99+ZUl4l4wMHGl48tNGi4DbCPXzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpbRNdyefjW4KDCmsFEyaVPBWF9DUlFk3OlxL1kCGlwwt3oC2ynpZPqWmy7Kwexu4
	 YsZr82Ftr6H24RtKwnTeTN2USjzLUhQslkGBKeX2krgUeBgAHIyS5PZvFQgVkGJ4iS
	 niSoGZYqIG4tc/yweD+WWWekb7fFIsYFytkXEREE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Nia Espera <nespera@igalia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 140/641] arm64: dts: qcom: sm8350: Fix DMA0 address
Date: Mon, 22 Jan 2024 15:50:44 -0800
Message-ID: <20240122235822.432111902@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b46236235b7f..1d597af15bb3 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -919,9 +919,9 @@ spi19: spi@894000 {
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



