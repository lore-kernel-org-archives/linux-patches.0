Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214793;
	b=5KB4zMD+F+tPO2avgx+806dF0MRUv1KpUreolnPzP8LNGEHew4/p9kzIYbquNql3dp8a
	 BvqP8oNjJAuTNFVKTztsBRxmlLOfC7DZmPq9Vu/jmJ8YvlirmfD5SGrg01DHsjCAXt7qs
	 Kzc80OiiMrpw+Oy3ElSMTUOJyu5vi9ElI5mittZqI8Z5tOITDismaRWQtVCweHmEo7kBZ
	 5Uw6MavfQE8qPNzHAMV8JT3AsQuu8y1EfR1tYkkrBj4v0F2gCwWN/viG0LSu+fKpl+pTU
	 NE2pbYpcg0eXPAOI6SoHxNpSuTaRMZLH0fHWUV1pSTlEvE5EWefOlFyfbjSYKegpOjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKp2zs5iQglS37TlXcjms0bE4fabdkCXai7xwDqDps8=;
	b=jWpc/R+XyUlRQs4SN8/kaIY2Nzzgk7PomWeohhxOixhW+Q9HGvcCkhz80ec2d7DUWGci
	 yQIqk5r7xyCQYYI0fnI/ORG5UY1+IZyywrrUfvxZBFif91s+ggu8U3EW9aW0gHFs3RP6/
	 DCulrPSNaw86+10d36+Tr4oDwobdl3BvJ4WdevHgcDvzx31kUvEANdA3d/W0wfGq4dEfj
	 0gx4bzTFegVxr99O9yQyz9D1DpfMUtvEiZaqG17c1qamXYXh2jXrdT4FOZKlqRxknGGvv
	 1gtAOmSVjUULoNWhl1oLOd1aoLXiP5yfQUP4KWzAHhHw+UyOlfVmTHIWkJ8zVceQrzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsB7uiRm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDA9606A32F;
	Wed, 28 Oct 2026 19:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsB7uiRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38BA1F01825;
	Wed, 28 Oct 2026 19:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214793;
	bh=jKp2zs5iQglS37TlXcjms0bE4fabdkCXai7xwDqDps8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsB7uiRmA34aL6mzLumNSzsBAA27ynL4dahsxzPC6z1gUTnQI34GAg+j7IZfM9cES
	 9uV+4Mdk4OPfayA9rB2gN2oVTpVrOUiBy5zrY+odZ8NdhXmlbYMOtibGrRj6tjl97H
	 giIvBOLNt2x54Yp2k1Z+7EacaWCxeJ880+A2RqJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0983/1887] xfrm: account XFRMA_IF_ID in aevent size calculation
Date: Wed, 28 Oct 2026 17:51:19 +0100
Message-ID: <20261028170521.780011401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Keenan Dong <keenanat2000@gmail.com>

[ Upstream commit 7081d46d32312f1a31f0e0e99c6835a394037599 ]

xfrm_get_ae() allocates the reply skb with xfrm_aevent_msgsize(), then
build_aevent() appends attributes including XFRMA_IF_ID when x->if_id is
set.

xfrm_aevent_msgsize() does not include space for XFRMA_IF_ID. For states
with if_id, build_aevent() can fail with -EMSGSIZE and hit BUG_ON(err < 0)
in xfrm_get_ae(), turning a malformed netlink interaction into a kernel
panic.

Account XFRMA_IF_ID in the size calculation unconditionally and replace
the BUG_ON with normal error unwinding.

Fixes: 7e6526404ade ("xfrm: Add a new lookup key to match xfrm interfaces.")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6fb79def144c8..9041a9885854f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2366,7 +2366,8 @@ static inline unsigned int xfrm_aevent_msgsize(struct xfrm_state *x)
 	       + nla_total_size_64bit(sizeof(struct xfrm_lifetime_cur))
 	       + nla_total_size(sizeof(struct xfrm_mark))
 	       + nla_total_size(4) /* XFRM_AE_RTHR */
-	       + nla_total_size(4); /* XFRM_AE_ETHR */
+	       + nla_total_size(4) /* XFRM_AE_ETHR */
+	       + nla_total_size(sizeof(x->if_id)); /* XFRMA_IF_ID */
 }
 
 static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct km_event *c)
@@ -2467,7 +2468,12 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	c.portid = nlh->nlmsg_pid;
 
 	err = build_aevent(r_skb, x, &c);
-	BUG_ON(err < 0);
+	if (err < 0) {
+		spin_unlock_bh(&x->lock);
+		xfrm_state_put(x);
+		kfree_skb(r_skb);
+		return err;
+	}
 
 	err = nlmsg_unicast(xfrm_net_nlsk(net, skb), r_skb, NETLINK_CB(skb).portid);
 	spin_unlock_bh(&x->lock);
-- 
2.53.0



