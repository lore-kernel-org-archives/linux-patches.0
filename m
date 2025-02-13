Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFDF23A9AA;
	Thu, 13 Feb 2025 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458017; cv=none; b=FAvGmrPAlGOBzU/c4dspA6ZHerUZrWchZy/7AfTisU6VeCP3a8PKO02jephogicWyo01UijcxQcdNG+qxnCzJDvW4R4RqXcQHGrh5nKbQ6R7P0amiLSIsx0KWDxlq81+IXYMlhK+EkAJ/k3JKvjiFFo/fdyqVCHA9Je0dvSTQK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458017; c=relaxed/simple;
	bh=lUVAJfMnRFEeu42PfuLM9tpUfur4L7rwpYd+jSvdpIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWeKFdeDmActOgjGd/KC9phHLGfpVQL54cosuGWQ9StGzgjFxEfwfRi7tZNJIGcFQ7upXHO+YvnSQUNgaZ+OGiDrb30gki8phsVxIFpn6reI5mMSuZ4R2OWqi5JE5ZedqOG9vlwBQMnYfYn+pGC3446Ms02Hg8JKBqLkH5/ZQJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h24g8FcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h24g8FcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0A8C4CED1;
	Thu, 13 Feb 2025 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458017;
	bh=lUVAJfMnRFEeu42PfuLM9tpUfur4L7rwpYd+jSvdpIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h24g8FcLqZsKS++DWiniEtsUvflRGSqvK7LkkN+ceAanq5dYvjUUrUjSMf03tRXLQ
	 NefyFiamIoeu3OZZ64KpaFmBv/dHXoYsiiChM347m9HtDnPmF2ynZ4fVKze+fOy+iX
	 z+7q0lsayjdul/wbICrkHyi/Kqb51W2kLVtu7s9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 278/422] arm64: dts: qcom: sm6375: Fix ADSP memory length
Date: Thu, 13 Feb 2025 15:27:07 +0100
Message-ID: <20250213142447.269418426@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit bf4dda83da27b7efc49326ebb82cbd8b3e637c38 upstream.

The address space in ADSP (Peripheral Authentication Service) remoteproc
node should point to the QDSP PUB address space (QDSP6...SS_PUB) which
has a length of 0x10000.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: fe6fd26aeddf ("arm64: dts: qcom: sm6375: Add ADSP&CDSP")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-17-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -1559,7 +1559,7 @@
 
 		remoteproc_adsp: remoteproc@a400000 {
 			compatible = "qcom,sm6375-adsp-pas";
-			reg = <0 0x0a400000 0 0x100>;
+			reg = <0 0x0a400000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 282 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,


