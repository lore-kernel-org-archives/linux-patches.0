Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210341;
	b=ryG0zBBpNOMY+gQ5K9Qc0Q43uYU27IHoUrwXrcEgL5cTfDpfU8tecr3Xs9XXdwgm28Ul
	 w9KejaIzMXegO5/FhzVq+o2zKKFwDEnp3Aqy98JRDZB5BcapwsOfxSIyVGdRk8+Uk4RQb
	 dlSDvN/idvnt8zwMBGmvUQ1v43L/YIvTBxYQjf/kUoIbHTuwZ1WSLMVkMes0Ypl1r+bYN
	 iuV4Sqo9gB2OfjtRIIVWLYu9gcPAWGXxf3DyQUT4oKHv5uZpNHJdxEkPS3bdTozpmHHYn
	 DD9zlN0GMXW5UzhbSN1z73fVns9bgTNfmPopvbYzBVU/he4hgA12nWCtTM0LW7x1gMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WwVl3CnMK8+97ZygbF8DZeufrfNayIUyrsfWSyALmJk=;
	b=SKwXDadxYPomqAfOZhePhWn1l5bLHqzekjz9T+Denf2jMqsUz3noSR/3n98KFvvEFmTR
	 l1cpnki05RM0Eaz4P4Bs0k1tciLDhCP7YZaxzBzul0+aoGHyWOiK3uTOTUK4MUhtx5A4n
	 77b7CabLUsGsLDjIXdYA0DrG4e5PNjC4AmNN15+ah1U4T8PUldaEH1ptBJDMBp1mtBG9D
	 ncGkd99d4ZLZbvF10+IfSEVjHGxSqdqDbVqzkIyYOHLbqk9JEa9JsLzHN08c6wAqmknGW
	 wMMZf2S8yaJaBDoRkHoedsK3yweD8CWoGeNQoEfeROMVerdzif64SWrFORzBx/p09gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIfQSmx5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FCD606A330;
	Wed, 28 Oct 2026 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIfQSmx5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7BA1F01828;
	Wed, 28 Oct 2026 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210340;
	bh=WwVl3CnMK8+97ZygbF8DZeufrfNayIUyrsfWSyALmJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIfQSmx5pKJf37T5kaELTwNOKgMCe0L1M9uabW39acSqwsJWzU3i3QPJG8IvHUG2d
	 wVD+axByg9yp1e5Ts2X0bihpkHbjGj4ITdyGKuYJoLNb+oeBN5Wg4KlA3CsTT2TZkS
	 JWOvUMPoQsE5eNscmNW0+YhoBiw9+wqAp6+4G6ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Inglis <giinglis@amazon.com>,
	Aaron Ahmed <aarnahmd@amazon.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 162/168] ftrace: Initialize modname and offset in print_rec()
Date: Wed, 28 Oct 2026 18:01:38 +0100
Message-ID: <20261028165946.923271702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Aaron Ahmed <aarnahmd@amazon.com>

commit e1f339ff3b83857b93baf8b88186275a413d445e upstream.

print_rec() leaves 'modname' and 'offset' uninitialized and
kallsyms_lookup() only sets them on success. When the lookup fails like
when a module is being loaded or unloaded, 'modname' holds a garbage
value, passes the 'if (modname)' check, and is dereferenced by
seq_printf().

  Oops: general protection fault
  RIP: 0010:string+0x48/0xe0
  Call Trace:
   vsnprintf+0x1f5/0x650
   seq_printf+0x8e/0xb0
   print_rec+0x6c/0xc0
   t_show+0x4c/0x440
   seq_read_iter+0x119/0x480

This can be triggered by reading available_filter_functions while a
module is being loaded or unloaded.

Initialize both variables so a failed lookup skips the module name.

Cc: stable@vger.kernel.org
Fixes: b39181f7c690 ("ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding weak function")
Link: https://patch.msgid.link/20261016230403.4916-1-aarnahmd@amazon.com
Tested-by: Gavin Inglis <giinglis@amazon.com>
Signed-off-by: Aaron Ahmed <aarnahmd@amazon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3807,9 +3807,9 @@ subsys_initcall(ftrace_check_for_weak_fu
 
 static int print_rec(struct seq_file *m, unsigned long ip)
 {
-	unsigned long offset;
+	unsigned long offset = 0;
 	char str[KSYM_SYMBOL_LEN];
-	char *modname;
+	char *modname = NULL;
 	const char *ret;
 
 	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);


