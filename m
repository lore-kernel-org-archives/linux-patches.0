Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315E826B083;
	Thu, 13 Feb 2025 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459629; cv=none; b=mVdwxaQTlfgfoUsaLMckVnICvWY53B7dbmxe75/1X428DEe+5GbuGGcJUP9h/7As7L3QQnltk4WwEn6aIP+cLS8Ua67GzjwfTGuzTUhBHg5s95apNdn/Zv5rbuw4poZj+v45S0IGTtz267k+HW6P7gHJ9WvEhYl1qZByafwWuK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459629; c=relaxed/simple;
	bh=VGcdu7mRq8ALPOp+4gqBmiGU6WevGnluLYZsgptqG8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBUwj74uLgdDWkd1LOmH3hL1J9B4YGER2+TIrofjUogtmHNNuU/MjuW4Ldk6gjf7eKIm3ZPVprHn4FjlLNDHICJgP7RSiKADTj2IK3ONzjCB14BMWw34gNCd0IdsVRXHhlikyptvIc5TPiXCQDHLUUyACQCnniys+aCTg1qvvyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrZ9cK8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrZ9cK8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9323AC4CEE5;
	Thu, 13 Feb 2025 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459629;
	bh=VGcdu7mRq8ALPOp+4gqBmiGU6WevGnluLYZsgptqG8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrZ9cK8g69izUa6TR3+6dq40oEZMFsJayCnrtq2NXmlmnu6Q30RReZHrLc/arilUu
	 faJLsPnOHmjqAAqnE0RhT33IWjNUDB9Fu3TryZsSiIANmQWO+u+21QDknwiO+Bpezh
	 KFlIf1fA4R9AHtX8IuTjgdtceddvdN5fgqNALJPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 320/443] arm64: dts: qcom: sm8650: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:28:05 +0100
Message-ID: <20250213142452.966404526@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5481,7 +5481,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,sm8650-cdsp-pas";
-			reg = <0 0x32300000 0 0x1400000>;
+			reg = <0x0 0x32300000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


