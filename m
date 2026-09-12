Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093B83859E6;
	Sat, 12 Sep 2026 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230328; cv=none; b=aQohCcEAOQZPzjv78/D2JXfTmkWAmioU7lJOh+rkumAoWtkcrzDcEcoPjf/kWNwV52sWO7qbbAHIwF29r4WEeH/XVyHHO72Hu1vysH/7D9Kcks+PjqFyVZrTO+C/AxueP/xX4W0JkRzWCHFzojQRF2HPIuZJIvefE2bkOimgcXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230328; c=relaxed/simple;
	bh=asm321GYFyptriGlL9q3Drgr1/boi/NHxS6ZQaqd2Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQKnZMAqGsVPU0kXwMfJpzdzpcdU+YHKYzAv90VHgJMcQaR7vOIJLRo9+rBAqQSbNnD0FWu9sEdzsEiCdfz0QDv9H2gRLfcnCUUm1eXo/IUgT61GZGy2cV70SO3g8bFEU9boop6xVkOh7WXy+udK8u0WLcAlZyEof8fH9BxjUUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9Qo2f2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9Qo2f2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952801F000FF;
	Sat, 12 Sep 2026 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230326;
	bh=5ujBKESPO8iAChEoxQsomtepzGDPdG/61N9LsYANzcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9Qo2f2V8HQjFL6sJIl5nQ6bVAA0RXgGMqHOuJvJMF+dmwIneX8kHGZJ9k9vzkayk
	 pHiGoK1qsO6vJwJhkdQuySWtqsegRG07q0E/RWm4X1kh1QVgwxqM6956BSOLX9i1WH
	 Q7Yv9D3ReL1CQ0NMtOngPDoKZ5/c0NR34kjXFmZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0770/1191] arm64: dts: qcom: sm8550: add QCrypto nodes
Date: Sat, 12 Sep 2026 08:58:18 +0200
Message-ID: <20260912065605.574238213@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 433477c3bf0b7f00334f4157de2a21aa4d8e46a1 ]

Add the QCE and Crypto BAM DMA nodes.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221115-topic-sm8550-upstream-dts-qce-v1-0-fe750dfa90f6@linaro.org
Stable-dep-of: deaea7e982bc ("arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 2d9377e01c3f0..57888fe063c05 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1366,6 +1366,30 @@ mmss_noc: interconnect@1780000 {
 			qcom,bcm-voters = <&apps_bcm_voter>;
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.0";
+			reg = <0x0 0x01dc4000 0x0 0x28000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x480 0x0>,
+				 <&apps_smmu 0x481 0x0>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
+			interconnect-names = "memory";
+		};
+
+		crypto: crypto@1de0000 {
+			compatible = "qcom,sm8550-qce";
+			reg = <0x0 0x01dfa000 0x0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x480 0x0>,
+				 <&apps_smmu 0x481 0x0>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
+			interconnect-names = "memory";
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0 0x01f40000 0 0x20000>;
-- 
2.53.0



