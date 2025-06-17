Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10638F54;
	Tue, 17 Jun 2025 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177678; cv=none; b=htpW/j7OMSgCSIS97bZiWTlBHyBbmRFjH6bItZMWl7d6cslbQl1IsCJmcJqupiGjvtibXjElLgethCj59i40NNlByloo+05RByKmGqh8GBVeBZSSiDanisfIpqzlrMT0yn6eGJGHQgMSqDEqtg7Ho3GHdKNaeeAzaaZrhyaX1Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177678; c=relaxed/simple;
	bh=MkUORlmyaeER9CkULd9gVuHblzY0pBxw1etjCopcrrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnojV6fjrbZ0INtoWJyevoKdtKan6jhQ706gV54g4SnBvqOoDsQKF2Y3ujNXc0iry6GeiZRDyvnybAv0EF5lKF+nd/W6xpHXFM3neooy6QiAkYij41TDqcFEUq3GPagE1bJzRCKL1zNEwxrdOGUyvoCgxtOXgq6ueI4PIOcm4qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0305Hm5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0305Hm5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA987C4CEE3;
	Tue, 17 Jun 2025 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177678;
	bh=MkUORlmyaeER9CkULd9gVuHblzY0pBxw1etjCopcrrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0305Hm5SLv3DSPcksPN+sYEHFU4+M0sHBQGTZZ8Eclb8D9QH7B7zlPt/E2bYmOpOz
	 jJuo3+DwIEZXnZpnM0YktW7kFlXaUCG0+m4SuRKj60maaDWCIVgLz7vHq/MEQr0RWN
	 m5evEYjnvYLhlwCZyK6W8UPy0dKjVStVEppRVl+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/512] net: dsa: b53: allow RGMII for bcm63xx RGMII ports
Date: Tue, 17 Jun 2025 17:25:46 +0200
Message-ID: <20250617152434.989338835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 5ea0d42c1980e6d10e5cb56a78021db5bfcebaaf ]

Add RGMII to supported interfaces for BCM63xx RGMII ports so they can be
actually used in RGMII mode.

Without this, phylink will fail to configure them:

[    3.580000] b53-switch 10700000.switch GbE3 (uninitialized): validation of rgmii with support 0000000,00000000,00000000,000062ff and advertisement 0000000,00000000,00000000,000062ff failed: -EINVAL
[    3.600000] b53-switch 10700000.switch GbE3 (uninitialized): failed to connect to PHY: -EINVAL
[    3.610000] b53-switch 10700000.switch GbE3 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 4

Fixes: ce3bf94871f7 ("net: dsa: b53: add support for BCM63xx RGMIIs")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250602193953.1010487-5-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 2747a507e3ce9..a17a3083180b0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1441,6 +1441,10 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_REVMII, config->supported_interfaces);
 
+	/* BCM63xx RGMII ports support RGMII */
+	if (is63xx(dev) && in_range(port, B53_63XX_RGMII0, 4))
+		phy_interface_set_rgmii(config->supported_interfaces);
+
 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100;
 
-- 
2.39.5



