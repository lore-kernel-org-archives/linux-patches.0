Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD321632DD;
	Thu, 13 Feb 2025 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460691; cv=none; b=KwUmUUVGaYnqmnH74+PAr0SNs9Q/GL6AqBfkAE0eGM0t6+ZGjgUnv/8mXk/o7KxKdikUgXx1SWfzpLYqIgQS/+/5X6yzFOtbFfT7hC1DVd5KFEakYwI9b5A11k9CzCa3LD+q7prYwY/DA8KaieZgZaQN9cSWG7tiFznG027LxHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460691; c=relaxed/simple;
	bh=4kY6ksw3yfwwPQR3eyj4hFh9qOV1s3w5xuU+F64gZT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8oKe4SQdsExNKvn0jVqErC3Smi88j0RDgQTNsiAoaAqRGtLMWcyayYfgnUSxMiedWAHYRPjiyvj/FbySn9OuL0lVc6TtWj50wIyAIPKlmUcyGS/Ji17zcGJ8tPH4fFGBapvKzsSP673v4FtsCiLsVIiKjMZPq/rSdwyQVDjH6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSp45sQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSp45sQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A305CC4CEE4;
	Thu, 13 Feb 2025 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460691;
	bh=4kY6ksw3yfwwPQR3eyj4hFh9qOV1s3w5xuU+F64gZT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSp45sQhISHYWGcJw/0qCH6oa0JDbmCDENert7HXudkBSVYt5E6HO4PHPuZuu8Afr
	 ZyGzOZW33erdY0h8tNjtm37V75AeXCcHKlNrKagXDt2vMIPTr/ilUDRmOZa1DhrcW2
	 W2/N/7mpaQDIcSNw/caphgCmLmXdLWfDR0m/ygBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 185/273] arm64: dts: qcom: sm8450: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:29:17 +0100
Message-ID: <20250213142414.636542437@linuxfoundation.org>
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
@@ -2581,7 +2581,7 @@
 
 		remoteproc_mpss: remoteproc@4080000 {
 			compatible = "qcom,sm8450-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


