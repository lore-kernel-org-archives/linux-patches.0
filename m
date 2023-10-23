Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AF1125BF
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXJpLMyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4751CC433C7;
	Mon, 23 Oct 2023 11:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060365;
	bh=cpYnA431QBcXozcBtKXLmgK8d+XsPK9s7K7vI6C01y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXJpLMyta8J05m/9d/eFdsL/MTuz94lFtjxKNcTVOTlXBdqUJ/gjLLnMOOLyLXpKg
	 qOoNURPXhIuh1mk6zDexlw4EAcZ/VAUMd3G8sgln/s4fhhb0SrY9D92ltfLEmBSgW7
	 cZ+jsXIQOPfjwUNOIFXktOeNN2qakBYbhsNGoge4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 148/196] dt-bindings: mmc: sdhci-msm: correct minimum number of clocks
Date: Mon, 23 Oct 2023 12:56:53 +0200
Message-ID: <20231023104832.663102928@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 1bbac8d6af085408885675c1e29b2581250be124 upstream.

In the TXT binding before conversion, the "xo" clock was listed as
optional.  Conversion kept it optional in "clock-names", but not in
"clocks".  This fixes dbts_check warnings like:

  qcom-sdx65-mtp.dtb: mmc@8804000: clocks: [[13, 59], [13, 58]] is too short

Cc: <stable@vger.kernel.org>
Fixes: a45537723f4b ("dt-bindings: mmc: sdhci-msm: Convert bindings to yaml")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230825135503.282135-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/mmc/sdhci-msm.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
@@ -59,7 +59,7 @@ properties:
     maxItems: 4
 
   clocks:
-    minItems: 3
+    minItems: 2
     items:
       - description: Main peripheral bus clock, PCLK/HCLK - AHB Bus clock
       - description: SDC MMC clock, MCLK


