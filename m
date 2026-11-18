Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025776;
	b=mSlF+jq6gnm07JEYiUEjhdkXTF/3NiJz4d3jC7CkItek6xaLafwG4ighvuZMyDQcs9X6
	 1l9j9WZyliA2mbdB++peHuDFrwyc3mc3lhKjAGbDg8FjvFx/Kg3Ak+V1k7nO02WGm+nmb
	 SHTM+fusIUlhbA/puF2AnKI40mW+frQtgtfWFcewQ5UGyyTB9BEDT5nzXjtaioH1Pewiw
	 gQOWJBrVmRj9Mb0Cw9ijmplOIzvoRKVgJUV3gpRmzvFEVKjhBrUkkTwq+VpkZYkIlAecm
	 COzHKdPrebo0ipk8RfBQIfg+0HGrXqDIRq4YeqFjs35K+754z9ksE7FkJ35LVoDXpdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KVtTIsKI1YxNPp/Km5YGTQ4qxzcGplAJNpsiSTJIw4A=;
	b=TcpM3H21yjcnWOiIALiVYae3gr2Rw+XeOTo1FF2+Z0D8RHEUVoekxzRDT2CC3r/HVj9e
	 tpSZ54bjSis/+IZnKey9147CUwl1Bm9AwVfRcxFtdhJmQnTq2PF1FAaVhpLMJPfW8Eiiu
	 yguHtoRFamO+ey6Jrq4Cg8CjsJ9OBv1lcvkQbNrOOULbZMcMfbR4msts9hHBbeI6VJB5f
	 QznzGOFe13IOCDe8fu8wKbGUliU2t2xmCL4h4FL7DtYMHiSmhYeeHKikcVCALfBbkAs6M
	 WEvzL7I9569MBPZCgLFbr3f6YzcHBl7fEb9899qarT/Nuvs2fbkSQHH3r1abbbj4RuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9rndyZ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93A7606A320;
	Wed, 18 Nov 2026 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9rndyZ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F321F000C5;
	Wed, 18 Nov 2026 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025776;
	bh=KVtTIsKI1YxNPp/Km5YGTQ4qxzcGplAJNpsiSTJIw4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9rndyZ3blMny/GISEJDzyEtC+gKhHbYm8HMgBCqfESSJyVFb1JFTgONdup+sdm6n
	 FlnbTddD1NM1FtkfJXdK3uxQ6DozQI7XYJLWxgprAWm7jcNCa4Yq13cv8SzvFQR2ED
	 toWjPx0jx5FE+2EQz4DD69DrBy1DQpRKDAPa+Wyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1157/2151] dt-bindings: dma: dma40: Restore disabled-channels
Date: Wed, 18 Nov 2026 15:48:12 +0100
Message-ID: <20261118150204.320759776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



