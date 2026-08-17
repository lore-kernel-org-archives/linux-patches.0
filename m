Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0259A3C3C08;
	Mon, 17 Aug 2026 13:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974808; cv=none; b=e9H8j3Ja409DdkYNNg3JXtLKfbc0TfE3hSNM6YIfiud+8xK85GefbpRtVPk4BzMhbPFwc1ipRTf4fQjgCZQ8QEf722XKfkXBRo2D5zNMBjRv3w0xq7+PdwyTNDbcbQmUfRbdFiW8OJ1vctwv8BC/q4ogoINVeyC1Kw/HxDbRK+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974808; c=relaxed/simple;
	bh=UlmI66MzkrgdhkEDjwAIArKjjy+gUJO+8pIKhpRtg/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSIwt3WmSZAy6wyfiFd5dnJvpAOaPNZKizHf3e3Cg0oYYkimjDTzEWmbz0SX20IMjbRsuBkT6fSx7bg7RhJuvEEuSEYc/8bm+drOe+a/lfVKkMxmmCANlr8Ia5Oe77SnxTPbDx+bAo5VdqozxQP7AIEoY6P9i5AOgFHAYuqTDV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5q4EEGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5q4EEGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFC51F00A3D;
	Mon, 17 Aug 2026 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974804;
	bh=1mm0btalo7SYSS7Vrt7W0q1pQaBfXuckevc+E2IPsQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5q4EEGkh8a8V62iUkhcpDapJZbMhpzpn+uLUNWKexCgH7hQ+UwkKSvHbf9XWFGwg
	 klQPwtQwR4X2lw5jmJ5aSyQpnszMh8CyOEED4dll0FRTNtLpjoFQDzkbcnHsfB8oFq
	 MvfYlnSeC2y5fa6dZKwepSq4NCAjpH3VpFPemqLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/250] net: reduce indent of struct netdev_queue_mgmt_ops members
Date: Mon, 17 Aug 2026 15:30:20 +0200
Message-ID: <20260817132538.853005315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 92d76cf96dcbc3c58daa84dbbf71a3ca8d9de53d ]

Trivial change, reduce the indent. I think the original is copied
from real NDOs. It's unnecessarily deep, makes passing struct args
problematic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Stable-dep-of: d1000fd7995e ("bnxt: fix memory leak in bnxt_queue_mem_alloc error cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netdev_queues.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index cd00e0406cf46..541e7d9853b1b 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -135,20 +135,20 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * be called for an interface which is open.
  */
 struct netdev_queue_mgmt_ops {
-	size_t			ndo_queue_mem_size;
-	int			(*ndo_queue_mem_alloc)(struct net_device *dev,
-						       void *per_queue_mem,
-						       int idx);
-	void			(*ndo_queue_mem_free)(struct net_device *dev,
-						      void *per_queue_mem);
-	int			(*ndo_queue_start)(struct net_device *dev,
-						   void *per_queue_mem,
-						   int idx);
-	int			(*ndo_queue_stop)(struct net_device *dev,
-						  void *per_queue_mem,
-						  int idx);
-	struct device *		(*ndo_queue_get_dma_dev)(struct net_device *dev,
-							 int idx);
+	size_t	ndo_queue_mem_size;
+	int	(*ndo_queue_mem_alloc)(struct net_device *dev,
+				       void *per_queue_mem,
+				       int idx);
+	void	(*ndo_queue_mem_free)(struct net_device *dev,
+				      void *per_queue_mem);
+	int	(*ndo_queue_start)(struct net_device *dev,
+				   void *per_queue_mem,
+				   int idx);
+	int	(*ndo_queue_stop)(struct net_device *dev,
+				  void *per_queue_mem,
+				  int idx);
+	struct device *	(*ndo_queue_get_dma_dev)(struct net_device *dev,
+						 int idx);
 };
 
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, int idx);
-- 
2.53.0



