Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AAF2F0C62;
	Wed, 20 May 2026 17:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299105; cv=none; b=F9juwPlGBvISv5bVulGO0Qvb9wyf3mRZrLEBU0FtL3Jm8o/y1OyMgLk8UXeUUN/YEpKnP91FeOVA+o2JbkqMTWgdin4Bv4NAEE+rSH/qs64tQ0NVNlFr0857WNpmW3tDhNJKlJA0FzBXU6UZmGvpvTNPD8QqYTv5xhtFifhy650=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299105; c=relaxed/simple;
	bh=wyoa+hg1L3OVQm3ACLuvtntNVS50OOVSpcjKe4fqH3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzAobrJxc4VC4iyxMDK6a+y3WxrcRLo6y5uqPSmsXqyx2rM+EKrUy4dN+bDqizLU4IykBO4XEtYtutYNXn7rhK5a9CeQYW7zqcO+0E1On7xBnZhVxx529sXyAQXAf1Yvdaqbew9VsMf7NtcBYwGtehvh+Bx2nflf2tN14VjeWAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1yIAFY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1yIAFY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775461F000E9;
	Wed, 20 May 2026 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299103;
	bh=3kWooR6MjEuREeMUAPbSiu9k6P2t4b54SsMTU2MgLio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1yIAFY2Jn7XvC4Zr1cvbic2UiBXGcSlAPrhh2f01G3N+qw5PRtSuw82h9DhA3BSS
	 0td7MNHLHh1gZu+hC9Uw9ZJ9uusN0Xh9ZbTc5hUNYM/scZQO2TUR2Zy+gnLp5wje4g
	 R4IWhkKAanBNhNq/iu+M9x2r43EdniNmV4H5ajr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 622/957] net: dsa: use kernel data types for ethtool ops on conduit
Date: Wed, 20 May 2026 18:18:25 +0200
Message-ID: <20260520162148.020585855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8afabd27fe46ebf991b4aea20b74e08196c15c0c ]

Suppress some checkpatch 'CHECK' messages about u8 being preferable over
uint8_t, etc. No functional change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251122112311.138784-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0f99e0c3e19b ("net: dsa: remove redundant netdev_lock_ops() from conduit ethtool ops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/conduit.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/dsa/conduit.c b/net/dsa/conduit.c
index f80795b3d0460..c210e31296558 100644
--- a/net/dsa/conduit.c
+++ b/net/dsa/conduit.c
@@ -89,7 +89,7 @@ static void dsa_conduit_get_regs(struct net_device *dev,
 
 static void dsa_conduit_get_ethtool_stats(struct net_device *dev,
 					  struct ethtool_stats *stats,
-					  uint64_t *data)
+					  u64 *data)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	const struct ethtool_ops *ops = cpu_dp->orig_ethtool_ops;
@@ -110,7 +110,7 @@ static void dsa_conduit_get_ethtool_stats(struct net_device *dev,
 
 static void dsa_conduit_get_ethtool_phy_stats(struct net_device *dev,
 					      struct ethtool_stats *stats,
-					      uint64_t *data)
+					      u64 *data)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	const struct ethtool_ops *ops = cpu_dp->orig_ethtool_ops;
@@ -160,8 +160,8 @@ static int dsa_conduit_get_sset_count(struct net_device *dev, int sset)
 	return count;
 }
 
-static void dsa_conduit_get_strings(struct net_device *dev, uint32_t stringset,
-				    uint8_t *data)
+static void dsa_conduit_get_strings(struct net_device *dev, u32 stringset,
+				    u8 *data)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	const struct ethtool_ops *ops = cpu_dp->orig_ethtool_ops;
@@ -169,8 +169,7 @@ static void dsa_conduit_get_strings(struct net_device *dev, uint32_t stringset,
 	int port = cpu_dp->index;
 	int len = ETH_GSTRING_LEN;
 	int mcount = 0, count, i;
-	uint8_t pfx[4];
-	uint8_t *ndata;
+	u8 pfx[4], *ndata;
 
 	snprintf(pfx, sizeof(pfx), "p%.2d", port);
 	/* We do not want to be NULL-terminated, since this is a prefix */
-- 
2.53.0



