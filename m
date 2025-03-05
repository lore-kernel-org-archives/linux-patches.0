Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4731946C7;
	Wed,  5 Mar 2025 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197066; cv=none; b=DdLp3iYvJKVpU4zrZCZ6S1VWkieX+rFeSTvzuMLB6s9J3LTmdkh1K/WEhvzJbN/uYhKfPA2mASrjaoejScSxRgNxE6yD79u8zWi6koxeA+ul11WKA9FbYYxICQPD4KmUtDqSfGV6E72r86ECyfob9X589L2vuOiavYGVerl5m+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197066; c=relaxed/simple;
	bh=QBfP1r0fUJI9SaCP1ZMuJ0w82MWXJP/pMvREZJQjvkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcpRH9Dx6KL85+rH2JcGAZkULjPy+YwZe2y5quChLIcdjLC6y6JiWyBpxRwl/50Xvr1kwi8onVI7sA40cF7yn+B0Df9ZDwQoqU918HcZQkW93JUw3XMOHW0PhCRiwKg3G6wZouyNef8Xvj7Nwt7B027zHNIzdExpnXCAnLfFnPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USb6TcBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USb6TcBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD22DC4CED1;
	Wed,  5 Mar 2025 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197066;
	bh=QBfP1r0fUJI9SaCP1ZMuJ0w82MWXJP/pMvREZJQjvkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USb6TcBpuMFYE9uPzbs/WXAtqkT/gN3C6ABcz3tz+uoDI+gYDN5+Xh7szs6LrF4l5
	 Lmd+cio+HBraFY/dge6zZK5lS8pP49OSCunW2H9Ff64y9o6FY+y0G+XHwb++1CB3Ep
	 BQSiSs5Q59m7aP/E7YmAQ61cxA/drt4igYGfsY7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/176] arm64: dts: qcom: sm8450: Fix CDSP memory length
Date: Wed,  5 Mar 2025 18:46:36 +0100
Message-ID: <20250305174506.552330967@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 3751fe2cba2a9fba2204ef62102bc4bb027cec7b ]

The address space in CDSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x1400000 was
copied from older DTS, but it does not look accurate at all.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 1172729576fb ("arm64: dts: qcom: sm8450: Add remoteproc enablers and instances")
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-5-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 9151ed3b0a62f..9420857871b1e 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2159,7 +2159,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,sm8450-cdsp-pas";
-			reg = <0 0x32300000 0 0x1400000>;
+			reg = <0 0x32300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,
-- 
2.39.5



