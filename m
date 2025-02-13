Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F952222C0;
	Thu, 13 Feb 2025 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458024; cv=none; b=qNvqBlyXA/fOcj2AXRoQVTSADVb7Wn4MjBIXJ/SN+/gUj0QrSSWfJmSWCBy4SHXG0CpqeXOnq7WkSveWh/JHCqotvAHDgi5qRfI3ern3vaBZpVZzmxxAhICNhRKwOury5A9KTh/cbAxLFhfWCmPpBxF49sBhjSh5p74wq78vo+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458024; c=relaxed/simple;
	bh=2HVcXVhgOW3OWBLuvusGzWKoSjWCoT2erLd9zA5D+hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYKmOifGXQhXJKw1qD5m4Fjbm7+4vRU4fq63qfQ/kZP8TPu2caDYPWcKkLWhh3ibgwP2FXp9RPYWewKg1vrrmDdSVZXWOsCqfCptU/2oFtJ7MrP6PE2JXMxWDEmX9Bw4phF3XVlGTbsz87TQ6dYjLsux+dfE7YKtbfaoFXzg+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRY6pkkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRY6pkkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B7BC4CED1;
	Thu, 13 Feb 2025 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458024;
	bh=2HVcXVhgOW3OWBLuvusGzWKoSjWCoT2erLd9zA5D+hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRY6pkkhb5Yv7EUVGnJFbu+aVkhp1zS9YOkN2/jUYf09n487rS3V2BQA92CuCU3sl
	 Tpjr75VsGKVSrjartrUY11K5ArWte7g5oeeW91hllDnxAd2+c6A3xwuV85hzCsNHlr
	 0luv3D35H4mSkKH4eqJV1wd3h7Y6bXCfCNFLKOYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 280/422] arm64: dts: qcom: sm6375: Fix MPSS memory base and length
Date: Thu, 13 Feb 2025 15:27:09 +0100
Message-ID: <20250213142447.349534391@linuxfoundation.org>
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

commit 918e71ba0c08c3d609ad69067854b0f675c4a253 upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB): 0x0608_0000 with length of 0x10000.

0x0600_0000, value used so far, is the main region of Modem.

Correct the base address and length, which should have no functional
impact on Linux users, because PAS loader does not use this address
space at all.

Fixes: 31cc61104f68 ("arm64: dts: qcom: sm6375: Add modem nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-19-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -1516,9 +1516,9 @@
 			#power-domain-cells = <1>;
 		};
 
-		remoteproc_mss: remoteproc@6000000 {
+		remoteproc_mss: remoteproc@6080000 {
 			compatible = "qcom,sm6375-mpss-pas";
-			reg = <0 0x06000000 0 0x4040>;
+			reg = <0x0 0x06080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 307 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


