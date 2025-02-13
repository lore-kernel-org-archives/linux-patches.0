Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48E821D3FC;
	Thu, 13 Feb 2025 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458010; cv=none; b=jYrIAo6xYneiIUlx59Xh2Pv2ZBFKbZt0fO2MK3r7ANL/GAtauWTSpZUIwSW+z1fRuMvaRZUYlwIxkXoH3NBNt6Q4brLSbfLQvDYy2Zes1plKLV7AHwWn63ubPECeZPGEqak7Y5KqP/FqD8Ne7WNW2UUuCD4o2ylroVS+clROc4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458010; c=relaxed/simple;
	bh=NYZ/9A/Z7fi3hyWh3QNznFGZriuk1XSVwT2xOX+pf0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvuNLuzBELaLCHLAPxWS+DZ2vzqTV6x5Hx7fDY/buc8jNnJ7ALk13YoEfhyf+E9Nq/iLiMSFaw4WdvvnC7nKdR0eEX/vUrkauXVC7VQZjhFuk/2lwbhWPdODNnhSd2d+FgJ/65+zp+JkSmbk3h8Mek0ud/Fmr7iorgdn1B/+xTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VkTug+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VkTug+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251A7C4CED1;
	Thu, 13 Feb 2025 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458010;
	bh=NYZ/9A/Z7fi3hyWh3QNznFGZriuk1XSVwT2xOX+pf0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VkTug+RHKhYoVTeoEM2G9aBGxc47gFnxyDOm4peWWBykD+suLPUn2amNSOCZFfXk
	 i1OKnZ5ub7nvB74x4W4dwbkMngMChitRcEWQkL09MdqQ4g3dUkIsZITnhZwLoRRACV
	 vziSA7fT/FJgjCzsiNjT7CV/6SgSAGo1WFeIDXYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 276/422] arm64: dts: qcom: sm6350: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:27:05 +0100
Message-ID: <20250213142447.192520601@linuxfoundation.org>
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

commit cd8d83de9cc9ecfb1f9a12bc838041c4eb4d10bd upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x4040 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 489be59b635b ("arm64: dts: qcom: sm6350: Add MPSS nodes")
Cc: stable@vger.kernel.org
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-16-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1503,7 +1503,7 @@
 
 		mpss: remoteproc@4080000 {
 			compatible = "qcom,sm6350-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_EDGE_RISING>,
 					      <&modem_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


