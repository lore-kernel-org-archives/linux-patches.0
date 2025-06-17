Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E8018E025;
	Tue, 17 Jun 2025 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179083; cv=none; b=Cz0hIhHAgq2gGTPPhXouQPSW7XRTUdwSCJJlnKhQWHLQ6HN+c+DSUuiKe5H6j+JLYvPWpN7XcBMgwbQUnUkNvWI3oz6oRf4eiyQsAHIOlXJ7BuU+ZOlLt/yW0M2uhvI8cEv4cGkMkozZZ/LWHDgX5qIrpMx/K/amy2CW/1ftsiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179083; c=relaxed/simple;
	bh=tbr6wvtcOiR7WiiIsYDJK8sARl2UlGFyst9pG06W6MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMI06S7zljvAAaopQTqPor/Ij8s6PERqtQpX1G6N8JO6Ntduxty6lwmD7pCPsfwNkLbmHMFArrcwuduEjB5xML/GKtVPqJHdohSP30VCMz5guTZTkcQ9mMT8IGeOJfhJvEuKOZEltr/CO3IzJykT9GILd3cX7XA6KkaNYn/p7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QirvzgNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QirvzgNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D148C4CEE3;
	Tue, 17 Jun 2025 16:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179083;
	bh=tbr6wvtcOiR7WiiIsYDJK8sARl2UlGFyst9pG06W6MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QirvzgNVJ3HAetiYdTi5HyIjkaDbTdbFg1ILq+zv2cdlpyboBf/ojZ9JqyzXT0jI4
	 Eh0nPRe+2uGDMNIwCLdV6qEBMB8AORZM2cz64t1FOvbCrlE36kbUkgAXODbsL7aagN
	 EOS4BqSLFEr0NvN6pUQB2RBAFqiLwhIVjWkm3i/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 614/780] net: dsa: b53: allow RGMII for bcm63xx RGMII ports
Date: Tue, 17 Jun 2025 17:25:22 +0200
Message-ID: <20250617152516.487480963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f4934f974c81..be4493b769f44 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1439,6 +1439,10 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
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



