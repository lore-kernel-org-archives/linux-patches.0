Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E8B27B344;
	Mon, 18 Aug 2025 13:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523607; cv=none; b=gxYH9i7FDCJQDtlrh154IO49z+GMHeb3jwp3dnodFC3s1J7f/X8O201kx81n1DhdqYdV1BX9YfutS3xNhkak8GBKNnujzWUR2CVhIab6UsDRbETam/SK+UgGZ1MlLXX2Eo40wJ/WrDFv2PusEAL0fiUo8NjtC6e31hrSPlrvAWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523607; c=relaxed/simple;
	bh=6TFsKiz57AGcCKXtFb0LxM264oHs/Z7qG5ZfKeVKYzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZu4TVRI0f44t1zkQ00WvWIeTGKdMniekgNjgHAiwOOXXieQOO3EATiV0yDU+BXBE4UDaRdGfAOJeOcaEyMDi/jABxBn88LE+YuSHgGHqZp9pxHtlZ4ZHq3DGOYarXGorDDVqrwQQv7otEz5z7C5OfJ+uKNkGB50CCjmap0rNFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjrC6/q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjrC6/q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5EDC4CEEB;
	Mon, 18 Aug 2025 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523607;
	bh=6TFsKiz57AGcCKXtFb0LxM264oHs/Z7qG5ZfKeVKYzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjrC6/q5Nupqdx7kkP7zA7EYv+uYDXuMCxXsXBlVb6Llf6pVBJ32NtIiyuwa81Yg6
	 xmG9bFZDJDCnxyYkBcjRXE2NrP2WvnQ57IzKTiOYzYTfp8RjFQyXJh7NuNiwRimM6n
	 kTP9DpvxG3TH5YKY1bkxyeB9BaKx9s5jhSBCKMug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	David Hildenbrand <david@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 191/515] powerpc/thp: tracing: Hide hugepage events under CONFIG_PPC_BOOK3S_64
Date: Mon, 18 Aug 2025 14:42:57 +0200
Message-ID: <20250818124505.726248904@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 43cf0e05089afe23dac74fa6e1e109d49f2903c4 ]

The events hugepage_set_pmd, hugepage_set_pud, hugepage_update_pmd and
hugepage_update_pud are only called when CONFIG_PPC_BOOK3S_64 is defined.
As each event can take up to 5K regardless if they are used or not, it's
best not to define them when they are not used. Add #ifdef around these
events when they are not used.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/20250612101259.0ad43e48@batman.local.home
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/thp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/trace/events/thp.h b/include/trace/events/thp.h
index f50048af5fcc..c8fe879d5828 100644
--- a/include/trace/events/thp.h
+++ b/include/trace/events/thp.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
+#ifdef CONFIG_PPC_BOOK3S_64
 DECLARE_EVENT_CLASS(hugepage_set,
 
 	    TP_PROTO(unsigned long addr, unsigned long pte),
@@ -66,6 +67,7 @@ DEFINE_EVENT(hugepage_update, hugepage_update_pud,
 	    TP_PROTO(unsigned long addr, unsigned long pud, unsigned long clr, unsigned long set),
 	    TP_ARGS(addr, pud, clr, set)
 );
+#endif /* CONFIG_PPC_BOOK3S_64 */
 
 DECLARE_EVENT_CLASS(migration_pmd,
 
-- 
2.39.5



