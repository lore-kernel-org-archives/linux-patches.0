Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EFD1D042F;
	Wed,  2 Oct 2024 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877036; cv=none; b=Rw9mJ762YEkI5Q4yPB1w/Ax1ktNvchWlZGq5NVbxcPC/DC3drSEMfLBIl50eKpaaBTRcJ+ZGJol/ubTh1kbJr8rpvt23XmSB2XAjmxe03qaPgWm0XaOhqULH9hY1K4KGzIAqyMGzQDT0B1rJD43gmkPm9PJTD5oMayiWIGroEnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877036; c=relaxed/simple;
	bh=57FKOkwkuTW7ey9bP1562FJlW6QvJMhI/G7MLDLfKSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5gJV8mgOCmKwziS5BGvUf61wma5JLMwUau4TPnQoD8xUWew/n794Kv+rsEvqXW+bN64soiQjkWQY5hwQkVe/UsxDuW1fGIPozGI7SYVjMahDIXK6qbT9Utyk8h1m4TJ1DXUFef87zr0Frc0nhSCLdflUEhB8PUnf+JClYo/TU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnNxrTmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnNxrTmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB30C4CEC2;
	Wed,  2 Oct 2024 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877036;
	bh=57FKOkwkuTW7ey9bP1562FJlW6QvJMhI/G7MLDLfKSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnNxrTmGQ26fp7hlRk5BLu3zy2U8wHPxYZol8ZDaipT9Xw4R+ckHFuUSu+uv3CUH5
	 Js0vLepgarZfUTJQksiHlAweK/UdC7Tkfb6HrxQh9zmyAtnxmLtsgKZDhMGNwAD7Xd
	 ZkHdnnaHNJ6dHPt2TwpMuK783zo0q7U+PzuLmA4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Qingqing Zhou <quic_qqzhou@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 643/695] arm64: dts: qcom: sa8775p: Mark APPS and PCIe SMMUs as DMA coherent
Date: Wed,  2 Oct 2024 15:00:41 +0200
Message-ID: <20241002125848.183819661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingqing Zhou <quic_qqzhou@quicinc.com>

commit 421688265d7f5d3ff4211982e7231765378bb64f upstream.

The SMMUs on sa8775p are cache-coherent. GPU SMMU is marked as such,
mark the APPS and PCIe ones as well.

Fixes: 603f96d4c9d0 ("arm64: dts: qcom: add initial support for qcom sa8775p-ride")
Fixes: 2dba7a613a6e ("arm64: dts: qcom: sa8775p: add the pcie smmu node")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Qingqing Zhou <quic_qqzhou@quicinc.com>
Rule: add
Link: https://lore.kernel.org/stable/20240723075948.9545-1-quic_qqzhou%40quicinc.com
Link: https://lore.kernel.org/r/20240725072117.22425-1-quic_qqzhou@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -3070,6 +3070,7 @@
 			reg = <0x0 0x15000000 0x0 0x100000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <2>;
+			dma-coherent;
 
 			interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
@@ -3208,6 +3209,7 @@
 			reg = <0x0 0x15200000 0x0 0x80000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <2>;
+			dma-coherent;
 
 			interrupts = <GIC_SPI 920 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 921 IRQ_TYPE_LEVEL_HIGH>,


