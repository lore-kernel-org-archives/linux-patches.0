Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774527;
	b=SqzlhnIJGDa9sqV5o297OCwzHaTuBql+ra9Z7IEjkEo5Us5AWRhjeZ6cGtMr2R9E+JBD
	 PqF8GbjfwcOTaL4y2VdkKfXAkprCMOzoJdOCngqBgv4qQQmMJPgEYudk0EiXaWWiThbJZ
	 zAzNkP1CtA18hpPQCMoNLBYRuO+9xU/EaGCUBsNs+3I52ugoPbN6kSaJg4/Pui/rWSyCN
	 hRDJmR5dD23Tole9QdVDdTA5yjarY47tJV64tiRj3VecWbe5+CEJlLsFjaZbtygbKA9qv
	 V3Ch3DI+hQJMonohS460yhSWLZ2TUeKpdMySpaJ+BUQf3l4n141sPHCZRQW1i+gGOag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ta7AbZJvmo2LWOw9rUuSOwTsEMf4C8U1sFeannP2iCk=;
	b=to6j7g0TX3fOFj4rF1e6+nJaTKUdjxCOKHMbqvX1G2EqhWYJAu1n06apgblkW/aN4X6H
	 GHYmFESziiUbMdlnTgpIdyyQCDurhSCuAy1kq1Am0sZq13xXKrXEuHmRH6Nj2Vr5YjbK4
	 Hy8d6Lk3oDzeZI5rG1XoWJbBL01I/qMp55/qNy0ImaqDbQ57g9FLUjQUmiC4ycXRi5pQJ
	 cZ6NSOSlfgDvygvwqS6jHMVS/JrmxnkiUvIbPImwODx8PrHdEcshuN5wKVSDsELUy93Ne
	 iRI5WzeuRpYUdYs+cLw666PfT6GAP2CwxSuIgLEgh/yMJKjWUmfgWuen7YwZYINtRkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1UgZp+UE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53AD606A31E;
	Fri, 23 Oct 2026 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1UgZp+UE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CB01F01825;
	Fri, 23 Oct 2026 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774526;
	bh=ta7AbZJvmo2LWOw9rUuSOwTsEMf4C8U1sFeannP2iCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UgZp+UETk7Yve+vYfFwOswZeRQ2CMv9HIJwRPq2FKVx50W4i7e9hPdUTKUUo3hmJ
	 lBL2HSg/OOViIUWPwQvyGKvDsw6lLUQUDwpSWimqlgwGOPbMh852LUP5fBoPdk07NB
	 /kidiDlYTeVtuXwZBBGvFDAwcSCG5cLNAzpK2Hzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 070/242] tracing: Fix simple_ring_buffer undef check on sparc64
Date: Fri, 23 Oct 2026 18:38:32 +0200
Message-ID: <20261023163715.436739408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 0fa993581aaa58a34ae3dcebebe0fbf593fcb441 ]

simple_ring_buffer relies on headers that end up including
<asm/thread_info.h>. On sparc64, this emits the undefined symbol
current_thread_info_reg. Allow this symbol.

Link: https://patch.msgid.link/20260923074213.3077182-4-vdonnefort@google.com
Fixes: 1211907ac0b5 ("tracing: Generate undef symbols allowlist for simple_ring_buffer")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/5574c9e6-9ed2-4ee6-a2b2-fb6ee81e83a1@roeck-us.net/
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 0e1846f7dda32..3860bc53a4bed 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -146,6 +146,7 @@ KASAN_SANITIZE_undefsyms_base.o := y
 
 UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov __sanitizer __tsan __ubsan __msan \
 		      __aeabi_unwind_cpp __s390_indirect_jump __x86_indirect_thunk simple_ring_buffer \
+		      current_thread_info_reg \
 		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '$$2 {print $$2}')
 
 quiet_cmd_check_undefined = NM      $<
-- 
2.53.0



