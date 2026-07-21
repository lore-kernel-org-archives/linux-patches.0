Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DE03B42EF;
	Tue, 21 Jul 2026 21:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670525; cv=none; b=mc4UIcRztMGMTDyCj2GQLhdjXykSimD/MVG+z5u8prECpmDexDiqqkXPz7oz63Pt4t3xVYRh9SADBEJ7T1sNVYWDY3UI6KONpqrNYzoySFLPRy5WQreiZySLpfkXyYJtyKcW1qgUjF2tTJGiJfsiCbaxlEMZ1FhJ/vdttwei5IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670525; c=relaxed/simple;
	bh=9zgxdeSt4SF6DOMEG/A4dGCVXc05sJCx0u+lRlzxGcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcp7Cd5Xd09bj9HFQ45n+CSe70WYxeh52/eSMGwpLwY+nm+68n+MT0mG0aVHVVqT/c/SIc8Bd4ggu5K3D2mMYL27JiUZxr5BDkZYKBkWVlwZnmoOTPK1r9Ygj/rgBtLFSHVVa8aSmP16XXJIAGOptoj1Q+BrxsP5XThHdm4+qgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfrTpGfu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfrTpGfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643D11F00A3A;
	Tue, 21 Jul 2026 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670523;
	bh=N7snau69xJfTic3xiuOwTlODJLcKby8ly+P+ztukbLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfrTpGfuXpN+JPZR/jLqWoB+vewk8BXWNjcWKMX9LijBtbdmQoECXc2HeOzyFBE+/
	 +AMvx00vPT6pS5WW5k41GLDhzc3Pu0ckKb3KaPK4PFM5wPdnfCyKRYy3mqZMf2EXVe
	 Ihh6TOaTjjjJUT5K2RkMzqwN8lmkoGeWL0CwDg/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0964/1067] PCI: mediatek: Use generic MACRO for TPVPERL delay
Date: Tue, 21 Jul 2026 17:26:05 +0200
Message-ID: <20260721152446.102901246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


