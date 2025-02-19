Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D61018FC86;
	Wed, 19 Feb 2025 09:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956403; cv=none; b=dYf41kSHQ6UcdfzUEyXdgZSUW5FhQtNODk357yzG5UWUD2JU5zh7thZQrxUK15Zi1x3Id60loWTuEtv/9PwO6fOzM3PtZlUWXHf1Jd39beWyZGZGQ5IhvB2QJMj2ljH8PBKsbLGJJweEeJ5qo7/BRfWlH81dNmSPfVw0BczxFdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956403; c=relaxed/simple;
	bh=HJNDIsQC30rmPGmVC2I2C1ufOm7GgfkMj/TKcuq7IzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt1LdkD411ad8DwLcDGWbTMG/BgMTNUnK27b83iMA8hZ1xPVU80rZAkSWfVUYqG1mb7ikjAzHBmIk7V2zfxgQc+WP9605UL49ibPtaUYHhnYE9jfbt9E5eNnTM0GU+bz2jtQyMS0cHl/6sqNNVjOoXvy25KfcnZUT4efQrx9KmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIfIBnwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIfIBnwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D801C4CED1;
	Wed, 19 Feb 2025 09:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956403;
	bh=HJNDIsQC30rmPGmVC2I2C1ufOm7GgfkMj/TKcuq7IzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIfIBnwW8H1VVHeqdMeBysZ2CVvbkyTL+fUvuaXG9s90tj8waDvqXk7Z93pev9FR5
	 HoFgtZRhHB34GRjrnvXk/GK3wSOULPXBKlO0bu5T29wc29jHZyLvGiW2ww/G8M6R7h
	 CPmKvvRnNQCdk9pKleEQuo0xBXShU3bSj6SRnZE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/578] arm64: dts: qcom: sc7180-idp: use just "port" in panel
Date: Wed, 19 Feb 2025 09:22:51 +0100
Message-ID: <20250219082659.534680903@linuxfoundation.org>
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

[ Upstream commit 746bda7d9dd9518793034d7008a19e4cf5c3004d ]

The panel bindings expect to have only one port, thus they do not allow
to use "ports" node:

  sc7180-idp.dtb: panel@0: 'ports' does not match any of the regexes: 'pinctrl-[0-9]+'
  sc7180-idp.dtb: panel@0: 'port' is a required property

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230326155753.92007-4-krzysztof.kozlowski@linaro.org
Stable-dep-of: aa09de104d42 ("arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-idp.dts | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-idp.dts b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
index 9dee131b1e245..ebb4f4541e14d 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
@@ -306,14 +306,9 @@
 
 		reset-gpios = <&pm6150l_gpio 3 GPIO_ACTIVE_HIGH>;
 
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			port@0 {
-				reg = <0>;
-				panel0_in: endpoint {
-					remote-endpoint = <&dsi0_out>;
-				};
+		port {
+			panel0_in: endpoint {
+				remote-endpoint = <&dsi0_out>;
 			};
 		};
 	};
-- 
2.39.5



