Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027526;
	b=Ynvr1paHCfNRGmcA6wxqzAIWNFF/Rig6Drtrg7qAsXhex2sRqq5CVPEqgjQU9QRc4foM
	 RgFsyRWwva3gci7L8pHk9hEweXN96gnCA+yJvR6SI6THeT5kpnh3kZ/6lOeTqsxKJQalw
	 1zQ2GBWr8l4eZB6pU3MBnZcX7ZA9BhZ17c7jiR4/qw10YAaPGGn+Rd2u1oAwXVMJlYr7c
	 7Lu7oPu5q5AH7wfQ5uSgYtGcIeOoQ6rG5jWItlGtGz2CUf2F6xCAx0NiHau4o7aPzUY0L
	 cgNvAhntamiF5RpcR+9CrzNZg+0vZDVHP0rC4MQvq5XJ4b4NHn9QKdE08I+sEpk8WbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pqXS/x0TqeO0C4Wp5PGZ/nuDcP5KJ6vBB/BSnfSUCww=;
	b=FvUdcztTU4bBkmv+Fo0X5wn2ydr03FeKIItMuES8BFp5vyermUBSh94tdjQzuU/S0t1U
	 xcdwSCGTHwXgIJEey2jUFQlxZwLQwNfgI+K2DTJMfCCGve/OIYQYXX2jQ5s46z9bAld9A
	 c7qzi2kF9hlWK9Yj19dLMPoDUylVZuaMUS2HsQb12ntVRM+3k9fww55oJhgKnJT1ITtLG
	 JIoUVSAh06pJiDQPBs81ed/iteiCWKfm1Y6iJ6d93V7Z8NqLYhI55UeXVKMfthaWo/t30
	 PaeSCS7Ple3EImg5AvygMqT+B+Nu9CfK/ClW97dgK5TSsAdYl3BcfYifqM3LsomBwCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLOIc64K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F7560A260A;
	Wed, 18 Nov 2026 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLOIc64K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAF51F000CF;
	Wed, 18 Nov 2026 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027526;
	bh=pqXS/x0TqeO0C4Wp5PGZ/nuDcP5KJ6vBB/BSnfSUCww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLOIc64K14lDYGO1oGGx6eR19r/Xo/PZEY/+HkEf0kZdSVxmwb1dnBN0J66SPeH3A
	 Ar21LYM2EbpQUcjf+I9gzFv2keMQA964Wz8bFIrn5aJFQX2B5zQcKXTNZn+WPm2ZqE
	 GXKKrb5/RDj9hc3lFGhwP6WiLQwn67nSHcvt3/g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1819/2151] net: bcmasp: fix OF node reference leak for phy_dn
Date: Wed, 18 Nov 2026 15:59:14 +0100
Message-ID: <20261118150228.068362549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit a31623d91c6e48b08c74dc95567aeb62f1f35938 ]

In bcmasp_interface_create(), intf->phy_dn is obtained via
of_parse_phandle() or assigned ndev_dn. of_parse_phandle() returns a
node reference with its refcount incremented, but of_node_put() was
never called on intf->phy_dn in bcmasp_interface_destroy() or the
error unwind path in bcmasp_interface_create().

Acquire a reference on ndev_dn for the fixed-link case as well so that
intf->phy_dn consistently holds a reference, and release it with
of_node_put() on teardown and error.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-5-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index c2828d1d8c612..dfc6ce4dcec9c 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1261,7 +1261,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 				 ndev_dn->name);
 			goto err_free_netdev;
 		}
-		intf->phy_dn = ndev_dn;
+		intf->phy_dn = of_node_get(ndev_dn);
 	}
 
 	/* Map resource */
@@ -1302,6 +1302,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 err_deregister_fixed_link:
 	if (of_phy_is_fixed_link(ndev_dn))
 		of_phy_deregister_fixed_link(ndev_dn);
+	of_node_put(intf->phy_dn);
 err_free_netdev:
 	free_netdev(ndev);
 err:
@@ -1314,6 +1315,7 @@ void bcmasp_interface_destroy(struct bcmasp_intf *intf)
 		unregister_netdev(intf->ndev);
 	if (of_phy_is_fixed_link(intf->ndev_dn))
 		of_phy_deregister_fixed_link(intf->ndev_dn);
+	of_node_put(intf->phy_dn);
 	free_netdev(intf->ndev);
 }
 
-- 
2.53.0



