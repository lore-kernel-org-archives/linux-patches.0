Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A4E13C816;
	Thu, 13 Feb 2025 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460772; cv=none; b=o1uKr4q9Xt7wXbQJIAjpKVd/8OsO9TqZrhoSmyfFXndaYTKUwZy+Q+c1N+oytlkrYfe5Nh3EtLoyQU2So60cIrewSeNJuTjiOtPG+eidn4mkmhgP+PlFX1wT4fNgQ0FLd7BGKfwHVsPoP3Ks8FDdF7ts6HxcJKQ02Bvigzfwdxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460772; c=relaxed/simple;
	bh=ztm5AtpUMyOiWU2ASIP7Fbsc4zb385Grojicdl43mN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGXx5P9ExoIbeFxrNLxhJw3k5CWm1RmnPlWB+C9xaVig+bD54fEj6VPvT/1qMVMiFh3X7f8hIS7tcVqkqQKzgPX4FTceD+JoLIKcF7xbumnsHzgEA5bA11kaE2PTwRmb8/8fQc7Ot/niAz9aJ/N3kkbigMI8zklH3oAAIqTmh/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eS6UYuRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eS6UYuRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D668C4CED1;
	Thu, 13 Feb 2025 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460772;
	bh=ztm5AtpUMyOiWU2ASIP7Fbsc4zb385Grojicdl43mN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eS6UYuRB7tyYmyiWw9aHvl0JaEuvbjcFfSDZEfUTdcRZjQrW/5oJFz7pGVzmGnhs4
	 5CxDrXwF86CMWc4qzwLct9+EyYco+Kuu+vm6e4m0lq8sTaNCrxjg8iBvhTDuIyGWEa
	 SsHu9HWu8pQk91p4/foEHhApnm4C8FEcFq5g1QJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 176/273] arm64: dts: qcom: sm6350: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:29:08 +0100
Message-ID: <20250213142414.286721860@linuxfoundation.org>
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
@@ -1480,7 +1480,7 @@
 
 		mpss: remoteproc@4080000 {
 			compatible = "qcom,sm6350-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_EDGE_RISING>,
 					      <&modem_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


