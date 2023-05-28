Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA0E611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCE0C433EF;
	Sun, 28 May 2023 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302548;
	bh=3qGr7NclIe9TWHlCtdmjZcENcT+Xbqypfue4DImknwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQBsm2GaVEdMNNK+bBJ5RtuWIoGtwvC0NgvjsmXJGG52dQ7MTC1ou9KS8mnQE1mCc
	 zPzl06ibPgKLg8D7SvDCmh0BLneAERxmVoFtXn45N8fpE6CcW1lGaGReOHQavYPfKl
	 bwkMAeIx9V00pIHvwbPgtBqLAxWfK2zahGhF7jfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 040/119] dt-binding: cdns,usb3: Fix cdns,on-chip-buff-size type
Date: Sun, 28 May 2023 20:10:40 +0100
Message-Id: <20230528190836.716704043@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

commit 50a1726b148ff30778cb8a6cf3736130b07c93fd upstream.

In cdns3-gadget.c, 'cdns,on-chip-buff-size' was read using
device_property_read_u16(). It resulted in 0 if a 32bit value was used
in dts. This commit fixes the dt binding doc to declare it as u16.

Cc: stable@vger.kernel.org
Fixes: 68989fe1c39d ("dt-bindings: usb: Convert cdns-usb3.txt to YAML schema")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/cdns,usb3.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/cdns,usb3.yaml
+++ b/Documentation/devicetree/bindings/usb/cdns,usb3.yaml
@@ -64,7 +64,7 @@ properties:
     description:
       size of memory intended as internal memory for endpoints
       buffers expressed in KB
-    $ref: /schemas/types.yaml#/definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint16
 
   cdns,phyrst-a-enable:
     description: Enable resetting of PHY if Rx fail is detected


