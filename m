Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064604;
	b=XffJ8abuTF9zvNJIOOCKE7WxKxaQlOm4V5jAGf6Td0raaD56vDxvQ9QPncK+x2eBYd6O
	 KKC8pVuWiGTunZzIkJWrH/LgVwk8x1Q/6GM9yUugv1TSYjzYnunxbLMruhjPUVHqGziX/
	 UMN2Rq+fV8hoy6t2fUbrZibj9ZPXuGMx68EhNd/+aMiXfn5x+WIzh60kRbIJ7OhGC3GrA
	 qqTCWP78cJzKXN94eyU/jumk9z+3Ty1t+HAzVHges96XZhVqr/xXKCJ8oWwF69xE7UBbe
	 WibC/3j9okL6EglJmzC242md1r1H9qu7GteEJ/IayReV5CvDUzvN3EGqkJZUlYc4YDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PWr8DhV6fGVimK/o4pA6MfiRs6hg1MXLgRI3o+BNahY=;
	b=S25JSf4Vl9tcWbxB6ICT2oYfy1n9gb0A124TrK4Jau82UEHFdHV0LMtPuAxhC++xSeH1
	 kigaFEmzO+k+5Nk47tAO0u8qUKNX3+XHLVejYinKp5dDLRP2rQLbtweWKLszbGYpYALQK
	 cOo6ZqLi94xp7+YCGeWq9KI/VKO5ewZR+OxtkEWnWOiXaWdhbiJnavxNTp7PEgWMm97/b
	 ykQ5h2K9ziCNUoxfvWFiScdY6QUGtixSKJ2iuNeX56XulIQibseSE3erUic8GAQQz/nup
	 A65icfEXD5Ord9WiW03R+NSho5lHaB2FZX67BrA//RVuUxIDbvqUM6oeZzTdq5kMCdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V5k2SstF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB15606E8F7;
	Sat,  7 Nov 2026 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V5k2SstF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F324E1F0089F;
	Sat,  7 Nov 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064604;
	bh=PWr8DhV6fGVimK/o4pA6MfiRs6hg1MXLgRI3o+BNahY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5k2SstFbaGvfIWdlXRdC70d2xzu0aTQfiVDIflKsJ+R0OLZlYf+KZqx3GRQNTi6A
	 PZIyfJqGgXr2w2YX4okB6Q76VgGhJAVz24mYNV003z0UobLs0bi+deLufakYObGG6O
	 9kqleeyEPS6/rqCp+EReUKfNMcDQVh+KqBtCRWew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7.3 0616/1257] cxl: Account for link width in latency calculation
Date: Sat,  7 Nov 2026 08:48:32 -0500
Message-ID: <20261107134956.317001771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit db4503d4575cdd2fad7e8a13a8a8ffcbc86d152d ]

cxl_pci_get_latency() derives bandwidth from the per-lane speed returned
by pcie_link_speed_mbps(), ignoring the negotiated link width. This
overestimates the FlitLatency contribution for multi-lane links.
Sections 2.11.3 and 2.11.4 of the Intel CXL Memory Device Software Guide
describe the link bandwidth as the product of the negotiated speed and
width.

Replace pcie_link_speed_mbps() with pcie_link_bandwidth_mbps() and
migrate both CXL callers (the only users of the API). The new helper
obtains speed and width from a single Link Status read. The CXL
bandwidth calculation no longer needs a separate width read and
multiplication.

While at it, make error handling more robust by converting PCI config
read errors to negative errno values and checking for zero bandwidth
before calculating latency.

Fixes: 4d07a05397c8 ("cxl: Calculate and store PCI link latency for the downstream ports")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# pci/pci.c
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261009045452.1107921-3-den@valinux.co.jp
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 22 ++++++++--------------
 drivers/pci/pci.c      | 23 ++++++++++++++++++-----
 include/linux/pci.h    |  2 +-
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 1f470ab0df3b7..bb6ad0753a421 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -660,8 +660,8 @@ long cxl_pci_get_latency(struct pci_dev *pdev)
 {
 	long bw;
 
-	bw = pcie_link_speed_mbps(pdev);
-	if (bw < 0)
+	bw = pcie_link_bandwidth_mbps(pdev);
+	if (bw <= 0)
 		return 0;
 	bw /= BITS_PER_BYTE;
 
@@ -756,18 +756,12 @@ EXPORT_SYMBOL_NS_GPL(cxl_pci_setup_regs, "CXL");
 
 int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c)
 {
-	int speed, bw;
-	u16 lnksta;
-	u32 width;
-
-	speed = pcie_link_speed_mbps(pdev);
-	if (speed < 0)
-		return speed;
-	speed /= BITS_PER_BYTE;
-
-	pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
-	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
-	bw = speed * width;
+	int bw;
+
+	bw = pcie_link_bandwidth_mbps(pdev);
+	if (bw < 0)
+		return bw;
+	bw /= BITS_PER_BYTE;
 
 	for (int i = 0; i < ACCESS_COORDINATE_MAX; i++) {
 		c[i].read_bandwidth = bw;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d79d2ee4ac69b..38c7cb8221223 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6000,18 +6000,31 @@ static enum pci_bus_speed to_pcie_link_speed(u16 lnksta)
 	return pcie_link_speed[FIELD_GET(PCI_EXP_LNKSTA_CLS, lnksta)];
 }
 
-int pcie_link_speed_mbps(struct pci_dev *pdev)
+/**
+ * pcie_link_bandwidth_mbps - get the current bandwidth of a single PCIe link
+ * @pdev: PCI device to query
+ *
+ * The bandwidth includes all negotiated lanes and does not account for
+ * encoding overhead. A negotiated width of zero gives zero bandwidth.
+ *
+ * Return: Bandwidth in Mb/s, or a negative errno on failure.
+ */
+int pcie_link_bandwidth_mbps(struct pci_dev *pdev)
 {
 	u16 lnksta;
-	int err;
+	int speed, err;
 
 	err = pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
 	if (err)
-		return err;
+		return pcibios_err_to_errno(err);
+
+	speed = pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
+	if (speed < 0)
+		return speed;
 
-	return pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
+	return speed * FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
 }
-EXPORT_SYMBOL(pcie_link_speed_mbps);
+EXPORT_SYMBOL(pcie_link_bandwidth_mbps);
 
 /**
  * pcie_bandwidth_available - determine minimum link settings of a PCIe
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5ffcf5ce8c966..272378dd8973b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1478,7 +1478,7 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
 u32 pcie_bandwidth_available(struct pci_dev *dev, struct pci_dev **limiting_dev,
 			     enum pci_bus_speed *speed,
 			     enum pcie_link_width *width);
-int pcie_link_speed_mbps(struct pci_dev *pdev);
+int pcie_link_bandwidth_mbps(struct pci_dev *pdev);
 void pcie_print_link_status(struct pci_dev *dev);
 int pcie_reset_flr(struct pci_dev *dev, bool probe);
 int pcie_flr(struct pci_dev *dev);
-- 
2.53.0



