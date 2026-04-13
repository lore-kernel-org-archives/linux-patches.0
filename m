Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F70D27280A;
	Mon, 13 Apr 2026 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097252; cv=none; b=K0AIfH/iF0WR8L81DbRhJAuIlOZyahdX9WyzCG6YcwoLkCNRWqOzOtrHpt/8mIe7Zf+J74Yp0J5ADVuHPR0uO4adJVmxpQNdBS3xnx0K7VUkCe8Om9J85VQARKWbN99bsYaGMK5oJtlnBN/nfPLW3lTnFZZf11okDHi42sGD3ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097252; c=relaxed/simple;
	bh=XPDsm0W+qAgmDqprIGgLTckzKG/odKqBIeJO18o9Mb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs0oqgt9XJUBDMSjMdJXz4PEUJ9KeSxIY1zxMJrUUhf7egXnYmcGxQoAb/VCWZ3ZckIpn61xAThZZT4TTd+z3k6edDNUkpjYrmVAqEjaVigzLibxKAG6Nmc7e5N40O4AVplXG3lXp/c8K8VEWAhwDXUUIActbi33ejDrtDmBwuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdQX+fRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdQX+fRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A28C2BCAF;
	Mon, 13 Apr 2026 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097252;
	bh=XPDsm0W+qAgmDqprIGgLTckzKG/odKqBIeJO18o9Mb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdQX+fRupA89iktoBOw2lq5+md6VHSA8f0ALgya7A1LqC5hg7U3yPSQd7/JOkYmPf
	 DTiaTaAXl02y/JKMRiyCCDIxj7CTWy6MYqO8U3QcyBVFfygnxsmqLC6JQVnndCVsQP
	 z3x/FBc7oaDVnt5s11yoVrP627YDQ7xRs0G/MNIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/570] net: dpaa2: replace dpaa2_mac_is_type_fixed() with dpaa2_mac_is_type_phy()
Date: Mon, 13 Apr 2026 17:53:16 +0200
Message-ID: <20260413155832.876520916@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 320fefa9e2edc67011e235ea1d50f0d00ddfe004 ]

dpaa2_mac_is_type_fixed() is a header with no implementation and no
callers, which is referenced from the documentation though. It can be
deleted.

On the other hand, it would be useful to reuse the code between
dpaa2_eth_is_type_phy() and dpaa2_switch_port_is_type_phy(). That common
code should be called dpaa2_mac_is_type_phy(), so let's create that.

The removal and the addition are merged into the same patch because,
in fact, is_type_phy() is the logical opposite of is_type_fixed().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 74badb9c20b1 ("dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/freescale/dpaa2/mac-phy-support.rst       |  9 ++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h       |  7 +------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h       | 10 ++++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h    |  7 +------
 4 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
index 51e6624fb7741..1d2f55feca242 100644
--- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
@@ -181,10 +181,13 @@ when necessary using the below listed API::
  - int dpaa2_mac_connect(struct dpaa2_mac *mac);
  - void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
 
-A phylink integration is necessary only when the partner DPMAC is not of TYPE_FIXED.
-One can check for this condition using the below API::
+A phylink integration is necessary only when the partner DPMAC is not of
+``TYPE_FIXED``. This means it is either of ``TYPE_PHY``, or of
+``TYPE_BACKPLANE`` (the difference being the two that in the ``TYPE_BACKPLANE``
+mode, the MC firmware does not access the PCS registers). One can check for
+this condition using the following helper::
 
- - bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,struct fsl_mc_io *mc_io);
+ - static inline bool dpaa2_mac_is_type_phy(struct dpaa2_mac *mac);
 
 Before connection to a MAC, the caller must allocate and populate the
 dpaa2_mac structure with the associated net_device, a pointer to the MC portal
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 805e5619e1e63..f388acc434987 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -711,12 +711,7 @@ static inline unsigned int dpaa2_eth_rx_head_room(struct dpaa2_eth_priv *priv)
 
 static inline bool dpaa2_eth_is_type_phy(struct dpaa2_eth_priv *priv)
 {
-	if (priv->mac &&
-	    (priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
-	     priv->mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE))
-		return true;
-
-	return false;
+	return dpaa2_mac_is_type_phy(priv->mac);
 }
 
 static inline bool dpaa2_eth_has_mac(struct dpaa2_eth_priv *priv)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 7842cbb2207ab..0b2fc22f11909 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -27,8 +27,14 @@ struct dpaa2_mac {
 	struct fwnode_handle *fw_node;
 };
 
-bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-			     struct fsl_mc_io *mc_io);
+static inline bool dpaa2_mac_is_type_phy(struct dpaa2_mac *mac)
+{
+	if (!mac)
+		return false;
+
+	return mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
+	       mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE;
+}
 
 int dpaa2_mac_open(struct dpaa2_mac *mac);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 0002dca4d4177..9898073abe012 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -230,12 +230,7 @@ static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
 static inline bool
 dpaa2_switch_port_is_type_phy(struct ethsw_port_priv *port_priv)
 {
-	if (port_priv->mac &&
-	    (port_priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
-	     port_priv->mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE))
-		return true;
-
-	return false;
+	return dpaa2_mac_is_type_phy(port_priv->mac);
 }
 
 static inline bool dpaa2_switch_port_has_mac(struct ethsw_port_priv *port_priv)
-- 
2.51.0



