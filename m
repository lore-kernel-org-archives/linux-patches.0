Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C56303A0E;
	Sat, 25 Oct 2025 16:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408725; cv=none; b=Nu3THEsgqhLB70mEm1Hl0XiB3TwQEjlruAY6qm+2hwjuhp7Kj93Bdpk+ATL+F1q9W93igNJCYZ/VfdyT0qC1LRzG4y1kN19a2nfHN1bhMyk86mwpLdGlatHpPdSLU06bCtDxAn8mVE9Yo9qEaYBaYveDnqOHrAFSVknfsll+VqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408725; c=relaxed/simple;
	bh=+lzY6IZ4hCXTAaFY7hPCx3VNSpeh5RjUQpRnATfLobs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJlWgfrxnNSYN21ZGLaHVB/HiIbrwTwrC8c7uw07YOF6L//e48lCE488QISMnS+9TWF7CM08rNujpd0pPwiUEpfIkMZ4Y9y+ADZw3A3ZUV4NBesVaLVe5beqy6enowICjvDy0ApjNO9J1E97xQfmM+60tqbcZKViKC42zQltItM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFK1zEg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFK1zEg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0CCC4CEFB;
	Sat, 25 Oct 2025 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408723;
	bh=+lzY6IZ4hCXTAaFY7hPCx3VNSpeh5RjUQpRnATfLobs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFK1zEg9M2AU7GrAN5515ZbHAjv7IVPCA3HgTMhtpzuIqN08DHPAIqXXd7saUrz3J
	 CNDtRZIL4rvVnMdq6TorJVKAubcptoXHEhAcDTOeDrgGWNqAD72TfKIaRU+d8mrSEI
	 avGHlbhLEmgBcBXrYH5l/LVnKnn6IJFZDshm/0pLPpq1eacNvEgwXsR23UAcWo/xr2
	 d5abmaWxp5ShnDnm3QRia8Q37Viv1yjfQD7FUwePh9Sn9aCdzAcn3Dz5Zc8+SBcrS4
	 kx+L4qnjrt9rhYT5vsbeITrdDCMXV4fWs0KGEHgBgJeBNwdY0Jj9yeSaiDy3VPmsGZ
	 NaQE/XMAIsabw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] mips: lantiq: danube: add missing device_type in pci node
Date: Sat, 25 Oct 2025 11:54:45 -0400
Message-ID: <20251025160905.3857885-54-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit d66949a1875352d2ddd52b144333288952a9e36f ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: pci@e105400 (lantiq,pci-xway): 'device_type' is a required property
	from schema $id: http://devicetree.org/schemas/pci/pci-bus-common.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The patch adds `device_type = "pci";` to the PCI host
  bridge node `pci@e105400` in
  `arch/mips/boot/dts/lantiq/danube.dtsi:108`. The node already had
  proper `#address-cells = <3>`, `#size-cells = <2>`, `#interrupt-cells
  = <1>`, `compatible = "lantiq,pci-xway"`, `bus-range`, `ranges` (with
  both memory and IO windows), and `reg` (see
  arch/mips/boot/dts/lantiq/danube.dtsi:97-106). The only missing piece
  was the `device_type` property.

- Why it matters (binding/spec): The PCI bus binding requires
  `device_type = "pci"` on PCI bus nodes (commit message cites the DT
  schema error), so this is a correctness fix to match devicetree
  bindings.

- Why it matters (runtime): Linux uses the `device_type` property to
  recognize PCI bus nodes and select the PCI bus translator in the OF
  address translation code. Specifically:
  - The bus matcher for PCI requires `device_type = "pci"` (or `pciex`,
    or a node name “pcie”) to identify the node as a PCI bus
    (drivers/of/address.c: of_bus_pci_match).
  - If `device_type` is missing on a node named “pci@…”, the generic
    “default-flags” bus is selected instead of the PCI bus. That leads
    to incorrect parsing of the `ranges` flags.
  - MIPS PCI host setup for Lantiq calls
    `pci_load_of_ranges(&pci_controller, pdev->dev.of_node)`
    (arch/mips/pci/pci-lantiq.c:219), which iterates
    `for_each_of_pci_range` and switches on `range.flags &
    IORESOURCE_TYPE_BITS` to configure the I/O and MEM windows
    (arch/mips/pci/pci-legacy.c:145-177). Without the PCI bus
    translator, those flags are not decoded as
    `IORESOURCE_IO`/`IORESOURCE_MEM`, so ranges may be skipped or
    misclassified, breaking I/O space mapping and potentially PCI host
    initialization.

- Scope and risk: The change is a single-line DTS fix, confined to the
  Lantiq Danube SoC. It does not introduce new features or architectural
  changes. It aligns with many other MIPS PCI DTs that already set
  `device_type = "pci"`, and it brings the node into compliance with the
  binding and the kernel’s OF bus matching logic. Regression risk is
  minimal; the intended behavior is precisely to have this node
  recognized as a PCI bus.

- Stable criteria:
  - Fixes a real defect (schema error and likely functional mis-parsing
    of PCI ranges on this platform).
  - Small and self-contained (one DTS line).
  - No architectural churn; no cross-subsystem impact.
  - Touches a platform DTS; DT ABI impact is corrective and consistent
    with binding requirements.

Given the above, backporting this fix will eliminate binding violations
and prevent incorrect PCI resource setup on Lantiq Danube systems.

 arch/mips/boot/dts/lantiq/danube.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
index 0a942bc091436..650400bd5725f 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -104,6 +104,8 @@ pci0: pci@e105400 {
 				  0x1000000 0 0x00000000 0xae00000 0 0x200000>; /* io space */
 			reg = <0x7000000 0x8000		/* config space */
 				0xe105400 0x400>;	/* pci bridge */
+
+			device_type = "pci";
 		};
 	};
 };
-- 
2.51.0

