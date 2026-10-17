Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31543B813A;
	Sat, 17 Oct 2026 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255706; cv=none; b=ZBVKkFUhhna1fr7kuMdkvDZ3TYzgCcCKkDWOIuD9fqMKib6KNhYcU8CLwAl5wLrr75DvUWrEsDrewzMY4lODG44sXnJ7yguZWbSB81nVZuRBQuLl7I38GJ5w2rfzzM7rmwbybMpIwgI+k7K+v2dfFnw85u8vjv/QFf2ksSdNl/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255706; c=relaxed/simple;
	bh=E6xgosJ2A0A4NJ+fIlUKOxQ1TPda2v+89Zyu78jbB+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anVNdMVMdNadxF881FAFsCdFic9zLs7XCK79x673YP5ImwGfbZGcf4sChrrupR4AkQ+s2gQi9XLPqaPx45wFh+iFgX+P8P2SuwDFUKKgck7DfM98vufDuUxn3yArj6GwH8vKq/NIrODYfubwL6oQsRG5ipVIukrObnkaMilLOg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIVerywr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIVerywr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158F51F000C4;
	Sat, 17 Oct 2026 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255704;
	bh=V4yd+EdzJUdlvI6wVpANN8ZABaGFBAE4PV8lwrJ1fCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIVerywrrTFWOyKNrbRJPyUvw+pjfpUUEAYbQhXPEq4Nhwh7Tl7FvCQ6Ep+8+pB/Z
	 Up7s+qkZcmMVPEBk33pD/GEMoEXId6s2LhfwUA5cEP7Kq82Suwe695dxnokhPuK3mv
	 c75ltELtMO3tRPKgaF3DsVKLaks05eFjHPor57X8=
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
Subject: [PATCH 6.12 864/869] types: move struct rcuwait into types.h
Date: Sat, 17 Oct 2026 18:01:45 +0200
Message-ID: <20261017160059.010447416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2d7b9ae8714ce..f1356a9a5730a 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -248,5 +248,17 @@ typedef void (*swap_func_t)(void *a, void *b, int size);
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



