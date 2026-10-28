Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209851;
	b=LekoxJ8IyH9U/anTJIIUfqtNtW0EcW789qtcgVegUskDpG+DRbF79IE9OcZCsXe+yi1t
	 +mdxgFDcZnFD/1LHHKpgVC9PCC0ZpX0+a0zjXqRaAboI18KzJvMyQxWFHRUJzZ7mjVkh+
	 fYBvg324FsgZVchP5zNSp/gWFD2/OZra0JOg3yMPJhXbpX2AF+jMJex+CN1a9dvfq23XR
	 J+3MTU9wHe9hVq4F7oYY8AvcnwQs6dFvjEO4foEQQC/biu2ssedpQSwfVrAFY/HG5rh33
	 OEhyWiW7c4XG53PL67PMt4ElhgiCHueJrrQKPvozEk2euGmIqxqu9DknTsXRkRn1Iwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqnOzPYUbwdVccpZUOPnptR24PGUpTJw2Q6o+szZHvY=;
	b=E/cuk9fmXWagrxuuBYPYXexJRUEUG/jkCPzLo87dOk1K5OWQz6PPN0mAspiXiIOqQKKW
	 OMKQS4H4pV1Lh0GlQ+M1vBH6d8fd+sUYOwX0yqclWOaCOoiyqy8z5Ii8ETBCOfvXAWKtj
	 FT9oYJq43NocSDcBpzi9wu/1q3Re+nu5HqAE4imuWQKHV6XDcOLU0WzlXqVn5AFemVPcR
	 4Y/N85Mjd2lRRbva5K1eQKAV93HRTeYrA8xqRgPifp/sBnYB9NQoz/LCrBmvMee0ueK82
	 xpAqEpd/LBDCPLQgAcvuURCtPQEEXNZctvns3jdRRii7ZNb44qoMcoHU9OTNmdPJiFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1bM0ayl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315D5606A31A;
	Wed, 28 Oct 2026 17:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1bM0ayl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE8E1F01825;
	Wed, 28 Oct 2026 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209851;
	bh=iqnOzPYUbwdVccpZUOPnptR24PGUpTJw2Q6o+szZHvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1bM0ayluPVGza6pAI40xQ+B/AXVl3WDeDgVUUyaZ5o4+OaIH7hgUV2KRy1ujRQdt
	 v7maZdeJgc8Am/OmPd2YJM0wwP3snpxFEodYU/GOaiBUhNy/Mbl+EJM+rInDakK12S
	 pgzZO9o051h9A6wiNp91Iv6mL933wEz7IkkpgkXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Inglis <giinglis@amazon.com>,
	Aaron Ahmed <aarnahmd@amazon.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 100/109] ftrace: Initialize modname and offset in print_rec()
Date: Wed, 28 Oct 2026 18:01:24 +0100
Message-ID: <20261028165944.710072501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -4370,9 +4370,9 @@ subsys_initcall(ftrace_check_for_weak_fu
 
 static int print_rec(struct seq_file *m, unsigned long ip)
 {
-	unsigned long offset;
+	unsigned long offset = 0;
 	char str[KSYM_SYMBOL_LEN];
-	char *modname;
+	char *modname = NULL;
 	const char *ret;
 
 	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);


