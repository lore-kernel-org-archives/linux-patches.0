Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017083;
	b=O9o4C4/2mcYQjZB8qwpkTtFQXh0DtwhP3B63hOTblMLwRVVcssiSvnGd8h883Nj/cFiG
	 JNLYpriovoVjhGsX9i0TlhbPXq1mbL1w7Ir4exdoeE8UZJl9mPAm0FoPhQlHa0AQBIo2y
	 MMBZIA+7jbYQS1rNAnnGVkeMMAMpqdhyT3e41NkI4sMN9Ai3zXrn3LSDyijujspSbODNh
	 RQahJSuScLZnu7dYlHDpMCP/S1FdGsy7AOMCQgqR+X1r87me6un6vrfMvhPX6+SC5fg/0
	 2OiX09XNcNaxwqJDEkFyxuBpVEV+77B+r+uKOBC7TLiMhkeCx2Y64JJB0d+kC64rWRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=44ioZUX5pPqlYY2PexMaeWRI3qMyiMKwnoriFx8sdqI=;
	b=SfD5qrqO8qz7jD4zlgl5nawyLELl4Ht3h5yDYb56K3zGy6vTqIBECA4vUmRIIseBW0qH
	 FTHd4eJYhe+6ruT5Pa0dYwj4JwklSSohi9mJ8tCnnOOdEvtaRM00KXap7WowP1JFhmxJQ
	 s1nUBnIWbJTU6Xm7b1MB3qzt0Qiv9l5dXfOzPJcHJ2GSm5JGJUp64zACSRDN/+5ZGsON5
	 sdvzPGUTWiZ4RpvY3o4bE6MuR2jtmUw8J+tXPqeEUVLNPMW7MyMxZKhZfk/+EMV0gWmxC
	 JsvV0xYyOhPzlmyk/P56ChOww94ZD3EwfLKmVytgrKEzqDHeix01u0f9OOicY5bSVIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lWY/DOis";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C402606A330;
	Wed, 18 Nov 2026 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWY/DOis
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3F71F000C7;
	Wed, 18 Nov 2026 15:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017083;
	bh=44ioZUX5pPqlYY2PexMaeWRI3qMyiMKwnoriFx8sdqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWY/DOis4q0ElxEPcY6gjREaQLf/F2qCDjik99nSS0Kr0tjJv1wFWh3d00MABQDve
	 ncQW1+vRgv80d3UhM+hHdfTev9UlmW7u9qdq4V8YC8ir1Ri8s/hp9AWe5wVhUvN0LK
	 hzovbEgb3YCQSGAs5UeqSbm1p7ZJwKSJZ3lSYHvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0758/2651] bpf: Keep target extended until its last freplace link detaches
Date: Wed, 18 Nov 2026 15:33:18 +0100
Message-ID: <20261118150315.168240166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit c43c348a84460b003fa757dd43d8c89848ae220d ]

The is_extended / prog_array_member_cnt protocol introduced by commit
d6083f040d5d ("bpf: Prevent tailcall infinite loop caused by freplace")
keeps a prog extended by a freplace program out of prog_array maps, and
vice versa: once a tail call re-enters an extended subprogram, its
tail_call_cnt resets on every execution and the loop never terminates.

But is_extended is a plain boolean, while one target prog can carry
several freplace links at the same time, one on its entry and one on a
global subprogram.  __bpf_trampoline_unlink_prog() cleared is_extended
whenever *any* freplace link detached, so detaching one of two links
re-armed the unbounded loop through the remaining one.

Replace the is_extended boolean with a count of the freplace links
attached to each target prog, so the target stays extended until its
last link detaches.  Also rename bpf_freplace_check_tgt_prog() to
bpf_freplace_link_tgt_prog(), as the helper has never been a pure
check: it reserves the target prog on success.

Fixes: d6083f040d5d ("bpf: Prevent tailcall infinite loop caused by freplace")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20260924023737.1140521-2-chenyuan_fl@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     | 4 ++--
 kernel/bpf/arraymap.c   | 2 +-
 kernel/bpf/trampoline.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5ca24186c6503..d71cbd920a036 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1812,7 +1812,6 @@ struct bpf_prog_aux {
 	bool xdp_has_frags;
 	bool exception_cb;
 	bool exception_boundary;
-	bool is_extended; /* true if extended by freplace program */
 	bool jits_use_priv_stack;
 	bool priv_stack_requested;
 	bool changes_pkt_data;
@@ -1824,7 +1823,7 @@ struct bpf_prog_aux {
 		u8 verdict;
 	} sig;
 	u64 prog_array_member_cnt; /* counts how many times as member of prog_array */
-	struct mutex ext_mutex; /* mutex for is_extended and prog_array_member_cnt */
+	struct mutex ext_mutex; /* mutex for freplace_link_cnt and prog_array_member_cnt */
 	struct bpf_arena *arena;
 	void (*recursion_detected)(struct bpf_prog *prog); /* callback if recursion is detected */
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
@@ -1856,6 +1855,7 @@ struct bpf_prog_aux {
 	char name[BPF_OBJ_NAME_LEN];
 	u64 (*bpf_exception_cb)(u64 cookie, u64 sp, u64 bp, u64, u64);
 	u16 stack_arg_sp_adjust;
+	u16 freplace_link_cnt; /* counts freplace links extending this prog */
 #ifdef CONFIG_SECURITY
 	void *security;
 #endif
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 0ce26b538075e..0fe9afd4a591e 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1035,7 +1035,7 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 	}
 
 	mutex_lock(&prog->aux->ext_mutex);
-	is_extended = prog->aux->is_extended;
+	is_extended = prog->aux->freplace_link_cnt > 0;
 	if (!is_extended)
 		prog->aux->prog_array_member_cnt++;
 	mutex_unlock(&prog->aux->ext_mutex);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index bf4cb3dd444d6..d880ad6913b38 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -859,7 +859,7 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-static int bpf_freplace_check_tgt_prog(struct bpf_prog *tgt_prog)
+static int bpf_freplace_link_tgt_prog(struct bpf_prog *tgt_prog)
 {
 	struct bpf_prog_aux *aux = tgt_prog->aux;
 
@@ -873,7 +873,7 @@ static int bpf_freplace_check_tgt_prog(struct bpf_prog *tgt_prog)
 		 */
 		return -EBUSY;
 
-	aux->is_extended = true;
+	aux->freplace_link_cnt++;
 	return 0;
 }
 
@@ -1023,7 +1023,7 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_node *node,
 		/* Cannot attach extension if fentry/fexit are in use. */
 		if (cnt)
 			return -EBUSY;
-		err = bpf_freplace_check_tgt_prog(tgt_prog);
+		err = bpf_freplace_link_tgt_prog(tgt_prog);
 		if (err)
 			return err;
 		tr->extension_prog = node->link->prog;
@@ -1069,7 +1069,7 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_node *node,
 					 tr->extension_prog->bpf_func, NULL);
 		tr->extension_prog = NULL;
 		guard(mutex)(&tgt_prog->aux->ext_mutex);
-		tgt_prog->aux->is_extended = false;
+		tgt_prog->aux->freplace_link_cnt--;
 		return err;
 	}
 	bpf_trampoline_remove_prog(tr, node);
-- 
2.53.0



