Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF8BBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D276EC433EF;
	Tue,  7 Mar 2023 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210044;
	bh=8kqN3RniMzBMnKdyxH0PpH/cGfSiIAJm7s5/6Wj3Lkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwDTxgFpuXZG8ww2JF8ViYZleeHvreReYJxZpY9xeoLSMZ59/MuZN/egGFrblSxto
	 z92pK1cm7wA0WYoMWkYA3+a5+No1tr+Nlo+dk/YaI2OmfYwAgnhm0ouWhz1wMYy7sC
	 KocX0CKqOsBRqQnETNUrgejHXeF0LeRVVHIjOQ2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0414/1001] ASoC: dt-bindings: meson: fix gx-card codec node regex
Date: Tue,  7 Mar 2023 17:53:06 +0100
Message-Id: <20230307170039.306098299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 480b26226873c88e482575ceb0d0a38d76e1be57 ]

'codec' is a valid node name when there is a single codec
in the link. Fix the node regular expression to apply this.

Fixes: fd00366b8e41 ("ASoC: meson: gx: add sound card dt-binding documentation")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230202183653.486216-3-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/sound/amlogic,gx-sound-card.yaml        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml b/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
index 5b8d59245f82f..b358fd601ed38 100644
--- a/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
+++ b/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
@@ -62,7 +62,7 @@ patternProperties:
         description: phandle of the CPU DAI
 
     patternProperties:
-      "^codec-[0-9]+$":
+      "^codec(-[0-9]+)?$":
         type: object
         additionalProperties: false
         description: |-
-- 
2.39.2



