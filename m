Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F01446AA6C;
	Tue, 21 Jul 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648090; cv=none; b=Em/FlfseTGNB+l3UNyE2Q4E3dl8+jbnIKIRonZ72bCz8YSV28eg9O049JO+F2UNbwukOo7+NVIm0Ffz8YiubfEsvFfvnEKacw5erYjPSNvjWrUsAWl3gJl1DSc3cpv95ZPnEMhLjqNZYh4pbgj/683wTmbLLmhESjEje2qgVU18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648090; c=relaxed/simple;
	bh=arnmdvnNtsciiXT4Pz5G2vg32JHXTD9Vvcnfs1Ktm+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmSD/QLja0My8EDkRdaWYRaOIBgWw2wThbjSsRoBInLWhKkkeLD4jyOMGlTCKSoHjfdu86CHGa3+czIG+meHRlQ44Fnn1sA/ipWmT9JS+3DXsaZG8/t/LRsOYxnbEugsVMD9axHNNkG8wQQpoKeglY3SLPrpWYoduWRz09pun+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doajA3BB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doajA3BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51851F000E9;
	Tue, 21 Jul 2026 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648089;
	bh=afb+MxEURjMSThyoT8m2ENWNOrt38oEzLXTwzUndg/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=doajA3BByXhPSo/2zPdp2T3GuYEWclWQfdZscmySniWnh9IJE1UKAzIr7z9Ej8bdr
	 0uG8/4RTj9c9DbiY5Fv7yFPVN/4IUbmrPZJ/c6mBVMysiJx0Eneg1zqdGRa9HMofUV
	 xby3BHhaZbZpJQbrcHwh8Drf8/kli3IMZ8pB8/uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor+dt@kernel.org>,
	Nick Hu <nick.hu@sifive.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0067/2077] dt-bindings: timer: Remove sifive,fine-ctr-bits property
Date: Tue, 21 Jul 2026 16:55:40 +0200
Message-ID: <20260721152554.271463890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c16b260db040d..051edb1da0d739 100644
--- a/Documentation/devicetree/bindings/timer/sifive,clint.yaml
+++ b/Documentation/devicetree/bindings/timer/sifive,clint.yaml
@@ -72,22 +72,6 @@ properties:
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



