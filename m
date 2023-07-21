Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA47F1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E79C433CD;
	Fri, 21 Jul 2023 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955758;
	bh=2FrzODuS0GWBD5UrcsQlh8CCM5roADhzsrVxOFDR5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSQkIsCc31YQWADsiEJ3TrIpVm0+HkTsbPYQRKT97jLnEN+k0buJVujL7QslkGgsY
	 59ae075fw1XWxzeHRLHMDhuqPuH9nsoLEIGOnBA/Urp3lM3CQFOZnth9XGDslNibb7
	 XZcqiCpynu8Pc47PLuOkpxEpYyWWrG5BRJlgg7hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 007/292] net: lan743x: select FIXED_PHY
Date: Fri, 21 Jul 2023 18:01:56 +0200
Message-ID: <20230721160529.128757662@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

commit 73c4d1b307aeb713e80ab03f90c7df9d417dc0f0 upstream.

The blamed commit introduces usage of fixed_phy_register() but
not a corresponding dependency on FIXED_PHY.

This can result in a build failure.

 s390-linux-ld: drivers/net/ethernet/microchip/lan743x_main.o: in function `lan743x_phy_open':
 drivers/net/ethernet/microchip/lan743x_main.c:1514: undefined reference to `fixed_phy_register'

Fixes: 624864fbff92 ("net: lan743x: add fixed phy support for LAN7431 device")
Cc: stable@vger.kernel.org
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/netdev/725bf1c5-b252-7d19-7582-a6809716c7d6@infradead.org/
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -46,7 +46,7 @@ config LAN743X
 	tristate "LAN743x support"
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
-	select PHYLIB
+	select FIXED_PHY
 	select CRC16
 	select CRC32
 	help


