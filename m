Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031073;
	b=txMKvDuhKJgqxjizIOuyUR3kQFWVs6k/Ux1r02eX4R/icVWsZ5MesmmUdLIF/pIvYNga
	 //9jLpdYVDpH5cwbQU3H/4w6e89cxtMVCVrczNMZa9w55IaqCFpHfOgYw6zBriAbsjKT1
	 Lc6b9xzJ4kIeSdSa9mfTsdINdlSATq4mBvUdCfZz5fu5nytRJn6DhnrRWz012mbiuwB8i
	 abUwVA5KAjnJKxkxy7mBEhtTxyJ14mzQtAUKy0rfSpmdw51EJwQXJzr5La7Ov+O2ZWWdl
	 e9UYLRpe5yB5OlMw8N27aL6RvRU4D7d5vA9E+KD8G8vsFnbzAbFTu69Ec+53r9uZiqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NabY3avheq2XKr5IlosJU1+56QaLbVKWpb6Ix7UJWbk=;
	b=EUxdwZqAPqMp29DUpd23nrVnK1tE1rhC/hAk4gVFYoLg+e5WQqAKR0dAv9x8efI5xLI0
	 iQykEqyCchwaL9/GhNJLgix1K9oTMCX7+CUvo6HUrYbyR5ySLmmZiR+1gogyD/CGHpSMS
	 61ssKlHBs1oVPsGeLB9G6DH3mJESE8bZAtYfuBe2LrI2KmTogZsnu+R9fU/nthBIQx8A3
	 I1kVY7CGZTKwpQiCar9ugebOTFGaGDhwH1+XCirk6Yyn9zQt5OAoMqCD90Mm+VKQO+/6J
	 PvkOYyE+AXX5zJ39L9Pp7+VJ+5BJ+kCQud0bRsFhfMFIURKWlmrdecv8Et5CtkrgLUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VT2SskmG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91EE606A325;
	Wed, 18 Nov 2026 19:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VT2SskmG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B881F000C4;
	Wed, 18 Nov 2026 19:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031073;
	bh=NabY3avheq2XKr5IlosJU1+56QaLbVKWpb6Ix7UJWbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VT2SskmGNTxEXB+DfguavtQi4b8pZSI0duz7y62cW5lrIYzSTl+a4jdO2D2YIhBuZ
	 NkumBCuKKUFoRvWfgqekqXHgWhbW3gfnKWrBjIjwhL7yOwtboAJ/bg1bjmb40zdgHb
	 O6qU5xzzpaNrcvu8GuvpBSbbGjV0HIeqcf/9DGRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0922/1756] dt-bindings: dma: dma40: Restore disabled-channels
Date: Wed, 18 Nov 2026 15:50:49 +0100
Message-ID: <20261118150046.683709740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 38d97b1122e02f6b8859e660990aaeda1c32e00f ]

The conversion of the DMA40 binding to YAML omitted the optional
disabled-channels property from the original text binding. The driver still
parses this property, but additionalProperties: false rejects any device
tree using it.

Restore disabled-channels and constrain it to the physical channel range.
Also constrain memcpy-channels to the limits enforced by the driver and
reject duplicate channel entries in both properties.

Fixes: 23fbc87c8ae6 ("dt-bindings: dma: Rewrite ST-Ericsson DMA40 to YAML")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260918-dma40-dt-disabled-channels-v1-1-0f691109d8d3@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/dma/stericsson,dma40.yaml  | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
index 7b94d24d5ef42..73a69a1547701 100644
--- a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
+++ b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
@@ -145,8 +145,22 @@ properties:
     items:
       maxItems: 1
 
+  disabled-channels:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    maxItems: 31
+    uniqueItems: true
+    items:
+      maximum: 31
+    description: Physical channels that cannot be used by the DMA engine.
+
   memcpy-channels:
     $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    maxItems: 8
+    uniqueItems: true
+    items:
+      maximum: 63
     description: Array of u32 elements indicating which channels on the DMA
       engine are eligible for memcpy transfers
 
-- 
2.53.0



