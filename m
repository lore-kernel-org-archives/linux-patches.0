Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CA91C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AACFC433EF;
	Wed, 28 Dec 2022 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244216;
	bh=9dUPKqRteL/BxhH6fqdLsfEkUfjD2qB6Fxf+dVoy+g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOO1LVt/3OiJwZRMtid6wIGzPGIV1Qkzc7B/gWormXE6ld6WFVA7UpQfr3wZ663Ky
	 rSZo/RhNtaVJ07Uetkcl2Mkhb6MHYeZklzZPPkMr2DZ1ozBLUn1mzh/sC6JOVv0HY1
	 G2T8xrH82545xpvtw35baJYGjn2Fm7qsQns3TYqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <frank.li@nxp.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0630/1146] PCI: endpoint: pci-epf-vntb: Fix call pci_epc_mem_free_addr() in error path
Date: Wed, 28 Dec 2022 15:36:09 +0100
Message-Id: <20221228144347.279980833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <frank.li@nxp.com>

[ Upstream commit 0c031262d2ddfb938f9668d620d7ed674771646c ]

Replace pci_epc_mem_free_addr() with pci_epf_free_space() in the
error handle path to match pci_epf_alloc_space().

Link: https://lore.kernel.org/r/20221102141014.1025893-4-Frank.Li@nxp.com
Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Frank Li <frank.li@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 0ea85e1d292e..fba0179939b8 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -557,7 +557,7 @@ static int epf_ntb_db_bar_init(struct epf_ntb *ntb)
 	return ret;
 
 err_alloc_peer_mem:
-	pci_epc_mem_free_addr(ntb->epf->epc, epf_bar->phys_addr, mw_addr, epf_bar->size);
+	pci_epf_free_space(ntb->epf, mw_addr, barno, 0);
 	return -1;
 }
 
-- 
2.35.1



