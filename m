Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0F626B0AD;
	Thu, 13 Feb 2025 15:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459612; cv=none; b=GHynGHV6w/ajI4ygo4amgp80+2egGwT32vaaQiMBkSLJWBreza9e34Z5tjGQja+5BwR2PvmDM3ejTs1Vc2022AHWM/xvBNBvKufhs8QtAB3AcGl65gh0I9Iyoik1tRTNK5peRL0hFiaqL2KVKfhuqo4yxS/GN49S0R/yBKkslmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459612; c=relaxed/simple;
	bh=sTY0vz1ppGua8xWCGwBGHCIRa5Xu7E5IxfJVY35pF/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2sczTBS8zdJdMh67brOZHXANSJXj2OuMVsXMltROSOSKocaHhrftLiJ/CT4eMG7BMC61x49YybmbyIq9zpL8Pj+RRx9NQiiHXbrWmqIyKkLjSyAPxwwQ+iAZlhV8Jz5eipf8T5Ps8E8R+Gh9OQUe9p6tZ/R304uTTwuUhxBvUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcP0PRhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcP0PRhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A50C4CED1;
	Thu, 13 Feb 2025 15:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459612;
	bh=sTY0vz1ppGua8xWCGwBGHCIRa5Xu7E5IxfJVY35pF/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcP0PRhEm6sZHMpcTQHscoXDdaFY4HCqCL6VgWX1gOk8xZhjCok1EHIHS5jHhq4V8
	 GvKhnY89mq0eSL1f3jP7Yr0MBWQgJ8dbkD0kvSghqwnyKE+dUTLRW4SKsXzMqI7WG7
	 x8Sr99MXVkP8kUxO7A1xBIEWnuzqa1aqBv+LOpVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 307/443] arm64: dts: qcom: sm6375: Fix ADSP memory length
Date: Thu, 13 Feb 2025 15:27:52 +0100
Message-ID: <20250213142452.461697427@linuxfoundation.org>
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
@@ -1559,7 +1559,7 @@
 
 		remoteproc_adsp: remoteproc@a400000 {
 			compatible = "qcom,sm6375-adsp-pas";
-			reg = <0 0x0a400000 0 0x100>;
+			reg = <0 0x0a400000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 282 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,


