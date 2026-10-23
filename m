Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774161;
	b=Ptpp+pHY1kacOluf0QIEnfafwLkjWi/nGKL5NHfT6bKePWoseDAlIlXMIcMFWzSIcs7X
	 fs9I7uwgxzSD8OxVKsU85CItcrCTbJbFMFp1EYvC/wSDqm0rw8CzpQcQTDb31MyDGcRpQ
	 BuGbLfRwHVnZPsG99nITchVeQ7bMuvjA2iK/vZhWTUpOFyU4hiQnwQBhzFiHG+F/K3Fdz
	 Ij5uSFFtcmpgG+UMsdUgQwd665q+Tp6sj06m4X0rlu0mAunMk4Ct/Eyi7e6Ht0s+W1q70
	 43Xdlxpr9OhMiC/EepUe2JzlopnakHiG9KJcqrcy8fWoRYUMXE956IXWAo/l0wOs3TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=54OPQFxWp+RzAFqxiZfvn5Q5SA+5KuUK8TPdTTw41jw=;
	b=DM17hMry7rA8sC7VQn3aFaNbBTBOKmp5ZnG5xb+k+v2EadCN9Iw/DMxXGcXA6ZFfdQAj
	 ftbB9GOFZqf8IVKX4zTfRPKmqhpbPCcNbXi6LuxSypZYfA425+9Wk1cTaMZNTZhowRRO2
	 Pl7rbkEtJh4ZEpdRILS0yhr94QRU+9bmDMvBArp7NzUuLyZ4xKx8PnzNEhWu2r4rXAS06
	 uMWc08UenGpoXQNQYqhPz3tw7mRQcfjNDhuSPrGvbDAMfUJ1Cbh8OdhK8BTGUxAHgAmpr
	 /W2at0O/ZdmzLVDDqpfBIdKPovLmZp5NdotqTOOZNa/R+RSt31nXwB3uDj5U29Z4kdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8o7ZSYm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A3606A322;
	Fri, 23 Oct 2026 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8o7ZSYm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D821F01828;
	Fri, 23 Oct 2026 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774160;
	bh=54OPQFxWp+RzAFqxiZfvn5Q5SA+5KuUK8TPdTTw41jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8o7ZSYm8m01/JImi2VUTuPSIDLi6V4e85gUKKqZ/32GYnXZUy9cX602+6KySvBuG
	 uAcmGrsCnQcWZQceZHaut72BI36JOgkCYVyVDK6paPaNGTcXpFKnJCD1T8LZDSgOTY
	 pqR07Ybixoe3EDJMGNqD9tZeE+ChtV5Jre4Ujru8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 093/193] perf: Track the perf mlock gift separately
Date: Fri, 23 Oct 2026 18:36:10 +0200
Message-ID: <20261023163716.406574653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 78436f3882fb8d848c823bf8cf754988202c5ca5 upstream.

The locked_vm field in struct user_struct was originally introduced by
commit 789f90fcf6b0 ("perf_counter: per user mlock gift") to provide an
mlock-like budget for perf measured against mm->pinned_vm (since 2011).

perf grants each user a 'gift' of perf_event_mlock_kb * online CPUs of
buffer pages which is charged to user->locked_vm without any RLIMIT_MEMLOCK
check.

Only pages beyond the gift are checked against RLIMIT_MEMLOCK, per-mm, via
mm->pinned_vm, which makes it different from the standard mlock() check,
which is per-mm and made against RLIMIT_MEMLOCK.

However, since this was introduced, a number of other components have
utilised this field where a shared resource needed to be limited against
RLIMIT_MEMLOCK.

The other users are currently MSG_ZEROCOPY, io_uring, AF_XDP, iommufd,
s390 KVM zPCI and most recently, secretmem in commit 97d34aa65c29
("mm/secretmem: properly account locked pages").

This field is shared between all of these, but because the gift is not
checked against RLIMIT_MEMLOCK, user->locked_vm alone can exceed it - 16
CPUs * 516 KiB is already more than the default 8 MiB - after which every
other user of the field fails unconditionally.

This was reported by a user who saw secretmem failing while running a
simultaneous perf record.

Resolve the issue by simply giving perf its own field separate from the
rest.

BPF used user->locked_vm up until commit 80ee81e0403c ("bpf: Eliminate
rlimit-based memory accounting infra for bpf maps") which landed in 5.11.

Thus also eliminate the now-defunct ifdef for CONFIG_BPF_SYSCALL for
user->locked_vm.

This issue exists between all of the components which use user->locked_vm
and perf, however secretmem is the first user who has caused a report over
many years and has been backported, so target the fix at that.

Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
Closes: https://lore.kernel.org/20261002175651.811343-1-ameer.hamza@truenas.com
Reported-by: Ameer Hamza <ameer.hamza@truenas.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261003-perf-locked-vm-fix-v1-1-d214dcaf0d76@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/user.h |    8 +++++---
 kernel/events/core.c       |   12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -23,11 +23,13 @@ struct user_struct {
 	struct hlist_node uidhash_node;
 	kuid_t uid;
 
-#if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
-	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
+#if defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
 	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD) || \
 	defined(CONFIG_SECRETMEM)
-	atomic_long_t locked_vm;
+	atomic_long_t locked_vm;	/* pinned pages charged to RLIMIT_MEMLOCK */
+#endif
+#ifdef CONFIG_PERF_EVENTS
+	atomic_long_t perf_mlock;	/* perf buffer pages within perf_event_mlock_kb */
 #endif
 #ifdef CONFIG_WATCH_QUEUE
 	atomic_t nr_watches;	/* The number of watches this user currently has */
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6779,7 +6779,7 @@ static void perf_mmap_close(struct vm_ar
 		perf_pmu_output_stop(event);
 
 		/* now it's safe to free the pages */
-		atomic_long_sub(rb->aux_nr_pages - rb->aux_mmap_locked, &mmap_user->locked_vm);
+		atomic_long_sub(rb->aux_nr_pages - rb->aux_mmap_locked, &mmap_user->perf_mlock);
 		atomic64_sub(rb->aux_mmap_locked, &vma->vm_mm->pinned_vm);
 
 		/* this has to be the last one */
@@ -6961,11 +6961,11 @@ static bool perf_mmap_calc_limits(struct
 	/* Increase the limit linearly with more CPUs */
 	user_lock_limit *= num_online_cpus();
 
-	user_locked = atomic_long_read(&user->locked_vm);
+	user_locked = atomic_long_read(&user->perf_mlock);
 
 	/*
 	 * sysctl_perf_event_mlock may have changed, so that
-	 *     user->locked_vm > user_lock_limit
+	 *     user->perf_mlock > user_lock_limit
 	 */
 	if (user_locked > user_lock_limit)
 		user_locked = user_lock_limit;
@@ -6973,7 +6973,7 @@ static bool perf_mmap_calc_limits(struct
 
 	if (user_locked > user_lock_limit) {
 		/*
-		 * charge locked_vm until it hits user_lock_limit;
+		 * charge perf_mlock until it hits user_lock_limit;
 		 * charge the rest from pinned_vm
 		 */
 		*extra = user_locked - user_lock_limit;
@@ -6991,7 +6991,7 @@ static void perf_mmap_account(struct vm_
 {
 	struct user_struct *user = current_user();
 
-	atomic_long_add(user_extra, &user->locked_vm);
+	atomic_long_add(user_extra, &user->perf_mlock);
 	atomic64_add(extra, &vma->vm_mm->pinned_vm);
 }
 
@@ -7000,7 +7000,7 @@ static void perf_mmap_unaccount(struct v
 	struct user_struct *user = rb->mmap_user;
 
 	atomic_long_sub((perf_data_size(rb) >> PAGE_SHIFT) + 1 - rb->mmap_locked,
-			&user->locked_vm);
+			&user->perf_mlock);
 	atomic64_sub(rb->mmap_locked, &vma->vm_mm->pinned_vm);
 }
 


