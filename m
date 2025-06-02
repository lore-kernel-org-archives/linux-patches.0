Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E98E221729;
	Mon,  2 Jun 2025 13:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872162; cv=none; b=W5FHQ78Uzet3MCrUgZP7lcnNA54H6vr0jQt+B2g5ZEeRfOSmP/HQl9XoPh1dDsSPPOBpC6M43ghbBoinTyqXc6HqXBJAMJtDtTazpbc1mwY9zo1PjItZYyg4N5ZgJERph+a1yDvHgRf1fsGeltfiOyFRt/PiXach0C5CZlCfimI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872162; c=relaxed/simple;
	bh=BExlBKhPciHkjBukf/UJ5FYeh1g0KzTm4374Z2Tyf4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRxhT2dszleY1bRddfPJRitF7Ezl8MnX5g22rhzptHcQYxrO2e8yTCbNlVIVBap51xvAy67I5R01isjnrdKYqQyhGb+zKvyQD4K+n6ljPB5mny65GeAHL1MeAiG6KJhwyDPEivWfO3Qiv+f67mbQoYke9kHGcBLt51ilzF4K1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8PBM+zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8PBM+zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CB1C4CEEB;
	Mon,  2 Jun 2025 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872162;
	bh=BExlBKhPciHkjBukf/UJ5FYeh1g0KzTm4374Z2Tyf4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8PBM+zrbz4XH06sZwbFwVkvEogRcpDztzasQLK4LyrdD08WeMevFM8KYcTIr2Y2I
	 nDKBMf7+xULZu2RfpmLU67ufixkU/9bxjbhWCKNRkR8cyBd3x0DR7D9+mxIxcOEmV6
	 wYwPu/7axbGDEAhTrf3P6NKVea1+lkamsUEbZlzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 09/49] arm64: dts: qcom: sm8450: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:47:01 +0200
Message-ID: <20250602134238.308007334@linuxfoundation.org>
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

commit 0fe6357229cb15a64b6413c62f1c3d4de68ce55f upstream.

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
Fixes: b92b0d2f7582 ("arm64: dts: qcom: sm8450: add crypto nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-2-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5283,6 +5283,8 @@
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <16>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x584 0x11>,
 				 <&apps_smmu 0x588 0x0>,


