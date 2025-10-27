Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EFC2D6E70;
	Mon, 27 Oct 2025 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592128; cv=none; b=NovoUF5c9N6F8HM1CW5IaX0Mf4PPqNzdZxMuw18BzE/bkQYBmifxx1AKJw/nK0qJb/wJqvmOQMkiZAiQRUodGCiAbyqrBVp6mKiHhMTe5dHjd2gZNLl5mO9Yq3WLvZ1XvkHKHhOg3BhBbW1zOqqIrg8pNZ6r6TvyJMLKtviZgQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592128; c=relaxed/simple;
	bh=1TsHgw3UBX/dEKgE+fRb+VdrVraqadrdYwstlUJ//ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JikScMkWG9rGYXZqs3IYsF72VxQMDuwC2YtU5aqGHG6Ugj7xIwOMUjF8jDpl3tg/1CCKFiuEjFMABxABkVPBmsghpA+/WtZGQy4DDRnz1f3aC7PmUu41dUwI/JFZWsJuKGyar29vF7F7xhmHLcCqIDNGqOFC/Gbka4HPrGE8vvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOJ+QtrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOJ+QtrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD0AC4CEF1;
	Mon, 27 Oct 2025 19:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592127;
	bh=1TsHgw3UBX/dEKgE+fRb+VdrVraqadrdYwstlUJ//ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOJ+QtrWr7ih1HYTS5MoEhdZNyeUtlQWq3iE1G+o+vLNV4KyEv9fCEW0qaBeJw5EP
	 89KRAb+38aohIhBNTFGtfYpE9Q7TMyRT3PTY80V1gn892vBu/CafisOGC9ftHPijkF
	 /cJ6iKcOgCB0JoPQJFQ7UFGVkzooq4jF9dI+L4o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/123] PCI: j721e: Enable ACSPCIE Refclk if "ti,syscon-acspcie-proxy-ctrl" exists
Date: Mon, 27 Oct 2025 19:36:22 +0100
Message-ID: <20251027183449.118782130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 82c4be4168e26a5593aaa1002b5678128a638824 ]

The ACSPCIE module is capable of driving the reference clock required by
the PCIe Endpoint device. It is an alternative to on-board and external
reference clock generators. Enabling the output from the ACSPCIE module's
PAD IO Buffers requires clearing the "PAD IO disable" bits of the
ACSPCIE_PROXY_CTRL register in the CTRL_MMR register space.

Add support to enable the ACSPCIE reference clock output using the optional
device-tree property "ti,syscon-acspcie-proxy-ctrl".

Link: https://lore.kernel.org/linux-pci/20240829105316.1483684-3-s-vadapalli@ti.com
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: f842d3313ba1 ("PCI: j721e: Fix programming sequence of "strap" settings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/cadence/pci-j721e.c |   39 ++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -46,6 +46,7 @@ enum link_status {
 #define LANE_COUNT_MASK			BIT(8)
 #define LANE_COUNT(n)			((n) << 8)
 
+#define ACSPCIE_PAD_DISABLE_MASK	GENMASK(1, 0)
 #define GENERATION_SEL_MASK		GENMASK(1, 0)
 
 #define MAX_LANES			2
@@ -218,6 +219,36 @@ static int j721e_pcie_set_lane_count(str
 	return ret;
 }
 
+static int j721e_enable_acspcie_refclk(struct j721e_pcie *pcie,
+				       struct regmap *syscon)
+{
+	struct device *dev = pcie->cdns_pcie->dev;
+	struct device_node *node = dev->of_node;
+	u32 mask = ACSPCIE_PAD_DISABLE_MASK;
+	struct of_phandle_args args;
+	u32 val;
+	int ret;
+
+	ret = of_parse_phandle_with_fixed_args(node,
+					       "ti,syscon-acspcie-proxy-ctrl",
+					       1, 0, &args);
+	if (ret) {
+		dev_err(dev,
+			"ti,syscon-acspcie-proxy-ctrl has invalid arguments\n");
+		return ret;
+	}
+
+	/* Clear PAD IO disable bits to enable refclk output */
+	val = ~(args.args[0]);
+	ret = regmap_update_bits(syscon, 0, mask, val);
+	if (ret) {
+		dev_err(dev, "failed to enable ACSPCIE refclk: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int j721e_pcie_ctrl_init(struct j721e_pcie *pcie)
 {
 	struct device *dev = pcie->dev;
@@ -257,7 +288,13 @@ static int j721e_pcie_ctrl_init(struct j
 		return ret;
 	}
 
-	return 0;
+	/* Enable ACSPCIE refclk output if the optional property exists */
+	syscon = syscon_regmap_lookup_by_phandle_optional(node,
+						"ti,syscon-acspcie-proxy-ctrl");
+	if (!syscon)
+		return 0;
+
+	return j721e_enable_acspcie_refclk(pcie, syscon);
 }
 
 static int cdns_ti_pcie_config_read(struct pci_bus *bus, unsigned int devfn,


