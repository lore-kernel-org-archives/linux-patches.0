Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018854;
	b=rVOXVBr3aegxyxx6Ce9wqaV7L1aRCgADXCSrO8sbHx+9rm1VZ445ZcbVqNJKcpNmE6ke
	 X56grYtntX8TWqUa1hpN61Inck9g0DybPP3Jvcs7CZJVWmWqC6mCcPF9PUAjSIMxM1JBh
	 +JjvtJ/Mmtc4d8Pi1plTOsjv9kVHPbTiNL/iFqtkMjVx/5b4n0TxoR+5v0x7v8yiuJ48I
	 L86J+DBZ269mx3XWvH5JDqbXOJUjtP7FOwc+WG6U2X1FUm5xEv65zOclG6BwC8Ca7tvez
	 SoSSfNV1yslS3Ggjg/9Ri/f7Ezkt1ZobNgG7ttUCMjALQ8IU60dJ+kdZxKoqHFpKBJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nG/dcYTZSAOofmVIa3v0M644Vc6K+NPzquUihaQT04w=;
	b=3LFZfQY9i8MlwFLwJhsCJqe7r8ZUDBG/WSMXsgus67h2Xw8gACd6BiAVG82UMfXyBi74
	 z8kf32EGcSpzdYzQBtr/2xxuA93ZtEHJraODNyWHDuQKp4lz5/okVVYo/UBYq2krX/3P+
	 Wgy6qWY5V1fH6gqWGkEbaFzqyKXYM7sFVBgD6ooqkkNmg1BEPcbcnTCw+qQSlIStxyk7s
	 scrgUib74ac0y6fmBHqNesHVBSOwJrR6YUoWryzWIpQrGXZknHVniHY0yGdRgTgqaiGPl
	 G7VD4qYt71IsI/JcxNjVROrat/HmKc4ozeMhzoN7QHzsvcnJE/NZccpbeLDFqTN8ZXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwdfWgC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247AC606A31C;
	Wed, 18 Nov 2026 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwdfWgC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778CF1F000C5;
	Wed, 18 Nov 2026 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018854;
	bh=nG/dcYTZSAOofmVIa3v0M644Vc6K+NPzquUihaQT04w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwdfWgC6POTm/p5Xu3Uv6VZPfYCDSAuxNRS5ZTLbYd1qrkQF8toU5+ATVinJBd89z
	 3G3Fq5OSZi20nfCDjDuA6G2KMbATUNzBr8BpM9UHoK+uA3CnAn8k3Ou3XXeR9y0zSq
	 VJGAHZ2A4cCWf/0OdR+YRL+R+Can6eSN6XzC0h7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1387/2651] PCI/ACPI: Tidy _OSC control bit checking
Date: Wed, 18 Nov 2026 15:43:47 +0100
Message-ID: <20261118150337.950855051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 0a1fdf4546ccf2f02845135fa5b36ed90685b220 ]

Add OSC_OWNER() helper to prettify checking the _OSC control bits to learn
whether the platform has granted us control of PCI features.  No functional
change intended.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Link: https://patch.msgid.link/20261002211828.1293177-3-sathyanarayanan.kuppuswamy@linux.intel.com
Stable-dep-of: 4fe37866b0d9 ("PCI/ACPI: Centralize pcie_ports_native checking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_root.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 88c65f34e3058..756dc2f055f51 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -993,6 +993,12 @@ static void acpi_pci_root_release_info(struct pci_host_bridge *bridge)
 	__acpi_pci_root_release_info(bridge->release_data);
 }
 
+#define OSC_OWNER(ctrl, bit, flag)		\
+	do {					\
+		if (!((ctrl) & (bit)))		\
+			flag = 0;		\
+	} while (0)
+
 struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 				     struct acpi_pci_root_ops *ops,
 				     struct acpi_pci_root_info *info,
@@ -1003,6 +1009,7 @@ struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 	int node = acpi_get_node(device->handle);
 	struct pci_bus *bus;
 	struct pci_host_bridge *host_bridge;
+	u32 ctrl, ext_ctrl;
 
 	info->root = root;
 	info->bridge = device;
@@ -1028,21 +1035,21 @@ struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 		goto out_release_info;
 
 	host_bridge = to_pci_host_bridge(bus->bridge);
-	if (!(root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
-		host_bridge->native_pcie_hotplug = 0;
-	if (!(root->osc_control_set & OSC_PCI_SHPC_NATIVE_HP_CONTROL))
-		host_bridge->native_shpc_hotplug = 0;
-	if (!(root->osc_control_set & OSC_PCI_EXPRESS_AER_CONTROL))
-		host_bridge->native_aer = 0;
-	if (!(root->osc_control_set & OSC_PCI_EXPRESS_PME_CONTROL))
-		host_bridge->native_pme = 0;
-	if (!(root->osc_control_set & OSC_PCI_EXPRESS_LTR_CONTROL))
-		host_bridge->native_ltr = 0;
-	if (!(root->osc_control_set & OSC_PCI_EXPRESS_DPC_CONTROL))
-		host_bridge->native_dpc = 0;
-
-	if (!(root->osc_ext_control_set & OSC_CXL_ERROR_REPORTING_CONTROL))
-		host_bridge->native_cxl_error = 0;
+
+	ctrl = root->osc_control_set;
+	ext_ctrl = root->osc_ext_control_set;
+
+	OSC_OWNER(ctrl, OSC_PCI_EXPRESS_NATIVE_HP_CONTROL,
+		  host_bridge->native_pcie_hotplug);
+	OSC_OWNER(ctrl, OSC_PCI_SHPC_NATIVE_HP_CONTROL,
+		  host_bridge->native_shpc_hotplug);
+	OSC_OWNER(ctrl, OSC_PCI_EXPRESS_AER_CONTROL, host_bridge->native_aer);
+	OSC_OWNER(ctrl, OSC_PCI_EXPRESS_PME_CONTROL, host_bridge->native_pme);
+	OSC_OWNER(ctrl, OSC_PCI_EXPRESS_LTR_CONTROL, host_bridge->native_ltr);
+	OSC_OWNER(ctrl, OSC_PCI_EXPRESS_DPC_CONTROL, host_bridge->native_dpc);
+
+	OSC_OWNER(ext_ctrl, OSC_CXL_ERROR_REPORTING_CONTROL,
+		  host_bridge->native_cxl_error);
 
 	acpi_dev_power_up_children_with_adr(device);
 
-- 
2.53.0



