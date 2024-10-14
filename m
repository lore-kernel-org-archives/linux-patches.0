Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2081ABEB5;
	Mon, 14 Oct 2024 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917398; cv=none; b=NxeEhaa7HF/9ji9RyCmoE9ShIqNzfGfeM40LrXzh77plreyjwDrCZUlRfRoOFklSzMfWxmX2sy5MJXlb2HGlqxXJyziRpwlNx2hjl5POi0CDwPgM/o2vUq/9aB4eUvYJnJVZqfw5B8K4Bm2Ywh1nwbUYuUtgRB65QTZCtxoFnIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917398; c=relaxed/simple;
	bh=wQQdMbAmuxERXbBuecFaL1sYIpvputYgsdMM+ZUJmkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RadHqRcfcAYLzWUjSuDlVA2PC2lPGSoRsOQuDp1H9sXfdT24DFYbnGTpow4cXzfktmYiMirbPf5Ocn2CxkGXwik5gC0+cAAy3en3bnWF/bU4Xcj363z/P7jp/CRdlayCX6Ozcm5SLaYlcmy9IwdnA6Wf5vyEhqzv66S6h9T6nlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAfMFD5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAfMFD5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C76C4CEC3;
	Mon, 14 Oct 2024 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917397;
	bh=wQQdMbAmuxERXbBuecFaL1sYIpvputYgsdMM+ZUJmkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAfMFD5mDGkdzPxNGdujUX6CBisCXoH/8ZzHYx4kEG5CUBagXcKVryCggG9dLp5zr
	 w98pAJ6h8mws2t7tQxMOTqQGB6IFALwf7uLVM1DJQU5EyLTVmR392GMdYE1+PyoTxf
	 Jnq2uwcGQJAdhx6LE1jyeNSpEu4z+7ZVXVm6kn8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feiyang Chen <chenfeiyang@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Serge Semin <fancer.lancer@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Yanteng Si <siyanteng@loongson.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/798] net: stmmac: dwmac-loongson: Init ref and PTP clocks rate
Date: Mon, 14 Oct 2024 16:09:22 +0200
Message-ID: <20241014141218.278042732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yanteng Si <siyanteng@loongson.cn>

[ Upstream commit c70f3163681381c15686bdd2fe56bf4af9b8aaaa ]

Reference and PTP clocks rate of the Loongson GMAC devices is 125MHz.
(So is in the GNET devices which support is about to be added.) Set
the respective plat_stmmacenet_data field up in accordance with that
so to have the coalesce command and timestamping work correctly.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
Signed-off-by: Yinggang Gu <guyinggang@loongson.cn>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index e129ee1020f0a..472ea1bb454cc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -35,6 +35,9 @@ static int loongson_default_data(struct plat_stmmacenet_data *plat)
 	/* Disable RX queues routing by default */
 	plat->rx_queues_cfg[0].pkt_route = 0x0;
 
+	plat->clk_ref_rate = 125000000;
+	plat->clk_ptp_rate = 125000000;
+
 	/* Default to phy auto-detection */
 	plat->phy_addr = -1;
 
-- 
2.43.0



