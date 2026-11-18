Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016289;
	b=nmMa4p7+vH6u8ewdaSREiNPLGWGm9TYO3buxE11D0ArRYAJXrv0/FYpiXvGyVenWV8Tu
	 3uv//Kz56k7QSHcZhMpwTYeh+GNgnlIv5m484q2JRzrqoUboaRQOLv7yAQsMDVJ9Ognd8
	 U2yvRCvrHFaSCLqgf25JRduFrBtVOBnG8WKwCeXD3BspLdSi1UZ0hJEs49oPD9atD94NX
	 UCaYOfk/s4yr/0tJnqJgLbvpatwyOwOZvdhmBpGtNxcI8cxiVqOQ9nwWj/huThP4ez+Qg
	 mzVQCTVOX5zJ6TfjCrmX1urYsGmeDt8g3XkI8jw3n29JbzplmPyLOLNf6jj1zGIS/Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=veyJo8u3n8CojHq9F8R297ZNYpde3LbvziDX4Zqi33s=;
	b=FD/78iJOW57o0Tzh195knl8RcU//49oj+bHnIglEp5T+8F6zuQit//e5JEZ5iXo+cI9J
	 S++j6bXlKevpSPTmmEwKdXda9+hR6G/JiFIKYUWhlsQy3OY4v6mztrPKA1s9uWnAFJhPS
	 BVL14UB9xRRdFqCzR+fNRwkJSVAh9TQxlIM7dl4l/JWrDb0hpZ/m3bqfBkH0oS5wgrfMZ
	 EyOifWTD6VgjAGdpXKEu4B8PSHdmgAj4LdOhIu7ikmwfsfYVtnRkQf2AlteWBXFiIIzfc
	 VdC29VzF9jOIYFP1AEzpfxOVCiES1FIMKrJOdtzn2ZzRDqIleChny9oNJByNIyp7+Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4sSZgz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AE360A262C;
	Wed, 18 Nov 2026 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4sSZgz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FE61F000C4;
	Wed, 18 Nov 2026 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016289;
	bh=veyJo8u3n8CojHq9F8R297ZNYpde3LbvziDX4Zqi33s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4sSZgz88nkCEfAOGVluUVfzXDQFVyJU+U4xsx2/SMm+V10c0gIgZqpenBEj4PJW9
	 cXR+wfRUdVGb0Hw52iLdkoPGC+Kfh/t+rAR09ox48RoVuUF8+fKLz7nSKJgXmxcaTp
	 Jdo4FEF4tuHYDmy5hbB03l1nfpQpoVxSI8wcob0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0425/2651] bpf: Fix program BTF use-after-free in sleepable programs
Date: Wed, 18 Nov 2026 15:27:45 +0100
Message-ID: <20261118150303.129613995@linuxfoundation.org>
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
index 96217b99399d5..12bd6a05907ac 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2441,6 +2441,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 {
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
+	btf_put(aux->btf);
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
 	free_uid(aux->user);
@@ -2466,7 +2467,6 @@ static void __bpf_prog_put_rcu_tasks(struct rcu_head *rcu)
 static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
 	bpf_prog_kallsyms_del_all(prog);
-	btf_put(prog->aux->btf);
 	module_put(prog->aux->mod);
 	kvfree(prog->aux->jited_linfo);
 	kvfree(prog->aux->linfo);
-- 
2.53.0



