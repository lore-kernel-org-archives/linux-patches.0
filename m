Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D432375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302534; cv=none; b=atwI1bjhX0/kglFY6Kg1dXyhPs+Gxpf1nZZEZWgyJg6E4Ya4tprAGuEx9HmzsJb0LThKm9k7Sxx1PQGlo/94e4NqtfS+FlYKjpkQbOAnfGYC6Pl0Mbni7S4xW4Dm4J4ZQjpg/CCpOnAD1Zc03Y8+6CgLgHIKjMaoqGUojn27sbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302534; c=relaxed/simple;
	bh=X5R0Se5OjZv4sZbDBcxfVegU5mYzJbyPRtfesp1TJP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDvxQauCl/vY065+Y3jt2L/VpEwz8GnEqNiXer+i5eUKQyjhvchU3f24XWZv/cxU+LBM+lAmiM/Kdhvb2V2DUVmrFbeyjMdvOssGL4fR/6lWkdRCtJqHivVYeRQ8GnRpomrsHxK5wVQPi8MhNNhKNAXLdL2PWrw9sNN/cU+q+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mcz90/V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mcz90/V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BB9C19423;
	Sat, 28 Feb 2026 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302534;
	bh=X5R0Se5OjZv4sZbDBcxfVegU5mYzJbyPRtfesp1TJP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mcz90/V1XTEv8UhqDqDKHOsz5ZKi9jdawqXslfrupaxSpAMn/AqxnNU3JN1Fe4m5X
	 G0PQ5Y9o+l0aBMceA1/quOcuUx+z/fFhwdbzTW09Srjudb3B5V3NKifuWHVtWpPhhZ
	 h2QPZH5yteQudEKAUojfbFcorIcwxnzgNYxFq195yxXD33Nyx7/UGygYAdB5h5hVdq
	 xYOIkaDUURNLU4cdvNbXfUhHDcW44YiRmH1yRsajbP25YT/T4xB9VCnTtAW9bnRS88
	 Y+TS9aLfhOKJyiLnebRbbUJayOJR82qNp6/kPzpjbSTmU3t2GhfsoKNvkSiy/aGYrf
	 2YVZa72f9FdIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/164] arm64: dts: qcom: sdm630: correct QFPROM byte offsets
Date: Sat, 28 Feb 2026 13:12:53 -0500
Message-ID: <20260228181505.1600663-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 70dfde9d24ec5..e6527652a1245 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -554,13 +554,13 @@ qfprom: qfprom@780000 {
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

