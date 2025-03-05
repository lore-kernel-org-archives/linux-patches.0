Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB341C6FF6;
	Wed,  5 Mar 2025 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198237; cv=none; b=AvGJ1QJKy6zHuPMmx54Zk4jirK9W9ganAFMLY4bItmllfZAkweolc3jY8YnYv3ePtgc/HE7Mxo07Y+3KykEiQV2V+z05r8nvQSCR4UQHuUEwWzkl4nkd0KlUoVZKJlaPIII1AVt+pAAs6hr4Vz74sqAGYxJnXDDc7Xu5olTgfB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198237; c=relaxed/simple;
	bh=hyY0zMr5LU4XaqUWN6yhqNQ18cZUWtbOAb1ZKbg8qDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMiHjGC9dAHTef4V4eSRD7WOVu0QWmYj79/TdSoB7TIWqR5y9M/U9jxCxdn610CfDOLxSmyp7/AyET6wFx0NH2yD6gIWawX6PIovV6RxF4ne+gQljF19w7YSn4iMyzQ/k/V/IsD/LwOPoeFOjan9/5fGqiNX5uij9Wsp07ND8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nayGqy4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nayGqy4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5467C4CEE0;
	Wed,  5 Mar 2025 18:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198237;
	bh=hyY0zMr5LU4XaqUWN6yhqNQ18cZUWtbOAb1ZKbg8qDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nayGqy4crvQqyZT7011zsVOjvGIOJKIlLsoN1t/UG0WbRP6KDwSmFiqRWk9IgJT18
	 uHZBZBRbLiCQsbhD7j1eJGFtIDOVmgfSunJOIr85u+W4JKCUxn313UHKW9A07YpY7w
	 MFDNJQU1FQ9hZwv2XFjqCyGl+dE6LO5L77YkQvj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 109/150] net: stmmac: dwmac-loongson: Add fix_soc_reset() callback
Date: Wed,  5 Mar 2025 18:48:58 +0100
Message-ID: <20250305174508.191771610@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

commit f06e4bfd010faefa637689d2df2c727dbf6e1d27 upstream.

Loongson's DWMAC device may take nearly two seconds to complete DMA reset,
however, the default waiting time for reset is 200 milliseconds.
Therefore, the following error message may appear:

[14.427169] dwmac-loongson-pci 0000:00:03.2: Failed to reset the dma

Fixes: 803fc61df261 ("net: stmmac: dwmac-loongson: Add Loongson Multi-channels GMAC support")
Cc: stable@vger.kernel.org
Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Yanteng Si <si.yanteng@linux.dev>
Link: https://patch.msgid.link/20250219020701.15139-1-zhaoqunqin@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index bfe6e2d631bd..f5acfb7d4ff6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -516,6 +516,19 @@ static int loongson_dwmac_acpi_config(struct pci_dev *pdev,
 	return 0;
 }
 
+/* Loongson's DWMAC device may take nearly two seconds to complete DMA reset */
+static int loongson_dwmac_fix_reset(void *priv, void __iomem *ioaddr)
+{
+	u32 value = readl(ioaddr + DMA_BUS_MODE);
+
+	value |= DMA_BUS_MODE_SFT_RESET;
+	writel(value, ioaddr + DMA_BUS_MODE);
+
+	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
+				  !(value & DMA_BUS_MODE_SFT_RESET),
+				  10000, 2000000);
+}
+
 static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct plat_stmmacenet_data *plat;
@@ -566,6 +579,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	plat->bsp_priv = ld;
 	plat->setup = loongson_dwmac_setup;
+	plat->fix_soc_reset = loongson_dwmac_fix_reset;
 	ld->dev = &pdev->dev;
 	ld->loongson_id = readl(res.addr + GMAC_VERSION) & 0xff;
 
-- 
2.48.1



