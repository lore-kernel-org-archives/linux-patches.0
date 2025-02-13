Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3655F221720;
	Thu, 13 Feb 2025 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458021; cv=none; b=GDsFw7jQW8Lxq6L4WLMhDiyvIu9cUHEPAzkVrbAl62Np9yYole4p87NKKbmFEA1WqjqegIIkhyXcYdaIFmj23z7ZMFKvdCjvSlllcJVfvHlIoW+9DU4zSe+8/63Ci1eZ3VvE5LNRLi82DIOxxIlLw2xbii3tvbm2q/z7JoG1cXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458021; c=relaxed/simple;
	bh=NgDXTJVWsQqxrLUq4NgidVPP3/NBD4HAFRpVmvNtagc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaMXlTqplNTNH00VF1JRZKx4r6pz0nuiUxJF8ty5I/acX8aS7bhLqYs1vp4CIhPJTp8dcyKLUiYNLGGoh+pXPeknnzFcVWVEkSj2erxVXGZhbVI6hTI/OovggZYO/dud6ZIRnGeNFJ+7Tk3b4FUov8LorgdMhl5Dwl5CAHpx798=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCNIOMJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCNIOMJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED6BC4CED1;
	Thu, 13 Feb 2025 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458021;
	bh=NgDXTJVWsQqxrLUq4NgidVPP3/NBD4HAFRpVmvNtagc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCNIOMJmk1qAsF73lBtUOWE/3OGQO7vf1hp0iGwpjM0KuZ+8ys1DVCVsObjvYs6zL
	 uJHaMSiMqt6gTwS9eVk4cLx9vzo7ZJH0ALGcZJOC4L3MKBHDTX+2I5rJPUHeeLM72f
	 LDWim97h5anr0XmrXvwC0WVzvOkJSV+BhPKrefgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 279/422] arm64: dts: qcom: sm6375: Fix CDSP memory base and length
Date: Thu, 13 Feb 2025 15:27:08 +0100
Message-ID: <20250213142447.310508157@linuxfoundation.org>
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

commit c9f7f341e896836c99709421a23bae5f53039aab upstream.

The address space in CDSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB): 0x0b30_0000 with length of 0x10000.

0x0b00_0000, value used so far, is the main region of CDSP.

Correct the base address and length, which should have no functional
impact on Linux users, because PAS loader does not use this address
space at all.

Fixes: fe6fd26aeddf ("arm64: dts: qcom: sm6375: Add ADSP&CDSP")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-18-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -1595,9 +1595,9 @@
 			};
 		};
 
-		remoteproc_cdsp: remoteproc@b000000 {
+		remoteproc_cdsp: remoteproc@b300000 {
 			compatible = "qcom,sm6375-cdsp-pas";
-			reg = <0x0 0x0b000000 0x0 0x100000>;
+			reg = <0x0 0x0b300000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 265 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


