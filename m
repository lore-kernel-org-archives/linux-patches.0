Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049425;
	b=K8w6mJPJFyS6eRRbA4lk516bMnZoNYZzpTt+HoNUGNJQETa0wuo3tgwgUcEFxK9Ef9Gu
	 +28dcxBFyTn0de7iEUqoV5irivrkZqLSkI7vx3br/IirAqyQ/7VxjQrktyagiYD3qsu9j
	 jFEjsJBb+a8NlQMhWlAdeYft0uBL3KK3k4c1WibHCx16kMxma7zN/Kn8P2pA6uf2jXEmE
	 Aw6RuzsKiI9yl5pmD2KfyPIU95J2EgyasPPp5K0r1AY+rpjzvhxtbuToYucBI9SO26QiK
	 1SFFc1H58dRGA7m7Ewwe8o/fgVphrrl2dg0FyecKB47KBIofbIQBFc845QXbcpmPosA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4Oh40WJQbqrCGdqlQ4FV7Lw/Qu0EdrtYrS4CemYDrA=;
	b=Q58qfJr8cZAJxJu82UuuUASuXVW/7u+tua2gll+oAfXUb2vQkZmo7/elmRxDsVJQ9eca
	 gR47VYNIeLsho2L7mpVRDSEBcs5OMHLjnyUtvguGHgmXkIBDqtoehHP32I0KklgqDP4E3
	 YfnfnJULG6Ir2bZpdEu6EDM/SM+m1Gsk7nVsgFPvvlc7dRUj8kVRhP/cstyR+4MZTw+Zc
	 hI6UECx2v8cPd5x44qv6IS25/1kCfemlahX0S9Z3Nw9ShK2AkdyYXTP5AKjaf7QF5oO3l
	 HRcTK2SDtB5+LUtrp2fj/woNx+4JLutNmp70OdJqPfIQMzhIHv1xLkLVnryVCCpA1sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCyFnD6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A94606A32F;
	Thu, 19 Nov 2026 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCyFnD6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6B51F000C7;
	Thu, 19 Nov 2026 00:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049425;
	bh=s4Oh40WJQbqrCGdqlQ4FV7Lw/Qu0EdrtYrS4CemYDrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCyFnD6cNeGaA8BvoRCYFAkaogqwgrG5tSw9orN9InbB26WEUTGRQop14ehLrDceM
	 Uvk5URv3EGIVOvrcUCNmjFg10kTgdufUAQUrKn81w/NpbA1oi4SNWBAaQnu5O8JZnK
	 3I7IeZUiP7gIlwNVanlK9ouktjygv343KZ7cLI8E=
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
Subject: [PATCH 6.1 2346/2857] net: rtnl: introduce rcu_replace_pointer_rtnl
Date: Wed, 18 Nov 2026 15:56:20 +0100
Message-ID: <20261118150325.997753389@linuxfoundation.org>
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
index a01bd720e7cdd..a872a4240907d 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -88,6 +88,18 @@ static inline bool lockdep_rtnl_is_held(void)
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



