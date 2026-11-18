Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016693;
	b=OU0FON4vtaalE1McCV3wCSJRmwKcE+xGl49yIONpx2Z4ojQloLUZJT/ydw16UndhgrEA
	 ykvmaMgQlz7Uc+fxtXpJHIz5exwUeaQ+C0RPscipzgYBPsu0XkbnXbJuPb6MjWScy/Vb5
	 H2ofWlSj7UjZ0uqOvSY1QRt1Lf5rUhWDjpRoCD5rE7o9y/JTvbRv1Sbae+KXSTRWZdOu8
	 3c0TpPDPN06bPLtR4hi0Y0ecPFwUK6Iym+wJwi95oMDNC+JAUO8GEQXbT43yasI1H8rwQ
	 TvU1Fpp5d4FKJK4JLR6NniaAzfAmUg/clM3Sbez8fUTY5nZ39B0XHYRqLwDdHg/q5+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UGPp0GTOkKq1FGIVmpPGYJ0GrwSvAukf6CGJ0fLvCWw=;
	b=IoAtHIM7yit77Ve6IceJnf2U6IKUF3sEu44pSD/YgYYqOwhiYpkEeL9iDz6PAM8R6bJm
	 KGQX+Twjq9PG8moGdAIF7zOGsX/iFh5r2Vd0NAgT8m7h1n+/gd+1TmTR+aLmUYqXlpWdb
	 Iuyj+V7IT9eRxxxBBkjAZNZNWt6W95yRl36a5v6dmnta0HYYD+Pie89M4I3NQUbnU8TcP
	 Gt52m26RQfRmWQogT2oepod7sHSK22cG9VwiOh5I2MAE+h3c3YXqYWqwEvYSH1Kr8ngra
	 IrbSLSLbOrQ+39JcZKxzHfnS1IJZIR5mScYqmIzIDKuEwQYPXM0LiiGJ/3JXM7+QMQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=to7L+lVn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67657606A31C;
	Wed, 18 Nov 2026 15:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=to7L+lVn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE1F1F000C4;
	Wed, 18 Nov 2026 15:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016693;
	bh=UGPp0GTOkKq1FGIVmpPGYJ0GrwSvAukf6CGJ0fLvCWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=to7L+lVng03qf6eCAGdf3vDY1K61q5dLFIZ31YdFltaAk1b03BjIjURpsvb7aWrbv
	 +Kie8gYOWE7hx1xy8J8XiKW2iMkpbmQgOItUIsrfhmbVG0QwV7W2oYIcRK0PtMnt8/
	 FWyMsfsT1EyIkODwNRH5PfsZfnAwf04OAfJxFadw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0620/2651] i3c: master: Match ACPI targets to the correct bus controller instance
Date: Wed, 18 Nov 2026 15:31:00 +0100
Message-ID: <20261118150310.019827032@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 25648fb7cebb7e1963afc31c07e650d703cfc140 ]

For ACPI-enumerated I3C targets, _ADR encodes both the zero-based bus
controller instance number in bits 51:48 and the Provisioned ID (PID)
in bits 47:0, as defined by ACPI 6.6 Table 6.2 and MIPI DisCo for I3C
v1.1 section 5.2.

However, i3c_master_add_acpi_dev() treats the entire _ADR value as the
PID. On multi-instance controllers this folds the instance number into
the PID, causing i3c_master_add_i3c_boardinfo() to reject devices on
instance 1 and above with -EINVAL.

The problem is exposed by the MIPI I3C HCI PCI driver, which creates one
MFD child device per bus controller instance. Since the child devices do
not have their own ACPI companions, they all inherit the parent's ACPI
node and therefore enumerate the same set of child devices. As a result,
a target belonging to any instance other than 0 prevents registration of
all controller instances.

Add an instance number to struct i3c_master_controller, propagate it
from the HCI PCI driver, extract the PID from bits 47:0 of _ADR, and
ignore ACPI child nodes that belong to a different controller instance.

ACPI-enumerated I2C devices are unaffected. Their controller instance is
encoded in the Resource Source Index of the I2cSerialBusV2 descriptor
rather than in _ADR and will require separate handling.

Fixes: b46a4b3c5d1e ("i3c: master: Support ACPI enumeration of child devices")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c                          | 19 +++++++++++++++++--
 drivers/i3c/master/mipi-i3c-hci/core.c        |  4 +++-
 .../master/mipi-i3c-hci/mipi-i3c-hci-pci.c    |  1 +
 include/linux/i3c/master.h                    |  3 +++
 include/linux/platform_data/mipi-i3c-hci.h    |  4 ++++
 5 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index f9a6c8560fabf..215a22f2c7b61 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -8,6 +8,7 @@
 #include <dt-bindings/i3c/i3c.h>
 #include <linux/acpi.h>
 #include <linux/atomic.h>
+#include <linux/bitfield.h>
 #include <linux/bitmap.h>
 #include <linux/bug.h>
 #include <linux/delay.h>
@@ -3076,6 +3077,13 @@ static int i3c_master_add_of_dev(struct i3c_master_controller *master,
 	return ret;
 }
 
+#define I3C_ACPI_ADR_PID GENMASK_U64(47, 0)
+/*
+ * Zero-based instance number of the Bus Controller to which the Target is
+ * connected.
+ */
+#define I3C_ACPI_ADR_INSTANCE GENMASK_U64(51, 48)
+
 #ifdef CONFIG_ACPI
 static int i3c_master_add_acpi_dev(struct i3c_master_controller *master,
 				   struct fwnode_handle *fwnode)
@@ -3083,6 +3091,7 @@ static int i3c_master_add_acpi_dev(struct i3c_master_controller *master,
 	struct acpi_device *adev = to_acpi_device_node(fwnode);
 	acpi_bus_address adr;
 	u32 reg[3] = { 0 };
+	u64 pid;
 	int ret;
 
 	/*
@@ -3100,9 +3109,15 @@ static int i3c_master_add_acpi_dev(struct i3c_master_controller *master,
 
 	adr = acpi_device_adr(adev);
 
+	/* Match the multi-bus instance number */
+	if (FIELD_GET(I3C_ACPI_ADR_INSTANCE, adr) != master->instance)
+		return 0;
+
 	/* For I3C devices, _ADR will have the 48 bit PID of the device  */
-	reg[1] = upper_32_bits(adr);
-	reg[2] = lower_32_bits(adr);
+	pid = FIELD_GET(I3C_ACPI_ADR_PID, adr);
+
+	reg[1] = upper_32_bits(pid);
+	reg[2] = lower_32_bits(pid);
 
 	fwnode_property_read_u32(fwnode, "mipi-i3c-static-address", &reg[0]);
 
diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index dadf049bd4b54..8b3a87d8a8bb0 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -1142,8 +1142,10 @@ static int i3c_hci_probe(struct platform_device *pdev)
 	 * necessarily in separate contiguous sub-ranges. To avoid overlapping
 	 * mappings, provide base_regs from the parent mapping.
 	 */
-	if (pdata)
+	if (pdata) {
 		hci->base_regs = pdata->base_regs;
+		hci->master.instance = pdata->instance;
+	}
 
 	if (!hci->base_regs) {
 		hci->base_regs = devm_platform_ioremap_resource(pdev, 0);
diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
index af9595009b03a..5b8e10d05ceea 100644
--- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
+++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
@@ -390,6 +390,7 @@ static void mipi_i3c_hci_pci_setup_cell(struct mipi_i3c_hci_pci *hci, int idx,
 					struct mfd_cell *cell)
 {
 	data->pdata.base_regs = hci->base + hci->info->instance_offset[idx];
+	data->pdata.instance = idx;
 
 	data->res = DEFINE_RES_IRQ(0);
 
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index f7ceec2b44773..72065715feee5 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -536,6 +536,8 @@ struct i3c_master_controller_ops {
  *		 Bit 0: SETDASA
  *		 Bit 1: SETAASA
  *		 All other bits are reserved.
+ * @instance: Zero-based instance number of the Bus Controller as defined by the
+ *            DisCo specification I3C Target Address (_ADR) Encoding
  * @wq: freezable workqueue which can be used by master
  *	drivers if they need to postpone operations that need to take place
  *	in a thread context. Typical examples are Hot Join processing which
@@ -573,6 +575,7 @@ struct i3c_master_controller {
 	} boardinfo;
 	struct i3c_bus bus;
 	u8 addr_method;
+	u8 instance;
 	struct workqueue_struct *wq;
 	struct work_struct hj_work;
 	struct work_struct reg_work;
diff --git a/include/linux/platform_data/mipi-i3c-hci.h b/include/linux/platform_data/mipi-i3c-hci.h
index ab7395f455f94..6f61d8a023786 100644
--- a/include/linux/platform_data/mipi-i3c-hci.h
+++ b/include/linux/platform_data/mipi-i3c-hci.h
@@ -3,13 +3,17 @@
 #define INCLUDE_PLATFORM_DATA_MIPI_I3C_HCI_H
 
 #include <linux/compiler_types.h>
+#include <linux/types.h>
 
 /**
  * struct mipi_i3c_hci_platform_data - Platform-dependent data for mipi_i3c_hci
  * @base_regs: Register set base address (to support multi-bus instances)
+ * @instance: Zero-based instance number of the Bus Controller as defined by the
+ *            DisCo specification I3C Target Address (_ADR) Encoding
  */
 struct mipi_i3c_hci_platform_data {
 	void __iomem *base_regs;
+	u8 instance;
 };
 
 #endif
-- 
2.53.0



