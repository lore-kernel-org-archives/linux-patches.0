Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC1B1DE4EF;
	Wed, 19 Feb 2025 09:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956409; cv=none; b=NYv47DY01pU8Na7BaKGJjevX8p4WNgdfRJWRh9anxiUo9aogB6bep+zR8j8NsMuZ/qeNuUR9M9GNDejY9IVtpVZ1Ig++65Rq1EQyU1rC9SSMDdhEb59mAGe7cPKoln1+1jgJZ3LnyuNLxJLqyb/FRcmkxuBFxYkwLFtGAbSwwa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956409; c=relaxed/simple;
	bh=frSYd4p8ZlDBaTRi3fKXjbPfgUHBPYtXIDQ0VqmlWu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlwwVO3hqmYrzFe1pA9vOeX9LkK6NiQiv7Sy+ocUQKdL7zerAaYfW10Tdx8Jdya1dJf+2XGrn0xLT3HPwGjxz/snCU4mMO8JG/falREcd5KzYI7eF8F5U/goqrWkYBLUAtslrM7bud91/I3mEc4v3DTodvrPCDZi48/xPl69n1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gC2TgOxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gC2TgOxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB55AC4CEE7;
	Wed, 19 Feb 2025 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956409;
	bh=frSYd4p8ZlDBaTRi3fKXjbPfgUHBPYtXIDQ0VqmlWu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gC2TgOxW+5ygsB/tsQ4lNv02RcwKlA64qnFEppyW6qZEL7sDabNhDsTY46Ltpqlrw
	 HeRoa7uqq5iNpo3hRK6nln2hvS/Tawsn/xJQbZBCMzOJNvG3Y0JH6TvIKQVecvBs6G
	 i/2IITihwmtZc6cpZh9VEAVo+skMIAat/9jB2zPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/578] arm64: dts: qcom: sc7180-trogdor-wormdingler: use just "port" in panel
Date: Wed, 19 Feb 2025 09:22:53 +0100
Message-ID: <20250219082659.613714038@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c28d9029f3b68a42794a0527696c91f7b31e81f3 ]

The panel bindings expect to have only one port, thus they do not allow
to use "ports" node:

  sc7180-trogdor-wormdingler-rev1-boe.dtb: panel@0: 'ports' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230326155753.92007-6-krzysztof.kozlowski@linaro.org
Stable-dep-of: aa09de104d42 ("arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi     | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
index 6312108e8b3ed..0b5b0449299bd 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
@@ -124,14 +124,9 @@
 		backlight = <&backlight>;
 		rotation = <270>;
 
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			port@0 {
-				reg = <0>;
-				panel_in: endpoint {
-					remote-endpoint = <&dsi0_out>;
-				};
+		port {
+			panel_in: endpoint {
+				remote-endpoint = <&dsi0_out>;
 			};
 		};
 	};
-- 
2.39.5



