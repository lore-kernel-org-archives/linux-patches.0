Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2218951A;
	Tue, 30 Jul 2024 16:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355836; cv=none; b=HfmV4vwUcnIqdMtPOyfA7yDFWZKjDHR3vQQXaGX+GX0iL1PSMsXR+VwFaMyhxr1JQQDqpKQg+YVaHrfZRJ/WCmEGXsvEzh0wyyf4OM+zCYAgG3upQQshW0H/KZ5Xftb3Inq68FR1YG99C5+b9m2bLXgdd74BwjjoMErcaZZlPIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355836; c=relaxed/simple;
	bh=Rn1z14TjVH6RvsKhJSL+BnTV9R7RvGBExpr/sQU8bQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwHV55CjnPM9GNTbufKdyZF8nXPZDjjxyS1+iBSBmBLjC1dc3h0nHrSNhrpR5xtpmf5BJle+O2iKdCg28R+x+XRJDPad0h0/X/3HKEQ/sKs0/pUKqxdpWKXzYFG9LaPZuMtX7azL17Ac1b3WtNRHR1x/OZKFKMUnFSFjZqbDB3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs40gNwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs40gNwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C397DC32782;
	Tue, 30 Jul 2024 16:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355836;
	bh=Rn1z14TjVH6RvsKhJSL+BnTV9R7RvGBExpr/sQU8bQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs40gNwacsUtaA0CUcg/mLMPyTT2IUiMCDkzoZvnoSf8BzoTS26gKCFug77IkTQNB
	 YaaHz6tjTB+OxKEfssAk3RB8UUI8/rqvggFTNKJpkEw5+G1DAGBNvMrnJ2h2VPG6B9
	 R9Ked7EW+9KHMCoVxEZeSqvlsOi7bBETMo5u5Sok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 093/809] arm64: dts: amlogic: sm1: fix spdif compatibles
Date: Tue, 30 Jul 2024 17:39:29 +0200
Message-ID: <20240730151728.311650108@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit b0aba467c329a89e8b325eda0cf60776958353fe ]

The spdif input and output of g12 and sm1 are compatible but
sm1 should use the related compatible since it exists.

Fixes: 86f2159468d5 ("arm64: dts: meson-sm1: add spdifin and pdifout nodes")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240625111845.928192-1-jbrunet@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
index 643f94d9d08e1..fcaa1a273829c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
@@ -339,7 +339,7 @@ tdmin_lb: audio-controller@3c0 {
 		};
 
 		spdifin: audio-controller@400 {
-			compatible = "amlogic,g12a-spdifin",
+			compatible = "amlogic,sm1-spdifin",
 				     "amlogic,axg-spdifin";
 			reg = <0x0 0x400 0x0 0x30>;
 			#sound-dai-cells = <0>;
@@ -353,7 +353,7 @@ spdifin: audio-controller@400 {
 		};
 
 		spdifout_a: audio-controller@480 {
-			compatible = "amlogic,g12a-spdifout",
+			compatible = "amlogic,sm1-spdifout",
 				     "amlogic,axg-spdifout";
 			reg = <0x0 0x480 0x0 0x50>;
 			#sound-dai-cells = <0>;
-- 
2.43.0



