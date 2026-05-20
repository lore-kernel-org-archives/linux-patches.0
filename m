Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2873EE1DA;
	Wed, 20 May 2026 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294557; cv=none; b=ZVO+M8VLCFquxAwaT1nHHyZsBvarCYbDOP6d/Euw6EAIJqjc7CB42mH0oCglPv3xtfoWpQXclPOASQ90+82+EjzjEr2ytbThEtwtxN+c+ia6FU7xp9AQssuT3LjGyDS0VOulHS8bULc77R/TRmCBVD70S4NUjHlG/3w2e9bXeXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294557; c=relaxed/simple;
	bh=n8aCt7folw2SdNWSaG+NBg5Qv9LoFbg9SkjQxq6QN5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4HDoC88dEVTLcPoUaZQYSar7ZCuyHh2STjgR8zM5iGph/VFb6paTYQQd1zpqd/AE4oJR6xFCl1gput6Aj/24I4x4Gt8n/BF+OJYV6tlSFTYzfIew+lwQ63qXhNxm+Rp73pjtXPVInugHlplQVEpj4sHXm79GGcuUlHL34WvoBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFPkCC5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFPkCC5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6876C1F00893;
	Wed, 20 May 2026 16:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294555;
	bh=NOHmzKfcRu9SrDUDh38LyNoCUq7BvuSEOwrJ5SF2M5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFPkCC5KrgMb/QaYAx8gzmuJV6TZ0B7BLO6NzCfUq1ZD8rOTVnhX/1D14LCPJTDaC
	 HDVTXmkjo7foi6a+ivIXHNVD+AXrNm2jAN4Re4lcjZJDf4sIVHPQbqPDa1wEQp0aQa
	 fVfMk+BRV9rzFMyPoFIQtaYYUNGPcpY3I8Nor1L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0043/1146] locking/mutex: Rename mutex_init_lockep()
Date: Wed, 20 May 2026 18:04:53 +0200
Message-ID: <20260520162149.355602526@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 8b65eb52d93e4e496bd26e6867152344554eb39e ]

Typo, this wants to be _lockdep().

Fixes: 51d7a054521d ("locking/mutex: Redo __mutex_init() to reduce generated code size")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260217191512.1180151-2-dave@stgolabs.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mutex.h  | 4 ++--
 kernel/locking/mutex.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index ecaa0440f6ec4..8126da9590886 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -87,12 +87,12 @@ do {									\
 	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-void mutex_init_lockep(struct mutex *lock, const char *name, struct lock_class_key *key);
+void mutex_init_lockdep(struct mutex *lock, const char *name, struct lock_class_key *key);
 
 static inline void __mutex_init(struct mutex *lock, const char *name,
 				struct lock_class_key *key)
 {
-	mutex_init_lockep(lock, name, key);
+	mutex_init_lockdep(lock, name, key);
 }
 #else
 extern void mutex_init_generic(struct mutex *lock);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 2a1d165b3167e..c867f6c15530d 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -171,7 +171,7 @@ static __always_inline bool __mutex_unlock_fast(struct mutex *lock)
 
 #else /* !CONFIG_DEBUG_LOCK_ALLOC */
 
-void mutex_init_lockep(struct mutex *lock, const char *name, struct lock_class_key *key)
+void mutex_init_lockdep(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
 	__mutex_init_generic(lock);
 
@@ -181,7 +181,7 @@ void mutex_init_lockep(struct mutex *lock, const char *name, struct lock_class_k
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map_wait(&lock->dep_map, name, key, 0, LD_WAIT_SLEEP);
 }
-EXPORT_SYMBOL(mutex_init_lockep);
+EXPORT_SYMBOL(mutex_init_lockdep);
 #endif /* !CONFIG_DEBUG_LOCK_ALLOC */
 
 static inline void __mutex_set_flag(struct mutex *lock, unsigned long flag)
-- 
2.53.0



