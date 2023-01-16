Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CA646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D52C433EF;
	Mon, 16 Jan 2023 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885797;
	bh=QR6MxQrldUdDWMfrKT93GGo/bMaTZQ2jwrNxGnVBOgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VatgKX+dCls3tV/tV+8LhTHzRmE7wTN/8pZjcwa50A9aVdjVPa4TTh4ZTwS0wizMD
	 EbH3MKz1d5/L0QHB5StEg8bPJiU3U1lA1fuS/y1cRQlCfn/mWoDJ7lP7oLIJ4OT88T
	 L90aiR6NmLiglFyIVUuJKF4eNjjzF1fglxJcHbAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/658] ASoC: dt-bindings: wcd9335: fix reset line polarity in example
Date: Mon, 16 Jan 2023 16:44:06 +0100
Message-Id: <20230116154916.680567237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 34cb111f8a7b98b5fec809dd194003bca20ef1b2 ]

When resetting the block, the reset line is being driven low and then
high, which means that the line in DTS should be annotated as "active
low".

Fixes: 1877c9fda1b7 ("ASoC: dt-bindings: add dt bindings for wcd9335 audio codec")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221027074652.1044235-2-dmitry.torokhov@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/qcom,wcd9335.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt b/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt
index 5d6ea66a863f..1f75feec3dec 100644
--- a/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt
+++ b/Documentation/devicetree/bindings/sound/qcom,wcd9335.txt
@@ -109,7 +109,7 @@ audio-codec@1{
 	reg  = <1 0>;
 	interrupts = <&msmgpio 54 IRQ_TYPE_LEVEL_HIGH>;
 	interrupt-names = "intr2"
-	reset-gpios = <&msmgpio 64 0>;
+	reset-gpios = <&msmgpio 64 GPIO_ACTIVE_LOW>;
 	slim-ifc-dev  = <&wc9335_ifd>;
 	clock-names = "mclk", "native";
 	clocks = <&rpmcc RPM_SMD_DIV_CLK1>,
-- 
2.35.1



