Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5D26B087;
	Thu, 13 Feb 2025 15:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460759; cv=none; b=UxshpyM55pUB5f66es03XD9noZ1/1B/3lAXk8ipM0F0dCjVKih6YLcWel1kU/xclhCiREx2UdCGvXYheQI8tYyTZuHGQd3AESlKSDEEYENQYD1AZz14dtO81zqgtAVdmheDS1cmkMzd5vILBm1LL2tEWF0Ks8FHL7FuLIcV8cMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460759; c=relaxed/simple;
	bh=UwAWjwp4hU6MYAoMlwumdSq76BR8wNsBAx9h3PxO1S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyZwQTjsW0L52DYelhGJ22GMB5fLC6ewGiB0CdoS2wesKlRCNbMMQujfkqN2QwFB5LG4H1fjjmu+JiMyjDSviv0Eie5ButLQLJwS+zjBEADN0eSdl7IntIN+/KS9kJ1PTIESle1uhu16eCA7Zb2x1kbPoIwlQqJlATN2GLx0ilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsGz5Res; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsGz5Res"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5913C4CED1;
	Thu, 13 Feb 2025 15:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460759;
	bh=UwAWjwp4hU6MYAoMlwumdSq76BR8wNsBAx9h3PxO1S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsGz5ResCboOwZf5vKRqRxSv+nGClGcGstPD7tinaTzSPC+lhlzrBieMZV7CNQchE
	 QacrA2JMcZT8w7CkDfq43eJmSkcTbxFbPjbgPQwT8QCaCtn/RvZGLnUN4fwgsyGMdS
	 BI04MToFVfT3u2agr2twb1anNNoFaOKWUY2fLcvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 172/273] arm64: dts: qcom: sm6115: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:29:04 +0100
Message-ID: <20250213142414.128775345@linuxfoundation.org>
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

commit 472d65e7cb591c8379dd6f40561f96be73a46f0f upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x100 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Cc: stable@vger.kernel.org
Fixes: 96ce9227fdbc ("arm64: dts: qcom: sm6115: Add remoteproc nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-21-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1667,7 +1667,7 @@
 
 		remoteproc_mpss: remoteproc@6080000 {
 			compatible = "qcom,sm6115-mpss-pas";
-			reg = <0x0 0x06080000 0x0 0x100>;
+			reg = <0x0 0x06080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 307 IRQ_TYPE_EDGE_RISING>,
 					      <&modem_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


