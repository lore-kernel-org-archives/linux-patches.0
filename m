Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848E61D0F5A;
	Wed,  2 Oct 2024 14:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880565; cv=none; b=a92MaHJKUDN4XMERMU5tIQ33YnRajGCuGlSD/fNaSJhpdZ3RQ/GLMDm49HUxvPcA25W+CLovkt95F9eoQ3qw60DXEuzYm9rOxn9iod/qKB5gDFjE3jZNLJjLXB0wL5vHeYjLf8XiWsGvxVYcd8WoKVc1TnYTdKnh8tf6/wVJafY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880565; c=relaxed/simple;
	bh=Z/MBlxx08emoqCyEF0INVVvFPsKFTTdhdMwpl0Sy0jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjLENjFzcJfZzDtiobvX/MCwSEnWVc9e3YR9thr/s3Ogy64KOhpaoljKJ1onmsnc2oNLhARWYW1oXD0x3FGZn7gNse2XgLLLGjBODneHNgUlddWIKY9J3sCU6esyMG2M69BdWsYLP3dy9QNkP6mIOF7xVaLc4EVbwSvUyKEOJsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DdzmI7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DdzmI7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F709C4CEC2;
	Wed,  2 Oct 2024 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880565;
	bh=Z/MBlxx08emoqCyEF0INVVvFPsKFTTdhdMwpl0Sy0jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DdzmI7CcUw+cIeH9/zMM2aF6C8oiUPbxPeSQPMd1v9jJ9L7bJfqlpCFsA7Cd88OV
	 ndqaiSDRxqa6kB5MUrbbx6YA1x6QgpStNutW9VL7MHm7t02ZsTyoUvlsmcDyftrnRU
	 cSzJR4yafWv51jONLzlgBN6CLf/xkBnwFPRwOz0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Qingqing Zhou <quic_qqzhou@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 472/538] arm64: dts: qcom: sa8775p: Mark APPS and PCIe SMMUs as DMA coherent
Date: Wed,  2 Oct 2024 15:01:51 +0200
Message-ID: <20241002125811.075519340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -1951,6 +1951,7 @@
 			reg = <0x0 0x15000000 0x0 0x100000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <2>;
+			dma-coherent;
 
 			interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
@@ -2089,6 +2090,7 @@
 			reg = <0x0 0x15200000 0x0 0x80000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <2>;
+			dma-coherent;
 
 			interrupts = <GIC_SPI 920 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 921 IRQ_TYPE_LEVEL_HIGH>,


