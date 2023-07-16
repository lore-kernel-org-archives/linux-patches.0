Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744748F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97995C433C7;
	Sun, 16 Jul 2023 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540012;
	bh=hZr3tAXKWEulM937V6CHeO6PMLvRbshiHPi+q+Nalwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fY257xFLkLuVj6w010eHZm8P7Yp7gvQE9SXr50wHVlQNYr0FnDT2w6KRznoN7WTWc
	 5UEiviGf8VcKN+N8sAV3m+Z65bmckrQZNQRRdyY8HyqjeeZyjEVl4dXOfLGNT2zOej
	 2Pn8iOuAxkRiIJQALDS7a4lPAHP9CH+UGwHB8En4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/591] arm64: dts: qcom: apq8096: fix fixed regulator name property
Date: Sun, 16 Jul 2023 21:45:50 +0200
Message-ID: <20230716194929.328777516@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit c77612a07d18d4425fd8ddd532a8a9b8e1970c53 ]

Correct the typo in 'regulator-name' property.

  apq8096-ifc6640.dtb: v1p05-regulator: 'regulator-name' is a required property
  apq8096-ifc6640.dtb: v1p05-regulator: Unevaluated properties are not allowed ('reglator-name' was unexpected)

Fixes: 6cbdec2d3ca6 ("arm64: dts: qcom: msm8996: Introduce IFC6640")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230507174516.264936-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts b/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts
index 92f264891d84b..9b20c1a47a186 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts
+++ b/arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts
@@ -26,7 +26,7 @@ chosen {
 
 	v1p05: v1p05-regulator {
 		compatible = "regulator-fixed";
-		reglator-name = "v1p05";
+		regulator-name = "v1p05";
 		regulator-always-on;
 		regulator-boot-on;
 
@@ -38,7 +38,7 @@ v1p05: v1p05-regulator {
 
 	v12_poe: v12-poe-regulator {
 		compatible = "regulator-fixed";
-		reglator-name = "v12_poe";
+		regulator-name = "v12_poe";
 		regulator-always-on;
 		regulator-boot-on;
 
-- 
2.39.2



