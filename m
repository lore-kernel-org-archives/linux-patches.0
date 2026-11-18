Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050331;
	b=BUZs18joJZfHD64QvegYsUyLj+7eYzZfvxr154q395Vc1G3QlwVfVxnopYA1oVk1L0eA
	 jb4Cgy9WKaEkJ1PCUkZ1g10+MyIidfRF8G+ziDlbBoKLGCgUb6WMMB/VDvryCLle6qrPX
	 SSiCtpFwrbZz4VU8skadmjgcAqvwLkqV2u/quAeoSfA41yHjTP1qqyFPr6Vu10F6vl2RC
	 +zbQKsmZ2d4Qn4FalaC640OLctE4++w3pq048nDn4ioV7gaWbEne/wxfVkafBs2f7fcBG
	 PMr+pochCqHEgT4fFF2T22TsOv6JBuKR/1C+McM7TPCW8WyhkjXQclb0ESbFFoJhl3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5DQMXqK8tZJuxjeqPlZnhQPgJguWiXPzfHVYnG2QyR0=;
	b=MZliC3XsDMRw6nyVJRpnwzrvkYdIhGn5KKAGy5/aogp5L6sqLTAhYSvF9+jJpCS5JHHa
	 7wmlGEIqUYFLZgwc8uXJ7U3QPAJ/wXKOP2NrfAntBt8vDa8bnATnR7H4a/prMweW7aS4s
	 akFLQkoYQATfkq0Qz/ydIFimzy+4vj8KCmcxIi0ep5589NZ7lOdlL2POvOI/Tz8Q68kSq
	 dNK7iHHoAgCXgEcYYQZhWj+0uKgI/lmefM/kdp/GolKIr1kNre/zufS7x+QQ3Ju9FDqRn
	 KsMInbA6OnX1maefBoGpMK/b6v1xBnCcZH+LYHAHuBHgTyJht6iATTvGieCj1xj8uew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GTAQYNZ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A550606A320;
	Thu, 19 Nov 2026 01:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GTAQYNZ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D8F1F000C5;
	Thu, 19 Nov 2026 01:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050331;
	bh=5DQMXqK8tZJuxjeqPlZnhQPgJguWiXPzfHVYnG2QyR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTAQYNZ5Qg2uJ7WtBb/6+Ynx505dejlYlSnLaNk3gmeEfUOhvN7tJ/DKVOHufzlm4
	 QLLw0e3td0/MdmGskNekfm3JQyoUlVBei1npr7k9zZAGkyiVrRA0e2gL3LIOspy2WF
	 3Q4BgQblNJhugkpMKIQCyP2YuhPde8BzYVRVGfuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2629/2857] cleanup: Add conditional guard support
Date: Wed, 18 Nov 2026 16:01:03 +0100
Message-ID: <20261118150336.251558572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e4ab322fbaaaf84b23d6cb0e3317a7f68baf36dc ]

Adds:

 - DEFINE_GUARD_COND() / DEFINE_LOCK_GUARD_1_COND() to extend existing
   guards with conditional lock primitives, eg. mutex_trylock(),
   mutex_lock_interruptible().

   nb. both primitives allow NULL 'locks', which cause the lock to
       fail (obviously).

 - extends scoped_guard() to not take the body when the the
   conditional guard 'fails'. eg.

     scoped_guard (mutex_intr, &task->signal_cred_guard_mutex) {
	...
     }

   will only execute the body when the mutex is held.

 - provides scoped_cond_guard(name, fail, args...); which extends
   scoped_guard() to do fail when the lock-acquire fails.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20231102110706.460851167%40infradead.org
Stable-dep-of: bb4834d5242c ("ALSA: pcm: Protect channel-map reads against runtime detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cleanup.h  | 52 +++++++++++++++++++++++++++++++++++++---
 include/linux/mutex.h    |  3 ++-
 include/linux/rwsem.h    |  8 +++----
 include/linux/spinlock.h | 15 ++++++++++++
 4 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 53f1a7a932b08..6d7bfa899df02 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -92,25 +92,55 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
  *	trivial wrapper around DEFINE_CLASS() above specifically
  *	for locks.
  *
+ * DEFINE_GUARD_COND(name, ext, condlock)
+ *	wrapper around EXTEND_CLASS above to add conditional lock
+ *	variants to a base class, eg. mutex_trylock() or
+ *	mutex_lock_interruptible().
+ *
  * guard(name):
- *	an anonymous instance of the (guard) class
+ *	an anonymous instance of the (guard) class, not recommended for
+ *	conditional locks.
  *
  * scoped_guard (name, args...) { }:
  *	similar to CLASS(name, scope)(args), except the variable (with the
  *	explicit name 'scope') is declard in a for-loop such that its scope is
  *	bound to the next (compound) statement.
  *
+ *	for conditional locks the loop body is skipped when the lock is not
+ *	acquired.
+ *
+ * scoped_cond_guard (name, fail, args...) { }:
+ *      similar to scoped_guard(), except it does fail when the lock
+ *      acquire fails.
+ *
  */
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
-	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T)
+	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
+	static inline void * class_##_name##_lock_ptr(class_##_name##_t *_T) \
+	{ return *_T; }
+
+#define DEFINE_GUARD_COND(_name, _ext, _condlock) \
+	EXTEND_CLASS(_name, _ext, \
+		     ({ void *_t = _T; if (_T && !(_condlock)) _t = NULL; _t; }), \
+		     class_##_name##_t _T) \
+	static inline void * class_##_name##_ext##_lock_ptr(class_##_name##_t *_T) \
+	{ return class_##_name##_lock_ptr(_T); }
 
 #define guard(_name) \
 	CLASS(_name, __UNIQUE_ID(guard))
 
+#define __guard_ptr(_name) class_##_name##_lock_ptr
+
 #define scoped_guard(_name, args...)					\
 	for (CLASS(_name, scope)(args),					\
-	     *done = NULL; !done; done = (void *)1)
+	     *done = NULL; __guard_ptr(_name)(&scope) && !done; done = (void *)1)
+
+#define scoped_cond_guard(_name, _fail, args...) \
+	for (CLASS(_name, scope)(args), \
+	     *done = NULL; !done; done = (void *)1) \
+		if (!__guard_ptr(_name)(&scope)) _fail; \
+		else
 
 /*
  * Additional helper macros for generating lock guards with types, either for
@@ -119,6 +149,7 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
  *
  * DEFINE_LOCK_GUARD_0(name, lock, unlock, ...)
  * DEFINE_LOCK_GUARD_1(name, type, lock, unlock, ...)
+ * DEFINE_LOCK_GUARD_1_COND(name, ext, condlock)
  *
  * will result in the following type:
  *
@@ -140,6 +171,11 @@ typedef struct {							\
 static inline void class_##_name##_destructor(class_##_name##_t *_T)	\
 {									\
 	if (_T->lock) { _unlock; }					\
+}									\
+									\
+static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
+{									\
+	return _T->lock;						\
 }
 
 
@@ -168,4 +204,14 @@ __DEFINE_LOCK_GUARD_1(_name, _type, _lock)
 __DEFINE_UNLOCK_GUARD(_name, void, _unlock, __VA_ARGS__)		\
 __DEFINE_LOCK_GUARD_0(_name, _lock)
 
+#define DEFINE_LOCK_GUARD_1_COND(_name, _ext, _condlock)		\
+	EXTEND_CLASS(_name, _ext,					\
+		     ({ class_##_name##_t _t = { .lock = l }, *_T = &_t;\
+		        if (_T->lock && !(_condlock)) _T->lock = NULL;	\
+			_t; }),						\
+		     typeof_member(class_##_name##_t, lock) l)		\
+	static inline void * class_##_name##_ext##_lock_ptr(class_##_name##_t *_T) \
+	{ return class_##_name##_lock_ptr(_T); }
+
+
 #endif /* __LINUX_GUARDS_H */
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 5b5630e58407a..e1c323c7d75ba 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -248,6 +248,7 @@ extern void mutex_unlock(struct mutex *lock);
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
 DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))
-DEFINE_FREE(mutex, struct mutex *, if (_T) mutex_unlock(_T))
+DEFINE_GUARD_COND(mutex, _try, mutex_trylock(_T))
+DEFINE_GUARD_COND(mutex, _intr, mutex_lock_interruptible(_T) == 0)
 
 #endif /* __LINUX_MUTEX_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 1dd530ce8b45b..9c29689ff505e 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -203,11 +203,11 @@ extern void up_read(struct rw_semaphore *sem);
 extern void up_write(struct rw_semaphore *sem);
 
 DEFINE_GUARD(rwsem_read, struct rw_semaphore *, down_read(_T), up_read(_T))
-DEFINE_GUARD(rwsem_write, struct rw_semaphore *, down_write(_T), up_write(_T))
-
-DEFINE_FREE(up_read, struct rw_semaphore *, if (_T) up_read(_T))
-DEFINE_FREE(up_write, struct rw_semaphore *, if (_T) up_write(_T))
+DEFINE_GUARD_COND(rwsem_read, _try, down_read_trylock(_T))
+DEFINE_GUARD_COND(rwsem_read, _intr, down_read_interruptible(_T) == 0)
 
+DEFINE_GUARD(rwsem_write, struct rw_semaphore *, down_write(_T), up_write(_T))
+DEFINE_GUARD_COND(rwsem_write, _try, down_write_trylock(_T))
 
 /*
  * downgrade write lock to read lock
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 83377540c369a..6a4c7cee005c4 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -498,6 +498,8 @@ DEFINE_LOCK_GUARD_1(raw_spinlock, raw_spinlock_t,
 		    raw_spin_lock(_T->lock),
 		    raw_spin_unlock(_T->lock))
 
+DEFINE_LOCK_GUARD_1_COND(raw_spinlock, _try, raw_spin_trylock(_T->lock))
+
 DEFINE_LOCK_GUARD_1(raw_spinlock_nested, raw_spinlock_t,
 		    raw_spin_lock_nested(_T->lock, SINGLE_DEPTH_NESTING),
 		    raw_spin_unlock(_T->lock))
@@ -506,23 +508,36 @@ DEFINE_LOCK_GUARD_1(raw_spinlock_irq, raw_spinlock_t,
 		    raw_spin_lock_irq(_T->lock),
 		    raw_spin_unlock_irq(_T->lock))
 
+DEFINE_LOCK_GUARD_1_COND(raw_spinlock_irq, _try, raw_spin_trylock_irq(_T->lock))
+
 DEFINE_LOCK_GUARD_1(raw_spinlock_irqsave, raw_spinlock_t,
 		    raw_spin_lock_irqsave(_T->lock, _T->flags),
 		    raw_spin_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
 
+DEFINE_LOCK_GUARD_1_COND(raw_spinlock_irqsave, _try,
+			 raw_spin_trylock_irqsave(_T->lock, _T->flags))
+
 DEFINE_LOCK_GUARD_1(spinlock, spinlock_t,
 		    spin_lock(_T->lock),
 		    spin_unlock(_T->lock))
 
+DEFINE_LOCK_GUARD_1_COND(spinlock, _try, spin_trylock(_T->lock))
+
 DEFINE_LOCK_GUARD_1(spinlock_irq, spinlock_t,
 		    spin_lock_irq(_T->lock),
 		    spin_unlock_irq(_T->lock))
 
+DEFINE_LOCK_GUARD_1_COND(spinlock_irq, _try,
+			 spin_trylock_irq(_T->lock))
+
 DEFINE_LOCK_GUARD_1(spinlock_irqsave, spinlock_t,
 		    spin_lock_irqsave(_T->lock, _T->flags),
 		    spin_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
 
+DEFINE_LOCK_GUARD_1_COND(spinlock_irqsave, _try,
+			 spin_trylock_irqsave(_T->lock, _T->flags))
+
 #undef __LINUX_INSIDE_SPINLOCK_H
 #endif /* __LINUX_SPINLOCK_H */
-- 
2.53.0



