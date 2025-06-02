Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7275A22129E;
	Mon,  2 Jun 2025 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872074; cv=none; b=svG8g7agFvajZ0hKmF0vpO7MTrSUJe4Za57fEibCRwIZxXZCSyHH2tHjTqLOCT6W5pqVRcSg0+OYcctUOa7MmGoi20YI0CMJ/QalsHC4d1DqsRlSATqge+a5dGdQmku1eYoUBcz5g2LsVaBwUgeVB/AJRnNDORCSFl37Y2zaOZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872074; c=relaxed/simple;
	bh=Yv1VqGyyMvrA0x6VnuBUZjEQ4l4J4B1UCd0Sq1YY8C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWIv/BzQSa2jD68QbmPPcMEc1f/ay7D/uVJhq7FUatq6anACR9RIoZ2qd6t22qPlMhUC5A3BplRMancdEcLKPR0RgkKLvgqM1HruYrldKYek89PN4dCWfQVv0tCgZLsT8KTYL6CiCveb0NiTldKmL7p9s//Hc/dnyiRrj1nAt0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQ4+Sqt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQ4+Sqt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789F2C4CEEB;
	Mon,  2 Jun 2025 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872074;
	bh=Yv1VqGyyMvrA0x6VnuBUZjEQ4l4J4B1UCd0Sq1YY8C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQ4+Sqt06k1Mx3w6JWrdeoxfIqWW7YL+orv3ltfZm5GN4vMw3OY4ele8KAdZ1oHZI
	 q4drpXDedm7BU/5oq3BFABZu5R8VRTT33ousmIPAGyNGpc4tobh3IaJ9Ai5Zu/qFFz
	 mz2L87JdgzcEba6CJbPJueXclDz2iaZF7k7Bjkds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 10/49] arm64: dts: qcom: sm8550: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:47:02 +0200
Message-ID: <20250602134238.345143876@linuxfoundation.org>
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

commit 663cd2cad36da23cf1a3db7868fce9f1a19b2d61 upstream.

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
Fixes: 433477c3bf0b ("arm64: dts: qcom: sm8550: add QCrypto nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-3-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1957,6 +1957,8 @@
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x480 0x0>,
 				 <&apps_smmu 0x481 0x0>;


