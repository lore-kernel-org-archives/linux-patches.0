Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24B8198E9C;
	Thu,  6 Jun 2024 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683518; cv=none; b=YI08OZvWoCrNHzI2fL6yzYKFFge0irEq0iw6899Oqggme1bNj5YJcsoshej3N1WNa1C8pzjqBscKw54jyeSwDkJ3KUzpR1n/9xYrOtc3/UL0DiFwmRKzT86ps/kOY6e36zbMCJXNe9yjO8ulhM/P+nax6J6Zk6ToeQlhEXMHcCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683518; c=relaxed/simple;
	bh=WVu0mEHRKw8td50gRwYvL23xxBZvak9rkCXeETO+T38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAk4N4JRbMnIseK4jfPe4JtUbTDgZEnXXDuWKuQ0GQa7stMx2KI6V+fjIR7hpaeC3If/abjZmVWzliA8siC2jZ6NSEzxBrGp742bZn0jMhdggG9j9KPxLjiIbXt7X92473TnQZT4oVmfoGtRQkezBRwfcPqR0/lN2+kr6N4ayUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Si1GJ2pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Si1GJ2pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BC3C2BD10;
	Thu,  6 Jun 2024 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683517;
	bh=WVu0mEHRKw8td50gRwYvL23xxBZvak9rkCXeETO+T38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Si1GJ2ptgpP4cnqkgaZ7qg1qURS3Bc9BTDKO48iDFRu79jzhAqax9bmAw+rqizGfw
	 tYb3hMiWNxpsX1qIH5+vw3BGbREKsLQ4E0xvJBBA62FHkf5kRSFR822jhCAYaRKy5c
	 GKp7INsWPwbwPKKNXMcNhGL9pu4eNRXU9YXQdn0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 429/744] dt-bindings: PCI: rcar-pci-host: Add optional regulators
Date: Thu,  6 Jun 2024 16:01:41 +0200
Message-ID: <20240606131746.226935527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit b952f96a57e6fb4528c1d6be19e941c3322f9905 ]

Support regulators found on the KingFisher board for miniPCIe (1.5 and
3.3v). For completeness, describe a 12v regulator while we are here.

Link: https://lore.kernel.org/linux-pci/20231105092908.3792-2-wsa+renesas@sang-engineering.com
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 78d212851f0e ("dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pci/rcar-pci-host.yaml        | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml b/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
index 8fdfbc763d704..b6a7cb32f61e5 100644
--- a/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
+++ b/Documentation/devicetree/bindings/pci/rcar-pci-host.yaml
@@ -68,6 +68,15 @@ properties:
   phy-names:
     const: pcie
 
+  vpcie1v5-supply:
+    description: The 1.5v regulator to use for PCIe.
+
+  vpcie3v3-supply:
+    description: The 3.3v regulator to use for PCIe.
+
+  vpcie12v-supply:
+    description: The 12v regulator to use for PCIe.
+
 required:
   - compatible
   - reg
@@ -121,5 +130,7 @@ examples:
              clock-names = "pcie", "pcie_bus";
              power-domains = <&sysc R8A7791_PD_ALWAYS_ON>;
              resets = <&cpg 319>;
+             vpcie3v3-supply = <&pcie_3v3>;
+             vpcie12v-supply = <&pcie_12v>;
          };
     };
-- 
2.43.0



