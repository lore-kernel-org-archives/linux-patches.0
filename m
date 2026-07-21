Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEB537B02A;
	Tue, 21 Jul 2026 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669359; cv=none; b=LlHHCc69lUuxICiH4m9HCzoDcrbFtDEMvxalFqYpLj9Ef78bxaP0R5v/iKvRaEAqjZCdv1Vt2qEj5IkimsYZUvz8iT/tmfelWNmMsmJ4TFF2LWbuKKba4WjSqenZ3Hcl5YjM+EOBIpTbmKrbzGS/OdOzfkgf9Ld6wzuFQ6ffyZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669359; c=relaxed/simple;
	bh=FuuSGuoicDhfZwy4M2hyL1Hwx2TcCJ2IeCh1blWcw+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTVo8K4G9xCviiCuJ9riCXI86bbR94pvFZwZKCO4wGE092ftSudUSYKL7QwwzwP8T2p5m66vt/MSRk/nEV7tgrWZYU5FysR//L3r3sCqz5sm11Q+/3PFqDmrXGzWEoM/ZKDRQCw9AyUaaVWh4J5m+thRs5EbWHnJ4exLszALSqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nYl53NM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nYl53NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0DA1F000E9;
	Tue, 21 Jul 2026 21:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669356;
	bh=6wgpN/vmpRDLuzuyM1MKzBYVBOZygdmur+htwi+QYb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nYl53NMJV+33vFSIWDu4LVR9tXac+PTqvrBOspCSFn6qPVbzjm283J3jFt3q9P2R
	 o7AWq3n0sfMVbHyxDbgdo1BsjKyMfe4JacCkR7ZLvYHEVudaJexIri2SE55sIzUPW5
	 hh5XHgBLny9gwgV2Lhoouvzb3bYbLMWVsgBH9AHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0525/1067] PCI: rcar-host: Remove unused LIST_HEAD(res)
Date: Tue, 21 Jul 2026 17:18:46 +0200
Message-ID: <20260721152436.353385591@linuxfoundation.org>
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
index ebfb56702c1aa4..2a2f1ce1e85b9b 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -359,7 +359,6 @@ static void rcar_pcie_hw_enable(struct rcar_pcie_host *host)
 	struct rcar_pcie *pcie = &host->pcie;
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(host);
 	struct resource_entry *win;
-	LIST_HEAD(res);
 	int i = 0;
 
 	/* Try setting 5 GT/s link speed */
-- 
2.53.0



