Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4FC1DE4FA;
	Wed, 19 Feb 2025 09:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956406; cv=none; b=oqBIWDKciSZooxC1WVVR6CL2foDWbo9VjPtljTN44+bu7lEUTDfms0LPueRLWaNoxM5IgRt9AXCNTVRW/Wzj/aHFvdO2ja/2iX5NKi9Iuhy91ir1Z+xBzhAoeUvQw2MT6GJotT61JZsPEpGgtJxrY8yIU3QzeiZ+ZeM3VGbLSKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956406; c=relaxed/simple;
	bh=z1ZS/J3OnIrEsdgzZIo9K8ysc04K+aZV3Np5whoOjZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBuXynU8GE3P5U5KoYZBbMQp584219EFniwuLzd+jeCRvgTwrtOphL2Bd/zqj7VUjAdDPrHSEMl22m5qv0atq7H+JG1tZS7M6fm+dWuZGxNIEFHONZKec1ecjBi/6Mo/nqLmaY5LxsVkhCV5BV8CRph01biUC6Rwa+lFtLk8CPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L18dpyxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L18dpyxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7905C4CED1;
	Wed, 19 Feb 2025 09:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956406;
	bh=z1ZS/J3OnIrEsdgzZIo9K8ysc04K+aZV3Np5whoOjZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L18dpyxCKMOPARZhX6PhvvUZrurcvHH0kSXhKqhXxGaBPbJtoCDr65J+CArXmZlMk
	 yaj45q0h5jugi2ChS7JIDxy4d4yrZacnt79xEnpPFO+TuI4F+6Zr7NXQ131DzhTEqG
	 ROYnSk9q2WP93kvUFCyoStuDSW4uPmSxFBjAY0eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/578] arm64: dts: qcom: sc7180-trogdor-quackingstick: use just "port" in panel
Date: Wed, 19 Feb 2025 09:22:52 +0100
Message-ID: <20250219082659.575203849@linuxfoundation.org>
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

[ Upstream commit 88904a12fbcbd97e56d341080845ce0807164fb5 ]

The panel bindings expect to have only one port, thus they do not allow
to use "ports" node:

  sc7180-trogdor-quackingstick-r0.dtb: panel@0: 'ports' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230326155753.92007-5-krzysztof.kozlowski@linaro.org
Stable-dep-of: aa09de104d42 ("arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi   | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
index 695b04fe7221f..4ec3e578a1120 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
@@ -65,14 +65,9 @@
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



