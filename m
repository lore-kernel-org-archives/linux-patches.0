Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705144;
	b=o8kHLqMYPBYoK36nlf5gubxua2s6LEacCorE8FPNZQqNVNBfa2F6EOczZdQXzS+NYVEf
	 V2pDHGlAV0w31wjAPqdUZgeED7Zq7nJYiqPijq507xJegOWz/lOEQWg3ZfxJeAaQNvho1
	 uKMYfku6dkZAM5ON7FkwywSEHYxv2y5lS0ER+iWy5s9HjtXs+X/RFPbiSvFiCPTXM0OKx
	 w+IdsDaDIiSj41+zsFF8KM/+ykXg1ZmGtWDOfcyXvQqE8+G78VLL2ymq1PP004ghrZ+wT
	 xjucVGldCImgincwv8nfwqUa07fSdxLihRg4kUyHev+px0ZjkSGOLcFU9JsXnpGMs/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cPOtAL6Wt/fZ1BqpiDoHqSRQElQxADxJiNVMxxfKYrI=;
	b=OopAx1kiVWjqSXFrbV8q8aGuZ4EsAjfmxgn2Pas8OOZiE5bh9WEZpgiJ8qoyjLAyUpVM
	 kmsoE+fOgt08IpCTp7OXBid6iZX1pVgPm6theyxzWP/0jpU1gwsM1ETxlDBG93mrarHtJ
	 KUzoCL1Gnw2RDE157xDu6gyTthBvjh3aTWjWTKEdSb0d2KaZ+OTajs+XiA0+0D2mq+SXz
	 81PsvUNnzgbOaWgFoiHsSCJQPzuTj71C3XNuHRnPUmpDYW2EtEWpcfEnIDMSt1PABG99u
	 Z0JysO4onDJEq+T4E6pF2mpSklbCfVYvfrJe272rjTBv3PhMW4W+bXYK8YC6Eh/tbwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0HmOKZ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38136606A31C;
	Thu, 26 Nov 2026 14:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0HmOKZ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5681B1F000C4;
	Thu, 26 Nov 2026 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705143;
	bh=cPOtAL6Wt/fZ1BqpiDoHqSRQElQxADxJiNVMxxfKYrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0HmOKZ1bHyHiVpwnhA1ZqPiBiz/O7h846Ylq0/qVS18mlGjLRS85gsTT5a2nRydW
	 LTOtbzmoKBu4yn5Axx+zvaHapUk/MtgN9jsVlbcGNonQWVFMPc5tuczvj+b0B0QaiF
	 HIeRfN1lAYc8mJi+ZPb7K0nuxTVXDbd4EPXhwdxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/319] net: dsa: b53: Force flow control for BCM5301X CPU port(s)
Date: Thu, 26 Nov 2026 15:37:46 +0100
Message-ID: <20261126144008.957472920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 93a2579ed08c76835514d2a7f6e5bf3a9bc377ef ]

Just like what b53_adjust_link() does, force flow control for the
BCM5301X CPU port(s) by forcing rx_pause and tx_pause in
b53_phylink_mac_link_up(). Preparatory step for getting rid of
b53_adjust_link().

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20240423183339.1368511-5-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 41af38324341 ("net: dsa: b53: restore the NSP IMP port 2 Gbps mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d1751f2028582..84b71af29c5c9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1538,6 +1538,10 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		return;
 
 	if (mode == MLO_AN_FIXED) {
+		/* Force flow control on BCM5301x's CPU port */
+		if (is5301x(dev) && dsa_is_cpu_port(ds, port))
+			tx_pause = rx_pause = true;
+
 		b53_force_port_config(dev, port, speed, duplex,
 				      tx_pause, rx_pause);
 		b53_force_link(dev, port, true);
-- 
2.53.0



