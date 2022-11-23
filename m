Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030FD1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E84C433D7;
	Wed, 23 Nov 2022 09:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195939;
	bh=XN61+9YlMRuvd58nAtfL8AAaJ9d+xr7vdWCDGQYUSB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRkUVcK8QOZnvy5wMyhLVPAmdO07bb8RgmKgS5kUZ0UapoL6owfj5nDh71i6oYcPe
	 S2OZ8C7Zhtp68tMrkvh6xz4t62Rum4GXb0MdnDscDLzssfughDVetwainM0RSUqEcf
	 EafWx6gvZ3PP66Rtjdk9QsQvZP/CLK2SLetdkF2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaco Coetzee <jaco.coetzee@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/181] nfp: change eeprom length to max length enumerators
Date: Wed, 23 Nov 2022 09:50:38 +0100
Message-Id: <20221123084605.602821250@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index 62546d197bfd..865865adfefc 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1264,15 +1264,15 @@ nfp_port_get_module_info(struct net_device *netdev,
 
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



