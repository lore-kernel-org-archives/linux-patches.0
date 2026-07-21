Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6068735C6AC;
	Tue, 21 Jul 2026 22:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673828; cv=none; b=IcLHOXaNKMIxi7djQj/HUAp/vRuryxJ1+up68QeK/DGMPntgf/zccB3SsOOR/WPeaL+piHo4oUPl8jepwyYVzSLoyoImWOrYNYv7UGBwNTLzsYtnpg9dOaS5DRj0NQdjxMRz23mGxNLkdHDD23o0hAOSInuDZx/85ugA0laE698=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673828; c=relaxed/simple;
	bh=ppbKN1/J0sSZgCTEkKoMliRCGzoUO9qwWNghWCLinBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3EZ2D/yNtV2IpEdSvRQEOQgLmo45U2BqBnoiOfDxq0h6si4/NOoTkh9YomRrMjfJM6czjNalCYvmrlBO2RQtJZ9SXNuwd/XYrmRdzsIBSUpHueWaPpbClgXEdBKSe8b+gP+lMC6903hLpqnIRncoEu5yNfMTNtnPQrlq7MPliA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0u0SXF3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0u0SXF3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CF21F000E9;
	Tue, 21 Jul 2026 22:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673827;
	bh=V2x4V/Xo4VvlXX1BOOEUQwfnKmiBXaS8XYGVAgKcPyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0u0SXF3PfJkNP8YvAqf8i/sWFSVHIEiT6YhuY31Q48pFPMNXDFM2rDLM/dhqnvyxN
	 IuPizbq30OverpZ1JegYSFXn/3Edn/zE3zXBKB86oqkjFdxs+SrQY0Yn4dW50lOFND
	 oxripFxZ9UYfRZT9qv7AzCyb+ArTx0bm6aY/NvpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/699] PCI: rcar-host: Remove unused LIST_HEAD(res)
Date: Tue, 21 Jul 2026 17:21:07 +0200
Message-ID: <20260721152402.643031380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 6ba90ce2069ae923b0ec787aebdf2d786e5d2a58 ]

Remove the unused LIST_HEAD(res) declaration from rcar_pcie_hw_enable().

The macro instantiation defines an unused 'struct list_head res' variable,
which conflicts with a valid resource loop-local 'struct resource *res'
declaration further down in the function, triggering a compiler variable
shadowing warning:

 drivers/pci/controller/pcie-rcar-host.c:357:34: warning: declaration of 'res' shadows a previous local [-Wshadow]
 357 |                  struct resource *res = win->res;

Fixes: ce351636c67f75a9 ("PCI: rcar: Add suspend/resume")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://patch.msgid.link/20260521091256.15737-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index 2bee09b16255d0..62d261ee8ff774 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -261,7 +261,6 @@ static void rcar_pcie_hw_enable(struct rcar_pcie_host *host)
 	struct rcar_pcie *pcie = &host->pcie;
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(host);
 	struct resource_entry *win;
-	LIST_HEAD(res);
 	int i = 0;
 
 	/* Try setting 5 GT/s link speed */
-- 
2.53.0



