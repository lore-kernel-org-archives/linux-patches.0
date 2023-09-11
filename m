Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360731170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FDDC433C8;
	Mon, 11 Sep 2023 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442218;
	bh=9hz0CaZikkbbsW/0wu3mY8Em1ep1bvqKxNB/GE7CqgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvWW5R8tHCLHPPZTG4hS0zeRgB2AXh2V1ImMPH91OuhZbBuSaGw0WgcJRttk81p9I
	 KhpgKdt7VrQbc8DglkzCblxCzPnKaWHMQwX8SbXP3cGvPrbCPkLEwCAopvmAkNnjVp
	 R1eTjxkRgUGOwKWZsO4y3QXc3w1e5bk/Ak/lFbrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.5 687/739] dt-bindings: PCI: qcom: Fix SDX65 compatible
Date: Mon, 11 Sep 2023 15:48:06 +0200
Message-ID: <20230911134710.289014005@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 15d63a897f79f465d71fb55cc11c6b7e20c19391 upstream.

Commit c0aba9f32801 ("dt-bindings: PCI: qcom: Add SDX65 SoC") adding
SDX65 was never tested and is clearly bogus.  The qcom,sdx65-pcie-ep
compatible is followed by a fallback in DTS, and there is no driver
matched by this compatible.  Driver matches by its fallback
qcom,sdx55-pcie-ep.  This also fixes dtbs_check warnings like:

  qcom-sdx65-mtp.dtb: pcie-ep@1c00000: compatible: ['qcom,sdx65-pcie-ep', 'qcom,sdx55-pcie-ep'] is too long

[kwilczynski: commit log]
Fixes: c0aba9f32801 ("dt-bindings: PCI: qcom: Add SDX65 SoC")
Link: https://lore.kernel.org/linux-pci/20230827085351.21932-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/pci/qcom,pcie-ep.yaml        | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml b/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml
index 811112255d7d..c94b49498f69 100644
--- a/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-ep.yaml
@@ -11,10 +11,13 @@ maintainers:
 
 properties:
   compatible:
-    enum:
-      - qcom,sdx55-pcie-ep
-      - qcom,sdx65-pcie-ep
-      - qcom,sm8450-pcie-ep
+    oneOf:
+      - enum:
+          - qcom,sdx55-pcie-ep
+          - qcom,sm8450-pcie-ep
+      - items:
+          - const: qcom,sdx65-pcie-ep
+          - const: qcom,sdx55-pcie-ep
 
   reg:
     items:
@@ -110,7 +113,6 @@ allOf:
           contains:
             enum:
               - qcom,sdx55-pcie-ep
-              - qcom,sdx65-pcie-ep
     then:
       properties:
         clocks:
-- 
2.42.0



