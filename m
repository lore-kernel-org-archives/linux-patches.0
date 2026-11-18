Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019619;
	b=MfYkodZT78n4o0lUcHzZFVaw/7K4Qx7FWgLQYGf8fj7UJJiNfanbHL9QcjN3+kdSMt1t
	 HZkA/C77tuSmpG7jRv9vi9Hla0dsv50BvmuI8upOT0RnbOCNHmVOwo2gB3U+2rIJnxcdn
	 BhR9cqDT4KTf8f6U0hoUVtLr8DDf7jYjuAwuFopZHwBA7iu+e5CUV53BeNpJ+65U7cBl2
	 AT/DoaKIm3ggGqEhMqmZSCVddR9yRGLzSNSKqZGg50Wg6UoHPay39m3saS48aPSME1FK2
	 dONox9RfQdgPAPgFChsIIUGYXfOOtGuxCsOTab9to4HX/qt/RtzFAc+PYXM23TUcs7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KwQmVRwxgJs5w8i5BV64jQsUuyZF+a39VC8jMr6Trq4=;
	b=uggbANY98anx2gEAVFSSZd+yB9aDnX3k8lGS2pG7dsdVDf82pVuiRoPH0noJqIQwGhht
	 sdH6ME7s3bs7nMcu4z80VznK6qlS9sXDMXVGRZZolVAvj2lpDE7WAHT64EMygvNVGapaV
	 rc41tj8RbRC302dc2RGCIBFkZpQTc2MQlbO2Olpt5Rov49OqJXLyRoIIjFgv0Sf0DGYSx
	 8opF5WksaHBfWs46DSa/D4xrq6G1aqCkjLjiU9ZDR+D+3jE+JsZucRdkcMcOcgbtSCVEJ
	 kUor+DaufcvaHOZzYKZXgtDCgIezalSgbi3cW2yxmabtf6AtVDh/dn2JG9kHLagyb+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EON+E2Ze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C719606A7D8;
	Wed, 18 Nov 2026 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EON+E2Ze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B27F1F000C5;
	Wed, 18 Nov 2026 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019618;
	bh=KwQmVRwxgJs5w8i5BV64jQsUuyZF+a39VC8jMr6Trq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EON+E2ZeIQzftGszFk12lQmYUWIfKtzDL96AZrrVof6XE3Bs8h/AkLUU0/Eq7hXuL
	 pxYqsoD23iMeYGgGchtRANBc0aXROwsmiY1VbhPjnVghm1VsdfxGI9PeebjeImo4O/
	 QRUmN8TMtKPssblUv+/VyKN29HggMTLErOcbt1iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1620/2651] bpf: Reject BTF ids with the same address in tracing_multi link
Date: Wed, 18 Nov 2026 15:47:40 +0100
Message-ID: <20261118150346.176651372@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 87bfa22937000db29a9a09ec826ab7227eaf9e8c ]

check_dup_ids() rejects equal BTF ids, but different ids can resolve to
the same address. Aliases:

  ffffffff8161b6b0 t __do_sys_munlockall
  ffffffff8161b6b0 T __ia32_sys_munlockall
  ffffffff8161b6b0 T __x64_sys_munlockall

or several BTF_KIND_FUNC with the same name that vmlinux BTF has when
CONFIG_DEBUG_INFO_BTF_INLINE is set.

Each id gets its own trampoline and register_fentry_multi() adds them to
data->reg with the same ip. update_ftrace_direct_add() checks that new
entries are not in direct_functions, but doesn't compare them with each
other, so the attach succeeds. At detach update_ftrace_direct_del() sees
that 'direct' of one of the entries doesn't match and returns -EINVAL:

  WARNING: kernel/bpf/trampoline.c:1845 at bpf_trampoline_multi_detach+0x24c/0x280
  Call Trace:
   bpf_link_free+0x51/0x110
   bpf_link_release+0x18/0x20
   __fput+0x103/0x2d0
   __x64_sys_close+0x3d/0x80

The images are freed anyway, while ftrace still calls them:

  Oops: int3: 0000 [#1] SMP NOPTI
  RIP: 0010:0xffffffffc042b201
  Call Trace:
   ? __audit_syscall_exit+0x9/0x100
   ? do_syscall_64+0x5ab/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  Kernel panic - not syncing: Fatal exception in interrupt

Return -EINVAL from register_fentry_multi() when ip is already in
data->reg. When such ids are attached via different links the second
attach already fails with -EINVAL in update_ftrace_direct_add().

Move the declaration of ftrace_lookup_ip() to include/linux/ftrace.h.

The lookup adds 60 msec to the attach of 64480 functions in
tracing_multi_bench_attach: 1.34 -> 1.40 sec.

Fixes: aef4dfa790b2 ("bpf: Add bpf_trampoline_multi_attach/detach functions")a
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20261011164836.2233874-2-alexei.starovoitov@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace.h  | 1 +
 kernel/bpf/trampoline.c | 8 ++++++++
 kernel/trace/trace.h    | 3 ---
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index bd76a16a63afb..b041d9142d2b8 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -416,6 +416,7 @@ void free_ftrace_hash(struct ftrace_hash *hash);
 struct ftrace_func_entry *add_ftrace_hash_entry_direct(struct ftrace_hash *hash,
 						       unsigned long ip, unsigned long direct);
 void add_ftrace_hash_entry(struct ftrace_hash *hash, struct ftrace_func_entry *entry);
+struct ftrace_func_entry *ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip);
 void ftrace_hash_remove(struct ftrace_hash *hash);
 
 /* The hash used to know what functions callbacks trace */
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index fc94d6062109e..24edb59238f34 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -1638,6 +1638,14 @@ static int register_fentry_multi(struct bpf_trampoline *tr, struct bpf_tramp_ima
 	unsigned long ip = ftrace_location(tr->ip);
 	struct bpf_tracing_multi_data *data = ptr;
 
+	/*
+	 * Different BTF ids get different trampolines, but they can still
+	 * resolve to the same address (aliases, functions of the same name).
+	 * There's only one call site to attach to.
+	 */
+	if (ftrace_lookup_ip(data->reg, ip))
+		return -EINVAL;
+
 	if (bpf_trampoline_use_jmp(tr->flags))
 		addr = ftrace_jmp_set(addr);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3749485a7d85f..9044f03fe2d90 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1006,9 +1006,6 @@ struct ftrace_hash {
 	struct rcu_head		rcu;
 };
 
-struct ftrace_func_entry *
-ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip);
-
 static __always_inline bool ftrace_hash_empty(struct ftrace_hash *hash)
 {
 	return !hash || !(hash->count || (hash->flags & FTRACE_HASH_FL_MOD));
-- 
2.53.0



