Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5E014282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqBDvosW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F54C433C7;
	Mon, 23 Oct 2023 11:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059420;
	bh=ydSZRjsYTGxoQojpoaiaKEZx+mJWNDp6CYJj1/D6DNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqBDvosWgXDUzyM0Y01xakuN5F95aqyUCA60K0W38cWIjVpm1H9vyJOsgWVWY1HQo
	 ERYfxYg8Z6vXXrGS89h2jTo1UnIsfPlkUh6/WrqygO3uWL7h4Bz12ubcSsZ1Td+atO
	 rLkjg/Ey12hftYmxFMd0LiVl7o6r3+d+JQbqqcZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.5 171/241] dt-bindings: mmc: sdhci-msm: correct minimum number of clocks
Date: Mon, 23 Oct 2023 12:55:57 +0200
Message-ID: <20231023104838.050823245@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,7 +69,7 @@ properties:
     maxItems: 4
 
   clocks:
-    minItems: 3
+    minItems: 2
     items:
       - description: Main peripheral bus clock, PCLK/HCLK - AHB Bus clock
       - description: SDC MMC clock, MCLK


