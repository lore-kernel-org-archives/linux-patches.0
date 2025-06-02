Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402231F5846;
	Mon,  2 Jun 2025 13:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872669; cv=none; b=bajvcmZY4kTvhN8HNTqogcTmUDjHQ7Mdp//+xfl+HXVdM8X4plwgE0E+0aUBXbUYNTtHt0Xk9KsQ0McgOzoWQHnVIxFgjXXJhnRCVKFFx5lgY7BuWcpK3SdJ3ECEwaOYuuePYUx8o68zEYHM7ue/4kQ83+6FEErBX5vposTqd3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872669; c=relaxed/simple;
	bh=R33AvxJy/kJQK/Lw+9R0x6nLFE5rOnTJdK5ILvnMKgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/gQY2rBrQ34AU4qnRhgZ9MderW99R+X9Wk2gkPvoxUXxEzRLpwcYYMX3z8ml/XyuUkyLtEjpC1uPDKSVK5lGpZlLK9SKkNHX0KN1eOEAzTGAlGyf/V29lY03U9fy031CwiPiqFWPGD1j+rdzOpteE4lFjXd4pNV+S8QCxYEHvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbLF3hXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbLF3hXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA7CC4CEEB;
	Mon,  2 Jun 2025 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872668;
	bh=R33AvxJy/kJQK/Lw+9R0x6nLFE5rOnTJdK5ILvnMKgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbLF3hXRw1JuXmZS9nW4w1o9/QV1ei/QnfDxHE4IaX47pkRi2WUl2tDZM9kTF4Tt5
	 1qfUjb/c8QjiiGkqtxDzhBvMWLmmVLV42T8VAJNnGYlGyfexZ/fR/hoHQP+IZs0/y3
	 EAODG0n3kVSgmKECz4KQbGBO20mkW7MII/q9IdNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 05/73] arm64: dts: qcom: sa8775p: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:46:51 +0200
Message-ID: <20250602134241.891577019@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 23049cc58896..6a2c49047df5 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2413,6 +2413,8 @@ cryptobam: dma-controller@1dc4000 {
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x480 0x00>,
 				 <&apps_smmu 0x481 0x00>;
-- 
2.49.0



