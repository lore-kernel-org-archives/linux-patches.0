Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056680;
	b=QIxlBp/j3pWJ9Vd9fA8JTxXFE3dHA6nhvj4fRv3k9x+JVRoOZuKpYLAmNbMFe+HxLXyQ
	 GO0cxIS7P00G0Y6mCifk5S3vxr3qIjpTLu0xxJ3BcJSHJUUtEmZplphxVPweFVzFwYnvt
	 jjpjrYuLBR+zRF5iORTMTfqP3g01jyA4ZcIcKf3iGEvI3eBBZSF8iCR2Vp96Vmt28VNWw
	 fmOa+Zq6wdb2N+b/3WKfP5DNuZETkxDv7jwm2LDAJqpMdAmGb1Y3YFURViDbMlyf5skAF
	 UTAYXrFnjfWdSZ+y6OskO9gC+Fms0RG2tL99aDCRddOwt/W3+oPswl3KFiJamrmbmDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OxSP+UGXzZX78pNLM8seam0qe76NR7Qlu7C7+TWFbpE=;
	b=qz1jElhlxZeaiVy+aH+AOhU90sfSAFiywGsjvyucSHH9S4W68nLTeEC4FodUcoVVbyD7
	 Vm01wH7q7b0ZPE1wdl8h9zo+sUWDcZK1birwFCZUoAnofNtWcQKFs9fWU75d11f9F/eTI
	 qfxwtkv6WiOh5r2HZ3MFR/uJ+3FyFqK5mZzca0xBDfIOCLhRXbirr44UyjQQWHWwop8vf
	 zZDtVMhIA9eF2NMB73LJPxQ7aiK5eXz056sp08X9ZSnKf+klAYOf6QIp/W9vtzxYji2Ii
	 Ek7Cc9kfm0jrljkbj7GkBuudYiPIfM0hv8+ldDcb6FeMg0p1Ftcwote9ohhnERCHGRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q/XtZep+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA9E606A32A;
	Thu, 19 Nov 2026 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q/XtZep+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0706B1F000C4;
	Thu, 19 Nov 2026 02:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056680;
	bh=OxSP+UGXzZX78pNLM8seam0qe76NR7Qlu7C7+TWFbpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/XtZep+DKYXd1yJgYCt2MdJetAiw57cd3vsBKzHzf0IHVo+H6BUi3TpnQcBbHoSk
	 Cgf6lJFrYYw7qrtZ4p8JdBvH55tvJ/5Mb27f3umnrR/Mid1ySjLNPmIvNu24jHuJSq
	 8TbKhKB/x5ut9gDA1dPk00AgJQViL6Blyr74+gZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2037/2214] RDMA/core: Reject LAG selection when source MAC lookup fails
Date: Wed, 18 Nov 2026 16:01:53 +0100
Message-ID: <20261118150132.227253117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit fdfd099222d9de9e2f1b8d69e94494c5489272cc ]

GID deletion can clear the source device association after LAG lookup
retains the bonding master. Ignoring the resulting L2 lookup failure
copies uninitialized source MAC bytes into the synthetic hash packet.

Read the source MAC before allocating the packet and propagate lookup
errors to the caller, so failed lookups cannot influence slave selection.

Fixes: bd3920eac133 ("RDMA/core: Add LAG functionality")
Link: https://patch.msgid.link/20261015-ib-core-fixes-v1-3-60f6da3ddec3@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index c18642accfce5..9f2e5431757f9 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -19,6 +19,11 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 	u8 smac[ETH_ALEN];
 	bool is_ipv4;
 	int hdr_len;
+	int ret;
+
+	ret = rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr, NULL, smac);
+	if (ret)
+		return ERR_PTR(ret);
 
 	is_ipv4 = ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw);
 	hdr_len = ETH_HLEN + sizeof(struct udphdr) + LL_RESERVED_SPACE(netdev);
@@ -26,7 +31,7 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 
 	skb = alloc_skb(hdr_len, flags);
 	if (!skb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	skb->dev = netdev;
 	skb_reserve(skb, hdr_len);
@@ -70,7 +75,6 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
 	skb->protocol = eth->h_proto = htons(is_ipv4 ? ETH_P_IP : ETH_P_IPV6);
-	rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr, NULL, smac);
 	memcpy(eth->h_source, smac, ETH_ALEN);
 	memcpy(eth->h_dest, ah_attr->roce.dmac, ETH_ALEN);
 
@@ -86,8 +90,8 @@ static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
 	struct sk_buff *skb;
 
 	skb = rdma_build_skb(master, ah_attr, flags);
-	if (!skb)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(skb))
+		return ERR_CAST(skb);
 
 	rcu_read_lock();
 	slave = netdev_get_xmit_slave(master, skb,
-- 
2.53.0



