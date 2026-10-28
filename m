Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212627;
	b=bNP5gpRpOGHgJg5UGzy+UT7HTJa47HvwhK7crgZGjAJbxKb9KpV2y7RjIsfZGIxxCFl5
	 jAOTM4BvAKoHbQs+wkla/4rtQSIGaHzCOFkJa0+ZOO3UBfRoYLdFcYvL1xHoZO4ER4kHz
	 PIBAk13qswZCKJNTpjDvCuu1whbp/PdVxmVR+1z5zSQGWO2Lv4SIEDd3NBKuJpGTmkODr
	 74RZC64BtncC3xK84QTghOIiZusVNMvW3QwGUaLXkMscUsSqNAwM90wxWsHctNREr5opN
	 z5BUf2znn82Ek+R1qmN0uPTk6up5LpCF+/sBcFpFwd92bMnSVkKWv0bWZ26jXpY5pmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d+BrUvzTXabKqK6UJyhl4XWortYZodTOXhrKvVvdGvg=;
	b=RRPN6MBiEbdde8RDhCSD01lQDZw6b4fCTL+2Y7uARhOQ0P6QHLXzEWzEz5JmSIlvV0ez
	 I8Zgrhz4WXZAwbSrTiwhQ8w3xLFFgRlbZjIUQjfyREnCZbj5exM6Et/mn3Y2ElEy9CbVD
	 xcTmXb/absV7zcdZTSm8eEb3x6EkVD7DzDs0G+FY6ZDyk1rqCs4koyDWHqQLvhEeVUi45
	 I1BMTL2rROrU3DYH44eQszBREP287hMPTEL2seExOQei8+EkcNikY1erICBn05S/SdCu5
	 jNpO0b+UI821klQyNdIhpBpvoJ57iIyMRn4LcQi6brEfeDXir+2BEEbF/Z+CkFGCMHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqpYPFgu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CA0606A31A;
	Wed, 28 Oct 2026 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqpYPFgu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BCE1F01825;
	Wed, 28 Oct 2026 18:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212626;
	bh=d+BrUvzTXabKqK6UJyhl4XWortYZodTOXhrKvVvdGvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqpYPFguskZxMfOrJ1sLzzGf+o/0QTKy9drItU/h+5abi9W8ByzpLyqLEZ9Lr2w+I
	 06U/5pYXDzQGxvFtDvzib8euVvPZXtiqLUhyOpaa8RDL4EjFYwZsESmfCgw8CcloA+
	 4fgBw9EGaM0K8ib72OErLMJ7J+aPXAv8a7Gbx4Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Hagen Paul Pfeifer <hagen@jauu.net>,
	Jakub Kacinski <kuba@kernel.org>,
	James Bottomley <james.bottomley@HansenPartnership.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0203/1887] mm/secretmem: properly account locked pages
Date: Wed, 28 Oct 2026 17:38:19 +0100
Message-ID: <20261028170503.854554901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 97d34aa65c29cca85e3e9050f4c936389b38a054 ]

secretmem accounts folios by treating memory as if it were mlock()'d and
thus limited by the RLIMIT_MEMLOCK limit.

However the folios are unevictable and remain so until the inode is
evicted, eliminating usual mlock() semantics - mapping folios then
unmapping them does not clear their unevictable state, since it depends on
AS_UNEVICTABLE, not PG_mlocked.

A user can therefore easily work around the RLIMIT_MEMLOCK limit - simply
map then unmap and VmLck no longer counts the secretmem range.  Worse,
folios are not accounted in the process's RSS, meaning the OOM killer
won't know to kill the process.

Repeatedly mapping/unmapping (or forking) can then result in the
consumption of all available system memory with unevictable folios and
cause system instability.

A secretmem fd can be passed between processes and over fork so a
per-process limit simply does not make sense, so follow the precedent set
by io_uring, perf, skbuff, iommufd and xdp by tracking the number of
locked pages in user_struct->locked_vm.

Since the scope tracked is actually inode lifetime, the RLIMIT_MEMLOCK
applies per-user not per-process, so it doesn't make sense to bypass for
users with CAP_IPC_LOCK, therefore remove this bypass.

There is simply no reason to carry on marking the mapping as mlock()'d
since it's misleading and the lifecycle is now correctly handled, so
remove this too.

Note that secretmem does not support any form of truncation (including
hole punching) and the folios are unreclaimable, so the folios need only
be accounted on fault and unaccounted on inode destruction.

__secretmem_account_pages() is more or less a duplicate of the code that
io_uring etc.  use, but since this is a bug fix that needs backporting,
defer any de-duplication efforts to a follow-up.

test_mlock_limit() asserts mlock_future_ok() on mmap(), however this has
been removed, so remove the test altogether for the fix.  A new test will
be sent separately for upstream.

Link: https://lore.kernel.org/20260826-secretmem-accounting-v3-1-94cb04399510@kernel.org
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20260813225328.2010303-1-4ncienth@gmail.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Daehyeon Ko <4ncienth@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted folio-based fault handling to Linux 6.1’s page-based APIs using page_folio(page) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/user.h                |   3 +-
 mm/secretmem.c                            | 119 ++++++++++++++++++++--
 tools/testing/selftests/vm/memfd_secret.c |  30 +-----
 3 files changed, 112 insertions(+), 40 deletions(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 4cc52698e214e..8d7e5521f7cdd 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -25,7 +25,8 @@ struct user_struct {
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
 	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
-	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD)
+	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD) || \
+	defined(CONFIG_SECRETMEM)
 	atomic_long_t locked_vm;
 #endif
 #ifdef CONFIG_WATCH_QUEUE
diff --git a/mm/secretmem.c b/mm/secretmem.c
index b570a6e25b6be..84d10092ecb03 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -18,6 +18,9 @@
 #include <linux/secretmem.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/user.h>
+#include <linux/cred.h>
+#include <linux/slab.h>
 
 #include <uapi/linux/magic.h>
 
@@ -47,10 +50,69 @@ bool secretmem_active(void)
 	return !!atomic_read(&secretmem_users);
 }
 
+struct secretmem_inode_state {
+	struct user_struct	*user;
+	atomic_long_t		nr_pages_accounted;
+};
+
+static bool __secretmem_account_pages(struct user_struct *user,
+		unsigned long nr_pages)
+{
+	unsigned long page_limit, cur_pages, new_pages;
+
+	if (!nr_pages)
+		return true;
+
+	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	cur_pages = atomic_long_read(&user->locked_vm);
+	do {
+		new_pages = cur_pages + nr_pages;
+		if (new_pages > page_limit)
+			return false;
+	} while (!atomic_long_try_cmpxchg(&user->locked_vm,
+					  &cur_pages, new_pages));
+	return true;
+}
+
+static bool secretmem_account_folio(struct secretmem_inode_state *state,
+		struct folio *folio)
+{
+	const unsigned long nr_pages = folio_nr_pages(folio);
+
+	if (!__secretmem_account_pages(state->user, nr_pages))
+		return false;
+
+	atomic_long_add(nr_pages, &state->nr_pages_accounted);
+	return true;
+}
+
+static void __secretmem_unaccount_pages(struct secretmem_inode_state *state,
+		unsigned long nr_pages)
+{
+	atomic_long_sub(nr_pages, &state->user->locked_vm);
+	atomic_long_sub(nr_pages, &state->nr_pages_accounted);
+}
+
+static void secretmem_unaccount_folio(struct secretmem_inode_state *state,
+		struct folio *folio)
+{
+	__secretmem_unaccount_pages(state, folio_nr_pages(folio));
+}
+
+static void secretmem_unaccount_all_folios(struct secretmem_inode_state *state)
+{
+	const unsigned long nr_pages_accounted =
+		atomic_long_read(&state->nr_pages_accounted);
+
+	__secretmem_unaccount_pages(state, nr_pages_accounted);
+}
+
 static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct secretmem_inode_state *state = inode->i_private;
 	pgoff_t offset = vmf->pgoff;
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
@@ -72,8 +134,15 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			goto out;
 		}
 
+		if (!secretmem_account_folio(state, page_folio(page))) {
+			put_page(page);
+			ret = VM_FAULT_SIGBUS;
+			goto out;
+		}
+
 		err = set_direct_map_invalid_noflush(page);
 		if (err) {
+			secretmem_unaccount_folio(state, page_folio(page));
 			put_page(page);
 			ret = vmf_error(err);
 			goto out;
@@ -82,6 +151,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 		__SetPageUptodate(page);
 		err = add_to_page_cache_lru(page, mapping, offset, gfp);
 		if (unlikely(err)) {
+			secretmem_unaccount_folio(state, page_folio(page));
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
@@ -112,23 +182,30 @@ static const struct vm_operations_struct secretmem_vm_ops = {
 	.fault = secretmem_fault,
 };
 
+static void secretmem_destroy_inode_priv(struct inode *inode)
+{
+	struct secretmem_inode_state *state = inode->i_private;
+
+	secretmem_unaccount_all_folios(state);
+	free_uid(state->user);
+	kfree(state);
+	inode->i_private = NULL;
+}
+
 static int secretmem_release(struct inode *inode, struct file *file)
 {
 	atomic_dec(&secretmem_users);
+	secretmem_destroy_inode_priv(inode);
+
 	return 0;
 }
 
 static int secretmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	unsigned long len = vma->vm_end - vma->vm_start;
-
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
 		return -EINVAL;
 
-	if (mlock_future_check(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
-		return -EAGAIN;
-
-	vma->vm_flags |= VM_LOCKED | VM_DONTDUMP;
+	vma->vm_flags |= VM_DONTDUMP;
 	vma->vm_ops = &secretmem_vm_ops;
 
 	return 0;
@@ -188,19 +265,40 @@ static const struct inode_operations secretmem_iops = {
 
 static struct vfsmount *secretmem_mnt;
 
+static int secretmem_init_inode_priv(struct inode *inode)
+{
+	struct secretmem_inode_state *state;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	state->user = get_uid(current_user());
+	inode->i_private = state;
+	return 0;
+}
+
 static struct file *secretmem_file_create(unsigned long flags)
 {
 	struct file *file = ERR_PTR(-ENOMEM);
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
+	int err;
 
 	inode = anon_inode_make_secure_inode(secretmem_mnt->mnt_sb, anon_name, NULL);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
+
+	err = secretmem_init_inode_priv(inode);
+	if (err)
+		goto err_free_inode;
+
 	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
 				 O_RDWR, &secretmem_fops);
-	if (IS_ERR(file))
-		goto err_free_inode;
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_free_priv;
+	}
 
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_unevictable(inode->i_mapping);
@@ -213,10 +311,11 @@ static struct file *secretmem_file_create(unsigned long flags)
 	inode->i_size = 0;
 
 	return file;
-
+err_free_priv:
+	secretmem_destroy_inode_priv(inode);
 err_free_inode:
 	iput(inode);
-	return file;
+	return ERR_PTR(err);
 }
 
 SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
diff --git a/tools/testing/selftests/vm/memfd_secret.c b/tools/testing/selftests/vm/memfd_secret.c
index 9b298f6a04b37..348cc976726bb 100644
--- a/tools/testing/selftests/vm/memfd_secret.c
+++ b/tools/testing/selftests/vm/memfd_secret.c
@@ -56,33 +56,6 @@ static void test_file_apis(int fd)
 		pass("file IO is blocked as expected\n");
 }
 
-static void test_mlock_limit(int fd)
-{
-	size_t len;
-	char *mem;
-
-	len = mlock_limit_cur;
-	if (len % page_size != 0)
-		len = (len/page_size) * page_size;
-
-	mem = mmap(NULL, len, prot, mode, fd, 0);
-	if (mem == MAP_FAILED) {
-		fail("unable to mmap secret memory\n");
-		return;
-	}
-	munmap(mem, len);
-
-	len = mlock_limit_max * 2;
-	mem = mmap(NULL, len, prot, mode, fd, 0);
-	if (mem != MAP_FAILED) {
-		fail("unexpected mlock limit violation\n");
-		munmap(mem, len);
-		return;
-	}
-
-	pass("mlock limit is respected\n");
-}
-
 static void try_process_vm_read(int fd, int pipefd[2])
 {
 	struct iovec liov, riov;
@@ -258,7 +231,7 @@ static void prepare(void)
 				   strerror(errno));
 }
 
-#define NUM_TESTS 4
+#define NUM_TESTS 3
 
 int main(int argc, char *argv[])
 {
@@ -278,7 +251,6 @@ int main(int argc, char *argv[])
 					   strerror(errno));
 	}
 
-	test_mlock_limit(fd);
 	test_file_apis(fd);
 	test_process_vm_read(fd);
 	test_ptrace(fd);
-- 
2.53.0



