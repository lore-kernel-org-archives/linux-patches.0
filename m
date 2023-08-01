Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314341F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45E1C433C9;
	Tue,  1 Aug 2023 09:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881771;
	bh=3JWXxAibJDxCkJu3mzdiwzqp6n094e8wPBSTXZrhSY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/3BPK08E+Fl6sMCrO8+/tWrjcOGFlcbfOBhUzMqgN3UrV6/D/gDbIvn4uUzstE1V
	 rLAOH2UVfzco/dqS7LCXYT/Gyz2qTG/yWD4X5bkiqlVIzMYtxx/zOYcwqRKfkh6MRs
	 OOUpegIGD/cGC+pw28chW46gKeul16ELwCH8pttk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/155] PCI: rockchip: Remove writes to unused registers
Date: Tue,  1 Aug 2023 11:18:48 +0200
Message-ID: <20230801091910.774878991@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rick Wertenbroek <rick.wertenbroek@gmail.com>

[ Upstream commit 92a9c57c325dd51682d428ba960d961fec3c8a08 ]

Remove write accesses to registers that are marked "unused" (and
therefore read-only) in the technical reference manual (TRM)
(see RK3399 TRM 17.6.8.1)

Link: https://lore.kernel.org/r/20230418074700.1083505-2-rick.wertenbroek@gmail.com
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Stable-dep-of: dc73ed0f1b8b ("PCI: rockchip: Fix window mapping and address translation for endpoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 827d91e73efab..9e17f3dba743a 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -61,10 +61,6 @@ static void rockchip_pcie_clear_ep_ob_atu(struct rockchip_pcie *rockchip,
 			    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(region));
 	rockchip_pcie_write(rockchip, 0,
 			    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(region));
-	rockchip_pcie_write(rockchip, 0,
-			    ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR0(region));
-	rockchip_pcie_write(rockchip, 0,
-			    ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR1(region));
 }
 
 static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
@@ -114,12 +110,6 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
 		     PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
 		addr1 = upper_32_bits(cpu_addr);
 	}
-
-	/* CPU bus address region */
-	rockchip_pcie_write(rockchip, addr0,
-			    ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR0(r));
-	rockchip_pcie_write(rockchip, addr1,
-			    ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR1(r));
 }
 
 static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn, u8 vfn,
-- 
2.39.2



