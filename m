Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5B2471268;
	Tue, 21 Jul 2026 20:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664847; cv=none; b=gkTp6u/aqpedyXiYf2HQFQKj8383rzLG5uJFXL3+D3AXSHY8FMnJKh8EWVizvFKibyWdxq5zWm40noUFJhcqE2U1RXkVwbr38oWwZkf6ObCSmWI8H1DXT067bmSyL9pBGIVeJc9ypaFLOggoRLad1uAAV0kyuN3VfwqE1hogZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664847; c=relaxed/simple;
	bh=ZODaadn2Hgt7qVd0RBJRO45nZA2/PDVJYGskGXiP/p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgk7g8YFJhVTMc5GUVJ7qdT8ij7rwPJyeWkTZvI63ZF0X6OpQyKQcbbbLgmUl2D6GfVIZuLrIscv8XgqOJQclfjWubsymb+5ecf4eIeuAwpJQzdRBtRtQ+N3iH7kfjZbj56u17NKGhEVN6OQF2rwL4hDYtL8VGKZaq05Uxg8zTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjvhmqJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjvhmqJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FC21F00A3A;
	Tue, 21 Jul 2026 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664846;
	bh=pt1DP9QKKbZSew1ZMiZrlJdpDkqxsep19gSpgedcFIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjvhmqJDHIevgAEseRAiske2h7VKYE4YZuotNCNkiV9dbm7wCUr2EHqyWy4D6N6wF
	 5M9qrR6LYerSInQEn1axuUCAfL07kwoW/6xYhvwkUiO5nfzmIqvM7p+tEP740JISeW
	 4Cu46rIrvr5dT7BrlGOhNdIYYR22KuBWXk3go4zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@idosch.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0044/1266] net, team, bonding: Add netdev_base_features helper
Date: Tue, 21 Jul 2026 17:08:01 +0200
Message-ID: <20260721152442.788184946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d2516c3a53705f783bb6868df0f4a2b977898a71 ]

Both bonding and team driver have logic to derive the base feature
flags before iterating over their slave devices to refine the set
via netdev_increment_features().

Add a small helper netdev_base_features() so this can be reused
instead of having it open-coded multiple times.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20241210141245.327886-1-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Stable-dep-of: d064ea7fe2a2 ("bonding: Fix initial {vlan,mpls}_feature set in bond_compute_features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 4 +---
 drivers/net/team/team_core.c    | 3 +--
 include/linux/netdev_features.h | 7 +++++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e57e1296da3740..36277bcefe2908 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1456,9 +1456,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	struct slave *slave;
 
 	mask = features;
-
-	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	features = netdev_base_features(features);
 
 	bond_for_each_slave(bond, slave, iter) {
 		features = netdev_increment_features(features,
diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index deb6eb3a240a03..5cd1807e11f797 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -2026,8 +2026,7 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 
 	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	features = netdev_base_features(features);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 7c2d77d75a888c..1b5ad57e7cbf5a 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -261,4 +261,11 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
+static inline netdev_features_t netdev_base_features(netdev_features_t features)
+{
+	features &= ~NETIF_F_ONE_FOR_ALL;
+	features |= NETIF_F_ALL_FOR_ALL;
+	return features;
+}
+
 #endif	/* _LINUX_NETDEV_FEATURES_H */
-- 
2.53.0



