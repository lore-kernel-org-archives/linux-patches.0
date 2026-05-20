Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92011CDFCA;
	Wed, 20 May 2026 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295097; cv=none; b=ekL4NitXd7tod50jE6A4dLKQXZaZN8jyUZuzAiZCkYtrDMTwXPFmQZvU0yOVUZ0r61LppyjQn2zt1EmgTxE7jxnpUwQXgMnNyW8ooUaX1MlPOCMCGoWfa8nAKZb7cnatPG7p7v0ZNPlNeGkCZw+ic6YoeTGuaNFCkY/K00Vn5eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295097; c=relaxed/simple;
	bh=D7pXPqYAvtvPtP6BwTOAxNAkDTP/d7rucvs3TCYoPUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id6nsHhjmCUR6VPo6Bb86Jhu9bJ4NWdxHTxBeVFj4FIA8ocqnUEq7xuNI9Be5/lj8AGC/0H1Ua3qR1fLWQPY0UQeUXOrrKYidnrUG+x4ksdWFeMqScTi3WwOvrIg4dLTtKo3G4QlBXxdqRRLpeDM5eVoYpgfHU+SVq3RVrooOgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xu+nZSu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xu+nZSu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCDF1F000E9;
	Wed, 20 May 2026 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295095;
	bh=fWgbj9Msah27PbJ6umVZveFKk1z6OEyJz5uSTMT+Q24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xu+nZSu3KsRph3B+b6byQf5tyTZS+Bv1rpV2H9vVnynHndiwi3J//y7lZ37ZnDD9l
	 fh7hx8CQ735/7a5lQf8/jbdWAeZHxnjcPMhMrqKImNVurvn0DIy1Rq3eG3chXn0qgH
	 D+MMyDuKyl3zB/YGDA/TTTIP0SfaI/YgBVmSgEz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 7.0 0288/1146] dt-bindings: PCI: renesas,r9a08g045s33-pcie: Fix naming properties
Date: Wed, 20 May 2026 18:08:58 +0200
Message-ID: <20260520162154.734697739@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Madieu <john.madieu.xa@bp.renesas.com>

[ Upstream commit bb1b0f47f6822864c1689f46348efa42c5d4074c ]

Fix a typo in interrupt-names: "ser_cor" should be "serr_cor" (System
Error Correctable).

Also convert interrupt-names, clock-names, and reset-names properties
from "description" to "const" to enable proper validation with
dtbs_check.

Fixes: e7534e790557 ("dt-bindings: PCI: Add Renesas RZ/G3S PCIe controller binding")
Signed-off-by: John Madieu <john.madieu.xa@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> # RZ/V2N EVK
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260306143423.19562-6-john.madieu.xa@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/pci/renesas,r9a08g045-pcie.yaml  | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/renesas,r9a08g045-pcie.yaml b/Documentation/devicetree/bindings/pci/renesas,r9a08g045-pcie.yaml
index d668782546a23..d1eb92995e2c3 100644
--- a/Documentation/devicetree/bindings/pci/renesas,r9a08g045-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/renesas,r9a08g045-pcie.yaml
@@ -41,22 +41,22 @@ properties:
 
   interrupt-names:
     items:
-      - description: serr
-      - description: ser_cor
-      - description: serr_nonfatal
-      - description: serr_fatal
-      - description: axi_err
-      - description: inta
-      - description: intb
-      - description: intc
-      - description: intd
-      - description: msi
-      - description: link_bandwidth
-      - description: pm_pme
-      - description: dma
-      - description: pcie_evt
-      - description: msg
-      - description: all
+      - const: serr
+      - const: serr_cor
+      - const: serr_nonfatal
+      - const: serr_fatal
+      - const: axi_err
+      - const: inta
+      - const: intb
+      - const: intc
+      - const: intd
+      - const: msi
+      - const: link_bandwidth
+      - const: pm_pme
+      - const: dma
+      - const: pcie_evt
+      - const: msg
+      - const: all
 
   interrupt-controller: true
 
@@ -67,8 +67,8 @@ properties:
 
   clock-names:
     items:
-      - description: aclk
-      - description: pm
+      - const: aclk
+      - const: pm
 
   resets:
     items:
@@ -82,13 +82,13 @@ properties:
 
   reset-names:
     items:
-      - description: aresetn
-      - description: rst_b
-      - description: rst_gp_b
-      - description: rst_ps_b
-      - description: rst_rsm_b
-      - description: rst_cfg_b
-      - description: rst_load_b
+      - const: aresetn
+      - const: rst_b
+      - const: rst_gp_b
+      - const: rst_ps_b
+      - const: rst_rsm_b
+      - const: rst_cfg_b
+      - const: rst_load_b
 
   power-domains:
     maxItems: 1
-- 
2.53.0



