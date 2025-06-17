Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A64A221F14;
	Tue, 17 Jun 2025 16:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177737; cv=none; b=t86DeDj1IYjOpi5oFg+bkDAMbf3v6q+Fd8xIz2fV7mRqe/n0s9uoheV2oBdRWbxHMwilH9l/3bgqOLI/M6RYv12YcNbwI7KgK0cteMTpDLe3a8ODgkqnUykeLCcVgDQqC/a65QVt/hPbBrIka5TjnvvX/x/tuDnWgNvtwYOfTOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177737; c=relaxed/simple;
	bh=BA9JKuTb/e0ybNatljyd8anjTyWI0I+YI7gEi4lyH0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+lifHm1Gd8RgmiZjYbTL1ey2UNQrStlPPwuK34vuXn0EhwvgByHFT5NdC+sO8y3TNESvlY7dHQFUuF6QtakwYUXr8lIDj7mbiFESy7CGTC1JwjBEDgkQPVVvdgTyL7mULybVbE2cHoo445bKXM+OKkPS0jxAFg43M9AvxaCe20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXfGEyD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXfGEyD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C373C4CEE3;
	Tue, 17 Jun 2025 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177737;
	bh=BA9JKuTb/e0ybNatljyd8anjTyWI0I+YI7gEi4lyH0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXfGEyD/hMpIgIc+C3po52aUQRKPjLakQEfvkS62VcdXEDxTDbo0tgFDQ4OuIux3Q
	 Qtyrab9VL7huukwtpvDN4qI4PZm6nwWSjngmhAsnmjm+6hqdHyNu6Xb8aePek3q2tK
	 gG1akWSBOulaZPq9BxUUEwt/0Nl9fwOXysSB3W4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 353/780] arm64: dts: qcom: sm8350: Reenable crypto & cryptobam
Date: Tue, 17 Jun 2025 17:21:01 +0200
Message-ID: <20250617152505.836129809@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 75eefd474469abf95aa9ef6da8161d69f86b98b4 ]

When num-channels and qcom,num-ees is not provided in devicetree, the
driver will try to read these values from the registers during probe but
this fails if the interconnect is not on and then crashes the system.

So we can provide these properties in devicetree (queried after patching
BAM driver to enable the necessary interconnect) so we can probe
cryptobam without reading registers and then also use the QCE as
expected.

Fixes: 4d29db204361 ("arm64: dts: qcom: sm8350: fix BAM DMA crash and reboot")
Fixes: f1040a7fe8f0 ("arm64: dts: qcom: sm8350: Add Crypto Engine support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-1-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index f055600d6cfe5..a86d0067634e8 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1806,11 +1806,11 @@
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <16>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x594 0x0011>,
 				 <&apps_smmu 0x596 0x0011>;
-			/* FIXME: Probing BAM DMA causes some abort and system hang */
-			status = "fail";
 		};
 
 		crypto: crypto@1dfa000 {
@@ -1822,8 +1822,6 @@
 				 <&apps_smmu 0x596 0x0011>;
 			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
 			interconnect-names = "memory";
-			/* FIXME: dependency BAM DMA is disabled */
-			status = "disabled";
 		};
 
 		ipa: ipa@1e40000 {
-- 
2.39.5



