Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041050;
	b=HAM7TFb7lWmA0ParaThOxfTtaAw+FuvaNWRp9Hsi7pk3QWd4uB0vAqmRlOK7R5NunLIP
	 cC/iDMBUX7mfZDpK7u1a1SKA7CovR2LH2s/NfFHVkAFH38jX3R2U3/rdhRPALXlh3I/tb
	 9r0wLo9RJHxLrMIv1sYicjhHzU9aI5nJKJ1sdS4MME6u+z5OWzik7KgmwdQ5ZN2Nq9x+O
	 OLK9yYxIu7bnw5pAILmqbLHzhgbtSqBHKf/H2ParShnVLGCZVPY6dgorHe4hpNqE/abb3
	 5T5M+xPwbc1poHHtSNOO00YArmGRl17seCp0ahpzZH8p0CBoefq5QRy/Dg0eVVuRrJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBH0yaMTFTCYia5V9fJcW4IAtikNI6vlhYDZEUXjoLM=;
	b=1gMXQOJW/LeQg8oIFv7w0tMeSyN6w+tNbe3H/Jor/2ySOH9Pbj6dZGFE8+xUYdnnnwqo
	 +mzlJa3uOCg/43Gx3cZNFQf0sK3kYAH8PYSOPHAKGFb/N/MhOQpUSqvViFULIN0oh6wo2
	 EO/sRStIyrbswP4Jc9KpQ16SIv0YEgxgOsf5dWGPPVbtMJuVjzLjsEcoc4rYfaKMoYf6W
	 EGyGiBa7Wjahm4q7rjflKsGYTzgrBW1EF5avwkRT/KCdN1Xq9xBLQeG+546hoyZ2Is+2C
	 aaxgkoja0JCG5BTSROoLv7/S0HFRSS1/oKyC1hTSrlHAUmxJRLJdq4llhHaz+LF2OwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lauaxYtf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F035606A320;
	Wed, 18 Nov 2026 22:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lauaxYtf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEBB1F000C4;
	Wed, 18 Nov 2026 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041050;
	bh=cBH0yaMTFTCYia5V9fJcW4IAtikNI6vlhYDZEUXjoLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lauaxYtf9hnT8zzwXyitGQEac8sw0SJtRtKrP/4WQwjOsZk04S/tzK1aBJ8qCVczF
	 x0jyQxU9GVaSRE3yCc2mXMPlu1VT7eMXlxwmjsRWnWq3rXFC7SH8yupXDwr1UTJEgp
	 8NzFM9+y/IkKG/tShrdS7tELirOt0TQbMWXI9DCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2635/3318] dt-bindings: dma: dma40: Restore disabled-channels
Date: Wed, 18 Nov 2026 15:54:17 +0100
Message-ID: <20261118150440.135329611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



