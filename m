Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214352;
	b=WjYP70sht5URCZVe+r33WiY1tOZZmiVnXN/TqN0mgXDmfGI1LAs14LN9+JhwcNXgnkPj
	 DwsSQMrYUAS8jdb1MlJdiiZ2xcLHvs2rv27oFRaNgeLaH9X7XK6XwZzZEGWVIntNho3xA
	 tSymhfoAAvhieBd7OtN7eKVONc7nijCNwMwzWHos8uxe7vx8/vkhgigpQAPCLjhWezrsO
	 wUkTYin/D2urGQaIGEb7vTsiE3JEl5v6HzBIMdE8oiHVegi/sQrdjIgcOojJJ93G6Zyc0
	 o4OzCpJB9Lkb9Hxc2QZdG1hfJN1yBjqPf3BLEpoaPs3YI+2A7Gyg1Z110FTHn7+z9Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oni6VUZiMeopsQJgWSj15ZbzEW7ne5GYKfnwY2JyT5U=;
	b=D49MCeGF7FLK8QT9G8nu4qKDnnXicJ5seOelKjLDY2oDmewmhOeZKVQ8D15Gau6xRo05
	 ++qf2T82EfmT6OWTW+Mnl58W4PbfmtPKIpGHYzIrB+tAS7FcL2A2/N/47sIAWibRKEme5
	 ezdrFpgR8rC1Yp+56ecGfXP3ndXNzMmPiyQ7qaAg4Zmo+032wUOm22wF9U1iJoCBzm/81
	 0d3MFpEfN551SLparXk6uzX2vCiazQHGrseM+N2LpWBgaap0+afBRJQ4/Sx0CV3aKKvuR
	 6WGbdNT0/z1VYKepOTvlhnijPSyVbD6SelpXIKmJ9hgbHuAG/OLuABawqRe/qQu11ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrxfXdYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3B060A261D;
	Wed, 28 Oct 2026 19:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrxfXdYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2CD1F031E3;
	Wed, 28 Oct 2026 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214351;
	bh=oni6VUZiMeopsQJgWSj15ZbzEW7ne5GYKfnwY2JyT5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrxfXdYF3YdgPa6OKXZCdLbXbAkSAdtqUMwaNQ8u8v4/xsWQ/+0zBPY+aroeEuX4i
	 KluzQw5rqXtGC+aP6iDx6AEeKyqONKCkDZA6ZszQMG3Kz2KHrxpPNZoaztLTrBOgSp
	 dju8W6Vr+4SehuS5xsbeKduatuDgpfaqb3HsTAPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ohad Sharabi <osharabi@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0828/1887] habanalabs: helper function to validate export params
Date: Wed, 28 Oct 2026 17:48:44 +0100
Message-ID: <20261028170518.266590516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ohad Sharabi <osharabi@habana.ai>

[ Upstream commit 54fde5505c1311d45a96d7ad8fb8809581d38f22 ]

Validate export parameters in a dedicated function instead of in the
main export flow.
This will be useful later when support to export dmabuf for devices
with virtual memory will be added.

Signed-off-by: Ohad Sharabi <osharabi@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Stable-dep-of: 33927f3d0ecd ("habanalabs: fix UAF in export_dmabuf()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/memory.c | 79 ++++++++++++++-----------
 1 file changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 7ae0779fbf072..dcc496083f1c6 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -1797,36 +1797,10 @@ static int export_dmabuf(struct hl_ctx *ctx,
 	return rc;
 }
 
-/**
- * export_dmabuf_from_addr() - export a dma-buf object for the given memory
- *                             address and size.
- * @ctx: pointer to the context structure.
- * @device_addr:  device memory physical address.
- * @size: size of device memory.
- * @flags: DMA-BUF file/FD flags.
- * @dmabuf_fd: pointer to result FD that represents the dma-buf object.
- *
- * Create and export a dma-buf object for an existing memory allocation inside
- * the device memory, and return a FD which is associated with the dma-buf
- * object.
- *
- * Return: 0 on success, non-zero for failure.
- */
-static int export_dmabuf_from_addr(struct hl_ctx *ctx, u64 device_addr,
-					u64 size, int flags, int *dmabuf_fd)
+static int validate_export_params(struct hl_device *hdev, u64 device_addr, u64 size)
 {
-	struct hl_dmabuf_priv *hl_dmabuf;
-	struct hl_device *hdev = ctx->hdev;
-	struct asic_fixed_properties *prop;
+	struct asic_fixed_properties *prop = &hdev->asic_prop;
 	u64 bar_address;
-	int rc;
-
-	prop = &hdev->asic_prop;
-
-	if (prop->dram_supports_virtual_memory) {
-		dev_dbg(hdev->dev, "Export not supported for devices with virtual memory\n");
-		return -EOPNOTSUPP;
-	}
 
 	if (!IS_ALIGNED(device_addr, PAGE_SIZE)) {
 		dev_dbg(hdev->dev,
@@ -1843,26 +1817,61 @@ static int export_dmabuf_from_addr(struct hl_ctx *ctx, u64 device_addr,
 	}
 
 	if (device_addr < prop->dram_user_base_address ||
-				device_addr + size > prop->dram_end_address ||
-				device_addr + size < device_addr) {
+				(device_addr + size) > prop->dram_end_address ||
+				(device_addr + size) < device_addr) {
 		dev_dbg(hdev->dev,
 			"DRAM memory range 0x%llx (+0x%llx) is outside of DRAM boundaries\n",
 			device_addr, size);
 		return -EINVAL;
 	}
 
-	bar_address = hdev->dram_pci_bar_start +
-			(device_addr - prop->dram_base_address);
+	bar_address = hdev->dram_pci_bar_start + (device_addr - prop->dram_base_address);
 
-	if (bar_address + size >
-			hdev->dram_pci_bar_start + prop->dram_pci_bar_size ||
-			bar_address + size < bar_address) {
+	if ((bar_address + size) > (hdev->dram_pci_bar_start + prop->dram_pci_bar_size) ||
+			(bar_address + size) < bar_address) {
 		dev_dbg(hdev->dev,
 			"DRAM memory range 0x%llx (+0x%llx) is outside of PCI BAR boundaries\n",
 			device_addr, size);
 		return -EINVAL;
 	}
 
+	return 0;
+}
+
+/**
+ * export_dmabuf_from_addr() - export a dma-buf object for the given memory
+ *                             address and size.
+ * @ctx: pointer to the context structure.
+ * @device_addr:  device memory physical address.
+ * @size: size of device memory.
+ * @flags: DMA-BUF file/FD flags.
+ * @dmabuf_fd: pointer to result FD that represents the dma-buf object.
+ *
+ * Create and export a dma-buf object for an existing memory allocation inside
+ * the device memory, and return a FD which is associated with the dma-buf
+ * object.
+ *
+ * Return: 0 on success, non-zero for failure.
+ */
+static int export_dmabuf_from_addr(struct hl_ctx *ctx, u64 device_addr,
+					u64 size, int flags, int *dmabuf_fd)
+{
+	struct hl_dmabuf_priv *hl_dmabuf;
+	struct hl_device *hdev = ctx->hdev;
+	struct asic_fixed_properties *prop;
+	int rc;
+
+	prop = &hdev->asic_prop;
+
+	if (prop->dram_supports_virtual_memory) {
+		dev_dbg(hdev->dev, "Export not supported for devices with virtual memory\n");
+		return -EOPNOTSUPP;
+	}
+
+	rc = validate_export_params(hdev, device_addr, size);
+	if (rc)
+		return rc;
+
 	hl_dmabuf = kzalloc(sizeof(*hl_dmabuf), GFP_KERNEL);
 	if (!hl_dmabuf)
 		return -ENOMEM;
-- 
2.53.0



