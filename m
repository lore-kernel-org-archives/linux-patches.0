Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D00366
	for <patches@lists.linux.dev>; Wed, 30 Mar 2022 01:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6HO2dPm8/i9IO45pfY78cuDTC3sIxZcmrZ4/o0PUVaY=; b=FPuaF7Z5EIyZBYdSrgcftx5bNb
	aX1ZGGtLMqZbbfj6qXPDZg28vYVZucl8RBYUajF3skUK7mw0jmlf3AFFxcp080GRSBfNMJbc9PPbs
	L/h3HCya6na+KeCo+EpRe/yEK+BB8Yt3+gJer2ijyV9GrPIX6S2HRikyHSazw191IYjEm0fwuhvkv
	DKAhfjAKdsbbdlBNsjVSTcGi1Hn+MKRVYeEyNJD0VmWnmsWRMauI8aY6K1KUwFv6u4ez0qoy/pYHn
	N9zZIZ9Hs7etcQwRt63pj+Uo9EKb/mNcuYIYKtmCrrYZQyGKtO9igFs3Qf815nCDzBoXmkGTSZ7MR
	HCl3PWJA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nZN0c-00Du9E-DF; Wed, 30 Mar 2022 01:20:26 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	UNGLinuxDriver@microchip.com,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net: sparx5: uses, depends on BRIDGE or !BRIDGE
Date: Tue, 29 Mar 2022 18:20:25 -0700
Message-Id: <20220330012025.29560-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix build errors when BRIDGE=m and SPARX5_SWITCH=y:

riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L305':
sparx5_switchdev.c:(.text+0xdb0): undefined reference to `br_vlan_enabled'
riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L283':
sparx5_switchdev.c:(.text+0xee0): undefined reference to `br_vlan_enabled'

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20220329.orig/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ linux-next-20220329/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -5,6 +5,7 @@ config SPARX5_SWITCH
 	depends on OF
 	depends on ARCH_SPARX5 || COMPILE_TEST
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on BRIDGE || BRIDGE=n
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER
