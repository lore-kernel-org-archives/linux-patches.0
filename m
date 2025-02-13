Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5983E26B087;
	Thu, 13 Feb 2025 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460769; cv=none; b=QP3uBQFako2BKUe9a6CDjy76OaGjCpda3r6lQ8qxHIVGtMEfQpHLI3UawkDJAHuUoMU2RxA1YfMVfEkHXBziSqoA6lfcVT2+TrQWR5FNK3Cv9wVZcK8ZBKdK9LDc98HtyC6TPw9dDd2gKNT/KkWug7hwRVwWGXyfZmjm7uWC5eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460769; c=relaxed/simple;
	bh=vxDDDzqf4xVjC+hYKA7qZ5NGBnml5dOGAc7pE36x9to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d231hCtqGe2/h7cYuUC9QAcl108uKbdJrVfxVzRtpi6mU//yPmXbL5y/fSJHfvg3V7parLkoIUvrjoWPw0ULx42lbA7JX2xmROEhsjO7kaYkcOZGhZdYOFLZt7ft2dGbUMBXS6wo0RLuVm84Uqxio9gfNXJYT+3MRzhYCAjcjEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfkdsW6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfkdsW6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D3AC4CED1;
	Thu, 13 Feb 2025 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460769;
	bh=vxDDDzqf4xVjC+hYKA7qZ5NGBnml5dOGAc7pE36x9to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfkdsW6tFwtK2V0VlhhCj1/CS1ACqPB+yWU8O2FKE/LKBVCMXNrBfVRO7wz/oC6be
	 qgm+badZoKTrTIZVDdmJH4QF4XBCUzmNj4v2kSzPUSbnot2S+ekXoEOTK7706TWAXA
	 k/ml4NO1/ynM5R8/tMkITtY6th84MiKj8HUpXvAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 175/273] arm64: dts: qcom: sm6350: Fix ADSP memory length
Date: Thu, 13 Feb 2025 15:29:07 +0100
Message-ID: <20250213142414.248105363@linuxfoundation.org>
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

commit b0805a864459a29831577d2a47165afebe338faf upstream.

The address space in ADSP (Peripheral Authentication Service) remoteproc
node should point to the QDSP PUB address space (QDSP6...SS_PUB) which
has a length of 0x10000.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: efc33c969f23 ("arm64: dts: qcom: sm6350: Add ADSP nodes")
Cc: stable@vger.kernel.org
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-15-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1259,7 +1259,7 @@
 
 		adsp: remoteproc@3000000 {
 			compatible = "qcom,sm6350-adsp-pas";
-			reg = <0 0x03000000 0 0x100>;
+			reg = <0x0 0x03000000 0x0 0x10000>;
 
 			interrupts-extended = <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,


