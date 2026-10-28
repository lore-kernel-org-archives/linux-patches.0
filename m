Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207360;
	b=TQVslN/MreAZ1bayzUgtolDjMUujyCpso7QUNNDfFSzVaUeQlxVuHb04yT8BApyQ/DU/
	 uTs5tIYtaVASeLrxi8eq9NZMOZhyx4bUArX7Qfn1NwX6zvyip4fs4Lyt2WQ/uIWbKM/mi
	 ucEgK/QasQn40pPpHwDHvdL2NTdLqCFQLTAweD+afvQwJVrw1JBDUDbywVA2iKtG4iYi3
	 AKwYCpMSC89DEPyHXu2WnUVDqE4q1hFz4uXBFrUsAZLJ5mvbOglUOmADptbfW5Qobs1+R
	 GC6/R7hOEdOPRQOus4xeq0BRjvGO43QfttosMqZBCRtR9gz+Dha7rjGNLXC3ulrGUQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JFIXw6LlQNwuxAMh6POlhMhOS3MxLsowifG93f+/azk=;
	b=Z6mfjYld6KXkMklmjsCVCp9R7WeBTEFT6LDIHUvZbFraOYejSaGJLv8YsXQZRI0uSWZA
	 PQMr2gqKfh2lZfNw44Urwd0SWDyTMJA5b8aF6wEAFonkrp7LUATGbtCZ0ZxlHJuFHPtwk
	 417+kzxxZ8ve62k1zj7vLO/Eth0iPOlMW09YPjuKDUQCfd+MUNH3V22Q8FgLaDVKs3ogG
	 w23Mz1tB7z6vkSnKZ/0xySTgSzgUxnylH4CQeVtfFvihbbBOZPKIppyB8HHXIRq9Tv9WZ
	 3lCLqFPOYqeQdnPPm+lN6UBbQtGjmYcEMRKxLP6o3c+StOXRnmSUVBx25lpoJfx0VUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHa3Cchw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAD5606A31A;
	Wed, 28 Oct 2026 17:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHa3Cchw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD841F01825;
	Wed, 28 Oct 2026 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207360;
	bh=JFIXw6LlQNwuxAMh6POlhMhOS3MxLsowifG93f+/azk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHa3CchwLBGzn1TrGliOLXgwgFZUUj0hQvYOolQ7ywLnP+GcHX4wn0IWXrW0lHcVp
	 7fRC7gsjAW8WZ2JJ9HaJDJMpLFegKJcoZle2Z++yC6V7YrNfeqxOKJ9cSlyyW6Apu2
	 3bai4xHCRdwxbALWVPlJQgFw0HUebiXSm6HIb9ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Inglis <giinglis@amazon.com>,
	Aaron Ahmed <aarnahmd@amazon.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 79/88] ftrace: Initialize modname and offset in print_rec()
Date: Wed, 28 Oct 2026 18:00:27 +0100
Message-ID: <20261028165943.974245710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4426,9 +4426,9 @@ subsys_initcall(ftrace_check_for_weak_fu
 
 static int print_rec(struct seq_file *m, unsigned long ip)
 {
-	unsigned long offset;
+	unsigned long offset = 0;
 	char str[KSYM_SYMBOL_LEN];
-	char *modname;
+	char *modname = NULL;
 	const char *ret;
 
 	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);


