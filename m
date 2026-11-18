Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021292;
	b=VQ2SNHSU14M+Bwl3CfuT7QfzB4ewmI/AEiqDkuH7NIzfYlGpWFwm5DRquGPybyiN847H
	 7IY5bK0geIdqFwC1QsiO4oR0XgQKVfeB5NmiTh6ahlfUqMUwUdKd22UoAU9odN0z/fBg6
	 9hl5DUe3NL4u4z11IVqizK2Acc9Z8va0wLw//6eoGO6QqLpufUIuXcoqleJUP0a84xbRe
	 kQrxmx5MgF84SQNnnI4A0zO/wjI4996Ww/uxmfzjbfayYPg/XiGRO2ui8OPswdUEicH4a
	 tlVtNcqUT5XK0chfNG0Z1yvQ3UJMRCU7Kgi6fNXtNLSMFARK2ouwZVYZMpYxI+5HeMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LNjqMnCDkgB1Dji6FXZ2Gpq3TjZmzI2hd+cf8vYlnJk=;
	b=LhUT6MLQQm6773dJOWOyFGPCI1n+LtihbSgeNgqPrluKES1UryB3+wiWwiiMiiPiLk5u
	 pvJtavacWoBwZyHVAq+0KKZGBrZWa8ihPmqVybRpmlVNypfYNAQSHiVe9WgWI3n1zGfXf
	 Fjbap1axZ55ooqI/yDIlFGwxXwRohIzM+gzK4bjqWQfB1u8z0cOICvPt1k5347cLS7izV
	 Lyl1/YOt30Yh0quv+GSg6SA+KTnohNZhu5I5AWBEQRk1iRfBnIhKbjif/1ZIbf3fIKETY
	 GkC71VF4g6Gfq0bmu3xjxOQJqKa6AbAkHiBDNXFJow/WUp+lwNtPui/HtWju6ficrXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXMnXa+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B47606A31C;
	Wed, 18 Nov 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXMnXa+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35671F000CB;
	Wed, 18 Nov 2026 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021292;
	bh=LNjqMnCDkgB1Dji6FXZ2Gpq3TjZmzI2hd+cf8vYlnJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXMnXa+D0g77gNAae3eCMHRQamjMHY4VXCr2yAd8vFn+hbWn8TAjpB6L47Sm15ARV
	 qNryKPFZEl41lOkU95/jFsoyy+DnzIrbZdwptmDNFjZ60vRlqabrBn8ewExU3wqHl3
	 X2Ga8uqbNA7IY/POIyRQgVhZvsnuQdakmfENl0As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2255/2651] net: bcmasp: fix OF node reference leak for phy_dn
Date: Wed, 18 Nov 2026 15:58:15 +0100
Message-ID: <20261118150406.610787967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d679c796c8c20..693e8cdfe9604 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1298,7 +1298,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 				 ndev_dn->name);
 			goto err_free_netdev;
 		}
-		intf->phy_dn = ndev_dn;
+		intf->phy_dn = of_node_get(ndev_dn);
 	}
 
 	/* Map resource */
@@ -1338,6 +1338,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 err_deregister_fixed_link:
 	if (of_phy_is_fixed_link(ndev_dn))
 		of_phy_deregister_fixed_link(ndev_dn);
+	of_node_put(intf->phy_dn);
 err_free_netdev:
 	free_netdev(ndev);
 err:
@@ -1350,6 +1351,7 @@ void bcmasp_interface_destroy(struct bcmasp_intf *intf)
 		unregister_netdev(intf->ndev);
 	if (of_phy_is_fixed_link(intf->ndev_dn))
 		of_phy_deregister_fixed_link(intf->ndev_dn);
+	of_node_put(intf->phy_dn);
 	free_netdev(intf->ndev);
 }
 
-- 
2.53.0



