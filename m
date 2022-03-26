Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051417E
	for <patches@lists.linux.dev>; Sat, 26 Mar 2022 18:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NouxmkbXyieO1Hux/ld3G695f3UzkTVKQUYwNvnmwE8=; b=TAAZxnsjAOaA0cRvvgeIIlUiQ4
	ml0HEWH+UD7R6dKWsfLumGb20l/fLtlpDcauTSzZomPYi7Rd6NXMBHDGtzAsm4umqH49+fJwwiAPR
	JLpxTdU13YncFq6aWkdZocjTZFhwMnk/PGHN8xTzVDYJJAR8LIHCe7xNI3OhtP3I3qeanC7ldQk8R
	KM8HjMbotEuB3UZUVDHqs7EQ00RLmFuPEhAw6uPWLAy+chjaRLQs4Z9NAmE1qK8pG9YWOzjp0VWCf
	lw7eAglsOQApw6gKBgZCL31R/E35ljUuqZnHdtlUQlEjwOTgXy22/C177oSnfyhtH72C2oocdwEFB
	Ah3EN+gA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nYAkF-004f0I-Dp; Sat, 26 Mar 2022 18:02:36 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	UNGLinuxDriver@microchip.com,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Bjarni Jonasson <bjarni.jonasson@microchip.com>,
	Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH] net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL
Date: Sat, 26 Mar 2022 11:02:34 -0700
Message-Id: <20220326180234.20814-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix build errors when PTP_1588_CLOCK=m and SPARX5_SWTICH=y.

arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.o: in function `sparx5_get_ts_info':
sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
arc-linux-ld: sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_init':
sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
arc-linux-ld: sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_deinit':
sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf38): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf46): undefined reference to `ptp_clock_unregister'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o:sparx5_ptp.c:(.text+0xf46): more undefined references to `ptp_clock_unregister' follow

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Steen Hegelund <steen.hegelund@microchip.com>
Cc: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20220325.orig/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ linux-next-20220325/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -4,6 +4,7 @@ config SPARX5_SWITCH
 	depends on HAS_IOMEM
 	depends on OF
 	depends on ARCH_SPARX5 || COMPILE_TEST
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER
