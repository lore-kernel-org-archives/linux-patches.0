Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2533E23A9BA;
	Thu, 13 Feb 2025 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458059; cv=none; b=ohnpydtGFBA5yr6LPC2fqeXC8bdDZpDwL24H5LKncWiPKjyDNr7zsWc7jEsWMP++skTTxmNCWWg4Y3F1i2Wr/L5UJ0NlwlqfbMFlcGgS/nSfCHkIVF9a9Z4bDyjK1FXJrZNGRna2G1RkrxGnUQMRKvD7Uo8vHJvRYGYyRe3gnjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458059; c=relaxed/simple;
	bh=MXp0O4GyBJBczkCC6bs8vpBJXo2gDaBQBnkeA93D/uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNKjCScUfyNmM/uLxRiilPQrVFo3WUIsGGcI8iW2cwqaEBpS0aD85IL6c6xIHZ/iku84Pekqh7AQEdNLD+oQ28f/8S+w9BhCsNAhAAahqmb2RLokLM6Jp9HzL4BNIlx6l+RrZaq1nvfpCTZXQ6TXC9S764EAkH4MMl6nHaW45C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTxYv3bF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTxYv3bF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76664C4CED1;
	Thu, 13 Feb 2025 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458058;
	bh=MXp0O4GyBJBczkCC6bs8vpBJXo2gDaBQBnkeA93D/uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTxYv3bFENfaYfDuGIeHpd1LhHHlhbw6iMHp2k1XvW6Wa7S2EEtsDNRdUHNUQH2Im
	 So5bh1W00I7Tk4EQWrvAc7eXD2eSUrE98UOSkjYU/sOKIIQ7QFPuoNlOlTiG/uNrTc
	 HGV3cPZayI7tkyDBUXp3t9oPSbvGKWBchweVIljA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 289/422] arm64: dts: qcom: sm8550: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:27:18 +0100
Message-ID: <20250213142447.696558705@linuxfoundation.org>
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

commit 8ef227e93a513d431f9345f23cd4d2d65607b985 upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x4040 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: d0c061e366ed ("arm64: dts: qcom: sm8550: add adsp, cdsp & mdss nodes")
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-9-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2313,7 +2313,7 @@
 
 		remoteproc_mpss: remoteproc@4080000 {
 			compatible = "qcom,sm8550-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


