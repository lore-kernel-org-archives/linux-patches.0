Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE71386C39;
	Tue, 21 Jul 2026 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662590; cv=none; b=KVIeu4i9us6m5Dc0Pk6bpKNfYoc71gkBYTBbE4iaoP76Ls1U/1FqbWtsdHlB4D75USTSGe4WkM23/ZW2+mJ75YJPN92JADYOAuPmvAshqabbfybA5goUMFsmZJaqGPmhQ1gA8+FzWtPeGXsb2EMww1+2wMGwfTJNfpcDEMnx4Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662590; c=relaxed/simple;
	bh=b4AY4vohA+e+kaHHg7LO92PqpsFHxOdxjiiMzqmIbYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7WUWAUDX1i49JZSX+5O5ABeFDF/l8opBEMyecr1RUdKfboZWzsmofnrnYNvR3wr1wJtzsj1ypD7lYP3oojvLTEOnqfa7Bt/VF8X91m5zODLOzISkg8rG7+jiLOhF73KBUDsGd+2PRAdiD/N/Hv1wBKFA/Yvo0CO1T5EUYpakLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e92W5RJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e92W5RJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC96E1F000E9;
	Tue, 21 Jul 2026 19:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662589;
	bh=R9M7hE2B9hMGydlANnW9MIHjZcPW6077To1Sd+Ivp0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e92W5RJwk/7/HFHGAffTplctlOZG7luUSAy3hbkY00Z3IM29Rlv1DfO9FSnWrtb/2
	 nWW6T3A58LcOGZAUJp2Ag+WGyzRCZOJBTpXE2c1mEJgLCmhjYQemAaMh5GRwsrRM+6
	 HDIRTLPPOyaXNLd9RIOmfqYak1qh8UptHiZ2lG6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0500/1276] PCI: rcar-host: Remove unused LIST_HEAD(res)
Date: Tue, 21 Jul 2026 17:15:43 +0200
Message-ID: <20260721152457.293636984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a90beedd8e24ee..4ecb41a0e3b389 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -345,7 +345,6 @@ static void rcar_pcie_hw_enable(struct rcar_pcie_host *host)
 	struct rcar_pcie *pcie = &host->pcie;
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(host);
 	struct resource_entry *win;
-	LIST_HEAD(res);
 	int i = 0;
 
 	/* Try setting 5 GT/s link speed */
-- 
2.53.0



