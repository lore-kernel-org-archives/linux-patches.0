Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061880;
	b=RuIaorq5s0/ZAuzbTJbGmryHq1xc7OzLwzA+g+X3DJfiGLHE87gRlKZT9EQc2CN7xXDt
	 8HQeNNSJYbbwFVpWVOXl61ZX70T5Y/0NNOQB1YjEpy9sI5OHohiuHMA+W+Sz4Xh0j2Jyp
	 mgLP8v+MhHXoK+9ce/MWb7ZbfTYJV0aOstmr0Pk9I/o7CZQl8MnvISD0+JKnRmIs5qn+B
	 enPk4kqFTRiWw/IgUMzNdUHMtnxMi7qcyWStaugDwWny/sz+/dI7Vu0Pv+CW882HPJu/j
	 f7LH/BkX5vr6HcSPFLQQU4Ja276m0LTiUSZmLX+a+nHA9N2UGqIP5BZX0pcnTw+0TBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ad6jKB0ZYhMLF8TERyJB6xJz+DB0ceGW4VxvBh4c3w4=;
	b=SF/kn83naCnUxTDbfZH0aFMRni9z5cplf6IW0Vmuyb/2hAck+u44Y+0msjFLHV4tATVm
	 rUNWj7tSHiEGFb2KhzHHr6VbQkwRlruSqBrDK8xmaMzde5n8VDb0ExVdL2ahaA2B1laC3
	 acqClOsQ75vAxvNyp/TEm7INi3XIfoPPSXSQQT73nlKinrjqXm8iycsYStLvP+BgFr0fT
	 9xo9JmG9TR9eUNIgJ4N5/noTUNGL10Hb/41o5oALUTdKiusEfrBPFvinIG5Pa8Dt4xU4T
	 iPTW/xDo5w6eN600AdKJg8cBhnFGjSfTq4HWNQaiQuXBzUc9m82QSY0OMGF61JWbVNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z0/fHOOg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8050606A325;
	Thu, 19 Nov 2026 04:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0/fHOOg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318A91F000C4;
	Thu, 19 Nov 2026 04:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061880;
	bh=Ad6jKB0ZYhMLF8TERyJB6xJz+DB0ceGW4VxvBh4c3w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0/fHOOgHN5/vLb9zKmcAszJH4rq/KQ5RorJkPsWC2FZRzfS93ENdvWZcUqBuruf3
	 R37b3YoHPGAyZWMS8CwbphAQqDYkRi1aoqLnl+Fo+S95vnB7W/tHIATFHuafZBDjWI
	 okGUmRsMrN4QYT+4or5ZIrER0fS5hlBFZ5aAtp6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1711/1848] RDMA/core: Remove device argument from rdma_build_skb()
Date: Wed, 18 Nov 2026 16:02:29 +0100
Message-ID: <20261118150031.324379077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 05195dcb43504e381bf383e837fc935aac4258cc ]

'device' argument is never used since rdma_build_skb()
is introduced, so remove it.

Link: https://lore.kernel.org/r/20220826143215.18111-1-linyunsheng@huawei.com
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: fdfd099222d9 ("RDMA/core: Reject LAG selection when source MAC lookup fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index fc1dd6b5bf5ef..c18642accfce5 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -7,8 +7,7 @@
 #include <rdma/ib_cache.h>
 #include <rdma/lag.h>
 
-static struct sk_buff *rdma_build_skb(struct ib_device *device,
-				      struct net_device *netdev,
+static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 				      struct rdma_ah_attr *ah_attr,
 				      gfp_t flags)
 {
@@ -86,7 +85,7 @@ static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
 	struct net_device *slave;
 	struct sk_buff *skb;
 
-	skb = rdma_build_skb(device, master, ah_attr, flags);
+	skb = rdma_build_skb(master, ah_attr, flags);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.53.0



