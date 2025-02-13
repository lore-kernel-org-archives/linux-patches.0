Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D52926B098;
	Thu, 13 Feb 2025 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460663; cv=none; b=kQIu4r4pezi/IEboG1bSCuPLyX4biz4bpyAYZKGoUqrwQbDn3f8C9HrMCXggQnpwdaBbnAhHdZg9nGgPDhgOKWOsfjBLYdbgGqRee/ttXOrEgvzfoO0urVGiIUMqTDstZY57Ot6VriqQMkhvvvo57OWtSd0WXEBXSJNx+GxLDgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460663; c=relaxed/simple;
	bh=onnV6hLqXxWbKEr7fq4B20z13SKgZ7HpK03a+qJBobU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6Evo8hV/xP9zifHW7nXG9XHN20tOR0f39slZUZ+cgL3CvTJNY+SHy6ktwV33R1qGFpL0tzNMQ2zmLIPXpksAonhknVRFmNHbM8swpgKRkSevHgBNIdZiSg5adDGY8Q7flOUASY1boNRXhheMiIc3IEchz8ZltaTxNK2RxaQ5cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OydzJirE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OydzJirE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219ECC4CED1;
	Thu, 13 Feb 2025 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460662;
	bh=onnV6hLqXxWbKEr7fq4B20z13SKgZ7HpK03a+qJBobU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OydzJirE3tJbx2rvfgX/zH0Q/ja4R8365FLl37d+jb6ENTDcRWDUIsnDmxX5cSlSw
	 KPUIM/Dq46pn/nweQbfc/qpZEoA728IoGowk7aVVIIdB1Fh9fyTOtJlIsrUIJEG7xQ
	 bsPDZWuIaFT5zMJn8Z1/3k9oAOQKDjaIlh77d6kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 178/273] arm64: dts: qcom: sm6375: Fix ADSP memory length
Date: Thu, 13 Feb 2025 15:29:10 +0100
Message-ID: <20250213142414.365090737@linuxfoundation.org>
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
@@ -1514,7 +1514,7 @@
 
 		remoteproc_adsp: remoteproc@a400000 {
 			compatible = "qcom,sm6375-adsp-pas";
-			reg = <0 0x0a400000 0 0x100>;
+			reg = <0 0x0a400000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 282 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,


