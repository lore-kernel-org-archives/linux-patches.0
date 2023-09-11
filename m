Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D784611706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559DDC433C7;
	Mon, 11 Sep 2023 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443843;
	bh=a79bmNhlYyVgK6BP0Pw+JZjw69F6A+hsDTacbw4WQsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9pp6GAqD1joHlJoo2xiMqVYerv7fkrZVAgjEG5pVNcEBB+atedUDOO6fLlNwISvW
	 NM4rObUN0VFAmIl8CdPzAEuhiE6Kh3iS9j5mKDPiFsy5Lo17ue+ULgQcsRP16haDeE
	 KLLbkmqnmfMWwmV6sES9NXOzRZhx16VHwT2eajwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 494/737] dt-bindings: extcon: maxim,max77843: restrict connector properties
Date: Mon, 11 Sep 2023 15:45:53 +0200
Message-ID: <20230911134704.374775941@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit fb2c3f72e819254d8c76de95917e5f9ff232586c ]

Do not allow any other properties in connector child, except what
usb-connector.yaml evaluates.

Fixes: 9729cad0278b ("dt-bindings: extcon: maxim,max77843: Add MAX77843 bindings")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/extcon/maxim,max77843.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/extcon/maxim,max77843.yaml b/Documentation/devicetree/bindings/extcon/maxim,max77843.yaml
index 1289605456408..55800fb0221d0 100644
--- a/Documentation/devicetree/bindings/extcon/maxim,max77843.yaml
+++ b/Documentation/devicetree/bindings/extcon/maxim,max77843.yaml
@@ -23,6 +23,7 @@ properties:
 
   connector:
     $ref: /schemas/connector/usb-connector.yaml#
+    unevaluatedProperties: false
 
   ports:
     $ref: /schemas/graph.yaml#/properties/ports
-- 
2.40.1



