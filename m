Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFC45102A;
	Mon, 11 Dec 2023 18:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MybsCDjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F00C433C7;
	Mon, 11 Dec 2023 18:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320489;
	bh=H7HL4J3HZqtbxWnTZTKe89QEPgYHgbF2QNNXrTdEOKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MybsCDjUSUXpJcqcF7jLjpBk5qGCbvBopM89WtoycxpCm+P+zrAenKILJ7I3i8Ts8
	 H/gKrL1oh5uxk/OQWC3BnlnK6hJ5JHrf+GAE8MZz+jJ115aDkQP0sdpJuoqhI0sHaL
	 KD4/u5ZeYZ5QCf+/66bglZq8yW1hxMK5XRow9PWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawn.guo@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/194] dt-bindings: interrupt-controller: Allow #power-domain-cells
Date: Mon, 11 Dec 2023 19:20:42 +0100
Message-ID: <20231211182038.879094552@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit c0a2755aced969e0125fd68ccd95269b28d8913a ]

MPM provides a single genpd. Allow #power-domain-cells = <0>.

Fixes: 54fc9851c0e0 ("dt-bindings: interrupt-controller: Add Qualcomm MPM support")
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231129-topic-mpmbindingspd-v2-1-acbe909ceee1@linaro.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/interrupt-controller/qcom,mpm.yaml    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,mpm.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,mpm.yaml
index 509d20c091af8..6a206111d4e0f 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,mpm.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,mpm.yaml
@@ -62,6 +62,9 @@ properties:
         - description: MPM pin number
         - description: GIC SPI number for the MPM pin
 
+  '#power-domain-cells':
+    const: 0
+
 required:
   - compatible
   - reg
@@ -93,4 +96,5 @@ examples:
                            <86 183>,
                            <90 260>,
                            <91 260>;
+        #power-domain-cells = <0>;
     };
-- 
2.42.0



