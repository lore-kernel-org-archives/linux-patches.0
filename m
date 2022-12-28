Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F931C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD42DC433D2;
	Wed, 28 Dec 2022 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244091;
	bh=9dUPKqRteL/BxhH6fqdLsfEkUfjD2qB6Fxf+dVoy+g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seJKEI/mNVh07c4NdG74XBHG1bgZM2jpQM6UJwrPEgEJuD6mIR+dnlR1OIhdz5QMT
	 y20mFjJW4ocsH0zC+RPdtDHvdpKkzVwpxhmvNTOxDiOoc2ib7U097SyTVIHhhAsnqT
	 i8qDeQST3RHX2KUe5UbW1zQULwia1UUFsEDmxXjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <frank.li@nxp.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0613/1073] PCI: endpoint: pci-epf-vntb: Fix call pci_epc_mem_free_addr() in error path
Date: Wed, 28 Dec 2022 15:36:41 +0100
Message-Id: <20221228144344.694570295@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



