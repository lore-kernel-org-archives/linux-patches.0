Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705116;
	b=UHwCDmKLVZwvLsr6FN44SWiSjC2LLyZRbdlzxvt+708DJuCF6lKrBDjNTzqzXMA+5342
	 PAeZPJml+92O67RjMSXn3qBfcAWxEDnbcqLyz+xd3uyxjHMPpp5l3Mxu2PEsvYBXqzGVK
	 aFzSZ4y9PxV3Ij3vCr+XE0y4U92wYYffOPBFWz4dQ+Y8gGhRfPO+jwK9jX5Bp57kEVZPd
	 ZTFoovxBmeWA7EGqHvbE3knPNsuNUmM14vVVIRvRmUkAEYYnsmjpL8C3fMcLqEYaxCoS5
	 SwdfZvihofJ9in1UTonSSJUuErDOiNlRTEq0wivnMNao9IK8gJm2UNPiFMFbAD0oQGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/Nldy/whbKo82JDZs+sbJACu9yAiRQ1XZ/u1Oarz9A=;
	b=Y2/qtxfmh2hAhT4daJQC8JUraMWLbWCAEXr0IXZqHbbB17Cd01NcgAEiVMdMkHtGTUDz
	 mJBRESIag6Mqq+hxJwmyBgnRnKtmkqo0q+9uU6sZrfqwJe/5Qy3tDxej1gvtOHhPXfhcX
	 qx0YUZWFo7NNpnFU4U82f+c3FryWahBp9IwCCvsPlG1Mmuhj9coyCYyzZGDPqvUroWEQL
	 0RzVgs4v3pVT7+QTypxnvru0JggU5r/YhXK3Odwp0ygCnq8r9sXRk1b/VLRUHqV1I6hGe
	 xJHhSlSEQYxAZ5hBo3/EX2UNxrDEs0bS6X4ptUTuhQ/4U3/lX6Xx+yaktbrf5RsuFGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuoyoaWx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91CB606A332;
	Thu, 26 Nov 2026 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuoyoaWx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5163E1F000D1;
	Thu, 26 Nov 2026 14:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705115;
	bh=Q/Nldy/whbKo82JDZs+sbJACu9yAiRQ1XZ/u1Oarz9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuoyoaWxDCnUwp7hA6l01a4Qd0dzkqG/bmTbj30Tnove4BCiH3YA4n5sXgL9Mbuvr
	 b5/1OAqwkeUQ2yPpdsE0KMkrdWYBSdcNWjtPr7ljPsybpSgb/yc06nHFBw2RS1voV3
	 EbOd9aAT5owCQCLgMYMXXpW68Mb0ZYNHpk5HsGDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@gmail.com>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/319] net: ipv6: use the new fib6_nh_release_dsts helper in fib6_nh_release
Date: Thu, 26 Nov 2026 15:37:37 +0100
Message-ID: <20261126144008.753261539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 6130805066659cda3d685fc4c8d912c72a005ef5 ]

We can remove a bit of code duplication by reusing the new
fib6_nh_release_dsts helper in fib6_nh_release. Their only difference is
that fib6_nh_release's version doesn't use atomic operation to swap the
pointers because it assumes the fib6_nh is no longer visible, while
fib6_nh_release_dsts can be used anywhere.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9401b428b5d4 ("ipv6: Flush exception route while replacing nexthop.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 521ee189235dd..63f74b1f6d4ad 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3666,24 +3666,8 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 
 	rcu_read_unlock();
 
-	if (fib6_nh->rt6i_pcpu) {
-		int cpu;
-
-		for_each_possible_cpu(cpu) {
-			struct rt6_info **ppcpu_rt;
-			struct rt6_info *pcpu_rt;
-
-			ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
-			pcpu_rt = *ppcpu_rt;
-			if (pcpu_rt) {
-				dst_dev_put(&pcpu_rt->dst);
-				dst_release(&pcpu_rt->dst);
-				*ppcpu_rt = NULL;
-			}
-		}
-
-		free_percpu(fib6_nh->rt6i_pcpu);
-	}
+	fib6_nh_release_dsts(fib6_nh);
+	free_percpu(fib6_nh->rt6i_pcpu);
 
 	fib_nh_common_release(&fib6_nh->nh_common);
 }
-- 
2.53.0



