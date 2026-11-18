Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028345;
	b=Gm93kI5qe8w8RbnWEgI3bZZAIalXrUVHSh8PuqmpAWR/H4nN0PNnASvAJDj77yCJkWjL
	 XJgfBLfNtxYUspWKmZ3fnvlilAuK13bKDTVI3t6fNoXf8VEYaxldHSjqfN1YJITCaLt1z
	 j8a6TlrpT8KITGy8TSUbyoWmmUkD1hgzlx3dLK7cT32eVA9OaSY30hji5S3eSyjqwNz+l
	 KMAa8nxgHrWcCM+4smBunsbXZf740mHHnvfPpx7/n+VeZeXcLtN8WxxMZco8UgXEL5zrM
	 rdzc7A8c7UaVMDmId3vnjTARns7tPiF3JQU2eZgF38JUkVUteuAV3RPKBbBG7JC8wkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=745QfQs7bkbv/uFqg5Awa7leFdcjKuhXKiq6DOSCqNk=;
	b=0JkqGk3zFaxs1LKFcLAGwFW0XbQ5puFjuvcfMwRiDlkC3bIJugakJTTT2hBnfQQXIzsg
	 Q7mAaO89BCRSkZfGUgZx6ZY8l8ULs2Ud7t49ZgSkmRJQB3q6sDwMcmcx1C5+40vYCCwei
	 M6XKf92L/LXwOB3kqCTF+6byO00iiSVCoKzpzul+U4f1afLx1THH/0ZTm7BT7PzmX97U4
	 STj3XmujZj9YbBoDbVmpTTupW2hE8PFGzk9IDzQBEnH/1M03jUA+pRp4Y1aLWINgZW0mv
	 0WbRXRPcM6T5dZkzJ/7S4PXVFTQf/Tw9wH4vMLqZSXLFldN9i+h6Nk5ME/2FGsRPNIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGlnDxgG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC5A606A325;
	Wed, 18 Nov 2026 18:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGlnDxgG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627EE1F000C4;
	Wed, 18 Nov 2026 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028344;
	bh=745QfQs7bkbv/uFqg5Awa7leFdcjKuhXKiq6DOSCqNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGlnDxgGR/4pIYwTelIPChxvBfM6a83CVzr3kDws9LLEVBoPLxcIxoESxvTH/f3t+
	 6YfZW+tgELiOLrSOH5xwwnAo/cpQeTw9OYBW5tHfbF0BmuGaI4P0giO6EhLiwr31QF
	 6mG6LGBdCGu1JIQeGqyxaWiamcspV7/2t+vxfSC0=
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
Subject: [PATCH 6.18 2112/2151] net: add eth_type_trans_careful()
Date: Wed, 18 Nov 2026 16:04:07 +0100
Message-ID: <20261118150238.631050421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index df8f88f63a706..1f833ebd71ed9 100644
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



