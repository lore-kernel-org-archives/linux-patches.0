Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18454176ADE;
	Wed, 19 Feb 2025 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957075; cv=none; b=Ow4jZGpqh45FdNCBACdg8fRi+3LVBe0RR3XENm2iJaRPPIDQFTnLgqS8O4BbMS0WYPjBFaeApK/kcouHJ+HMnTP8NH8+tInDTgjT5bUCoSkKWpQewSMm3hw2rVCB71GstJ83ds6c8LZqzUTr1v/jMn77/gHK3b7RtkK8VnrFDlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957075; c=relaxed/simple;
	bh=aW5PoNm/wiwRRQDWxOfzvZWbVpqvlohMsnzL5dzrZy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/KE4z8GowlwSKbeiwvCRa+58R+hiHD4WsGe9ndHUCGtKPIE5H+bvctowyEy3suSVABc0nb/LBu9Rg+OH7wl2LCNdPBN+QZ0TULs+5gnLaYOO0Qy1hKyiE4ggw2txLIzIH4zup53PGOOOG6xHyW60C4FdcCTxbvzavhBV79U1CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6setaxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6setaxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F57C4CED1;
	Wed, 19 Feb 2025 09:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957075;
	bh=aW5PoNm/wiwRRQDWxOfzvZWbVpqvlohMsnzL5dzrZy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6setaxqOfEJkwOpvXsNuNT/S2DYC7CUG5wp1MRjGoQ0teg12OUWGxLKK/zYeFQC4
	 V36jZ5xdz4gGQa+pVAX1uwjPoeM4vUu2iL8cw5Q+nHUnav+Op23b8ANT5Gz3fX8DxV
	 SpyqBe3xTsxajV5MUK/dwGmjvPCaiKaqm5WgHByE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 400/578] arm64: dts: qcom: sm8450: Fix MPSS memory length
Date: Wed, 19 Feb 2025 09:26:44 +0100
Message-ID: <20250219082708.758843494@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit fa6442e87ab7c4a58c0b5fc64aab1aacc8034712 upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x4040 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 1172729576fb ("arm64: dts: qcom: sm8450: Add remoteproc enablers and instances")
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-6-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2265,7 +2265,7 @@
 
 		remoteproc_mpss: remoteproc@4080000 {
 			compatible = "qcom,sm8450-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


