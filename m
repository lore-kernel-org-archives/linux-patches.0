Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214287;
	b=HE4tpSuXTfwnMQG8AxZfoqhrze+pPdmMKB8WWeVM7nx53ZGfErOPtSC2rz5J//pfaPXT
	 fOae6GSYPsTIk43u42nBtBrBWlv9XsCL5QQqozoCjw94gjwu9dpo2IuIRIFaZwKgydiOZ
	 tAQOUzXGx9Qu+EXps1G+HMe+l3KOCNldXsbB2KyyHPUMnW8THnVywuzdaJ3hfP9ZTkcku
	 IbY30EY+NOjMztp61V4AndBRhZI7vCylN8DguRF/rqLjK0F7szEzlg4Nn8013BLiHmwTr
	 EmSJNtHNI81s6GtknBgbA/sK/UXlyi0xW1H1IHW2/rVQVXtbR470qMhEyMoYV9cUfEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Yucxdb+TpTE7X4AkMFYamHN7cSgTCbRdq1y81e+XJ6A=;
	b=ViuckdGznT789TBmH68JjEZmLurWU93XbDCtV/qKILKq1z46OAagSMv/IjFS82d/r1h9
	 VzibnDp1dvBAqcrjqUME8tXCz/5A1VlsRoPsI2dYwm9vSgItF5FcimMGp4zITVYAwusyU
	 L2Co9bzlrAZCHuc5gTyMBXqiKE2Ghy37hwjqixAic3NW88v5UHE9aEjwZ030TU4IJqkXl
	 Kbq5ZoC4dX8WqxCmsU9GBiHRyJpgRe8XUukYTU71JXHjnY8vybGyuiAYRSBmyyZGzUfKV
	 qfPie0gMZFFs5hLkUxwK3HY/M8EUbd1E/PLZLFF8obuH/Arqm+JpclSeN8Kinu7NQBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EGU0bsyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D351C60A2603;
	Wed, 28 Oct 2026 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EGU0bsyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329071F01825;
	Wed, 28 Oct 2026 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214286;
	bh=Yucxdb+TpTE7X4AkMFYamHN7cSgTCbRdq1y81e+XJ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGU0bsyxH4MQzHCK+pVeUssXT+qGAJj7peZ4YppGBMcXPW5Cpz7copb5sqvsIakEf
	 +CfVN/AKe5uYiM0CcWRkThBK4W99Z6tqqJWZZyL8Tmhgze/aaaqriZNF/MJSZdNB33
	 zHARYOG4SgE/GYmtzj7xvGkoj78b4f64n0Baq4UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0803/1887] net: dsa: b53: do not enable EEE on bcm63xx
Date: Wed, 28 Oct 2026 17:48:19 +0100
Message-ID: <20261028170517.702341511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 1237c2d4a8db79dfd4369bff6930b0e385ed7d5c ]

BCM63xx internal switches do not support EEE, but provide multiple RGMII
ports where external PHYs may be connected. If one of these PHYs are EEE
capable, we may try to enable EEE for the MACs, which then hangs the
system on access of the (non-existent) EEE registers.

Fix this by checking if the switch actually supports EEE before
attempting to configure it.

Fixes: 22256b0afb12 ("net: dsa: b53: Move EEE functions to b53")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250602193953.1010487-2-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index aaf9fbaefd6b9..7777d4cef351f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2237,8 +2237,12 @@ EXPORT_SYMBOL(b53_eee_enable_set);
  */
 int b53_eee_init(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
+	struct b53_device *dev = ds->priv;
 	int ret;
 
+	if (is5325(dev) || is5365(dev) || is63xx(dev))
+		return 0;
+
 	ret = phy_init_eee(phy, false);
 	if (ret)
 		return 0;
@@ -2255,7 +2259,7 @@ int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	struct ethtool_eee *p = &dev->ports[port].eee;
 	u16 reg;
 
-	if (is5325(dev) || is5365(dev))
+	if (is5325(dev) || is5365(dev) || is63xx(dev))
 		return -EOPNOTSUPP;
 
 	b53_read16(dev, B53_EEE_PAGE, B53_EEE_LPI_INDICATE, &reg);
@@ -2271,7 +2275,7 @@ int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	struct b53_device *dev = ds->priv;
 	struct ethtool_eee *p = &dev->ports[port].eee;
 
-	if (is5325(dev) || is5365(dev))
+	if (is5325(dev) || is5365(dev) || is63xx(dev))
 		return -EOPNOTSUPP;
 
 	p->eee_enabled = e->eee_enabled;
-- 
2.53.0



