Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CD1326D44;
	Tue, 21 Jul 2026 17:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655603; cv=none; b=iF9EsAHhzoMr4AnT7YY5DaM9Vn44EUlNy1WuAu6hfCNUwPGWZXnU3IuvhkV1FV/+bQv/j8xLqVx/jdFJDpwVgek9bjdyUqNqrUfzJHg5W8OsdZtiKhTfx0A4r5l+2KgFLGYBHhF8aq3PZXXoT0lgIkK6qPzRHLKjUB0c+uwxFAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655603; c=relaxed/simple;
	bh=oSROuuU8Lhggs7RZ7MucJIY9oZ6Vi331cyzCTzaID5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unvYGWaBgku+P5BoJCh/gMJcQOw8QHt4dL6+gJv3EOXr6nG13xurYHIO82RKGBHbPnq4Uh4F5j9aTNkWA6v7T4klsX5p52FWaJS16Tf+UErqAdveVJS1tN9esBtwTAOeRUrW+n9+saX+lRM7ULFyxOig9zv4dx4RJXEwcD0g0nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqqvOTj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqqvOTj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956291F000E9;
	Tue, 21 Jul 2026 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655602;
	bh=bJ2JEC+GwpOBugIF/Ew1MymD3DRLnPBc3QbDjuNAzE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqqvOTj4hqgjaEaVZrSJtbHWQzTbrCw8bPrmyxq8uiLbOfdVnEGRECeCB++txpWyF
	 dgNu69cXIOPRi3QHfU7KDkoFPZmoPG1lyI7pYNzxYm/euzPsupjmK0BscMuNicHVMr
	 u/6ELIZQDuEEjsHoNTrT64YDT0/AGuRLjfuMN4L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor+dt@kernel.org>,
	Nick Hu <nick.hu@sifive.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0071/1611] dt-bindings: timer: Remove sifive,fine-ctr-bits property
Date: Tue, 21 Jul 2026 17:03:07 +0200
Message-ID: <20260721152516.433288172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit 1ccca10755107bc8c649937d1ba69651d1ef9da2 ]

The counter width can be inferred from the compatible string, making the
explicit "sifive,fine-ctr-bits" property redundant. Remove the property
to simplify the bindings.

Fixes: 0f920690a82c ("dt-bindings: timer: Add SiFive CLINT2")
Suggested-by: Conor Dooley <conor+dt@kernel.org>
Signed-off-by: Nick Hu <nick.hu@sifive.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/linux-riscv/20260330-relative-hardened-5ce35fe1ef57@spud/
Link: https://patch.msgid.link/20260419-clintv2-remove-fine-ctr-v1-1-7527f4d45850@sifive.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/timer/sifive,clint.yaml  | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/sifive,clint.yaml b/Documentation/devicetree/bindings/timer/sifive,clint.yaml
index d85a1a088b35da..0c809819b69d70 100644
--- a/Documentation/devicetree/bindings/timer/sifive,clint.yaml
+++ b/Documentation/devicetree/bindings/timer/sifive,clint.yaml
@@ -69,22 +69,6 @@ properties:
     minItems: 1
     maxItems: 4095
 
-  sifive,fine-ctr-bits:
-    maximum: 15
-    description: The width in bits of the fine counter.
-
-if:
-  properties:
-    compatible:
-      contains:
-        const: sifive,clint2
-then:
-  required:
-    - sifive,fine-ctr-bits
-else:
-  properties:
-    sifive,fine-ctr-bits: false
-
 additionalProperties: false
 
 required:
-- 
2.53.0



