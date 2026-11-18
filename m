Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029525;
	b=r07GnjWfyuFseq6QAACfSahvQf+dEmiqEXg5UKKfNpnRS2A2gxQywX29VKqwT0lsaEFC
	 QNpD9GB29yjpPmUHw3nt/0Q8r5K3o3So/4suvJ5Li1d3L88q8NEd2BACUXJZ5/p5MD1ay
	 obJytJnF0Ip7b/vSbLDoZlpo5CeLahtVMijrsUEn7i0hpJYwSNSEMi3Liu37H88UIn5h8
	 lJyN4qi90oIach33wJQteL4fMwEO1N62JTY1e1x6+Bb1KpHSkgIwh8z9FnNcNvxbDyjfi
	 8XvyLuPoMnsXiiqV8y4jNWzSBJPSfh5qPLzyU4jLyLuYKtEMSZci8wfjrG0CpJbnYWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z2UP3xMJhWTFDlnp/PInYNcYRa5TAXTplkQJr9RM2CM=;
	b=jsaPb1oKdfG3UC47m1SqCUoCLM7SQzzXFYnAJFVAZrr4UbYN84njn0xrB2lqbQg6Otpt
	 rh7r7Hgf1HzkIgOesQUnYO0LKga9kqlesXwJeKSiosI703FzSS8/Y9V0aZ6IHff13zhUI
	 LgXhto5M/k84wNwAK+DljL3vnI1uw7/Xy8xPy5PxK8VueE/TlkiXMHktpKlrlS0y3HGsv
	 THCI4Q/jecKNu4I9OiCUFZvPtTLXfMSOAJyBv9Sf7ON2Xz6YkzzbYFEuPnmt40jq29IOR
	 eRrl9Hb0oWllR7/KDDakpwvHXe4j1607XiK8Gr95O3smIaBmqxNOfmemb8cXtChsADw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ix9WXxLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1850606A320;
	Wed, 18 Nov 2026 19:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ix9WXxLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D4D1F000C4;
	Wed, 18 Nov 2026 19:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029525;
	bh=Z2UP3xMJhWTFDlnp/PInYNcYRa5TAXTplkQJr9RM2CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ix9WXxLziUy1dB6/8ZYh6REcRqHnihgGfMPCRUFFRe3UPAUF3YRjt0Az1O8GwBz5D
	 z2CZ7Qa7pThZgzahH/M6se3MxzAkgH5fa5cDauS42FMSIcvIl8xn9/+JcLg++Js3kw
	 TTpiD6Pbyqi9goL7M4dE/36wXFYyNmf/IX33T9kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0374/1756] bpf: Fix program BTF use-after-free in sleepable programs
Date: Wed, 18 Nov 2026 15:41:41 +0100
Message-ID: <20261118150023.365337365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 88c9c6d0a766dd146545990053e8a04422ccb367 ]

Object kfunc calls embed metadata owned by the program BTF. A sleepable
program can remain active under Tasks Trace RCU after its last reference is
dropped, while program teardown releases the BTF through ordinary RCU. The
invocation can then dereference freed metadata in bpf_obj_new().

Move btf_put() into __bpf_prog_put_rcu(), the callback that frees the
program. When teardown is deferred, that callback runs after the program's
own grace period (Tasks Trace RCU for sleepable programs and ordinary RCU
otherwise), so the BTF outlives every active invocation. The non-deferred
path invokes the callback synchronously, so load-error cleanup stays direct.

Fixes: 958cf2e273f0 ("bpf: Introduce bpf_obj_new")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260901014829.3504342-2-sanghyun.park.cnu@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 854cc29b47c8f..9ebb51a32ff36 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2194,6 +2194,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 {
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
+	btf_put(aux->btf);
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
 	free_uid(aux->user);
@@ -2204,7 +2205,6 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
 	bpf_prog_kallsyms_del_all(prog);
-	btf_put(prog->aux->btf);
 	module_put(prog->aux->mod);
 	kvfree(prog->aux->jited_linfo);
 	kvfree(prog->aux->linfo);
-- 
2.53.0



