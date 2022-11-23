Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0A1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229DAC433D6;
	Wed, 23 Nov 2022 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197005;
	bh=sIAEPt/H/gTLrZ7FU7JS9WhysTyzp6yf8yks1QJRfgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsEF+O9CJqIPwIMQ5YSNZ7Jw4jkcAYruwqfbDwqGuBgQJh65g6ZAu3SpJ8HF77lr6
	 tes4TQVuS3hmY8Q8a0CaNmTkQhmijREBmK8fGXoZVaI7/SCCFFx3oPB7Ckts+UB/xF
	 NVBFssLmwyNBF3z5E3w2nnbMM+RMp8c42VosrWqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaco Coetzee <jaco.coetzee@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 141/314] nfp: change eeprom length to max length enumerators
Date: Wed, 23 Nov 2022 09:49:46 +0100
Message-Id: <20221123084631.936479132@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaco Coetzee <jaco.coetzee@corigine.com>

[ Upstream commit f3a72878a3de720661b7ed0d6b7f7c506ddb8a52 ]

Extend the size of QSFP EEPROM for types SSF8436 and SFF8636
from 256 to 640 bytes in order to expose all the EEPROM pages by
ethtool.

For SFF-8636 and SFF-8436 specifications, the driver exposes
256 bytes of EEPROM data for ethtool's get_module_eeprom()
callback, resulting in "netlink error: Invalid argument" when
an EEPROM read with an offset larger than 256 bytes is attempted.

Changing the length enumerators to the _MAX_LEN
variants exposes all 640 bytes of the EEPROM allowing upper
pages 1, 2 and 3 to be read.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Signed-off-by: Jaco Coetzee <jaco.coetzee@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index b1b1b648e40c..b19bff0db1fd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1440,15 +1440,15 @@ nfp_port_get_module_info(struct net_device *netdev,
 
 		if (data < 0x3) {
 			modinfo->type = ETH_MODULE_SFF_8436;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		} else {
 			modinfo->type = ETH_MODULE_SFF_8636;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		}
 		break;
 	case NFP_INTERFACE_QSFP28:
 		modinfo->type = ETH_MODULE_SFF_8636;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		break;
 	default:
 		netdev_err(netdev, "Unsupported module 0x%x detected\n",
-- 
2.35.1



