Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A085D355031;
	Tue,  6 Jan 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721748; cv=none; b=QvG4/2visyEvaSNm1D27y0GjRZTGlcF5S9TFjI7/ol8YTRQ+RAJz0RLebIft6ZDyuKKxAB1uRH6c6LMPjFdwABu5dlLDjkNuwP8z3HCXtsJ0uFO7EG8BSnnvOJplNTwYrJF/TbGMrQnDDUzez8lpTH/KVD3Knlofk/VD1TvBD8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721748; c=relaxed/simple;
	bh=Wq1l3GaHp2NxmU2LXnC7+f63NxvlbP9ehH2NFVZjL/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJpuLqqkzM6z1x8osKNs0i3oaK4nC/eI05H2uqA4SLaX+eCG27JQ7s3uSesLWL///nEjwbAmr0GeDYdtYjMdvT4ZEACClgV7x43HgAZ9Y1d1K15douJpM1cZ3Jb2OCNFt0P3PhAx9SEz38s5q/HpKqOzigDs6OXdjGnHOgc/Cpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SssXWqNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SssXWqNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F68C116C6;
	Tue,  6 Jan 2026 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721748;
	bh=Wq1l3GaHp2NxmU2LXnC7+f63NxvlbP9ehH2NFVZjL/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SssXWqNiIq73WuFgDiZQ/ixmCHQ2b7FzQB+kF4kggs40yU9JgKK6alW90vxb3bSat
	 nbSn62utMztzLcBsX5d8Wm49T+IeONHL4yKsXgpqx4HfjN1Se+gV67u2R+dojYfqOm
	 jjPZ2Mus/nRLj/A308Z7g1TDK85OYwW0wdwngOlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/312] net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct
Date: Tue,  6 Jan 2026 18:02:07 +0100
Message-ID: <20260106170549.771492477@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit f79f9b7ace1713e4b83888c385f5f55519dfb687 ]

Sphinx reports kernel-doc warning:

WARNING: ./net/bridge/br_private.h:267 struct member 'tunnel_hash' not described in 'net_bridge_vlan_group'

Fix it by describing @tunnel_hash member.

Fixes: efa5356b0d9753 ("bridge: per vlan dst_metadata netlink support")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251218042936.24175-2-bagasdotme@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_private.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7280c4e9305f..b9b2981c4841 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -247,6 +247,7 @@ struct net_bridge_vlan {
  * struct net_bridge_vlan_group
  *
  * @vlan_hash: VLAN entry rhashtable
+ * @tunnel_hash: Hash table to map from tunnel key ID (e.g. VXLAN VNI) to VLAN
  * @vlan_list: sorted VLAN entry list
  * @num_vlans: number of total VLAN entries
  * @pvid: PVID VLAN id
-- 
2.51.0



