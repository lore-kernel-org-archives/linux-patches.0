Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149B8168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6320BC433EF;
	Mon,  8 May 2023 09:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539804;
	bh=YEbyfyFrAeyV80itqiLsFEALqdSLwVWnzum9QBSKmM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDyLboRv6SdChJ3qEh3NBuTM6CdwYkeUufIcalyEsEFIFqcROypAX3MuaVsEoBMc1
	 SVfwrLkeXhtIJU8L9JWSC403/YqjZX161rjdc8Gga9UMOwcLnsK5wQ/T2TDN1rnGJr
	 y8QVVOUamtz3TnKjdrBmC0THS/IvOe3boS16bq8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 112/611] ASoC: dt-bindings: qcom,lpass-rx-macro: correct minItems for clocks
Date: Mon,  8 May 2023 11:39:14 +0200
Message-Id: <20230508094425.908873142@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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

commit 59257015ac8813d2430988aa01c2f4609a60e8e7 upstream.

The RX macro codec comes on some platforms in two variants - ADSP
and ADSP bypassed - thus the clock-names varies from 3 to 5.  The clocks
must vary as well:

  sc7280-idp.dtb: codec@3200000: clocks: [[202, 8], [202, 7], [203]] is too short

Fixes: 852fda58d99a ("ASoC: qcom: dt-bindings: Update bindings for clocks in lpass digital codes")
Cc: <stable@vger.kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230330071333.24308-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
@@ -27,6 +27,7 @@ properties:
     const: 0
 
   clocks:
+    minItems: 3
     maxItems: 5
 
   clock-names:


