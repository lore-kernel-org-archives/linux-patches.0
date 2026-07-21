Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA1135C686;
	Tue, 21 Jul 2026 21:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667731; cv=none; b=Yb40yum77Whls77TszOq5XYWlgaPWmZb7hX+Ag4f9Kq+82wgMqZ1YtmEvx4NQEsvXrXEgIx/FvH8ni+5g9opyT6VM78tXVGtGxwaVGSGqXvVru54xfINzXqjfyjoyOPDj+tCfpKdyhnrRPKTSyAwjXGzg/xUEPwLD1ATOwzdejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667731; c=relaxed/simple;
	bh=nB9BGddsvl8BeSkUkgRASbaJQifhQxbU9FyDtxen+GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTSdiaBBr1r74jO3JbZziHKNl1FwP3yttc9VFerr0QO1p8LLg3DjGy4bfG7DLxrtLJ6F3KM5rxXp3KpOJ2NK2tMGd/D1WeuTj6h/oLxmvs012KLhmDTzjMWbxDNsrAMROIbadC8pOt1vTscLX4g8dzghgXLexoMPu39amusguaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QO79IvHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QO79IvHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080FB1F00A3A;
	Tue, 21 Jul 2026 21:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667726;
	bh=8C49WCZj39uYXmlY00Ise8LSfOjPQmBT2wxGYFSM9D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QO79IvHVS84y6aj0q1ln7qHt3sve3jH3XXx1S7hNOb6OM/BGEKOhkyKoIqqdLLIf9
	 DP6rS+lnMgbvNu2CiIn8qQUmArf6RMb60sSCGcsN67eR3dWM7mKSR2stYGpP6C/MIG
	 0zG8gO6iQTdfjQfN9NJcr34i69qbX+IslU1Y7//4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1170/1266] PCI: mediatek: Use generic MACRO for TPVPERL delay
Date: Tue, 21 Jul 2026 17:26:47 +0200
Message-ID: <20260721152507.965311323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 2d58bc777728bfc37aa35dce7b90e72296cceb9f ]

Use the generic PCI MACRO for TPVPERL delay to wait for clock and power
stabilization after PERST# Signal instead of the raw value of 100 ms.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20251020111121.31779-5-ansuelsmth@gmail.com
Stable-dep-of: f865a57896bd ("PCI: mediatek: Fix IRQ domain leak when port fails to enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-mediatek.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -714,12 +714,7 @@ static int mtk_pcie_startup_port_v2(stru
 	 */
 	writel(PCIE_LINKDOWN_RST_EN, port->base + PCIE_RST_CTRL);
 
-	/*
-	 * Described in PCIe CEM specification sections 2.2 (PERST# Signal) and
-	 * 2.2.1 (Initial Power-Up (G3 to S0)). The deassertion of PERST# should
-	 * be delayed 100ms (TPVPERL) for the power and clock to become stable.
-	 */
-	msleep(100);
+	msleep(PCIE_T_PVPERL_MS);
 
 	/* De-assert PHY, PE, PIPE, MAC and configuration reset	*/
 	val = readl(port->base + PCIE_RST_CTRL);


