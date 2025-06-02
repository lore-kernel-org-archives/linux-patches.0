Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBF71E0E08;
	Mon,  2 Jun 2025 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872893; cv=none; b=MkGq9Ai6vsSpkbGtKToDSa6RtabKiJrC+8htf46bn7kUh6E2baqk1bo/uQed9GphhQV4ZmvaG/NufWmVoYWJPH1MRfCSWiBBSkPMT/FU3acc209CKiJ5Zmlu8qdNapciJUBCim3uOJdBpnXb00LHZLOzNvLj6XSViLca0aGZamM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872893; c=relaxed/simple;
	bh=4AmJ4A22FZ+996VthMd4qszbsFcxMxVz8d/HKZUaEPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBv/Se2ZCrG6A9w5TD1Ntnsqlnr/jNQRCb7QsuxytpdgQcvBl01d2SGnceM87YJnrB0GyRSiETt6nSn3AjEqD7/x+LI3YwWo3XvDp//vAaYcoprwlPT3JMnq8I1NMOZtzsW9jzdXQYX7ITLgG3KIbEVy4hkc7NHZzwNmD6po2ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCm8Ut7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCm8Ut7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0A9C4CEEE;
	Mon,  2 Jun 2025 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872892;
	bh=4AmJ4A22FZ+996VthMd4qszbsFcxMxVz8d/HKZUaEPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCm8Ut7UbU62eFeqebnKqLl/FbuFIMqt2iGgScBJ97kCcuUZZuIAQOewGICLM8720
	 cD1i4eBcq8hbEOoVlICPCYoWvFQ3+JgoBTWistjk3USRtUV2ru5OQKHaWJhItjkqIx
	 q5e1ls+fJlXunB/H8tYkJd6J8JyMTSUtQmYyeD+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 06/55] arm64: dts: qcom: sm8450: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:47:23 +0200
Message-ID: <20250602134238.521946398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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
@@ -4553,6 +4553,8 @@
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <16>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x584 0x11>,
 				 <&apps_smmu 0x588 0x0>,


