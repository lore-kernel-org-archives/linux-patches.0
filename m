Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217177;
	b=29PM4IOxlCg5qEP4bP24o1TkVtOKbXIgv4DXGzMPao/Hze2pDCKi3YE8o5vhLeL/8Lcv
	 smbY3VHwc/3BtnZZczLFm7c5cK4OkdS14ek0lZoYsPxwQLqfbD0GlWm451feIIEPL0i1o
	 GLuUHd9+oO8tDbvR2OwDmA80XZFnh1dBbGrbh8++xiSx0y+llcZsUxhcguPcbJ6Nvzsva
	 Ew95kRzEmuSxeDMHfY5/MYVGuBKIlf5xssvShLnxBxF5r3uPSNiZeG9sS31Orv29cIZU4
	 bDh/DFiyHUrZZp2qf8p9qA6BCaGR/alxFrolq5KEOtMLK2fftX1dHaniTltcSylE0JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LylESB5bREI5+B1ljRwu/I7XpthtFjukA3sWxhmKcMA=;
	b=BJlw+KXPE/0PUzEh2OctkuoVeZyb3sqXbliGO/9n83BnGSy7jVFci7XZlJWbb9F6dYl5
	 rlBxBObm8DyOPjRs/hPfwl+ELV3ut9jSOSa2LGRmtPm/hAj/MhTdWbSR16l/a3mcsF/rm
	 0BOaK8NCovMlA1E9Lf0WEJnbr/0+Ok1iPaRqIgUkaoUSdno55mnJnD4Ap6ltxmQl7HmfY
	 vtyRr2EB041rf93BMwv80moZWuJznEoxklSlFCcy7+44hgcEvB1R9GOMxUOcetgvvAi81
	 TDQK8WYziKAs/omKebNCgckQQK+GbM1P9WsRo/UAtX7jRpz2gMNrmGNz/rRE2kLzGgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKMYVGMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAE7606A31D;
	Wed, 28 Oct 2026 19:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKMYVGMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8C21F01825;
	Wed, 28 Oct 2026 19:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217177;
	bh=LylESB5bREI5+B1ljRwu/I7XpthtFjukA3sWxhmKcMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKMYVGMg86zk7rBJjdw88hV/KqgfzJo729sPlc7Dhvy0nI2lEa70PvraLxW6moxYA
	 wBUAzamKb9ACnEbuo0PoYiOoW3BhXUDWbWFSLY7mko/VwhCi9E25iA2a42X8C7Z1+6
	 LV5dC4ivog09XtCMool3+WBuSS9ZY23Y5jM9OeRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Inglis <giinglis@amazon.com>,
	Aaron Ahmed <aarnahmd@amazon.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 1814/1887] ftrace: Initialize modname and offset in print_rec()
Date: Wed, 28 Oct 2026 18:05:10 +0100
Message-ID: <20261028170540.726333505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3742,9 +3742,9 @@ subsys_initcall(ftrace_check_for_weak_fu
 
 static int print_rec(struct seq_file *m, unsigned long ip)
 {
-	unsigned long offset;
+	unsigned long offset = 0;
 	char str[KSYM_SYMBOL_LEN];
-	char *modname;
+	char *modname = NULL;
 	const char *ret;
 
 	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);


