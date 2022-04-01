Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCE1EBF
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 05:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=H4buxTxBIyUS7hoGNmZIWOzhJtPDIgdLe1OuTp8wG2Y=; b=0+jlHY20CkURuPUvhW9Q+4C2x4
	L90dQ9K2nxZFsRUEZ2kmUJuQ8mvUG+fkZhemoLr3VwaHVE/8wK8ljOZH9C3R2jzz7kmlL2//3MvTF
	teWZs6cvxpkONgY8pl95Vg6BDuxlU0Kas6vSgWedwAutQz+qVB8DpS2C8DfP9MlHtTC26IfzFVn0g
	Cfc3jAoK21nvPmwASigSwgHR2kyYilzaTqrmKl8NdZJdwvs7IqyTdqH1/KVhNCLzfF4TeeGs4AVLP
	t0wy3zn9c4rQVrETG69l9QA5V5ltDCdV2vpsdVrVNDjtef/F8n/lDGhqO2yuMEVHfQgS6BDwxMxh0
	IwBjcL5w==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1naA3Z-004a8w-6t; Fri, 01 Apr 2022 05:42:45 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net: micrel: fix KS8851_MLL Kconfig
Date: Thu, 31 Mar 2022 22:42:44 -0700
Message-Id: <20220401054244.18131-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KS8851_MLL selects MICREL_PHY, which depends on PTP_1588_CLOCK_OPTIONAL,
so make KS8851_MLL also depend on PTP_1588_CLOCK_OPTIONAL since
'select' does not follow any dependency chains.

Fixes kconfig warning and build errors:

WARNING: unmet direct dependencies detected for MICREL_PHY
  Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
  Selected by [y]:
  - KS8851_MLL [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICREL [=y] && HAS_IOMEM [=y]

ld: drivers/net/phy/micrel.o: in function `lan8814_ts_info':
micrel.c:(.text+0xb35): undefined reference to `ptp_clock_index'
ld: drivers/net/phy/micrel.o: in function `lan8814_probe':
micrel.c:(.text+0x2586): undefined reference to `ptp_clock_register'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/micrel/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2022-0331-2037.orig/drivers/net/ethernet/micrel/Kconfig
+++ mmotm-2022-0331-2037/drivers/net/ethernet/micrel/Kconfig
@@ -39,6 +39,7 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	select CRC32
 	select EEPROM_93CX6
