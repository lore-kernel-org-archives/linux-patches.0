Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208072;
	b=CB6PjD9TSrl4ouYL9wCF6OGW2TcFQA3fvgvv2mAie4czLreYSEpX/ujE/cXKmP2bp7/4
	 Vmq8DyjFAeGddr0vOd8Ds67oVHPgS7pN1XyX+sfDC6xAq54J5q5TG97zP1GRGJ0wtU9Hy
	 n0mbr3X/f2gHH5mHhGqftccsr7MYZPAfoHm/IVVgH3PF8P8Mt6wel1aTl1D9ALUkmDgsa
	 QQts35FU7lxgSD3zU4saql43xeFTOGspw02HkUju8zDjRjOqdDL5H98nRzo5jhbXwCFyg
	 d5ew0Jo5NIG9W5nUmW/d4ht4afaUMUurhE76QX/crkQ3ukJ+4bRlUISPLVHQhaB+3Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UQzGCv72SEI1qqYua13zvgXgETPuHVMgWH22FHWmqx0=;
	b=l+9MRKfKzpMt4cpDH2qKTnV+9VRgFktXp5/JlyMs88mEhHep6ZGwsT31rj0dj5LHVGE4
	 i0/jsYvs5lDINT01pt7gpy9ZIrH+uk2iL9Rn/CzoXAFWcsCsR+0Idypx7mWVddLx60Zk/
	 90IXuxQBuCd208mPaoCV0tHvQS93zv4rY9ws7Kc1FB79u0LFZuqrDmfWf5TOJ7cColq1g
	 zT+G50361rfp6K4iD8W4aTvX9reeHcDm2yyB4nUweEl/HbYYDEJXuRBYLDEuyvWsGF3CE
	 l6b1LiRzaogz0A0Gi2lOcRDXGX153Z59U+htHMWgYXHgda6lQZI8T0SiYCa6ghIwMog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5H8tNSu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8D6606A31D;
	Wed, 28 Oct 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5H8tNSu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64301F01825;
	Wed, 28 Oct 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208072;
	bh=UQzGCv72SEI1qqYua13zvgXgETPuHVMgWH22FHWmqx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5H8tNSunI1Hh5hFSG/qlshf0rHVOsJOnBDnLmo8SLiuvLY9Fa3Ou6JLueY1wNWw9
	 uSCocN7uaAi9Vmv9Rek1eDcgQ/CngU+pnoAyv5eHtCdYesjyoFhZzbLX0eqA3GOQdN
	 kz54XujkJz1uToMW2ed6qcPrI7I/ist84J53sHrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Inglis <giinglis@amazon.com>,
	Aaron Ahmed <aarnahmd@amazon.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 239/247] ftrace: Initialize modname and offset in print_rec()
Date: Wed, 28 Oct 2026 18:00:42 +0100
Message-ID: <20261028165953.081460666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -4316,9 +4316,9 @@ subsys_initcall(ftrace_check_for_weak_fu
 
 static int print_rec(struct seq_file *m, unsigned long ip)
 {
-	unsigned long offset;
+	unsigned long offset = 0;
 	char str[KSYM_SYMBOL_LEN];
-	char *modname;
+	char *modname = NULL;
 	const char *ret;
 
 	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);


