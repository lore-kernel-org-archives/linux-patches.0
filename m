Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D40E33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91CAC433D2;
	Mon, 16 Jan 2023 15:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884605;
	bh=R5Px0Ms81Hov6SKp1U3TOd9+gAyn7JNHe04Ye6AAoTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uR+e3/Ndfa1zEPJB6BF0DWDM+ya2NOzbyoQduAHSJwrVKXhMYrhu+BMjfUYPgNN9c
	 7Vi5UcoX+E2p0B2amnAPt9cteflrcU+4/R0Yjdx4PqCq765QhbQZvYw5526vdazl3p
	 cS9OPMMFgCv0sxondK8kBFiNSephbddZ3weURTnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.1 068/183] dt-bindings: msm/dsi: Dont require vcca-supply on 14nm PHY
Date: Mon, 16 Jan 2023 16:49:51 +0100
Message-Id: <20230116154806.235255241@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit a2117773c839a8439a3771e0c040b5c505b083a7 upstream.

On some SoCs (hello SM6115) vcca-supply is not wired to any smd-rpm
or rpmh regulator, but instead powered by the VDD_MX line, which is
voted for in the DSI ctrl node.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 8fc939e72ff8 ("dt-bindings: msm: dsi: add yaml schemas for DSI PHY bindings")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/513555/
Link: https://lore.kernel.org/r/20221130135807.45028-1-konrad.dybcio@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
@@ -38,7 +38,6 @@ required:
   - compatible
   - reg
   - reg-names
-  - vcca-supply
 
 unevaluatedProperties: false
 


