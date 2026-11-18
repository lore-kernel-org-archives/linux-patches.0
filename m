Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033252;
	b=4Mw5vzy7P0RON3lLwYPQalQppUgLqDCUP1GdkYeOnvDDMCkPDYSK7bh4DXUxwurlBJrA
	 LzlRkLbwAU+zuIYc07EQIjs6BcFNAP2NToLAAIHZMRlkBAH/eV4xgrncmC2wkexoUoAdo
	 YDIpBA1lhNXIYRpANu+W8vCq/DZbsCgqZRbunJvcfQgrX+vrPgi/UTs9Qaw43kLhONQmY
	 G6LWRtXK+8bBfUjDOeyLh5oMTC7Bjqer9khlSaTmp1s940Tl9XxQAyjkP0HQZ1+ZLy4F6
	 WEcl6VpZlBAcM4UGFm8L6wxLqRJX1UnyFMe+KST6MC1lUS0HjIJU6kxyCKe+zh5FTNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z03B30DQHsE+tdhSUEiUc8VihiLdhH099tYVoDSaaQs=;
	b=F8sM6QQr9omg5PRl/u2zTS1w3zd+9y393oQDgA6VpyCsFKDyaTkCsBI6nSrteRDs4lY2
	 S+Pgw7L9MDzCOm4vjhJZWwmeAy6aKxh3OPQzv4wVqUrbJC+BI3CPqf9LhhRm9GctPfJ7P
	 8kKDB2FTY6IzZSKLGV5FqWCbux7I4LEud1whzppu4/kV2P8J+KD5+GA46dPoimZ96U8Nj
	 xnhQbWivmCkbXly6pQm45W3kOQ8OKZ0TlzejHwUvXYnWROIwOaypzWT8sWEcvwavdA6aN
	 ckyxh7UnAX4mfGdCNlFzPcZoDlxa3ZshZ41KvOpfQrD8GoQKpKSBij8SNTzxh8r0wrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQO9lXsY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FE3606A32F;
	Wed, 18 Nov 2026 20:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQO9lXsY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0401F000C4;
	Wed, 18 Nov 2026 20:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033251;
	bh=Z03B30DQHsE+tdhSUEiUc8VihiLdhH099tYVoDSaaQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQO9lXsY1us/Y0LwAW6O4iNTz7MJYbA3tj+Cj0coQRPAAguqJpYkuSKVdjq5So0jM
	 lZWaH0NqxFdLMHXFpJiLK12d5d+yaYZE3w5V75wjuWXx8xsHdfChoTrTapf85op4dK
	 Dnfozusk1ZR+71U9Yr7E8ffbMUIRdZt7iUcJMe3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1703/1756] net: add eth_type_trans_careful()
Date: Wed, 18 Nov 2026 16:03:50 +0100
Message-ID: <20261118150117.438498249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 2519a6fe7a8bba57a961eb804e43e7df35ac40fe ]

eth_type_trans() assumes ETH_HLEN bytes are present in skb->head.
NIC drivers always provide this, and they should keep using the fast
version.

Devices looping skbs from their transmit path back to their receive
path get skbs built by the stack instead. Their link-layer header
might have been popped by tc actions (act_vlan pop_eth, act_ife decode)
or OVS actions (pop_eth + pop_mpls / pop_nsh), leaving fewer than
ETH_HLEN bytes in the linear part. eth_type_trans() then hits
the BUG() in __skb_pull().

Add eth_type_trans_careful(), which first pulls the Ethernet header,
and returns a drop reason on failure, so that the few devices exposed
to this can drop such packets.

Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261028122703.2093730-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 093a28998374 ("loopback: use eth_type_trans_careful()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/etherdevice.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index a3ae683affa58..1188bc2f41ac6 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -38,6 +38,34 @@ int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr);
 
 u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 len);
 __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
+
+/**
+ * eth_type_trans_careful - eth_type_trans() for skbs coming from the stack
+ * @skb: buffer, possibly with less than ETH_HLEN bytes in its linear area
+ * @dev: receiving network device
+ *
+ * eth_type_trans() expects ETH_HLEN bytes in skb->head, which NIC drivers
+ * provide. Devices looping skbs from their transmit path back to the
+ * receive path (loopback, OVS internal ports) get skbs built by the stack,
+ * whose link-layer header might have been popped by tc or OVS actions.
+ *
+ * Sets skb->protocol on success.
+ *
+ * Return: SKB_NOT_DROPPED_YET on success, or a drop reason. In the latter
+ * case, the caller must free @skb.
+ */
+static inline enum skb_drop_reason
+eth_type_trans_careful(struct sk_buff *skb, struct net_device *dev)
+{
+	enum skb_drop_reason reason = pskb_may_pull_reason(skb, ETH_HLEN);
+
+	if (unlikely(reason))
+		return reason;
+
+	skb->protocol = eth_type_trans(skb, dev);
+	return SKB_NOT_DROPPED_YET;
+}
+
 extern const struct header_ops eth_header_ops;
 
 int eth_header(struct sk_buff *skb, struct net_device *dev, unsigned short type,
-- 
2.53.0



