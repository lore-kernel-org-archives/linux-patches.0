Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841B72222CD;
	Thu, 13 Feb 2025 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458066; cv=none; b=DAyWrp44mCz13BcEnuQ/nelov/BrMOy/WZe8wEd83yomqVAJ/Ua11PVuTVXL7KZi99lEATohZGYWsx17dE9F/rdTSREUpNymtJw8deTuoW1i9j2F/yCm6cjZuP3ydR8pUSi8GlshdrEI057ATXT4pO0Dkk2P8WePiag8A+e+GXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458066; c=relaxed/simple;
	bh=vtrQwQHWExkI4Ovin7Ig09pZw4rThpajzhM9bTf/Ics=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR3u6OXnskOQ25iFKQQ3FWAbUlsb6CvGKJ8bXX/YbWutuTR2x4U8CEu+xeooUOrZxNnkSpACOWL1H/6JV2uHF7VKPa/Cf7sDja39AM/HePxN0JB03luRP3OJ4mXBRuiUml3CxiPow12BPh4KkfNXcJb8HD17wBrTCYXqmBz0rzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyzFsK5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyzFsK5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854FAC4CED1;
	Thu, 13 Feb 2025 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458066;
	bh=vtrQwQHWExkI4Ovin7Ig09pZw4rThpajzhM9bTf/Ics=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyzFsK5SdsKVPe5yXcu1zQtW12DPBhL31BUII538c2Z7FQV6jTUaiPrUzt8rFUxU/
	 avZ/S5lMWi3rWEGWqVHPLCC85on/JI86PXglfciGUpBkaLjckLXIcWVauYBsmaF8SK
	 mc7HjCBKK/gVZtZeiAU7uSgWc/UKnYUut31VyiO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 291/422] arm64: dts: qcom: sm8650: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:27:20 +0100
Message-ID: <20250213142447.774633452@linuxfoundation.org>
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

commit aca0053f051625a224c2e802a0e88755770819e4 upstream.

The address space in CDSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x1400000 was
copied from older DTS, but it does not look accurate at all.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-11-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -5483,7 +5483,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,sm8650-cdsp-pas";
-			reg = <0 0x32300000 0 0x1400000>;
+			reg = <0x0 0x32300000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


