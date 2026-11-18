Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027263;
	b=AwNmyjYfnCPA7rU9IhXQzGecgIUYeVAhI3WrLMJtFHnkofYPShVhg+BgECi5py+caJGA
	 EahcSM0detd+kO7szfYGWLwvAD1UZH4nvTPVlItIbIIfwmInmublJHV0e1EOeQ3IZw5Vv
	 gqZxk3PZemz6QGX33lYSioqTa5TwJvPlmZg+VepuDEKfPKuPfIdeezoVKA9JKWIl4sNz0
	 z+ZxzlVK7DmIHCgNwFBug3w2vSazNQ5xeEdlRYQGfbWNxtHZwzlABLauhgQBzXyqpCXwW
	 SRkKBz/UUzAdBD72oVTjjSzh4iXRt/jDPbdmg+CSRRyP9nM3fEpU1YlQYeUHLmFKGVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0VRdaLVkXQPHVaB+3Cd0ie6YtG9r0BtQZP1H9/sI2U=;
	b=DEJzEfmC2xjopPrLOqGrvg3tBETCK9Lc+VcWkrz/76d2l9B1qfUfPhzrYyI/zgis/Pm/
	 nKo7pN7SrpfkD1fW+XS2KX5HT2Pv33ht3y7/hGsAkLssOlbR7hNXSOzW0vLHH/jG/aAZk
	 AbhxmCPh0focl0xh2KDLa0I7JC/7ScbHUw+SBpefJh+rmyNfyOzR7HEcrdpXfDSHlXpdS
	 TvFFI59qLFQYAlYTJbuv8BFaysNlwT+rMo449pEg5d1XvtCWqHbCMEKDi/n7EZ/k1fHGl
	 hNhP2P/8yyuOF9ziLDNNvYQnh1QWPvahm75vKqjAHSorW8QG4bEE7LBvGBQ1fUuol7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PshVPRyo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A37606A74C;
	Wed, 18 Nov 2026 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PshVPRyo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0981F000C4;
	Wed, 18 Nov 2026 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027262;
	bh=h0VRdaLVkXQPHVaB+3Cd0ie6YtG9r0BtQZP1H9/sI2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PshVPRyo+YPYBUCyCwBOmj3dzDOK6UgdnTRAG6lJT5XKd+GErJD+TArXp8cw/J3Vq
	 BKtXBJUg6dhsRrhgXe0VTmzwejdfQgsb71h7+U0qqILdZ3o88gmWWbktpFn1mRuqVK
	 TVdLw0p21aUHarPcJ68A5011k5JVJUAOJsojC9SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1726/2151] bpf: Clear sk_refcnt of a clone before its storage is linked
Date: Wed, 18 Nov 2026 15:57:41 +0100
Message-ID: <20261118150224.715137447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 22f100bd013458836c3d0eaf8050b854d7534a66 ]

sk_clone() sets sk_refcnt of the new socket some lines behind
bpf_sk_storage_clone(). But the elements which that function copies are
linked to their maps at once, and an element leads to its owner: the
iterator over a sk_storage map hands the owner to its program.
bpf_sk_storage_get() with BPF_SK_STORAGE_GET_F_CREATE and
bpf_sk_storage_delete() rely on refcount_inc_not_zero() to tell whether
they may touch the socket.

sk_refcnt is in the part of struct sock which sock_copy() leaves out, and
sk_prot_alloc() does not clear a clone unless init_on_alloc is on. It is
zero in an object which has been a socket before, and anything in one
which has not. If it is not zero, a helper gets a reference which
refcount_set() wipes out, and the helper's sock_put() then drops one of
the two references of the new socket, which is freed too early:

  IPv4: Attempt to release TCP socket in state 1
  BUG: KASAN: slab-use-after-free in __raw_spin_lock_init+0x47/0x90

In the meantime the helper changes a storage which bpf_sk_storage_clone()
fills without taking its lock.

Nothing else can find the clone at this point. Say that it is not alive
yet, before the first element is linked. Sockets whose parent has no
storage are left alone.

Fixes: a50a85e40c59 ("bpf: Expose bpf_sk_storage_* to iterator programs")
Suggested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-15-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index eac5b710efcf9..2696699608299 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -163,6 +163,13 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	if (!sk_storage || hlist_empty(&sk_storage->list))
 		goto out;
 
+	/*
+	 * The maps lead to newsk as soon as an element is linked, but
+	 * sk_clone() sets sk_refcnt only later.  Until then it holds whatever
+	 * the slab object held before: no reference can be had yet.
+	 */
+	refcount_set(&newsk->sk_refcnt, 0);
+
 	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
 		struct bpf_local_storage_elem *copy_selem;
 		struct bpf_local_storage_map *smap;
-- 
2.53.0



