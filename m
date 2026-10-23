Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774559;
	b=FM3mVPEkj4CjBiEnB+fnyXKmotxo8QRDDoHUMtxN5exiDS/U1MP5XE1nV6JNNrbdr2ls
	 yyLfm5FMu6i9v2tvoG3D5pNGxc5o3s2xgqq+1mbjmVCc9llspHP2DVB3UmwaS7wiUrqwc
	 nEEGKzf34LTul4sZNFVHFs+kDNggHiAq8f6thnuGP7qbU0JLx+EpjabEiWVU20ueoSw0I
	 eVKm1WauvHzFvgrDceioosD20V3FjCZGkMWP7YyM2Wlwq9AaQ2xxAS1H4N3FfmQelkqFT
	 f59Wb6TUg8uYo7toQkQmMkOg/ZAn8FDOHhMLN5BZBiYkPoeLMK7y2FhsZIaeKjZ+pOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CyiFPWTSnv8B1Dnd7ZLevbQ2RhVM/BVNZ7jLsGgutiI=;
	b=TKpfyn9rVCx2HZtXQakVFuAq9hVmilzEGWMMvoCQap9f5madOnsm7QT8nbLC2b8AKFmf
	 AHsaXGLRgge6oDik5xlcsVUSOJWvFYbYMmuzb/61HQyWwylTY38KQIyrAfNzrFGvrlrwR
	 Sqavhv7aesnbRa4B/08BBfykDAkw1IJv1SXYP1wrC/zycGQrjz7JKE1FFL4j3x7KDV4iy
	 M88gysVKhMrKdulwK6uU0dXyivY8Bsso2f000d2PQ/RoUTkfuFIMV8VetUhTQFLRxYvts
	 dhsxRbdQ47i43Kh3/BVS7yYFYTx+LpwD36K6U0X3P82oH8prTjcsCoxQQXNfKqYJf3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxNcwBYL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBAA606A31A;
	Fri, 23 Oct 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxNcwBYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329781F01825;
	Fri, 23 Oct 2026 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774558;
	bh=CyiFPWTSnv8B1Dnd7ZLevbQ2RhVM/BVNZ7jLsGgutiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxNcwBYL+aFotl64uFZB8kEszPuoyuHHNQwqcJaUaqPtpKO1vv82EN9ZGKI/9Lff+
	 0bQ6mook9QuhPfRpevGO4HRRQvgHGP3Sdh6K5PU8CfX0nqUfAS0tmY4SFkMOppg3Sf
	 G9YDCh0HBvF/wzCIlW2tIWJNjqY0Q76zjQZX/eko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 080/242] net: ethoc: move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:42 +0200
Message-ID: <20261023163715.670218659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit c9f8ce62a5faa73515ff5457716bd7306d20fd93 ]

ethoc_probe() calls ethoc_mdio_probe(), which connects the PHY,
before netdev->netdev_ops is assigned. phy_attach_direct() ->
phy_link_topo_add_phy() reads dev->netdev_ops through
netdev_need_ops_lock() since the commit in question, so probing crashes
with a NULL pointer dereference when CONFIG_NET_SHAPER is enabled.

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261008022656.3592191-8-mmyangfl@gmail.com
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ethoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 0c418557264c2..e5b7df43e8f61 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1211,6 +1211,8 @@ static int ethoc_probe(struct platform_device *pdev)
 		goto free3;
 	}
 
+	netdev->netdev_ops = &ethoc_netdev_ops;
+
 	ret = ethoc_mdio_probe(netdev);
 	if (ret) {
 		dev_err(&netdev->dev, "failed to probe MDIO bus\n");
@@ -1218,7 +1220,6 @@ static int ethoc_probe(struct platform_device *pdev)
 	}
 
 	/* setup the net_device structure */
-	netdev->netdev_ops = &ethoc_netdev_ops;
 	netdev->watchdog_timeo = ETHOC_TIMEOUT;
 	netdev->features |= 0;
 	netdev->ethtool_ops = &ethoc_ethtool_ops;
-- 
2.53.0



