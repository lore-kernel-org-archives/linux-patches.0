Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027535;
	b=opsiCDAYJBycJTCYclwCmtlhMXT1NA2wfY8zDi/UR4aXr+LeeLvSnJzsGWyBnmFLf7dQ
	 u7W1776m3xVTnp0lOm1c2lIWOgcaBBhuEcyhFuoV6n4TJNFXqvzFUCqlW1Jszgc/RPUxj
	 9gMaPv3fFNXIf4NkouwjSTL9iInvgMbgycm+OEhF/dDr9Q0xRt16CPbQMzQcaKJRstX18
	 8wYfkhX8ozhidp+ULsuvfWwwPzdkRC3X362p3FaFsv3OicXx/egBF3KUbIhBA08Ax9//L
	 G+S2Tu9nICroY5QJ+qKMwHXyWHYOnoGp1+oFNNeNQkvoZGYhFslnppSYFf7svHGuSjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1/+ZeivudvS+s7Q3PakNtzMpqzkOWK8xBzM/OujYfTE=;
	b=GHhgoDMfw86X/KvXQlF6I2S1rpQETle33VxPcPB/8X2EDJAz9yl5wyLI+OYHvjKTbeTf
	 nFbC7DUmAjj8UYm0i2ob2QbkukT7BQJIybpSBIOGrDmJFQAgJv5ZmzxVVrxAq7Viy1FZK
	 7FHrFU2cM0TndAOvxcmJW6HOM4j9NemJm9I0/2ndOKf0GCjhSKqbqg9XtEuCwsPmbTXqD
	 5wjwOYYPZriJwBCU9t7L50dm/Y2U5hsgyLxf1lyfODkcKbs73F+Jp0uO7vXKYzWbsAsXN
	 QrOdKHTXJyOC5Q3xGwltSwY4/GksUzIPEZWdJtP6n5MnyMXY7P+necV322DvcfgQxpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gudJlw1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B29C60A2612;
	Wed, 18 Nov 2026 18:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gudJlw1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C781F000C6;
	Wed, 18 Nov 2026 18:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027535;
	bh=1/+ZeivudvS+s7Q3PakNtzMpqzkOWK8xBzM/OujYfTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gudJlw1jB1pyGz9V1JajBPO3B1V0xoRxu30QnPHe/MKIvOdhvQIfGVGv9zLZSRhhq
	 C/eAJoJjIin3B/4is/RqSNKgRQTgG3rt5DdWhT9OtXQJWIE5+qyRSVB+8CxNTB7Zdj
	 iE4y9mjsLjvZeuAVcUm15pM4z0tCcbb2EPzBugcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinpyo Lee <bint4b13@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1783/2151] nfs/localio: pin UUIDs during global invalidation
Date: Wed, 18 Nov 2026 15:58:38 +0100
Message-ID: <20261118150226.776590990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jinpyo Lee <bint4b13@gmail.com>

[ Upstream commit 62e14699c4dfc98c514a44bf780678cf8622fc08 ]

nfs_localio_invalidate_clients() moves UUID nodes embedded in nfs_client
objects to a private list, then walks that list without retaining the
containing clients. Concurrent client teardown can free an entry that
the iterator has already selected, causing a use-after-free.

Take a reference to each selected UUID under the namespace list lock.
Keep this reference count in nfs_common, independently of cl_count, and
have nfs_free_client() drain temporary UUID users before freeing the
client. Releasing a UUID reference wakes waiting probes and signals
completion when the last reference is dropped. It neither calls into
nfs.ko nor performs final NFS client teardown in the NFSD invalidation
context.

Keep the UUID on the namespace list until its files have been closed.
When another thread is already disabling it, wait for that thread to
finish unlinking it instead of repeatedly selecting the same head entry.
The wait releases the UUID spinlock so file cleanup can make progress.

Append registrations in sequence order and capture the last sequence
under the namespace list lock at the start of invalidation. Stop at that
boundary so new registrations cannot indefinitely extend the sweep,
even if its original last entry is removed concurrently.

Publish the LOCALIO association under the UUID and namespace list locks
before making the entry visible to invalidation. A temporary UUID
reference allows the handshake to drop the global lookup lock before
taking the UUID lock in the documented order; recheck the lookup in case
the probe was withdrawn. A new probe waits for temporary UUID users to
drain, then rechecks the association before reusing the UUID. This keeps
a transient invalidation reference from discarding the client's LOCALIO
revalidation attempt. Withdraw pending probes before dropping the owner's
UUID reference.

A deterministic same-base KASAN reproducer triggered the reported
use-after-free on the unpatched tree. With this patch, the same controlled
invalidation and teardown race completed without the target KASAN report
or another selected kernel diagnostic. A separate all-live run recorded
disable events for all 16 unique clients.

Test-only synchronization hooks verified that a second disabler waits for
unlink after ->net is cleared and that client teardown waits for a
temporary UUID reference to drain. NFSv4.2 and NFSv3 read, write, and
unmount smoke tests, export-flush and I/O stress, NFSD restarts, network
namespace lifecycle tests, and module unloads passed with KASAN and
lockdep enabled.

A full x86_64 kernel and modules build with GCC 13.3, CONFIG_WERROR=y,
NFS_FS=m, NFSD=m, and LOCALIO enabled completed without diagnostics.
Module metadata showed that nfs_localio.ko depends only on sunrpc, while
nfs.ko depends on lockd, nfs_localio, and sunrpc.

A separate NFS_FS=m, NFSD=y build also linked vmlinux successfully.

The vulnerability research and validation were conducted by members of
the Tobabz team as part of the Best of the Best 15th program.

Fixes: 085804110aa1 ("nfs_common: track all open nfsd_files per LOCALIO nfs_client")
Assisted-by: LLM
Signed-off-by: Jinpyo Lee <bint4b13@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c            |   2 +-
 fs/nfs_common/nfslocalio.c | 101 +++++++++++++++++++++++++++++++------
 include/linux/nfslocalio.h |  12 +++++
 3 files changed, 98 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index e3cd92b5aaa39..c1c6f628aa4e7 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -256,7 +256,7 @@ static void pnfs_init_server(struct nfs_server *server)
  */
 void nfs_free_client(struct nfs_client *clp)
 {
-	nfs_localio_disable_client(clp);
+	nfs_localio_free_client(clp);
 
 	/* -EIO all pending I/O */
 	if (!IS_ERR(clp->cl_rpcclient))
diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index 85aa03a7b020c..1423a43dbd6e9 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -24,6 +24,26 @@ static DEFINE_SPINLOCK(nfs_uuids_lock);
  * that is protected by nfs_uuids_lock.
  */
 static LIST_HEAD(nfs_uuids);
+/* Namespace registration order, protected by nfs_uuids_lock. */
+static u64 nfs_uuid_seq;
+
+/* The owner waits for temporary users before freeing its nfs_client. */
+static void nfs_uuid_get(nfs_uuid_t *nfs_uuid)
+{
+	refcount_inc(&nfs_uuid->refs);
+}
+
+static void nfs_uuid_release(nfs_uuid_t *nfs_uuid)
+{
+	bool released;
+
+	spin_lock(&nfs_uuid->lock);
+	released = refcount_dec_and_test(&nfs_uuid->refs);
+	wake_up_var_locked(&nfs_uuid->refs, &nfs_uuid->lock);
+	spin_unlock(&nfs_uuid->lock);
+	if (released)
+		complete(&nfs_uuid->released);
+}
 
 /*
  * Lock ordering:
@@ -43,6 +63,8 @@ void nfs_uuid_init(nfs_uuid_t *nfs_uuid)
 	INIT_LIST_HEAD(&nfs_uuid->list);
 	INIT_LIST_HEAD(&nfs_uuid->files);
 	spin_lock_init(&nfs_uuid->lock);
+	refcount_set(&nfs_uuid->refs, 1);
+	init_completion(&nfs_uuid->released);
 	nfs_uuid->nfs3_localio_probe_count = 0;
 }
 EXPORT_SYMBOL_GPL(nfs_uuid_init);
@@ -50,7 +72,12 @@ EXPORT_SYMBOL_GPL(nfs_uuid_init);
 bool nfs_uuid_begin(nfs_uuid_t *nfs_uuid)
 {
 	spin_lock(&nfs_uuid->lock);
-	if (rcu_access_pointer(nfs_uuid->net)) {
+	/* The caller retains the client while temporary UUID users drain. */
+	wait_var_event_spinlock(&nfs_uuid->refs,
+				refcount_read(&nfs_uuid->refs) <= 1,
+				&nfs_uuid->lock);
+	if (rcu_access_pointer(nfs_uuid->net) || nfs_uuid->list_lock ||
+	    refcount_read(&nfs_uuid->refs) != 1) {
 		/* This nfs_uuid is already in use */
 		spin_unlock(&nfs_uuid->lock);
 		return false;
@@ -77,7 +104,7 @@ void nfs_uuid_end(nfs_uuid_t *nfs_uuid)
 {
 	if (!rcu_access_pointer(nfs_uuid->net)) {
 		spin_lock(&nfs_uuid->lock);
-		if (!rcu_access_pointer(nfs_uuid->net)) {
+		if (!rcu_access_pointer(nfs_uuid->net) && !nfs_uuid->list_lock) {
 			/* Not local, remove from nfs_uuids */
 			spin_lock(&nfs_uuids_lock);
 			list_del_init(&nfs_uuid->list);
@@ -113,28 +140,37 @@ void nfs_uuid_is_local(const uuid_t *uuid, struct list_head *list,
 		spin_unlock(&nfs_uuids_lock);
 		return;
 	}
+	/* Drop the lookup lock before taking nfs_uuid->lock. */
+	nfs_uuid_get(nfs_uuid);
+	spin_unlock(&nfs_uuids_lock);
+
+	spin_lock(&nfs_uuid->lock);
+	spin_lock(&nfs_uuids_lock);
+	/* nfs_uuid_end() may have withdrawn the probe in the meantime. */
+	if (nfs_uuid_lookup_locked(uuid) != nfs_uuid)
+		goto out_unlock;
 
 	/*
 	 * We don't hold a ref on the net, but instead put
 	 * ourselves on @list (nn->local_clients) so the net
 	 * pointer can be invalidated.
 	 */
-	spin_lock(list_lock); /* list_lock is nn->local_clients_lock */
-	list_move(&nfs_uuid->list, list);
-	spin_unlock(list_lock);
-
-	spin_unlock(&nfs_uuids_lock);
-	/* Once nfs_uuid is parented to @list, avoid global nfs_uuids_lock */
-	spin_lock(&nfs_uuid->lock);
-
 	__module_get(mod);
 	nfsd_mod = mod;
 
+	spin_lock(list_lock); /* list_lock is nn->local_clients_lock */
 	nfs_uuid->list_lock = list_lock;
 	kref_get(&dom->ref);
 	nfs_uuid->dom = dom;
 	rcu_assign_pointer(nfs_uuid->net, net);
+	nfs_uuid->seq = ++nfs_uuid_seq;
+	list_move_tail(&nfs_uuid->list, list);
+	spin_unlock(list_lock);
+
+out_unlock:
+	spin_unlock(&nfs_uuids_lock);
 	spin_unlock(&nfs_uuid->lock);
+	nfs_uuid_release(nfs_uuid);
 }
 EXPORT_SYMBOL_GPL(nfs_uuid_is_local);
 
@@ -154,6 +190,10 @@ static bool nfs_uuid_put(nfs_uuid_t *nfs_uuid)
 	struct nfs_file_localio *nfl;
 
 	spin_lock(&nfs_uuid->lock);
+	/* A concurrent disabler can drop the lock while closing files. */
+	wait_var_event_spinlock(&nfs_uuid->list_lock,
+				rcu_access_pointer(nfs_uuid->net) ||
+				!nfs_uuid->list_lock, &nfs_uuid->lock);
 	if (unlikely(!rcu_access_pointer(nfs_uuid->net))) {
 		spin_unlock(&nfs_uuid->lock);
 		return false;
@@ -211,6 +251,7 @@ static bool nfs_uuid_put(nfs_uuid_t *nfs_uuid)
 	}
 
 	module_put(nfsd_mod);
+	wake_up_var_locked(&nfs_uuid->list_lock, &nfs_uuid->lock);
 	spin_unlock(&nfs_uuid->lock);
 
 	return true;
@@ -223,22 +264,50 @@ void nfs_localio_disable_client(struct nfs_client *clp)
 }
 EXPORT_SYMBOL_GPL(nfs_localio_disable_client);
 
+void nfs_localio_free_client(struct nfs_client *clp)
+{
+	nfs_uuid_t *nfs_uuid = &clp->cl_uuid;
+
+	nfs_uuid_end(nfs_uuid);
+	nfs_localio_disable_client(clp);
+	/* Unlink before dropping the owner reference, then drain all users. */
+	nfs_uuid_release(nfs_uuid);
+	wait_for_completion(&nfs_uuid->released);
+}
+EXPORT_SYMBOL_GPL(nfs_localio_free_client);
+
 void nfs_localio_invalidate_clients(struct list_head *nn_local_clients,
 				    spinlock_t *nn_local_clients_lock)
 {
-	LIST_HEAD(local_clients);
-	nfs_uuid_t *nfs_uuid, *tmp;
+	nfs_uuid_t *nfs_uuid;
 	struct nfs_client *clp;
+	u64 last_seq;
 
 	spin_lock(nn_local_clients_lock);
-	list_splice_init(nn_local_clients, &local_clients);
-	spin_unlock(nn_local_clients_lock);
-	list_for_each_entry_safe(nfs_uuid, tmp, &local_clients, list) {
-		if (WARN_ON(nfs_uuid->list_lock != nn_local_clients_lock))
+	if (list_empty(nn_local_clients))
+		goto out_unlock;
+	/* New registrations go to the tail and belong to a later sweep. */
+	last_seq = list_last_entry(nn_local_clients, nfs_uuid_t, list)->seq;
+	for (;;) {
+		nfs_uuid = list_first_entry_or_null(nn_local_clients,
+						    nfs_uuid_t, list);
+		/* Use a signed difference to allow the sequence to wrap. */
+		if (!nfs_uuid || (s64)(nfs_uuid->seq - last_seq) > 0)
 			break;
+		if (WARN_ON_ONCE(nfs_uuid->list_lock != nn_local_clients_lock))
+			break;
+		/* Teardown unlinks under this lock before dropping its reference. */
+		nfs_uuid_get(nfs_uuid);
+		spin_unlock(nn_local_clients_lock);
+
 		clp = container_of(nfs_uuid, struct nfs_client, cl_uuid);
 		nfs_localio_disable_client(clp);
+		nfs_uuid_release(nfs_uuid);
+		cond_resched();
+		spin_lock(nn_local_clients_lock);
 	}
+out_unlock:
+	spin_unlock(nn_local_clients_lock);
 }
 EXPORT_SYMBOL_GPL(nfs_localio_invalidate_clients);
 
diff --git a/include/linux/nfslocalio.h b/include/linux/nfslocalio.h
index 3d91043254e64..1a8cfb045abc7 100644
--- a/include/linux/nfslocalio.h
+++ b/include/linux/nfslocalio.h
@@ -8,8 +8,10 @@
 
 #if IS_ENABLED(CONFIG_NFS_LOCALIO)
 
+#include <linux/completion.h>
 #include <linux/module.h>
 #include <linux/list.h>
+#include <linux/refcount.h>
 #include <linux/uuid.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svcauth.h>
@@ -28,6 +30,11 @@ struct nfs_file_localio;
 typedef struct {
 	uuid_t uuid;
 	unsigned nfs3_localio_probe_count;
+	/* Owner reference plus temporary references held by nfs_common */
+	refcount_t refs;
+	struct completion released;
+	/* Namespace registration order, protected by list_lock */
+	u64 seq;
 	/* this struct is over a cacheline, avoid bouncing */
 	spinlock_t ____cacheline_aligned lock;
 	struct list_head list;
@@ -46,6 +53,7 @@ void nfs_uuid_is_local(const uuid_t *, struct list_head *, spinlock_t *,
 
 void nfs_localio_enable_client(struct nfs_client *clp);
 void nfs_localio_disable_client(struct nfs_client *clp);
+void nfs_localio_free_client(struct nfs_client *clp);
 void nfs_localio_invalidate_clients(struct list_head *nn_local_clients,
 				    spinlock_t *nn_local_clients_lock);
 
@@ -118,6 +126,10 @@ static inline void nfs_localio_disable_client(struct nfs_client *clp)
 {
 }
 
+static inline void nfs_localio_free_client(struct nfs_client *clp)
+{
+}
+
 #endif  /* CONFIG_NFS_LOCALIO */
 
 #endif  /* __LINUX_NFSLOCALIO_H */
-- 
2.53.0



