Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE1B26B0BA;
	Thu, 13 Feb 2025 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459579; cv=none; b=m/c4yt3DG533wJTn4tmRx14Ts5k220NJ4hj4RdRN8MqdH5xgj1+kLkPMnbH+86BVat7mCNzHQXqOPNyh1rVY8E2jXqKLqdKD6wfBzR0FpCus1XRDjk++JjBZ45n7X7SgBk9SJIe+S/zr4ki5F6/OckhobBfwsk075dluGg9WAlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459579; c=relaxed/simple;
	bh=xazOr+UR+kWcKsPymbunF2u2cBF0yxf84O/eVj9tops=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpfogN5gDKPHhFDgZW5+hdWhvPoFyMo0WT0AD79bySS1UTfXcMbIqqgCH5zVh8y9CA9ln41GtmLegn7bmwc0svyBMbDctwIE9RgZzHcK3hfoLRiAtXQFYSCaX6ZH8PlkiSNL02/6thNwc8zQl02qfQyWwlleeJ6OLWIs9ispM78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRn5BntO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRn5BntO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982CDC4CEE4;
	Thu, 13 Feb 2025 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459579;
	bh=xazOr+UR+kWcKsPymbunF2u2cBF0yxf84O/eVj9tops=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRn5BntO2QG7jKXnrUzZu1KdfYYPz326dpDfMa2zE+irjzKF05nYrCaMnS/oDM01J
	 tNI0p+Vw2B44vGYfus/s9ahGK/N2OTPOiVs9EiV08Tz3Cn1ItHwTD0QfwBJJhpfCvf
	 WrP4GWyFH3k84WXcqmp/vpOBfwncJA/qEn4nP99o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 305/443] arm64: dts: qcom: sm6350: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:27:50 +0100
Message-ID: <20250213142452.385104000@linuxfoundation.org>
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


