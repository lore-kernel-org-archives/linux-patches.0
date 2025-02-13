Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1BD24BBF5;
	Thu, 13 Feb 2025 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458045; cv=none; b=LQH37ktXplAJvGmlQlSDwqh8qUPy+qWEyYPZpZPzl0bo8fGBgrA4/RO9G7yvxuVB+Y1U62ys6yeUftvyyHxHB3kNcsfbxtHaaipduZ4FG+qhqShUCUeIPUEVlTdKv6Zdv3QvAqXgzeiozOX8uMi9lFK+AhVCgYqep5rV26YCk7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458045; c=relaxed/simple;
	bh=JD5ZR32FaW2twtOXbxrY8rz+bwi/RW5vtlevSIE5LgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmC7PQa6cxgswlF0ip7c1ONH528BXHVkH3VsYhNpFQ0ji9s5+3V5bOLQ88oISKiDsth/+Qq7uoCN74spXb5xKcJu9jfKDHTiYZHZldPMLZoMaPMZVAmvCQ9gBlwVQJ26YYgbvWPeaPsp2dDHP5xi3cRydvhIXCtzMuFNOh4tyos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTTF4ptu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTTF4ptu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87E6C4CED1;
	Thu, 13 Feb 2025 14:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458045;
	bh=JD5ZR32FaW2twtOXbxrY8rz+bwi/RW5vtlevSIE5LgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTTF4ptuKWRmWbFUzS5oF16gKzJXTYCWpI0Gb+C+C0k01dEVMXxqvYtVhaggtPds+
	 FcoAKFTml9UIfPcoKo7oCrz2TghuTbWjdwfrpUAo30Cog9ezclQaOGSoOMPsLG8I/m
	 eHHufeXCfMsViHmTaPf5iSpypTo+8b7Qh1iEqDzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 285/422] arm64: dts: qcom: sm8450: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:27:14 +0100
Message-ID: <20250213142447.542860853@linuxfoundation.org>
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

commit 3751fe2cba2a9fba2204ef62102bc4bb027cec7b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2796,7 +2796,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,sm8450-cdsp-pas";
-			reg = <0 0x32300000 0 0x1400000>;
+			reg = <0 0x32300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


