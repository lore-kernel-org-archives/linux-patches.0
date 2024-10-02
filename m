Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702981D0412;
	Wed,  2 Oct 2024 14:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878958; cv=none; b=SaggHo7SuqfxCOYh6iJjmiJyvEoD7lBBcGLvgfYbNrXsvULaILDIuyRqxx+ZrQpPQPUUgvB/tqqEnBHFcesif5cfYF0Q6nG+Oc62Dasl9uHgL6CVh40fchqg9WwI5EMHU/mdyzNw5wTrzgNwG38kZnFlwUNQ9FgHxgB1xKfRHWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878958; c=relaxed/simple;
	bh=o0DT1CV9J1xwivWZ8ha2DIdWgtKGttGNOcpjINGwbag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSk46quVl+QRtPq7BVnbanD7Z9RB+Dey1BTu7rn9zmynT6q8CWM/ufv7uvZxXpo+q5QXtq8d/EScqL5j0wbdPaNmYS3j2T4yKRI6oRaXt4dPmm+8jFxj+FIWn3Waxm33iO88T57kVYJUyUIvyErQQXt4ArK98LcYxUV5xYHoCxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVjXccpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVjXccpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5533C4CEC2;
	Wed,  2 Oct 2024 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878958;
	bh=o0DT1CV9J1xwivWZ8ha2DIdWgtKGttGNOcpjINGwbag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVjXccpXaMaQqNobM/osbXrLR8s1o4kV7J/zgrndB25Kdabkn8dckQxSUhK78CNPW
	 yZN5nN4sdCr9/K7Q1f8tc0B0LIXaoHBwJKKPXa3FAllfzR/zGfNbVtwtjqC5vl8yWS
	 kJB5Or7syQ4ECAugGvgfF/bzUIbB0moU10fPc3EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Qingqing Zhou <quic_qqzhou@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 573/634] arm64: dts: qcom: sa8775p: Mark APPS and PCIe SMMUs as DMA coherent
Date: Wed,  2 Oct 2024 15:01:13 +0200
Message-ID: <20241002125833.732831291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2104,6 +2104,7 @@
 			reg = <0x0 0x15000000 0x0 0x100000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <2>;
+			dma-coherent;
 
 			interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
@@ -2242,6 +2243,7 @@
 			reg = <0x0 0x15200000 0x0 0x80000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <2>;
+			dma-coherent;
 
 			interrupts = <GIC_SPI 920 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 921 IRQ_TYPE_LEVEL_HIGH>,


