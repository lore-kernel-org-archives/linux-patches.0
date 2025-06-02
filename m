Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8C1DED64;
	Mon,  2 Jun 2025 14:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872895; cv=none; b=IhYFJ0wrrCuEiJV7DirWTMswPD5oHUxnMrwNzg3AIqKfUrSybJo+9k8+Na5Jnx+BnqUnUOSlSIkZlDcrJjBHqOMe1DSrUstLxdYookq0yOSYnpWNJqoAVl2vGT4J/WCclFwC1LjzdUGF+JBnMUbxGdY5Zg6K8i4YoTgs3sJE/f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872895; c=relaxed/simple;
	bh=14xDnfdgyyiIHbcKnWE2zjQCbbtFAhkwkb9K2gsAXCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiSBHkU/vsef/TKP7Vf7m/MGWt0GwC6/zJ6BHUH/AaXPAA6p9RtrL9RxkOujgvyfoZjIXsdLDNXMg5Yqt3VOBmEwktlU1mxPG/3NXBYCRRCxJj3vF2qR62cOR6rpz7W4xzrMGYBgP9y5tG/CWEa05FEOsON5UD7zBAaUkIU4Nlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Qlyoh0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Qlyoh0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901E0C4CEF0;
	Mon,  2 Jun 2025 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872895;
	bh=14xDnfdgyyiIHbcKnWE2zjQCbbtFAhkwkb9K2gsAXCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Qlyoh0wYwCWXCo5gWl7xbNWX7n1DmmSNpiSkJf0LTJOODkVho7BrOVmgMbcReJqE
	 0dFvlZ+D0TycAz3rNFMS+iNxkGRdbcOEGZ5dplaZjwuSaSzR8XhQpMwkFskZ84pYY/
	 Sw7Dr2zSlAoMagD9t62MfGJrvI6k8+Pvm47TNPGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 07/55] arm64: dts: qcom: sm8550: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:47:24 +0200
Message-ID: <20250602134238.558774473@linuxfoundation.org>
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
@@ -1952,6 +1952,8 @@
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x480 0x0>,
 				 <&apps_smmu 0x481 0x0>;


