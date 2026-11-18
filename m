Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050753;
	b=fgO1wUWY5OGfHw/ZvxnZsE2AzD1aO3of9dJp/eWAmJ3QI3sNCQS1/LEU6uhyEAmqXVjW
	 WE7o5/X3E6xzYrzFmT3RJiRWMkV7sLj7ju9YyTR5X2vPgP08m7+xZIV+PPfIvgbyHb7CP
	 yo7AEjS7xicvVC6UTI1JdukYCvokQXXyg39uTO4c0itObXlERP/xtWl7sf8nfP3D4WsmI
	 CiF5dBwHrCovwl7eJBi96XwyD7AKzCXHa2mSc/SiZ3sTMQBGXT+FGAKHeWsDYAb43Co/8
	 IFK+WVvT9MXq5TOEXFjByuijYytfG2uv9Dab3EzWZmaXBWPUpyxpKqqvgOStAZ5kFDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmNHel0x49J3rZBMetOhVWbB5QYEfBz5fJSsrBbo7Fs=;
	b=ArmegS2u0rIUSqkCpA04uEjo8PQxydyi4GgURifmHWcdAvZRLgv6BGjXjBYjs5pY9+GU
	 i97wNEWquB8b9ZMnGFlG/vhmajma+jNHA9SdPr3E2D7eC2qvcSihH4FdA9hrk8QJi1zbV
	 9VP3sUE8FyVrqzl8/SI5BbQGu9jSfcWrQEReRFluyZibiQJJKaHUXwCf6qQx6nE2xjhOr
	 ihWqD51aXGmBu2PqzdRquYmVAjQRsrGMUkn+Vtu7hthSHOL90MYzamvHzAuU+TLWLDlS5
	 u8uveUPZsRdECrZbrVvqcpCofjb/wULR6Fv0RpA4Zzq1yvqCl64eDGvciYf+pKTrsTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Piv2GH+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EE8606A32F;
	Thu, 19 Nov 2026 01:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Piv2GH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F531F000C4;
	Thu, 19 Nov 2026 01:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050752;
	bh=VmNHel0x49J3rZBMetOhVWbB5QYEfBz5fJSsrBbo7Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Piv2GH+WjyZYKcOJY46l28rmmf6Joi4fY5Mi9ai6GuU7CM3UbCNbg2KGE7Ztvo09
	 C+6g9pXziAL4ZQEnmvcigUFmWMaXW/5c/DA45Ax6hNHTQFYswf81Ybd9vvf+UnM0dw
	 ENmMwAHEjnsOcATDZHmIYMR0NiE2K2dB9QyYkUes=
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
Subject: [PATCH 6.1 2820/2857] net: add eth_type_trans_careful()
Date: Wed, 18 Nov 2026 16:04:14 +0100
Message-ID: <20261118150343.132510244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d7eef2158667d..83806b3be348a 100644
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



