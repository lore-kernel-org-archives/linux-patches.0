Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64F9345EA7;
	Sat, 12 Sep 2026 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232222; cv=none; b=nU3Zuvwe4ZEIj1C3PiKf5yv0Ry3rUwt+qDHQECIQkEOlEQ7XppkNpxi7qplQpAWm2QyLliiQrPiF6WPg1uRXiiuyOCJ1vcOYW+DQaqKv5VKXt4yeEGp/lgJYfcUPQBXOtvCgb07zTvr9YlA4BlB8jimrBPWFm5Erj5faSbCST2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232222; c=relaxed/simple;
	bh=acNM1Xb5JdTY01mWO2V2A2jd7bZLJWMYWabNfNBgcFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpFAlR1ddlzczC6oR+tcMc3sAcALMmYY8P/WlRJQaszJejMoOdcL35o4RP7Apw0uVS2uErDrqDg8v/SdrZiqxCBOL6ClgmgQx658ahmHgNir7Afqu01uxpUiOcU5zYL8Lyd704BZGNqRgy4xFvYJqIB4Le+U1FVXf2yXGrVcTZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFy/N6n0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFy/N6n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C651F000FF;
	Sat, 12 Sep 2026 16:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232220;
	bh=i/SNo+IYoRWZVEovWPQU4wP9ldpQSQFFUvkJdeZ8aec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFy/N6n0+Uu0mI0M0wBwHLZtyQ6Tn2i5lGTsH0FxlFJf0VIuTQgGBazWuHF31hLYQ
	 +MdttRsVfi+yW9Bvy7qKjfWFsSI6mhpjolVIiIsml/tjJKepNbl0t9Id1ONuoMlNHh
	 JFNHs4Y41ZlbHYR0IDLGkDZpwCqvuVudhI3jsOE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1159/1191] arm64: dts: qcom: sm8550: remove invalid interconnect property from cryptobam
Date: Sat, 12 Sep 2026 09:04:47 +0200
Message-ID: <20260912065614.175567674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 26e95ff8a912fd787a65ae1ae4cc4684f5f84fce ]

The interconnect property is already present in the qce node, which
is the consumer of the cryptobam, so no need for an interconnect property
as documented by the bindings.

Fixes: 433477c3bf0b ("arm64: dts: qcom: sm8550: add QCrypto nodes")
Suggested-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230209-topic-sm8550-upstream-cryptobam-remove-interconnect-v1-1-84587c7bad0f@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 0c1df1d1e6950..09a3d2caf05ec 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1586,8 +1586,6 @@ cryptobam: dma-controller@1dc4000 {
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x480 0x0>,
 				 <&apps_smmu 0x481 0x0>;
-			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
-			interconnect-names = "memory";
 		};
 
 		crypto: crypto@1de0000 {
-- 
2.53.0



