Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819BA266196;
	Thu, 13 Feb 2025 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458103; cv=none; b=fLxl7RlyZo2j7rdBxiPPi+gtrWZwZDhUCDQ10erRnj6PYA6Bl6HHGo9Z0JY4KTCuyG1gDC1GC9r5QOex6z4wv1jyek8FeIzg+w656Pu0QGd/o1pFZIMzTXwCc+q5YSqlgRZKq+LIRkklH+bGzCHikC+N+yrhWlhRACHgSOY4PAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458103; c=relaxed/simple;
	bh=Fl5UaUcKp5Bg2QV3CY7Ofqohte77pHgrBwZob6Xhf7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bazl89tp4pnge8ZVakHgqPBEv61KNoz8U4wyKX4bv/pRKOPjcLTZocQfdO+JiDVhhadVlLT8P/hK+F36+ynRG2N/s4hwEZ12KTZidi/JuBldl3uyLb2wKXAW4MohJW1f8B/sqeaCQ9NPYfTlD6z04uK5BmrcQ0YwFixOg4qPx/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFwAS3yE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFwAS3yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ED3C4CED1;
	Thu, 13 Feb 2025 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458103;
	bh=Fl5UaUcKp5Bg2QV3CY7Ofqohte77pHgrBwZob6Xhf7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFwAS3yE2SsI1vxQkGpwlQt3M1GN/QJZqArD3k5IW9dBfHQm9b3r1In0phaW3c1mH
	 u4R8RGL6YIdAUgihNbhAU+GP6xFMuNUYJi2yZ6RhDnA8D0/9n6J9P/06FCzdXyk4w4
	 EDObnllcc+wf1HIDU2h3+DhODQvBAiVyCahi3DZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 271/422] arm64: dts: qcom: x1e80100: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:27:00 +0100
Message-ID: <20250213142447.001737093@linuxfoundation.org>
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

commit 3de1bf12c6bfb9a92f0803941ecae39b08470446 upstream.

The address space in CDSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x1400000 was
copied from older DTS, but it does not look accurate at all.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 5f2a9cd4b104 ("arm64: dts: qcom: x1e80100: Add ADSP/CDSP remoteproc nodes")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-14-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -6247,7 +6247,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,x1e80100-cdsp-pas";
-			reg = <0 0x32300000 0 0x1400000>;
+			reg = <0x0 0x32300000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


