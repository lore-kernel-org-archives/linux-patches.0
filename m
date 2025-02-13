Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF81F26B096;
	Thu, 13 Feb 2025 15:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459569; cv=none; b=F5o37NEMbk37E32vzDlcqa0NZX/6rmn1c0E3pgwayQlXCVjajTi5UPHtkmtzc0fW26vZKlu6U7XpzqzMMa1ATbAQAMHrUy23xSOKdH/WRh9gloC10liLD3N4KoQQO+6/NCfTWyvH9QGshM82uE3oFwlMQtYe/QS4maBBhwCns80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459569; c=relaxed/simple;
	bh=MWBeeHO9Am2pVKtJ4PUx9NXwSjJ15jxHhIHpP880iyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyxzvGylTBMxSJLloqjQ56ECyF7HTR/s9PwivHzMnSpjwDQaYzVRAoVnZ28zD2DquVLxaWpPwO/7OrXCKGFvw5QUPUiwN9jgO4IB1aWBGG7D3kxuUqUE+/PZ1Ap7Pgqo9MCKn9BLNj6WPs9KKDSkbfavlli8xVj19FsFpAYkHAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odsM9+p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odsM9+p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E08AC4CED1;
	Thu, 13 Feb 2025 15:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459568;
	bh=MWBeeHO9Am2pVKtJ4PUx9NXwSjJ15jxHhIHpP880iyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odsM9+p3uEomWrWK/Fie01n0jNKtG1TJJMAwc9BhrU7Kqc0o2wZgkWUQdYpRCCaQ2
	 TlIqV6uVuw2ly3piyqXtpGtMYTGBtVOZF+8WP9eHKbnIjCZujBXt/0j5ioJCpof9/J
	 Z3SCAf/T+j+OknFiN49Bhd+FITYLRgTCglRsOWto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 302/443] arm64: dts: qcom: sm6115: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:27:47 +0100
Message-ID: <20250213142452.267276763@linuxfoundation.org>
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

commit 846f49c3f01680f4af3043bf5b7abc9cf71bb42d upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x4040.  Value of 0x100000 covers
entire Touring/CDSP memory block seems to big here.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Cc: stable@vger.kernel.org
Fixes: 96ce9227fdbc ("arm64: dts: qcom: sm6115: Add remoteproc nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-22-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -2744,7 +2744,7 @@
 
 		remoteproc_cdsp: remoteproc@b300000 {
 			compatible = "qcom,sm6115-cdsp-pas";
-			reg = <0x0 0x0b300000 0x0 0x100000>;
+			reg = <0x0 0x0b300000 0x0 0x4040>;
 
 			interrupts-extended = <&intc GIC_SPI 265 IRQ_TYPE_EDGE_RISING>,
 					      <&cdsp_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


