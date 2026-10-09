Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EA82D77F5;
	Fri,  9 Oct 2026 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557318; cv=none; b=aU4QpLABfw3G6C2Mj6eF3o8LRrHAwSbuQ36MLMjqkwFjQNZ9NlxblfUHZ04hmllEBr1vIvZcOhXl18TG7KIzNTJFxknBuJmNW/1PVHc9mFp5IhNizjBf1jgEH3zNkOiUnkh9R/zHW/ozwxBfM28jj6q75gn5R+q99qUOFqb3lS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557318; c=relaxed/simple;
	bh=8uRkMSh94gZVVnEKLf99Inj98T0CUGd9C1l71+vtsuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eE5gLWEU3fdS0whj0PrCf9ynqAkHvkjE7v9mwpwAudphXwT65Q5t+dMq2mREYST5sm9CszJzCss+wULLdpuahZ0aM77ZI4Mt021Qa+exqvICoZfIzTinYiX0wASf+BpvZMOYi+y6U5uu4TRurMxYQ+0a0m7G+8vOdatMN9s3oWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXapUSmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXapUSmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D185E1F000FF;
	Fri,  9 Oct 2026 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557317;
	bh=vo1X2iE81p+Gxq3pdl9vRppVUghH9aUJifYF8hmpOGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXapUSmHXElBgwaLoH9Htj+QzmisbsWrh4dqXF3oC5L5AUN2tGbp6XmAYVCHeKjrg
	 g6lMNcZWBi6BnyJKtExSSsfmlw9yjqZPhVVOu/RmO4afRqemFUv0X7TlobglAOUwZO
	 4kUQ655PbwN+9m9v1MhYQSiLNWLyj2eRMbdj89dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/403] unwind: Shorten lines
Date: Fri,  9 Oct 2026 16:12:22 +0200
Message-ID: <20261009141001.236372766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c31b9d2f589463a7cb286467a618b3b598654890 ]

There are some exceptionally long lines that cause ugly wrapping.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://patch.msgid.link/20250924080118.545274393@infradead.org
Stable-dep-of: b9d1fdc6f4ac ("perf: Replace perf_event_header__init_id with full header init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/unwind_deferred.h |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/include/linux/unwind_deferred.h
+++ b/include/linux/unwind_deferred.h
@@ -8,7 +8,9 @@
 
 struct unwind_work;
 
-typedef void (*unwind_callback_t)(struct unwind_work *work, struct unwind_stacktrace *trace, u64 cookie);
+typedef void (*unwind_callback_t)(struct unwind_work *work,
+				  struct unwind_stacktrace *trace,
+				  u64 cookie);
 
 struct unwind_work {
 	struct list_head		list;
@@ -68,9 +70,17 @@ static __always_inline void unwind_reset
 static inline void unwind_task_init(struct task_struct *task) {}
 static inline void unwind_task_free(struct task_struct *task) {}
 
-static inline int unwind_user_faultable(struct unwind_stacktrace *trace) { return -ENOSYS; }
-static inline int unwind_deferred_init(struct unwind_work *work, unwind_callback_t func) { return -ENOSYS; }
-static inline int unwind_deferred_request(struct unwind_work *work, u64 *timestamp) { return -ENOSYS; }
+static inline int unwind_user_faultable(struct unwind_stacktrace *trace)
+{ return -ENOSYS; }
+
+static inline int
+unwind_deferred_init(struct unwind_work *work, unwind_callback_t func)
+{ return -ENOSYS; }
+
+static inline int
+unwind_deferred_request(struct unwind_work *work, u64 *timestamp)
+{ return -ENOSYS; }
+
 static inline void unwind_deferred_cancel(struct unwind_work *work) {}
 
 static inline void unwind_deferred_task_exit(struct task_struct *task) {}


