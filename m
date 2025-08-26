Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517B1D5147;
	Tue, 26 Aug 2025 12:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212883; cv=none; b=PoHWryubHDfXKJoj2iXp0rq/aftecih9YZbhUbejWGa0IYAWNp0xm8OPRTagOg/xoDm+GY3oFwXuUzQCFnDLEnujUTN4axodBGkaZJdY+GDUMwMHjxEvRNLFTCcDzw4Fe3odsWnbSdQsx9T1omz0QyNAHIkTWmPAp34XXpypfok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212883; c=relaxed/simple;
	bh=FlkqW8doSURFyMJGkP6Ei0wYitSBs24MS/JP5uF9b20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh+CgC+AWn7Fe1nC5bdooU97S3EGdw3fD+uE0pHLMplegoDVkOGxtg2NQeAuDgDMcUdqKDXAZ8Z5NvlVdZ/mjRI289kH1xAnaZkNGzJhM38n4njIzy0E8Y23gaCijp10HVEKi64jquzfkJEgBoeck83bNTUTlW4ZMzKigy+T2bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVwM0+r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVwM0+r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4473C4CEF1;
	Tue, 26 Aug 2025 12:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212883;
	bh=FlkqW8doSURFyMJGkP6Ei0wYitSBs24MS/JP5uF9b20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVwM0+r+4khEMgECcldeMjp9oZqNT0hNPPxuML0cqAc2Yxi1w3RUio9DfyeAf0XoO
	 9UT4I9AprRDHMdrGey8W+15YNMzOiKdPs/bHWr0FUleViQbIHDGlunEAOr0C9mu/D+
	 2obZRNojUtavsXMcV1+jvIZiFgsWHWAYq/UA7jG8=
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
Subject: [PATCH 6.6 139/587] powerpc/thp: tracing: Hide hugepage events under CONFIG_PPC_BOOK3S_64
Date: Tue, 26 Aug 2025 13:04:48 +0200
Message-ID: <20250826110956.488944075@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



