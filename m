Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265E619464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJzZUBM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1B9C433C8;
	Mon,  9 Oct 2023 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857216;
	bh=ToFLRMZx2W0fHLEA+whMPb3PlANBZoo7SeySjyY/J/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJzZUBM6lhI36GDMdHLiaCqBeTKLOP74YduLBY6Md1kUHuygSQfSW6CF6U4Ki7lth
	 PWiT5fmbAJOOypY5EtsalEJZWeGUZ43LV8h8cZtW875hfrS4HyrthJusTy/MjsnDTs
	 rdnZ3nUcXupqstzmmbXCf1PJWCAHi5JEOsBNVw3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Bryan Whitehead <bryan.whitehead@microchip.com>,
	UNGLinuxDriver@microchip.com,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 136/163] net: lan743x: also select PHYLIB
Date: Mon,  9 Oct 2023 15:01:40 +0200
Message-ID: <20231009130127.802185928@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 566aeed6871ac2189b5bfe03e1a5b3b7be5eca38 ]

Since FIXED_PHY depends on PHYLIB, PHYLIB needs to be set to avoid
a kconfig warning:

WARNING: unmet direct dependencies detected for FIXED_PHY
  Depends on [n]: NETDEVICES [=y] && PHYLIB [=n]
  Selected by [y]:
  - LAN743X [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICROCHIP [=y] && PCI [=y] && PTP_1588_CLOCK_OPTIONAL [=y]

Fixes: 73c4d1b307ae ("net: lan743x: select FIXED_PHY")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: lore.kernel.org/r/202309261802.JPbRHwti-lkp@intel.com
Cc: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Link: https://lore.kernel.org/r/20231002193544.14529-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 329e374b9539c..43ba71e82260c 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -46,6 +46,7 @@ config LAN743X
 	tristate "LAN743x support"
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
+	select PHYLIB
 	select FIXED_PHY
 	select CRC16
 	select CRC32
-- 
2.40.1



