Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061157;
	b=cS0ae3xrzNH3d4Epw+oxhqC55HGSNkK3KR+MlBZUWToVpFyNEMPm8aG7K1H0PfPnTQYO
	 n+3O/ZxVmQ15XU32HdP/WYybolC1oRhlsDlVwNUk70IcdT0N9ArS2gppW0xGTHzCT1Fx3
	 IZnMzhYtKvUFi9odnH5+/LcLcKPncHG1RHpbRAf5bqb0rFGALkK3Rpeyh9ujnBDIutsbB
	 aPaKQ395EvdCp4BkFfH61IL1JAtXyP6Vkblbrr7ei3doHFGOU/MW+yI71q+c0/ikklNPG
	 oU2gS/3Z/iAiuBROEeiImbo1bcxOQqfsLKijZnH0e+1nX2Q43T0x4EF8S6oTGOr6SKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Or8Zak/BmurYQXHbPG79GmyTXHsmKMTHQrpDls/nJe4=;
	b=ESb1Mt8DkgvKf9Q53LK2+YrcaR9zJSL7l5FfpMRipsayvPKXAnEhLWZZryUf/wxJFlfm
	 n92w7zIz5nCuDxPJnnJnrewVvCPU9d8kkFZjev05g50sozoCi5QfswdneAwxuzvozoHYU
	 gLUd1fgRtu41gg9bCVA5FO8kkq3wtyIwwK5MIkpvyhPqeMA8V/BD0D51rlknsnQjXwfXE
	 0cfu+2m9/zZyXiTrtgMrmuY+a5Qa+T6o1AVU/nh75uewwMDYdm7xyLAM0jW/3jP+V+97S
	 WsjAbfZhx8H+qUzV4kPKgZblGXXL56eZMitt9hIldEYExPc3MaMFJf+nAnCwO5Cce/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XWOhwEC/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38637606D805;
	Sat,  7 Nov 2026 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XWOhwEC/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A11F0089F;
	Sat,  7 Nov 2026 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061157;
	bh=Or8Zak/BmurYQXHbPG79GmyTXHsmKMTHQrpDls/nJe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWOhwEC/c33bLW62r5UhF2p91mCHjhfADDhQtLXeYWGVHGJ1Lwuh0Y4APmXHQ5RkP
	 i9CiDHHRzTeVKKbZ6K2AqpxBK59vpxQayb/2nN6kW3rb9EdtEZI7dmhHFy1OeYa+tZ
	 7Y4whOFd5/H+5UPhXrTGHx5lKcQ9IGM2dtbPyeO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0464/1536] module: Use RCU in find_kallsyms_symbol().
Date: Sat,  7 Nov 2026 08:41:20 -0500
Message-ID: <20261107135010.549697570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 30d0798f114f1..18931db1369da 100644
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
@@ -332,6 +332,7 @@ int module_address_lookup(unsigned long addr,
 	int ret = 0;
 	struct module *mod;
 
+	guard(rcu)();
 	preempt_disable();
 	mod = __module_address(addr);
 	if (mod) {
@@ -354,7 +355,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 {
 	struct module *mod;
 
-	preempt_disable();
+	guard(rcu)();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
@@ -366,12 +367,10 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
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



