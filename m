Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CEE33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5D1C433EF;
	Mon, 16 Jan 2023 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884576;
	bh=4yylJ2Egue4JgjwSZ7fp6iS43+VnMOkb5xIS5+LqzHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzXvtKRcnnooy7djZnqJffl4KtlXt4Elt3eNM64TKShmno92zqSb7Fi8ZoMoUoZKI
	 YHxOpgxTuomIGbPSGOKRAe07qaruHJv6dZ0pSmKsntJpvUqMBgE4sgL2m5yCoKBXh0
	 9+wwX5nLijDQCxHu6Ovpj8cH/Egm6rq4selIRb60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.1 058/183] dt-bindings: msm: dsi-controller-main: Fix power-domain constraint
Date: Mon, 16 Jan 2023 16:49:41 +0100
Message-Id: <20230116154805.796127493@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit a6f033938beb31f893302a93f83ec0b6460c6cac upstream.

power-domain is required for the sc7180 dispcc GDSC but not every qcom SoC
has a similar dependency for example the apq8064.

Most Qcom SoC's using mdss-dsi-ctrl seem to have the ability to
power-collapse the MDP without collapsing DSI.

For example the qcom vendor kernel commit for apq8084, msm8226, msm8916,
msm8974.

https://review.carbonrom.org/plugins/gitiles/CarbonROM/android_kernel_oneplus_msm8994/+/7b5c011a770daa2811778937ed646237a28a8694

"ARM: dts: msm: add mdss gdsc supply to dsi controller device

 It is possible for the DSI controller to be active when MDP is
 power collapsed. DSI controller needs to have it's own vote for
 mdss gdsc to ensure that gdsc remains on in such cases."

This however doesn't appear to be the case for the apq8064 so we shouldn't
be marking power-domain as required in yaml checks.

Fixes: 4dbe55c97741 ("dt-bindings: msm: dsi: add yaml schemas for DSI bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/515958/
Link: https://lore.kernel.org/r/20221223021025.1646636-3-bryan.odonoghue@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
@@ -134,7 +134,6 @@ required:
   - phy-names
   - assigned-clocks
   - assigned-clock-parents
-  - power-domains
   - ports
 
 additionalProperties: false


