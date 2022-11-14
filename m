Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158E44C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8652DC433C1;
	Mon, 14 Nov 2022 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430992;
	bh=0ov3wHGr7evKOo69+G0XrGuCiIeo/R0reDLsWRceCiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL5rmGcCVvTyNG1lbrj2qofA5004ZFvM1urwskAKHRysQ5IAg1YjKx4F7oNg0BEyT
	 G4UYLf2sHHS0lxmvVwJWOgMAvFXzg09sDAcS2ybmUArIF2ZmNC9KgPePZCXmTnz+4J
	 UgpYRjxLs5PFJ9EAlt+Md130JwI5x/Vp+NmQvRMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Rob Herring <robh@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 060/190] dt-bindings: net: tsnep: Fix typo on generic nvmem property
Date: Mon, 14 Nov 2022 13:44:44 +0100
Message-Id: <20221114124501.380293125@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit ec683f02a150b9c4428f08accd387c8c216ea0e5 ]

While working on the nvmem description I figured out this file had the
"nvmem-cell-names" property name misspelled. Fix the typo, as
"nvmem-cells-names" has never existed.

Fixes: 603094b2cdb7 ("dt-bindings: net: Add tsnep Ethernet controller")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20221104162147.1288230-1-miquel.raynal@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/engleder,tsnep.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index d0e1476e15b5..ccc42cb470da 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -28,7 +28,7 @@ properties:
 
   nvmem-cells: true
 
-  nvmem-cells-names: true
+  nvmem-cell-names: true
 
   phy-connection-type:
     enum:
-- 
2.35.1



