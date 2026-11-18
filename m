Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062094;
	b=eSRF0cVFfFRBZ4KxBTNHVB3edje2Ehb6PZ29/F5aXZnhIOnMr+KWlK3fsgUt7sE1NSZQ
	 AZw1bXZjyG/uYmrNWmS4Pe4FlMhV6VHvNt8sv/T5UytljG7s7MiCuNIrpZwcGrwH1CiBP
	 WcdtbQJ6N/2Tyyq4eWADgVlIooLQmTCUiHWnPKu8GeJvSNgN0IYKBJWoh3rMWNFjrXkhT
	 s5t7kRpo+1DbMZbGAPVdV/2slwy1zq5divUjph5FG97XMdvgBbdQOtaC2PUjvaY8qQntc
	 CYQqyD4V2x8M/07tN2D9/qwBF+YxPpU58xxwIoJqjuMHNRD6ydm/+IcYSF3pkhesosQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SHGR1Mtnp3TTxsl23rdyr6WrMJ6Tkm6445b5oa6EPQY=;
	b=ox+i3CnXxJ9P/XzTIbvdWByb5KSP8TMXRqfXPi9UTFkcDxIU0KXZippVJ5ve2sR25Srk
	 j04gcdN9BHYvr3Q2dmPKjr9eHRvwWSnt3ZJ0vyR/raU8q5RDTQhFVOWlHhkqqo+FV8hL5
	 T+5+Xygf9O26G5vSJGXbUcWlxX6q4d+tZrdak/+rMOZ40Kbt/MdzZKxT6wxh8tpzCHbff
	 dmvRrL40yqF7F1jc3tu534HVMegSV3plGDV5PEsh5dFBmbYPSnVNCHuWGZtSuZ3tESzlu
	 WF738U577lRnA2kMIXPrXBz7KUu1SsGGEq4jtuaMULbM0RXDGHJ9TtD1Cr7gC5MVlOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxZZhzYK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2306D606A320;
	Thu, 19 Nov 2026 04:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxZZhzYK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DE91F000C4;
	Thu, 19 Nov 2026 04:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062094;
	bh=SHGR1Mtnp3TTxsl23rdyr6WrMJ6Tkm6445b5oa6EPQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxZZhzYKKCk7xWNp0IZULOmBpXAGGBI/wtqm+gaRZlTLk+Ci2takckVKq5Jiqt3u3
	 vb7M9XpBpOfL7Isqp/Hv5CJU7nUo+8eS9nCDgad1/yH0Z7eLmRv0XmLJPZPx3A6Dkj
	 44uYt3NkaZTOsKytu87WvogB+Eon0f2BQBvzI8YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Allison Henderson <allison.henderson@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1788/1848] rds:Simplify the allocation of slab caches
Date: Wed, 18 Nov 2026 16:03:46 +0100
Message-ID: <20261118150034.163216780@linuxfoundation.org>
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

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 9f1f70dd850038b37e8b103ef0cc6f5eaeb6a8fc ]

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ffbbc315b8b8 ("net/rds: do not initialize transports after rds_init() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c      | 4 +---
 net/rds/tcp_recv.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 1d3fc063465bf..4f5d2e8a90c34 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -775,9 +775,7 @@ static int __init rds_tcp_init(void)
 {
 	int ret;
 
-	rds_tcp_conn_slab = kmem_cache_create("rds_tcp_connection",
-					      sizeof(struct rds_tcp_connection),
-					      0, 0, NULL);
+	rds_tcp_conn_slab = KMEM_CACHE(rds_tcp_connection, 0);
 	if (!rds_tcp_conn_slab) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index 42c5ff1eda95f..2a62ad1df587e 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -335,9 +335,7 @@ void rds_tcp_data_ready(struct sock *sk)
 
 int rds_tcp_recv_init(void)
 {
-	rds_tcp_incoming_slab = kmem_cache_create("rds_tcp_incoming",
-					sizeof(struct rds_tcp_incoming),
-					0, 0, NULL);
+	rds_tcp_incoming_slab = KMEM_CACHE(rds_tcp_incoming, 0);
 	if (!rds_tcp_incoming_slab)
 		return -ENOMEM;
 	return 0;
-- 
2.53.0



