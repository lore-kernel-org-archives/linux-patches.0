Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF05EFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A9FC433D2;
	Mon, 15 May 2023 16:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169769;
	bh=OPVuo+IubyEzmIK31J2qWvvUjhxo+wHgQdAXGBTYA8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLy4wgFK4ZE2K0nnC82ZSo9RJ3TJTYQ5RFylLsi4z58tH15Gsm98aCB+RjYUFd/r4
	 tvSbPcAC6vDHwOHmZPFp4Xahc/KMykLUUd4qPOSUFDEqxQ8Hs2pshGXHItp+VrPVCL
	 jvQLYgauSw7gJShvUdiaLyZsXRhRpFQiexpD2Iws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.3 165/246] ARM: dts: s5pv210: correct MIPI CSIS clock name
Date: Mon, 15 May 2023 18:26:17 +0200
Message-Id: <20230515161727.584241544@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 665b9459bb53b8f19bd1541567e1fe9782c83c4b upstream.

The Samsung S5P/Exynos MIPI CSIS bindings and Linux driver expect first
clock name to be "csis".  Otherwise the driver fails to probe.

Fixes: 94ad0f6d9278 ("ARM: dts: Add Device tree for s5pv210 SoC")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230212185818.43503-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/s5pv210.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/s5pv210.dtsi
+++ b/arch/arm/boot/dts/s5pv210.dtsi
@@ -566,7 +566,7 @@
 				interrupts = <29>;
 				clocks = <&clocks CLK_CSIS>,
 						<&clocks SCLK_CSIS>;
-				clock-names = "clk_csis",
+				clock-names = "csis",
 						"sclk_csis";
 				bus-width = <4>;
 				status = "disabled";


