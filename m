Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212132;
	b=e5evuLndxo9Iz+4jnNpra3R/DS48mMSkD0UTg0BKb9MX7Frhm3zGByXy+iWdakNcs3mu
	 3fir/0tDWdoypec7RJkYNEvNY6jfLQPITaZQNY7uwtl6jS4Y8Pr68UJPgT10suVBfIgRv
	 QIMUeVMyee2ccI4rZlMOq0fFVXDkCOcYrmR5lIRU860joFDVdhKfLaqZCp8cPP2JWyMOq
	 QoyhyjRaq4U4oj6jilpO/KdlMffQWbuajycLYXmSxkLv9Ua074D991aX1KWT1XV1bbueW
	 hJntc8IPxeLLQ1eBHuAvB7ZuDeVZ6IZHNOLOCj2asgJ9mfQ9jnR66mUlxUknT/mT5lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TJUf1nVEaUlTLZPaIBMLu7kgrx/VjviT21//ouNrMjQ=;
	b=wZLa6BH26x802xQ0V+DkONEtThRb/2LUingq1HWmBO1rGw8buWLLO0zwDXimP2ytpKNG
	 tlgeob2y0cDQvWXARI91WH5Rv12Yg8hrzG5BUB1ogr8JwkH47kpzE7IX5yxYZ2Ibzukoi
	 bJ1zDokJDecaHTVf9s+ZbAvb+Uld9PD/QLbfiFtvxz2pLv5Qb5J44t8j053fr17qTeDFv
	 hGlGMRktd99DcBjc/2pIUfpgqs9NB6lPQDP+UvMnaMl9vnXnkltuaDZ8sEIwIYthfy73f
	 vX2bxMUWhuFvlluJ5Rr6/aVpd0rweyqLQEDxHk0jsCso7sKt2cV8MlZTszOh/hnb5Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJo4Gf2L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0489606A31D;
	Wed, 28 Oct 2026 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJo4Gf2L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EBC1F01825;
	Wed, 28 Oct 2026 18:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212132;
	bh=TJUf1nVEaUlTLZPaIBMLu7kgrx/VjviT21//ouNrMjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJo4Gf2LD7xmopVBkWpE/9zD+ggrfOb1wM7wV0Q2lzKj6SBYHLkhlGrZ6T2QvkqHt
	 6Pr3k676JCuBolXzRk0PsT8aVJBeu94XEI5pIFjQppMG413g2aFOx4/Df94ulLnWjI
	 25BSihhcct5dFOci0tfSjXkjiNgEFuo7VmJxCRlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0048/1887] landlock: Fix use-after-free of the sources parent directory
Date: Wed, 28 Oct 2026 17:35:44 +0100
Message-ID: <20261028170500.320445882@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 2c6dc792538260a8087ac5b22c31b3b8e47c85d6 ]

current_check_refer_path() reads old_dentry->d_parent without holding a
reference nor a lock on it, and then dereferences it in
collect_domain_accesses() and in the audit record.

A reference on a child does not pin its parent: __d_move() reassigns
dentry->d_parent and drops the reference the child held on its former
parent.  hook_path_rename() is not affected because the rename path
calls lock_rename() before the hook, so the source cannot be reparented
under it.  hook_path_link() has no such protection: filename_linkat()
holds a reference on the source dentry but neither locks nor references
its parent, so a concurrent rename(2) can reparent the source while
security_path_link() runs, and the former parent can then be removed and
freed while the hook walks it.

A process can trigger this after entering a Landlock domain that handles
at least one filesystem access right.  The process can then race a
linkat(2) loop against rename(2) and rmdir(2):

  BUG: KASAN: slab-use-after-free in collect_domain_accesses+0x278/0x290
  Read of size 4 at addr ffff888160bd53f4 by task llrepro2/549
   collect_domain_accesses+0x278/0x290
   current_check_refer_path+0x952/0x1120
   security_path_link+0x1be/0x320
   filename_linkat+0x342/0x6d0
   __x64_sys_linkat+0xfa/0x150
  Freed by task 562:
   kmem_cache_free+0x139/0x4c0
   i_callback+0x4b/0x80
   rcu_core+0x7dc/0x10a0

Take a reference on the dentry selected as the source parent, using
dget() for the common-mount-root case and dget_parent() otherwise.
Release it after the hierarchy walk and synchronous audit logging.

Cc: stable@vger.kernel.org
Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Tested-by: Günther Noack <gnoack3000@gmail.com>
Link: https://patch.msgid.link/E9CDD9E6-E960-4DE2-B1AC-5667D52ABB3E@doyensec.com
[mic: Clarify the caller, reachability, and reference handling]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[ consolidated dput(old_parent) into one release after the hierarchy walks because the older branch lacks audit logging. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/fs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 8f20a146648cf..4e03da721e633 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -911,17 +911,19 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 	/*
 	 * old_dentry may be the root of the common mount point and
 	 * !IS_ROOT(old_dentry) at the same time (e.g. with open_tree() and
-	 * OPEN_TREE_CLONE).  We do not need to call dget(old_parent) because
-	 * we keep a reference to old_dentry.
+	 * OPEN_TREE_CLONE).  Pin the dentry used as old_parent in either case.
+	 * Otherwise, dget_parent() safely fetches and pins the current parent
+	 * against a concurrent rename(2).
 	 */
-	old_parent = (old_dentry == mnt_dir.dentry) ? old_dentry :
-						      old_dentry->d_parent;
+	old_parent = (old_dentry == mnt_dir.dentry) ? dget(old_dentry) :
+						      dget_parent(old_dentry);
 
 	/* new_dir->dentry is equal to new_dentry->d_parent */
 	allow_parent1 = collect_domain_accesses(dom, mnt_dir.dentry, old_parent,
 						&layer_masks_parent1);
 	allow_parent2 = collect_domain_accesses(
 		dom, mnt_dir.dentry, new_dir->dentry, &layer_masks_parent2);
+	dput(old_parent);
 
 	if (allow_parent1 && allow_parent2)
 		return 0;
-- 
2.53.0



