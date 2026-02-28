Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D6635AC18
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302684; cv=none; b=k3QxOdHS70CAT2oyCIpspPFbZEItWH397w7smu3MwUVcExFe6g0Ifqj9hzESYB2jOkhp9ptYuLskcKMNFCbDFC2mybw5Cuu1AgM41vl00FvrZ2enrStQIqFcfSSf0fFAe5zX5VRzcIZGzYSvo9fCqE05WH+5e0H4+NTkv1Esb84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302684; c=relaxed/simple;
	bh=CvYk6g8H1t+dFM+SqQU8Nvs1hMut5Q+uAzHVKGiXqEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auaaKK+DJ4jSJs2s71Y6E8Zwl6tgGpU9jp4XFq6wb/UZaBQjlAIzMHl8U/tYFjsWaMbkX4wDHlKxKIGBr9UY57A6bihryOSTj0qFj3gQ37W/vrN8VgprSfIHATRMZqGtOm+yaFy/CEzpLWTD9oX7Ym2xcRmQ8reWP/jvPey/h4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlM5M/SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlM5M/SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57126C116D0;
	Sat, 28 Feb 2026 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302683;
	bh=CvYk6g8H1t+dFM+SqQU8Nvs1hMut5Q+uAzHVKGiXqEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlM5M/SYEkQQ/bMXXbJ9phb0rOz+4PQDdqNqh1fkf4eZqhfY3waieDuERPNA7dGpD
	 qCbXBMLPFS4js73b+/0FasU5YZfu4YzFiQnUT/p6S4/atMD/B12snqCDz1wMvuPbjc
	 KG4AF5hHWfKG5Pkqoh1x4XzQ752rdLuCAI4w0mgzQBYIC3OAzDLtRY7YscopSrxfiQ
	 w/V4xqDk4PjotrbJnkNSVfFKXf5A/dSIL1dRE++ITfUNg9ENjcR/Va8B++piLZODRu
	 LURSERay0r42IfC5dzUSyfUp30meDZkCJhUxaKSbjrHMJiReNcFKO3o0CD1GxjFxlu
	 hgm8uVioO4A/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/147] arm64: dts: qcom: sdm630: correct QFPROM byte offsets
Date: Sat, 28 Feb 2026 13:15:43 -0500
Message-ID: <20260228181736.1605592-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 74b0fbd6048f8f4caaed712ceeca52c6034e9ad6 ]

The NVMEM bindings expect that 'bits' property holds offset and size of
region within a byte, so it applies a constraint of <0, 7> for the
offset.  Using 25 as HSTX trim offset is within 4-byte QFPROM word, but
outside of the byte:

  sdm630-sony-xperia-nile-discovery.dtb: qfprom@780000: hstx-trim@240:bits:0:0: 25 is greater than the maximum of 7
  sdm630-sony-xperia-nile-discovery.dtb: qfprom@780000: gpu-speed-bin@41a0:bits:0:0: 21 is greater than the maximum of 7

Align the offsets to match the bindings.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220505113802.243301-6-krzysztof.kozlowski@linaro.org
Stable-dep-of: e814796dfcae ("arm64: dts: qcom: sdm630: fix gpu_speed_bin size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index d810ab74204c5..c39e67fa64650 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -462,13 +462,13 @@ qfprom: qfprom@780000 {
 			#size-cells = <1>;
 
 			qusb2_hstx_trim: hstx-trim@240 {
-				reg = <0x240 0x1>;
-				bits = <25 3>;
+				reg = <0x243 0x1>;
+				bits = <1 3>;
 			};
 
 			gpu_speed_bin: gpu-speed-bin@41a0 {
-				reg = <0x41a0 0x1>;
-				bits = <21 7>;
+				reg = <0x41a2 0x1>;
+				bits = <5 7>;
 			};
 		};
 
-- 
2.51.0

