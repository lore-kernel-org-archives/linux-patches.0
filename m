Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDE533993;
	Sat, 12 Sep 2026 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232255; cv=none; b=rVUbAFL4L7nH5+84kIn0Rluc9sK3w2+uxq0PMPTZti9vd8EIEgYBc7fiVZ6hwRJ90gbI5dFDSHu/CJ2oyIT6PJiuYGd1yWLedBqdjBo8ZRhspt0dUF3V/e1Alyrb9MwTGgccOQ68d9F4Z+CxZwvpXenc+bbJtW6uLrYGNpHZSBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232255; c=relaxed/simple;
	bh=GHQqRlQ33nctM08GRdrLT62CtEImzwFNeX8f8hPzyMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQbOOIQpCiQacX/pz8dwkVdH7l/TEtY/0Mri/hThFX86Fe49soVZ2qHYXKnvTKSb2aw9hclfOD0uiLeSReQZIts3KSeGxGY379fquSqXksuv50SsiBAMnolPi60fmzmfjFHl5nBN48o6HOwW2NLJEGJroo3ky1+HULIXuMiAaw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHgHNzPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHgHNzPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A854A1F000FF;
	Sat, 12 Sep 2026 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232253;
	bh=v9EFWfZcMQglBl9+Ws1TCnSi9vKebOcGWoLIoh5eTOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHgHNzPZuphR34WW1UdSn/bY4ieUQh+hPuSjcjdf0WwSKW8n7Ia1bRA2nFWEtWl/R
	 J93/zLptpic+1jc9i4EnfeZhg8XRaj2SbTgKzoB2BPw+C9sxi5Zee1OxHK9CUmH5eZ
	 lzisF93ov6xu+vsMTtcBDtQSQgrFT0mxYs8U3epI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1166/1191] arm64: dts: qcom: sm8550: Mark QUPs and GPI dma-coherent
Date: Sat, 12 Sep 2026 09:04:54 +0200
Message-ID: <20260912065614.329705305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 91fc74458d833dbc999aa04ca34c2a197711a0b6 ]

These peripherals are DMA-coherent on 8550. Mark them as such.

Interestingly enough, the I2C master hubs are not.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240210-topic-1v-v1-3-fda0db38e29b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index de74499bbfd9c..c09458cc4de94 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -683,6 +683,7 @@ gpi_dma2: dma-controller@800000 {
 			dma-channels = <12>;
 			dma-channel-mask = <0x3e>;
 			iommus = <&apps_smmu 0x436 0>;
+			dma-coherent;
 			status = "disabled";
 		};
 
@@ -694,6 +695,7 @@ qupv3_id_1: geniqup@8c0000 {
 			clocks = <&gcc GCC_QUPV3_WRAP_2_M_AHB_CLK>,
 				 <&gcc GCC_QUPV3_WRAP_2_S_AHB_CLK>;
 			iommus = <&apps_smmu 0x423 0>;
+			dma-coherent;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			status = "disabled";
@@ -998,6 +1000,7 @@ gpi_dma1: dma-controller@a00000 {
 			dma-channels = <12>;
 			dma-channel-mask = <0x1e>;
 			iommus = <&apps_smmu 0xb6 0>;
+			dma-coherent;
 			status = "disabled";
 		};
 
@@ -1011,6 +1014,7 @@ qupv3_id_0: geniqup@ac0000 {
 			iommus = <&apps_smmu 0xa3 0>;
 			interconnects = <&clk_virt MASTER_QUP_CORE_1 0 &clk_virt SLAVE_QUP_CORE_1 0>;
 			interconnect-names = "qup-core";
+			dma-coherent;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			status = "disabled";
-- 
2.53.0



