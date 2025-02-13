Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23111547E3;
	Thu, 13 Feb 2025 15:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460687; cv=none; b=mreUsj2aEjtz1HN2qSegJ9gzue+Tqf28GCAhnjbXSGjgHGA6ovBqkbeJFYDy976rvC2m+vEj5Y6QgnsHCLSDjpfrTODTYY0vnXeM2vLV7vr9ayaMy9HXX8WHJyBaqS0i2/g6qvvxiP3ZBoQc0b657z7gFS8ELWXq0E0BqLzEitE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460687; c=relaxed/simple;
	bh=1WjoYwK4dSJb+QKvvrIVrkd6TrtCLR7E0tUYEVRxWKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgOevL7dugks+cQTunTaqGwKu34ZpNee+hintt6ctYEQ+4QHrN2JIJIe3cZCCNWdfpzJsYGREGhOD3Uzr7q3DPV5Xx1G7F7kcz14BDiPST5O6L+ylgnQ7YBQRLvTzDNG7LnmKoeAipBYBNKL5J3eNjBfWZQdlLnymrULyr/L3s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7JhsU3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7JhsU3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D090C4CED1;
	Thu, 13 Feb 2025 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460687;
	bh=1WjoYwK4dSJb+QKvvrIVrkd6TrtCLR7E0tUYEVRxWKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7JhsU3tZtMevqETG3YId7oiptkDb0Sn7kphsNfpROk64k0kq53bFkD46ASRGGcxq
	 P2nuQboVXgHj+2xwlLZ8lUCEgNtTYzOCHCpAJd/cBItE33/ewEdWV1MSGFQu2loBWU
	 T+vT4HzlUBxjHXG00bC1euczeM2EpUDtPD/GTuX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 184/273] arm64: dts: qcom: sm8450: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:29:16 +0100
Message-ID: <20250213142414.597054726@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 3751fe2cba2a9fba2204ef62102bc4bb027cec7b upstream.

The address space in CDSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x1400000 was
copied from older DTS, but it does not look accurate at all.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 1172729576fb ("arm64: dts: qcom: sm8450: Add remoteproc enablers and instances")
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-5-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2475,7 +2475,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,sm8450-cdsp-pas";
-			reg = <0 0x32300000 0 0x1400000>;
+			reg = <0 0x32300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


