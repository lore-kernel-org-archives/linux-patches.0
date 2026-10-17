Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE97B3890F8;
	Sat, 17 Oct 2026 18:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260846; cv=none; b=m8vNvVUuecm1U3UkvT+szVtMQgYFDcUwYUG8poNqOziUdc1Sy2OP/IQpsziQKcWpkujb8SNXEeNIJhXVoK5/rfK68wbYnmybc+RT1bUhaTkKcfFGT3WG0FaEQSUtqUmgpbIYmENSe2EOddjCWtqszU8sMzFi2r8jIB1bF8TheLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260846; c=relaxed/simple;
	bh=qmzHCG+/I6izpmmKRQLOvAGX4MKugHssWXABNlkksNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxhPXCzG8JAa2QWUJRKbUQzikMpCM2LwbnceDXHjsP60GMYbuYvJ5b8Hw3qs03zsUOoxvAslwYCNjmVx6uHUqPoM0yKGafiTLMOQp/Xcg59t9ntNoBLIgw6kdabDHn4mDG8PmnPosTwGattH08An2GOrLg48JAk1fFZGPhCoqcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZBqSMsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZBqSMsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014D01F000C4;
	Sat, 17 Oct 2026 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260844;
	bh=reSbJ9fYqK/L3Rz8mlso8ZhEaAXkBG9FUFl50jry5y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZBqSMsSOMFprMO0oegxmkMp4JyTBLjJdCcLgRgr4aa9sau8ghq0FhZLaA9brMxpi
	 CjbktkVAcgYveCD+zzA51aLG1lvYAe+/+A3mzERvfNCQWf3z8u/TdUhYI3TOPtxXTx
	 /U/U8zBFm7ZFJlQFXPu/MxdxJWB2zO9QY7Z+vk74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Shivank Garg <shivankg@amd.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Klara Modin <klarasmodin@gmail.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Minchan Kim <minchan@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sourav Panda <souravpanda@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wei Yang <richard.weiyang@gmail.com>,
	Will Deacon <will@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1672/1674] types: move struct rcuwait into types.h
Date: Sat, 17 Oct 2026 18:05:44 +0200
Message-ID: <20261017160513.981265639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit 2c2bd11caba2a45445c1f0c722451fe29e59db79 ]

Move rcuwait struct definition into types.h so that rcuwait can be used
without including rcuwait.h which includes other headers.  Without this
change mm_types.h can't use rcuwait due to a the following circular
dependency:

mm_types.h -> rcuwait.h -> signal.h -> mm_types.h

Link: https://lkml.kernel.org/r/20250213224655.1680278-7-surenb@google.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcuwait.h | 13 +------------
 include/linux/types.h   | 12 ++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index 27343424225cf..9ad134a04b415 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -4,18 +4,7 @@
 
 #include <linux/rcupdate.h>
 #include <linux/sched/signal.h>
-
-/*
- * rcuwait provides a way of blocking and waking up a single
- * task in an rcu-safe manner.
- *
- * The only time @task is non-nil is when a user is blocked (or
- * checking if it needs to) on a condition, and reset as soon as we
- * know that the condition has succeeded and are awoken.
- */
-struct rcuwait {
-	struct task_struct __rcu *task;
-};
+#include <linux/types.h>
 
 #define __RCUWAIT_INITIALIZER(name)		\
 	{ .task = NULL, }
diff --git a/include/linux/types.h b/include/linux/types.h
index 78d87c751ff58..ecacc613cfea4 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -245,5 +245,17 @@ typedef void (*swap_func_t)(void *a, void *b, int size);
 typedef int (*cmp_r_func_t)(const void *a, const void *b, const void *priv);
 typedef int (*cmp_func_t)(const void *a, const void *b);
 
+/*
+ * rcuwait provides a way of blocking and waking up a single
+ * task in an rcu-safe manner.
+ *
+ * The only time @task is non-nil is when a user is blocked (or
+ * checking if it needs to) on a condition, and reset as soon as we
+ * know that the condition has succeeded and are awoken.
+ */
+struct rcuwait {
+	struct task_struct __rcu *task;
+};
+
 #endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */
-- 
2.53.0



