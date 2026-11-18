Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034502;
	b=smuEk+9SjVZJsvUvnFFPPNgEeyHXATbocE0sZgJb9X0fkGdHeTIWzyS58vhkMWGy2ex0
	 dIorcM4ofOa0levZHAybdPMtJIDEacRWeUaXsbWyf3Q7dw6W+OpBJkZZPKjAHHrbFo74j
	 qGJbpyeFK9clU6IQ+G0Vf59v8+iQ3VaXT1PYivxETLBmzoS+3XFiS0r2wmdBNQQCpREGp
	 Z8iZiFXFSVTVvfLftpYXeBoMqLIlAIrt0yHeGT5WGouXNzZ2juubxUdhNLmajlPzHkfuD
	 FnczjQZMjw+BAKzGd5bTI4BQ/PxHWeuaPnKd3NT5RE+nuwCXGWggaY9mK+brRrcTtDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fFtO08gZoeG7Dxd/RgzgIazdTg3hlF3M8JfLiDDBIe8=;
	b=A3+lRAaNWsSssAc7fz1QNJeo51Rwa4WmKQxGEiHVcRFZSnAN5WqMiwpjtZh85SLDT3Zq
	 6aDNqs2hXOYIDYlpCeWn2VbRx0zoL8lJzTDCClexKOCzG1b7PPcwCUVuwGeIOhI8Tw55+
	 Sy0XFIMtdIzXur2JiJl2tfwMeSdUs1YwOrK+Us9wrqBXRaEmGZTMRr6n7kmxVurha3W+V
	 TCRTrmmYO3+1NHVXUChtLut/bXzhUNA21PeA6vQanIiBEWeJMKWl0DTU+dAPEpsgtH7ik
	 QR8CSgLAoWvTF+vMqaQnE/dwuYUmsZ26GdQYXy47E/TYAItmAQqqHI5UMZMd4ijD8Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aJpM5wFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED513606A31C;
	Wed, 18 Nov 2026 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aJpM5wFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE3E1F000C4;
	Wed, 18 Nov 2026 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034501;
	bh=fFtO08gZoeG7Dxd/RgzgIazdTg3hlF3M8JfLiDDBIe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJpM5wFLyDEfun3vJhMYK873yd4b7RfwrKBCRes3iBs/A2UAqpbJUPmf0LBH7rOe7
	 luDXm1MTmCxZLgQfWWu43mNYOK2M7lzBO8aamGxtqKmepoZ3q7Lr3iKk1AqJBSEyDq
	 FAbaG+zN8HJDyY8IILygCoQnGfscA6k2bFSaA+lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0393/3318] module: Use RCU in find_kallsyms_symbol().
Date: Wed, 18 Nov 2026 15:16:55 +0100
Message-ID: <20261118150328.155416902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f01369239293e4900af7be673e0fd26fe54f85e1 ]

The modules list and module::kallsyms can be accessed under RCU
assumption.

Use rcu_dereference() to reference the kallsyms pointer in
find_kallsyms_symbol().  Use a RCU section instead of preempt_disable in
callers of find_kallsyms_symbol(). Keep the preempt-disable in
module_address_lookup() due to __module_address().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250108090457.512198-5-bigeasy@linutronix.de
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Stable-dep-of: 0e9f090a4e9b ("module/kallsyms: fix nextval for data symbol lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/kallsyms.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index 8428089791133..5b7783d33fb93 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -260,7 +260,7 @@ static const char *find_kallsyms_symbol(struct module *mod,
 {
 	unsigned int i, best = 0;
 	unsigned long nextval, bestval;
-	struct mod_kallsyms *kallsyms = rcu_dereference_sched(mod->kallsyms);
+	struct mod_kallsyms *kallsyms = rcu_dereference(mod->kallsyms);
 	struct module_memory *mod_mem;
 
 	/* At worse, next value is at end of module */
@@ -331,6 +331,7 @@ const char *module_address_lookup(unsigned long addr,
 	const char *ret = NULL;
 	struct module *mod;
 
+	guard(rcu)();
 	preempt_disable();
 	mod = __module_address(addr);
 	if (mod) {
@@ -355,7 +356,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 {
 	struct module *mod;
 
-	preempt_disable();
+	guard(rcu)();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
@@ -367,12 +368,10 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 				goto out;
 
 			strscpy(symname, sym, KSYM_NAME_LEN);
-			preempt_enable();
 			return 0;
 		}
 	}
 out:
-	preempt_enable();
 	return -ERANGE;
 }
 
-- 
2.53.0



