Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774562;
	b=4w0xWfmjNYlTf2+1ESHMxsBY27SNznWjwNMzhhGQEWmjBAY0X5cZB8zUcZcSv4+36PyD
	 WF43nCuxntj+8plqXhgrDjD2NMrdoSfcelAaetyCiG69jdqCchL+d1wIPDkGMiRprRoHF
	 e7eCG3HlAC0pzf/6Qqfg5UdSmOll7wTiCmXlwGW3fUPHKe/06diIrciZuMfp/tePSq2tt
	 8lg4oYZKiksAOy6rSeaKqzE9UA77+9O9pApam59X0FSkSVTPwEDxnnE0+fEHD38SVI5ky
	 sA9AQYTBJ/0QMfdJJTD/YFJ186NuMB+IdKoOyu5YEsFYHgWvLBJFwtYWPvlbO2AC8GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rR+5/INJdDdKmKkXM8oPg+uCh5M9FxtAQ9GKZ1MbKhE=;
	b=FHuRppsQX4f33cetdQEcm6mRhwj9s3/JR8533VooCS36P9xAaVUs+R/PhhJ8TH7cD8pn
	 BAsOAc9uQrh/Nhmtg5PSiJ3CW552zcvcI9qDwLKPwj16czG2izs8PxBny/HG+MbT7mirh
	 lSH5sL38R9ocHuh/wCB/fcEZJMOY2+3YqeCTp5rGzZf+hCntthTUwJ2xmpGuSUHPrdXeu
	 4BHZ4/TXXjB588iUODgd4of7Vbtbw9lxXFZuZSOyU5uPcwQKKOH4M+eK9AKCaJZxyeCjo
	 hqYiGkQHorPBzL3bP+BgvrInsU6kN1qaQQIf2VKXP8jeNBjrsbyNhTmg87negFfhNRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClL6tCex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA05D606A31E;
	Fri, 23 Oct 2026 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClL6tCex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3A41F01825;
	Fri, 23 Oct 2026 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774561;
	bh=rR+5/INJdDdKmKkXM8oPg+uCh5M9FxtAQ9GKZ1MbKhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClL6tCexYRUe/N5YiJmWsgD131P1XStXaulduIHMSRXplaTocuSG+ICD1/l2kWBgw
	 sAaOMjLRfwDzPUK05yH0kN2AvTW1R5Wvuo327SmuMi9cmNofw5GjsKIT89zsStpaRh
	 rb92z4xpIQWFEs9XfGRiQk5U/Y3cshK0KYDwCbwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 081/242] net: ethernet: aeroflex: move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:43 +0200
Message-ID: <20261023163715.695355017@linuxfoundation.org>
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
Message-ID: <20261023163843._kj1dtQEr2S_cjhjivuSu-YgyRYCLQ_60hZOGTDog-0@z>

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit d71483f0716e7ae98578817bfdc8a5b822d250f8 ]

greth_of_probe() calls greth_mdio_init(), which connects the PHY,
before dev->netdev_ops is assigned. phy_attach_direct() ->
phy_link_topo_add_phy() reads dev->netdev_ops through
netdev_need_ops_lock() since the commit in question, so probing crashes
with a NULL pointer dereference when CONFIG_NET_SHAPER is enabled.

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Link: https://patch.msgid.link/20261008022656.3592191-9-mmyangfl@gmail.com
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aeroflex/greth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index a593adc16c78a..fccb67beebee1 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1421,6 +1421,8 @@ static int greth_of_probe(struct platform_device *ofdev)
 	/* Check if MAC can handle MDIO interrupts */
 	greth->mdio_int_en = (tmp >> 26) & 1;
 
+	dev->netdev_ops = &greth_netdev_ops;
+
 	err = greth_mdio_init(greth);
 	if (err) {
 		if (netif_msg_probe(greth))
@@ -1498,7 +1500,6 @@ static int greth_of_probe(struct platform_device *ofdev)
 		dev->flags &= ~IFF_MULTICAST;
 	}
 
-	dev->netdev_ops = &greth_netdev_ops;
 	dev->ethtool_ops = &greth_ethtool_ops;
 
 	err = register_netdev(dev);
-- 
2.53.0



