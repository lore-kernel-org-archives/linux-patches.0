Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA662DF13B;
	Tue,  6 Jan 2026 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720827; cv=none; b=Ooe6iUgpMkXXi/elxnwMRmR3OXUmBKb6V2YaO/jGKOgM4RVIUM/qS//jw7p17xJEwI56rsoHB99wsUi6oowcQZEzkMiJRUEBGBghjcMy5Ykk9U96d3wNn1V6OgNfilwoAgMIbXuQssVyV0DFcgf9kUXDTZVkw/v+l9WsiJ5wn1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720827; c=relaxed/simple;
	bh=AUlTrlVy1qIm/yceaOEKpy5feyPTn+D7ePA+Y9OJt5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoc7yBFX8JCD58tSoHMNyUcks0olijp6civY0LjSGgQHPkYaL0a2Vge7vnmEA+ahnv9yXWRroVB3gy2lbEs1udCJDewqv6VvW3HSZ1hC6B0QGJBI3lg0RruxVeGUTY0JpgOcewUYiyCIJcuYTda3zoALNTaNK/Fzl/K/WBdR9Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVwjnNQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVwjnNQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F65FC116C6;
	Tue,  6 Jan 2026 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720826;
	bh=AUlTrlVy1qIm/yceaOEKpy5feyPTn+D7ePA+Y9OJt5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVwjnNQYj8f/Un8OMJAp0Khsu0hLRX8N46T6s38sv0/+14g8/T/dK75jGqPPuwEHb
	 H9L0sTBLBp0iwGfTCkq/iVVCpOUN2FieHEgihR6+UV2xWOQlCNWQ2bn8UctTZCz6SG
	 CXPAn+QWYv1LG6bRMfYXjbcy0/ki7Se0BGPL35to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/567] net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct
Date: Tue,  6 Jan 2026 18:01:43 +0100
Message-ID: <20260106170503.200238965@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 741b0b8c4bab..a2e59108a5dc 100644
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



