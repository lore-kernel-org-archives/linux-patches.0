Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364462FDC4D;
	Thu, 15 Jan 2026 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499605; cv=none; b=IlsQtDYJAuE2avxwa0BJWUYfpX+FZKNSefw4p+bUJvC/NHRWhbcK3iQ7CFIq0dOqoNpwfSmkX4BJQIhvKKPoFB8VvWF2i+QBefjBAEzuR7oFd7/xILsvwI6XN+QB/tYrE7aLY+JOWG4EI4LWbprfs3bEXMoDlECoh1EYOb6Goas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499605; c=relaxed/simple;
	bh=gTC7ROzL1JIL7TMGiqwW/OP0witxyKEroumu+2B92RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiBD8Sr5rhgoKezqjBGqQ90wQjt+JZEQSlu1ZZ3x0W7fGHvvzNWhAyFKneyl0Tf2+fG6/OjQt3HeZagPTtBAArftSmMOb61EFgi4xQQT1lHp39GnzTk6ccjH6VLQD34m5jyUbM1/QZZKlm5G9oB7WpI6Qcnu8QU3f0sgAtUFPdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRRT45d/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRRT45d/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B146EC116D0;
	Thu, 15 Jan 2026 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499605;
	bh=gTC7ROzL1JIL7TMGiqwW/OP0witxyKEroumu+2B92RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRRT45d/r/iY3akqta4VgccmJzDt07SMdtc6/PTi6VGTAXlCPMj9lXvJdusK1Wytb
	 nQtUxGlmaSn6JDtH+ru5rx1dNYLTbwYpJDzZ5lwwmFNsJAbMmCOR/LZr7KzP6/5o5Z
	 7ud0W6wsQ4+wy1l2GQdK04cnHsM6s8RsLg4/O2FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/451] net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct
Date: Thu, 15 Jan 2026 17:48:07 +0100
Message-ID: <20260115164241.229847000@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 259b43b435a9..19d77a8721fa 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -158,6 +158,7 @@ struct net_bridge_vlan {
  * struct net_bridge_vlan_group
  *
  * @vlan_hash: VLAN entry rhashtable
+ * @tunnel_hash: Hash table to map from tunnel key ID (e.g. VXLAN VNI) to VLAN
  * @vlan_list: sorted VLAN entry list
  * @num_vlans: number of total VLAN entries
  * @pvid: PVID VLAN id
-- 
2.51.0



