Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C189211A0E;
	Mon,  2 Jun 2025 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872150; cv=none; b=ouQ9iqe4D90CRZR/ID/MrEuA2GcvpdvmW6hvLXUv2B/CLr9lVVQhdESheaCmNl06iG0visyIE0BXj2FbVzMqyg3j7p7TjF4AKkNSb8y9hxbcv95XpGuIvVuatIYhGe5ayeDjlAn452qbN3E8rMmNmBUyBk+bFjR7o3Uc4+N4WiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872150; c=relaxed/simple;
	bh=ycSm1rdhQK4wxK83Zkr0Q8l+FtL86iVTUyfmAh99dnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX4/tnahvKHeLIKvna4Tahleov2kArgv6R9JRZ5wa0TaDymvwCW4x4CSmcEn7Z152yaHjQganArj4DdhYnt/DdhIslafoaSu0wFnB0XQMV73i+9frmTxG3CrBp6X9C1ziR7ybRsm5B85Ezf8qnT5zRVmH8OD1hSUUbqeBKisgS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQoX0Mve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQoX0Mve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FB6C4CEEB;
	Mon,  2 Jun 2025 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872150;
	bh=ycSm1rdhQK4wxK83Zkr0Q8l+FtL86iVTUyfmAh99dnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQoX0MveAGn6N5Dm0xBrBnOBWTJkT+662iRvTJLXu2iC8+Sv/sM0remeLbVT+LwlJ
	 jRWZAo7SL3LniOJXboWcwoNAFx0Q11xXv/sZQFGeTbhgnhtV5RrrcxI2zr3QtfUCjc
	 djzLMX0ohdEeaBvHRBDqlI8TrwB4odMTNq05f4ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 05/49] arm64: dts: qcom: sa8775p: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:46:57 +0200
Message-ID: <20250602134238.152491307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit a2517331f11bd22cded60e791a8818cec3e7597a upstream.

num-channels and qcom,num-ees are required for BAM nodes without clock,
because the driver cannot ensure the hardware is powered on when trying to
obtain the information from the hardware registers. Specifying the node
without these properties is unsafe and has caused early boot crashes for
other SoCs before [1, 2].

Add the missing information from the hardware registers to ensure the
driver can probe successfully without causing crashes.

[1]: https://lore.kernel.org/r/CY01EKQVWE36.B9X5TDXAREPF@fairphone.com/
[2]: https://lore.kernel.org/r/20230626145959.646747-1-krzysztof.kozlowski@linaro.org/

Cc: stable@vger.kernel.org
Fixes: 7ff3da43ef44 ("arm64: dts: qcom: sa8775p: add QCrypto nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-5-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2413,6 +2413,8 @@
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x480 0x00>,
 				 <&apps_smmu 0x481 0x00>;


