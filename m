Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023549;
	b=5Fgi9DsdOyDxQlcKiTjNf7RPvP1rG0MnycESfreubdXAhF6SoB3qTZbAfLfLW8RAc72H
	 OXSWwYmgppwtdqt/oU6hdgigdvTNjQa1MBTgnp4ccKWy5wiPJF7mVK9WVRWFj/uEeTF5r
	 BfiVRPbOZCc0YFF2APaIpHZqeoQWOADp5K9LtZXRJGjTUZIMNz+fVytlBegsS3j6cHj+G
	 j+PQoVYo5maKLnTujiJlKrcS3eduG1rlOtTZDfNGS3VeMFf0t3aExK33dyiUT6iZY8Dv/
	 ZldAeFy4mXAdl1fN0ENRBwWe472qnXc7oD55HlRMcl0F9lHVp7WcrAy50a338mlmkzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LHSRBdO10wIUwKGVDYZfq6rPBaBCVdV4O2tmQk4lnpQ=;
	b=QsX+CU/t9ZMSeYqM33VMnIXPvQOUrfI9wDiO2ANH67XWmg1kPX3Pt1gy404Z7A9eIRot
	 yl6j6ggItLIMOFXJkby5RkA6wheJEQMpKJiaQm42AnMS6mNha3V+33fTZzWpX8CstbFWj
	 UN8ce6pSb8zKOAy5d4CiJbHNrlp+KMwlOw4g1G9k7D9jqlqpwqhUzin3ET0/cgqiTv3Eq
	 ZfyLQPRSrR2vVqvBCJMNOI+c2tTdtB8XENsOn6/Ih+YA+iJs800sEasHXWgx0aWnMV4t+
	 FHWdQTfG4XszbOSIpsAXBCTKZNjA8Pr41oBCnzOIZnHOmJBFjvPk8FcUUUlCZV04kjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQyh7eGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D53C606A325;
	Wed, 18 Nov 2026 17:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQyh7eGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627CA1F000C4;
	Wed, 18 Nov 2026 17:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023548;
	bh=LHSRBdO10wIUwKGVDYZfq6rPBaBCVdV4O2tmQk4lnpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQyh7eGxMXPfOKGRlntbMVxp46ubEPqCi8cIsAP++gCZmj47y53LcWgtcqreq1usP
	 3T6DJdL5VpJGFUPA9l1jZRFtPLGybVsEfp08q4b6k//4pBM91swxphKbIg5cnZCv1L
	 achtmmHeL+i4W5sF7foZESXwtUDbD51WJTqO7oUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0409/2151] bpf: Fix program BTF use-after-free in sleepable programs
Date: Wed, 18 Nov 2026 15:35:44 +0100
Message-ID: <20261118150136.965347803@linuxfoundation.org>
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
index 144d8b1183a98..f5eeaa0090875 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2384,6 +2384,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 {
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
+	btf_put(aux->btf);
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
 	free_uid(aux->user);
@@ -2394,7 +2395,6 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
 	bpf_prog_kallsyms_del_all(prog);
-	btf_put(prog->aux->btf);
 	module_put(prog->aux->mod);
 	kvfree(prog->aux->jited_linfo);
 	kvfree(prog->aux->linfo);
-- 
2.53.0



