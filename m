Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F393BF689;
	Mon, 17 Aug 2026 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976410; cv=none; b=KtFOe7wm8w6vMcMNtqAyinjj+gKdvw362M6ESsK0RYHlUFZq8D7i0/OJXrMbzvQSdRySk77gspDfuZQJTL26pBuluEXGnq4xPRTTH72YNgnkn1y0Ntbn8nEIVso+T6LYYjASHd+ZI+CBKaj9vloVMLz6gj0ueyK/ClhvN+j+rKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976410; c=relaxed/simple;
	bh=GP0SEbcmvpcDHJWLRoLkr6ZYuVdFoBWgT/O56CLd+I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edylq7zBEXKzay08khRVQq+1wy6COjYpC/qYNqDOt8jDaqFkpnYxrOOeCOfJJI4oQm0bS8NPGs06jyJe7gGIWxJqh36LRQHZoPJLJq4ZSukNupConyEkzqyrBjNGCySbnECFtTst85zjw+eF0TTAiVX2gyoTk4bFbOeUSpfgqLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jv7C6V1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jv7C6V1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275371F000E9;
	Mon, 17 Aug 2026 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976408;
	bh=ffB8hc/uv8Ofjbg3UtoJWDosk8RxF++vS7jC22ySmJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jv7C6V1JzPeO+0UEC4A697UoWJEXDjAnWD7YXPnsWt3SPrguR/cw36eXF3FOCmSYQ
	 B9hCGooL73DqdpV5aCKFYYNhJqUV0x3OPJeOaKjgP7Mdez+LFyStdJkSjf0jlU9BdP
	 lRy5NPuFbfZgV4RfOXqo64niBRBCyhAG0FwBMMfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/389] net: openvswitch: Fix kerneldoc warnings
Date: Mon, 17 Aug 2026 15:32:43 +0200
Message-ID: <20260817132551.560738685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 210bba6790dc150c0dd65da2cbc4de39e5fa3a74 ]

net/openvswitch/flow.c:303: warning: Function parameter or member 'key_vh' not described in 'parse_vlan_tag'
net/openvswitch/flow.c:303: warning: Function parameter or member 'skb' not described in 'parse_vlan_tag'
net/openvswitch/flow.c:303: warning: Function parameter or member 'untag_vlan' not described in 'parse_vlan_tag'
net/openvswitch/vport.c:122: warning: Function parameter or member 'parms' not described in 'ovs_vport_alloc'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20201028004849.930094-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cf6f8b29befb ("net/openvswitch: check Ethernet header length in key_extract()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow.c  | 4 ++++
 net/openvswitch/vport.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 94531289ed26a..beacb1b46706e 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -294,6 +294,10 @@ static bool icmp6hdr_ok(struct sk_buff *skb)
 
 /**
  * Parse vlan tag from vlan header.
+ * @skb: skb containing frame to parse
+ * @key_vh: pointer to parsed vlan tag
+ * @untag_vlan: should the vlan header be removed from the frame
+ *
  * Returns ERROR on memory error.
  * Returns 0 if it encounters a non-vlan or incomplete packet.
  * Returns 1 after successfully parsing vlan tag.
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index ced707ff6dd97..2c876424864d2 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -111,10 +111,12 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name)
  *
  * @priv_size: Size of private data area to allocate.
  * @ops: vport device ops
+ * @parms: information about new vport.
  *
  * Allocate and initialize a new vport defined by @ops.  The vport will contain
  * a private data area of size @priv_size that can be accessed using
- * vport_priv().  vports that are no longer needed should be released with
+ * vport_priv().  Some parameters of the vport will be initialized from @parms.
+ * @vports that are no longer needed should be released with
  * vport_free().
  */
 struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
-- 
2.53.0



