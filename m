Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061520;
	b=ywMjPzPAnfTmHewnriJE/Zx7p4IHqwoXx0ejpi5POAUikAeLLpvX8EsA+2mvEfhzLkJs
	 kbPgjTOJqtnmN2K+Ezu1bqW3zqrIwZAKdQN/dzbvvz7vyRPPLr0km/0ouW5oNOZ/XDJur
	 jdoofz7lHdbSWBg6f+ThMfali1hNfnaY4RKdINxkjKIYtBsSGjRFEsVWdT9RhepwBZaw3
	 JAImJVHcdNUXugwu2oZ1qoMxSvKlIbzTBk1nBj9sPqQMtEWTMizYBQvVq0ZA6xEZG3gSn
	 M5bh5SoGagY0J7qz/qLhYEksN+ZkEaBmdMt9iEjomLAUUbNvHP/u5j9NM7mN24/sG4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=If2Mtt2Z4729d5EPJR1jX11ZIS/gJdtxNcnl/bNmgsM=;
	b=rk85/U//erjwXnp/LfXnIJSpKvCsAD5KR992SzFJigRfPG0Wf0dSXiC16TzIxHGLJaZP
	 zNCFo07LsWQKregHkpB2AhUQnxwC81e1GR9IODABjrM2flHAA4N2b/AABRHcITDMkjISp
	 Qq44Qw6FbJLF1tYYSKLjk7sXZlJYUoNJKUWq8Gm790EKwc6PQuQctYCNo1+SjM/QjP803
	 yP1xzjZ3m/kgXzpHoB+y80l2GoColCbZrRXKxUHqVtSHdawnKlE7xEd2twsTiESyQhem6
	 /NFNbnZZ70TNm1/UanHKIhR4wWz5XfU2TuUPQ3rTH9MekNLW3Q1iuFLd4kaolHdCCCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qx21p8YX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803B606A32C;
	Sat,  7 Nov 2026 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qx21p8YX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E5C1F0089F;
	Sat,  7 Nov 2026 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061519;
	bh=If2Mtt2Z4729d5EPJR1jX11ZIS/gJdtxNcnl/bNmgsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qx21p8YXgGxOFdzUkght4J2wEBop+ZL90m+UH+7X745hPKczZ0ZgLKHhxL0CuDbTg
	 583nOGwp+B7sZXc+h4fD7ZOZQbyvXHTAHja/CdT/NtKBYGEdP3OQ9NMFTmkOrXIzoe
	 Hh478gaUu3QSfUenPRPjFEmKvFmmRzpf6njbpAm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.12 0608/1536] landlock: Fix superblock use-after-free in release_inode()
Date: Sat,  7 Nov 2026 08:43:44 -0500
Message-ID: <20261107135014.616052837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

commit 3e271a27c46fd591d1011c7de5a644a41e2010f1 upstream.

Without this fix, release_inode() (task 1) can race with a umount
operation in hook_sb_delete() (task 2).  The order of operations in
which the race occurs is:

* task 2: hook_sb_delete() arrives at the end of the function, waiting
  for landlock_superblock(sb)->inode_refs to become zero.
* task 1: release_inode(): does atomic_long_dec_and_test(), decrementing
  inode_refs to zero.
* task 2: gets woken up through some other means, sees that inode_refs
  is zero and returns.  The caller is the unmount operation and proceeds
  to release the superblock.
* task 1: Runs wake_up_var(&landlock_superblock(sb)->inode_refs),
  *dereferencing the sb_security on the freed-up superblock*.

Notably, wake_up_var() does not dereference the pointer passed to it,
and only uses it to determine an overapproximated set of tasks to wake
up. So while it's potentially possible for an attacker to provide a
different value for that pointer, this only results in the wrong set of
tasks getting woken up, and in this scenario, no further tasks are
actually waiting.

Nevertheless, KASAN detects it as a slab-use-after-free read on
sb->s_security:

  BUG: KASAN: slab-use-after-free in release_inode+0x196/0x290
  Read of size 8 at addr ffff888103b6c0a8 by task repro/217
   release_inode+0x196/0x290
   landlock_put_object+0x71/0x90
   landlock_free_rules+0x38/0xc0
   landlock_put_ruleset+0x47/0x130
   fop_ruleset_release+0x33/0x40
   __fput+0x305/0x780
  Freed by task 54:
   kfree+0x11c/0x390
   process_scheduled_works+0x766/0xe50
   worker_thread+0x7bc/0xb20

The fix is to determine &landlock_superblock(inode->i_sb)->inode_refs only once
earlier in release_inode(), and later use that precalculated address for the
wake_up_var() call, without having to dereference through the superblock.

Cc: stable@vger.kernel.org
Fixes: cb2c7d1a1776 ("landlock: Support filesystem access-control")
Assisted-by: LLM
Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20261006105847.2541190-1-gnoack@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -53,7 +53,7 @@ static void release_inode(struct landloc
 	__releases(object->lock)
 {
 	struct inode *const inode = object->underobj;
-	struct super_block *sb;
+	atomic_long_t *inode_refs;
 
 	if (!inode) {
 		spin_unlock(&object->lock);
@@ -69,8 +69,8 @@ static void release_inode(struct landloc
 	 * Makes sure that if the filesystem is concurrently unmounted,
 	 * hook_sb_delete() will wait for us to finish iput().
 	 */
-	sb = inode->i_sb;
-	atomic_long_inc(&landlock_superblock(sb)->inode_refs);
+	inode_refs = &landlock_superblock(inode->i_sb)->inode_refs;
+	atomic_long_inc(inode_refs);
 	spin_unlock(&object->lock);
 	/*
 	 * Because object->underobj was not NULL, hook_sb_delete() and
@@ -84,8 +84,8 @@ static void release_inode(struct landloc
 	 */
 
 	iput(inode);
-	if (atomic_long_dec_and_test(&landlock_superblock(sb)->inode_refs))
-		wake_up_var(&landlock_superblock(sb)->inode_refs);
+	if (atomic_long_dec_and_test(inode_refs))
+		wake_up_var(inode_refs);
 }
 
 static const struct landlock_object_underops landlock_fs_underops = {


