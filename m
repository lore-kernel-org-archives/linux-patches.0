Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052957;
	b=xu0fgCDdBLdW3aGKjU+M29bYnToIgwiJA+xrFnO+EO4VZ+pyLdTXG5KcdmxpRffacphq
	 aOc6dpQpQKwicvzFJTSAlhJXJ1Xu7OuAXezArQJ2BTNXNaa5GlFaeTGxu2xkv7GScNdvt
	 3sC73t3Gnj7zi8bnTTK4X16qfXi4bPY5dRF/ffmNHvsdj5sLAbcrI/VXkRIGMtGNlOorE
	 aBOma+Kz1hAJYe9ICpeVxcHv9a42R0/ja5ylGv2aK7YXoT8C9LGm1ZS5f2ixgEGLfxiQH
	 /q/IBsOF+4hxdFbfAi1MMTSVmm5jDG+wjaCQbXHbKy/n6+3XB155jYo8TnKnDFuR6dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K9BhkjgJMYU/xc5DR/UI9Nuvbz7weEhVK+vYbj3ujyk=;
	b=X6kpEg2Qm3rBMBf0gow2GE+V3mhMeFSTmzhb42x39evm4jgyiav7bFvt1KL2v7w62Jkv
	 nlqnCIXCxNYfCCwRSWmTROf3t3oLl8fLAPFVaNrb+PT8zPQh4rRBXT7XnjP9Vxjqzi1Qj
	 rkji8SRSxoREgMpvuEN8uKUGqvnxePAqkGXNF9a8MwG1gJX7O6jPz6/d3DduBqlTKufwu
	 MFxFxBe23ff0qAup0co6PxW7Njl9W2JzXkU8kNfbVyeO/535WCaRDwDK5pBrE5NirP8Di
	 99u7icO9xalSYLgE/u/+sMGt3NcPPxOyn6rlru4NRu//R4fetLNMlSdSMz2/VzZPvAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3vid4sB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA29606A31C;
	Thu, 19 Nov 2026 01:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3vid4sB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516E91F000C4;
	Thu, 19 Nov 2026 01:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052956;
	bh=K9BhkjgJMYU/xc5DR/UI9Nuvbz7weEhVK+vYbj3ujyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3vid4sBEtcGCsHJjqWkfiwPm0q+xG5EyxmJnFlMUVx6Un51FYk5zf446oyhN/rVO
	 eMbukTN8aRNzpqX0WhtJAYfBFEhnGoKylBSJ55KGuegYrhSKViqfCsRFoU7qbrMuDo
	 /qnpfdPE8zOjBK9c0Ema2ZVp8l7ZU3aVbPrTkbxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0749/2214] tcp: check congestion control restriction first
Date: Wed, 18 Nov 2026 15:40:25 +0100
Message-ID: <20261118150041.744241100@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit dda51b73721684637ab8e9bd97c78228b99c4bd2 ]

tcp_set_default_congestion_control() takes a reference to an algorithm
before checking whether a non-init network namespace may select it. A
rejected request returns -EPERM without dropping the reference.

This affects module-backed algorithms too; BPF is not required. For
example, after root loads tcp_bbr, a user with CAP_NET_ADMIN in a
non-init network namespace can repeatedly request it as the default
although it is not in tcp_allowed_congestion_control. Each rejected
write leaks a module reference. Since module->refcnt is an atomic_t,
2^31 such writes can make it negative; later module_put() calls warn,
and rmmod can hit the BUG_ON() in try_release_module_ref().

Check the namespace restriction before acquiring the reference, as
tcp_set_congestion_control() already does.

Fixes: 8d432592f30f ("net: Only allow init netns to set default tcp cong to a restricted algo")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/71c142b2d45af6a2fe7fc6cd4a5ca52c53afbe23.1793075984.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cong.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index f43db30a7195d..19e8b4a29202c 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -228,12 +228,12 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 	ca = tcp_ca_find_autoload(net, name);
 	if (!ca) {
 		ret = -ENOENT;
-	} else if (!bpf_try_module_get(ca, ca->owner)) {
-		ret = -EBUSY;
 	} else if (!net_eq(net, &init_net) &&
 			!(ca->flags & TCP_CONG_NON_RESTRICTED)) {
 		/* Only init netns can set default to a restricted algorithm */
 		ret = -EPERM;
+	} else if (!bpf_try_module_get(ca, ca->owner)) {
+		ret = -EBUSY;
 	} else {
 		prev = xchg(&net->ipv4.tcp_congestion_control, ca);
 		if (prev)
-- 
2.53.0



