Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041286;
	b=f9tduvPv6oHbBgfAsbEyy4ziQ1DGP4HwXN3DhBmVk42CFSyKBjGn2dE1sSJJgnl4kK72
	 UywQiQi7RphAdMDuFK7ILGhDgUMovKeWEpu1MvymcxdnZC9wxGUDii3nmwa8BFGhkjm0p
	 PR3aqCJbOo/21ldvNKuNsN1ie9VqeP1WNQrg+6aOfffMUJKyuAiUipr2aJ2lV/gVUEAp5
	 ZpzajqNkpx5RXAtJD5ONSKnXWVKeDaQ1oCEwfVfNwvf8jzNcftfJLh0HdwMVXabLShIxz
	 fMU6oEyRRlgtDpH60QzlUKfnhYzFgY6F4UF+CqWgFZsNVuobwS1lQAXzWe5SddiAb/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hq9i0rb6Ff9Qak3ecIJnOOfWtHVIqhlVqLcVugPf4NE=;
	b=tA7P8HelMdEoXQjPnSd4Z2XwUbFjlVj5okE+5lzxssaKDw63LKZf6SrjXwhq12trchDP
	 QyZqECS+G/A520OMMCEsMwPSYEI+WWEQCvcNHlxZI55ivEowkxoBM3EwcP16RSX1y+qGA
	 2BagXHY8fmJYkkJFx967GXkdqH5sIeQB4oufA3zI83+cAgYNGbxFzCuhVLDimhmLliuHK
	 45WvYo7pPYHveFg1xyH/Zimbq4uiTtd2FDMd4/2W2j93yc0BfeAU3ez/GZih0tl+sDzcW
	 yW+iC7VYPodLHLVRB4+YFRFsuLNtKA1VgQ33WU98aYWLmWlYdO/D37/jx/k5uqJzstw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igbaflPI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BA0606A31C;
	Wed, 18 Nov 2026 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igbaflPI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8201B1F000C4;
	Wed, 18 Nov 2026 22:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041286;
	bh=hq9i0rb6Ff9Qak3ecIJnOOfWtHVIqhlVqLcVugPf4NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igbaflPIpkoOC3eQQfW7m+yCZ1EmnZT/rOsqdAThCoANeBo43JZXtuGjj8uXRB4be
	 HMGQxTDG8diSvxzFpfFC5q59vbzOcjZkjlNNcZ/Ma6RFPAwkVVOa3kLA9C8foMHfSE
	 J3fcabxJTvbQdn8DlLna4n+m3hPGps7skN64jpbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2718/3318] net: rtnl: introduce rcu_replace_pointer_rtnl
Date: Wed, 18 Nov 2026 15:55:40 +0100
Message-ID: <20261118150442.398711981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 32da0f00ddcb101730cf242289b2b10ede0e1156 ]

Introduce the rcu_replace_pointer_rtnl helper to lockdep check rtnl lock
rcu replacements, alongside the already existing helpers.

This is a quality of life helper so instead of using:
   rcu_replace_pointer(rp, p, lockdep_rtnl_is_held())
   .. or the open coded..
   rtnl_dereference() / rcu_assign_pointer()
   .. or the lazy check version ..
   rcu_replace_pointer(rp, p, 1)
Use:
   rcu_replace_pointer_rtnl(rp, p)

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 298618f28bd3 ("wifi: cfg80211: reg: protect regdb pointer with RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 6a8543b34e2c0..410529fca18b2 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -79,6 +79,18 @@ static inline bool lockdep_rtnl_is_held(void)
 #define rtnl_dereference(p)					\
 	rcu_dereference_protected(p, lockdep_rtnl_is_held())
 
+/**
+ * rcu_replace_pointer_rtnl - replace an RCU pointer under rtnl_lock, returning
+ * its old value
+ * @rp: RCU pointer, whose value is returned
+ * @p: regular pointer
+ *
+ * Perform a replacement under rtnl_lock, where @rp is an RCU-annotated
+ * pointer. The old value of @rp is returned, and @rp is set to @p
+ */
+#define rcu_replace_pointer_rtnl(rp, p)			\
+	rcu_replace_pointer(rp, p, lockdep_rtnl_is_held())
+
 static inline struct netdev_queue *dev_ingress_queue(struct net_device *dev)
 {
 	return rtnl_dereference(dev->ingress_queue);
-- 
2.53.0



