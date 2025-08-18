Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA282253F2;
	Mon, 18 Aug 2025 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525366; cv=none; b=A38TQxGE1ItfhmbECTH8I3giRuOyg10SVglng7pfNeQOJUv/7MJ9GE5d9jsbc45cQicxJ9ctps0KRbyGH4FWB1bYFwd65y069uTssZWAPwuxugM1nzMYGCRxdDL8HuOH9CVYGWznPZ52cvdNbreptxJth8+m3VTeQgfv5kv2f4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525366; c=relaxed/simple;
	bh=JAyK+qqSfZMS1DSqPlACvDqUp0nXKeVKQOok4TwzTMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQCy3EZyTQ5xJlX25DiS2GUIy4h0RNlmMs6EWC8uzQ9l1tAEZW1NeYQtD+XuVOYCyITdW1f6PzG2hE9cjbVLvih1kKzxk8ruAa8jjkRxVUTtTCHkvUrJbIUyYSxcD/dHCTrFY4YyCXP0T0b2s3X0wVQ829WPmqvXjEa8kEgi2aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAhQ3zVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAhQ3zVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B8AC4CEEB;
	Mon, 18 Aug 2025 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525366;
	bh=JAyK+qqSfZMS1DSqPlACvDqUp0nXKeVKQOok4TwzTMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAhQ3zVWVIHcKtT9hxw064kZCAOdXA04HWamNl8UIpGVh0jP0KkePLA1Lk6uN3nNp
	 FPastRNtwo1q94PJIOs6TfpCeiAlMMt9pYKrh0SgX8GTpoBHmTsk+Gz6rVhBjlq1DR
	 o2GgFcq73Fvn08k3r6EveUisU97lvDCFbQhsmP0w=
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
Subject: [PATCH 6.16 207/570] powerpc/thp: tracing: Hide hugepage events under CONFIG_PPC_BOOK3S_64
Date: Mon, 18 Aug 2025 14:43:14 +0200
Message-ID: <20250818124513.781921920@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



