Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704306;
	b=cHW+YkXN910zOsOdI8NLnlCIGdWTquD6PkJIwAcGmK4R/5w7UxZVSWGfpu+4N3wiWSPf
	 TOoA8xYv0+m5T6BJ2q1D9ilOMvC6/aWa+Dm78N55jhvbFsOfk3z4U7m8b0ifDhtaoB9gx
	 cq9EHRhSlXf0pE+bCGlub85nrWGd4cvcvPFqVT+asGsoNZ7Vh0cwCGjkZtDoIzb+HMsgx
	 vh/cDRLyhJDsqNMjcwrAP/DzpGjjE/xrwmuZqdgEKxZIU2MCZTpEXFwBEVtkKyU4lls96
	 CCgmjBi1Zd30U73JWwtmgjF5va8cs3cQ47qLr+QJa13ZD/W48DQdnt7jea8A+ndMUcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XScr8pWHbLIDh5NZ4DU9T7ntpLAtKMnTrG3gxD4OVSA=;
	b=0Pyawdsw/Frj0Ofihd7MXnRy5jzgoop9Sjk7Brx6vOjHKcIBLuEvEFhYmD6zM10CGoUv
	 yuZiKYihndLiN0kvjPbffgS7TMhwW/WBk39w9LfmfTkXuxTgkSDOkgBw7yqeh32nPtLLG
	 8Ie3f434CX7xrFpgTGbEoD84zPZb9gYUPHU+Vkrm3dRQy2kGaDxTfUC+uSCNU5mQ/zX+k
	 626zhoVcwKX+3rc4nI+t+xzLr9mOXPqccthaIOSPwDszYWJhCHz7PMkAVeoD4LBwk028W
	 AFxscGIqfqdWB1VHk2FfLuRipjj4Ftm7ZMkEP52HzcTQTv91gri+l6S7mm/HhH//TbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSREo2b1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F312606A323;
	Thu, 26 Nov 2026 14:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSREo2b1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB8A1F000C6;
	Thu, 26 Nov 2026 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704305;
	bh=XScr8pWHbLIDh5NZ4DU9T7ntpLAtKMnTrG3gxD4OVSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSREo2b1wg3o1HoG5N14TuQhfbrUoNCBX6q/p4lpq6f/wgg9tSOQMYysHfF5gFl3h
	 wZnUSosJgdzql1Bi+pTOQuY2LZ0ZrtWXPpOMvQyLDsmkrktn6oLKyfvxSwcoF5hABn
	 ebgPSkLLfMzhxM9n/TQaYhSMn9hnwnIKW1UXP6hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@gmail.com>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/265] net: ipv6: use the new fib6_nh_release_dsts helper in fib6_nh_release
Date: Thu, 26 Nov 2026 15:36:46 +0100
Message-ID: <20261126143610.374517736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index 98e670e425f25..a81f8fb43f852 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3555,24 +3555,8 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 
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



