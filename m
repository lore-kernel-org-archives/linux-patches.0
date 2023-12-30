Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C0528FE;
	Sat, 30 Dec 2023 12:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlqNZGAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4241C433C8;
	Sat, 30 Dec 2023 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937943;
	bh=FzCcarRApC/VDOcAx2P3oYrX948HGwkg6zu7E5QmFGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlqNZGAhArAnfQ1KKstCuZfGPr7AXO2WWwhqZCSZQlm7zrsx+l4sF8G9/9l4soQYJ
	 F8FMmqcDYxV9qlLWFW4tGJhAjIp9IYyMf04WXhyfJ3sR4qICUs9lX2nZzaz1MxS7ll
	 M7XMbLCWrlhdHp1T8AfCok7FkbdyTTE9lui5SCUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Fabio Estevam <festevam@denx.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 123/156] dt-bindings: nvmem: mxs-ocotp: Document fsl,ocotp
Date: Sat, 30 Dec 2023 11:59:37 +0000
Message-ID: <20231230115816.396075420@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

commit a2a8aefecbd0f87d6127951cef33b3def8439057 upstream.

Both imx23.dtsi and imx28.dtsi describe the OCOTP nodes in
the format:

compatible = "fsl,imx28-ocotp", "fsl,ocotp";

Document the "fsl,ocotp" entry to fix the following schema
warning:

efuse@8002c000: compatible: ['fsl,imx23-ocotp', 'fsl,ocotp'] is too long
from schema $id: http://devicetree.org/schemas/nvmem/mxs-ocotp.yaml#

Fixes: 2c504460f502 ("dt-bindings: nvmem: Convert MXS OCOTP to json-schema")
Cc:  <Stable@vger.kernel.org>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231215111358.316727-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/nvmem/mxs-ocotp.yaml |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/Documentation/devicetree/bindings/nvmem/mxs-ocotp.yaml
+++ b/Documentation/devicetree/bindings/nvmem/mxs-ocotp.yaml
@@ -14,9 +14,11 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - fsl,imx23-ocotp
-      - fsl,imx28-ocotp
+    items:
+      - enum:
+          - fsl,imx23-ocotp
+          - fsl,imx28-ocotp
+      - const: fsl,ocotp
 
   reg:
     maxItems: 1
@@ -34,7 +36,7 @@ unevaluatedProperties: false
 examples:
   - |
     ocotp: efuse@8002c000 {
-        compatible = "fsl,imx28-ocotp";
+        compatible = "fsl,imx28-ocotp", "fsl,ocotp";
         #address-cells = <1>;
         #size-cells = <1>;
         reg = <0x8002c000 0x2000>;


