Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035060;
	b=SpY/EXfUkY5Ix9QSfUTQ/LTMRYonSn960mHKpaJDzoVGkWswM9iRMDb/g/F4eSQKXdyE
	 5uq2iUABuZ167ZGsLO4xFQxVKfRpaeAsqZqfYBXYlBdU3kzVZ8SeIYdPePgmziZ9bJphf
	 lEcLwO5gZaB6SiKlM8dPtCcPzDgX5quW5AaEzKn8V/wOX2yXh+KgaUkBbMV8l2q6sQOFX
	 7RQW7ye5+WTAxHJh6eiJ78KpG/nUwzliJPnMlCcrnFENh6Gp0TLGGwAUeh4OjofkpBVfN
	 +ew5h5VmHlwH70l39mI9X2KcTDO54UNKqKX2sigWd6pLiK0WWuwVwq4czVFhlQ0jexg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6uUshEoqskJZkUMTBH7lulb68Pe9YzNAhNHKOcOySHo=;
	b=NHwYsmqnF8g2qjfzw7We9+KciQfIARoxlBkAQdXKLu4yPmb30jpHYHhfcd8czozqzPsk
	 83zlnat2gLlWAa+ryyHSQSOZcpoFdxykWvLRz8C1W2iwrWdkiHdPlji7hrC98iQ0G/dVf
	 LkIgNQfpmNWtT6BRk3qXzArG2r9ANtnRNAYLgj8kGawcejaBRpKfgyVsqVnQ0wc7RpVU7
	 4jRPywaL89yysZnZNAcfrEy7HWT8lzHCXLasNyXQuPM5Wnme3GHHXdKHskjtTuM5qqn6W
	 6UhQzrWtDabqqbGoK5+IohKtZY9H9K4vibRFPlFEaf27yR3n1hsnirEpBS5EzyIQP3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQ42qT8O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628C0606A31C;
	Wed, 18 Nov 2026 20:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQ42qT8O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73471F000C4;
	Wed, 18 Nov 2026 20:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035060;
	bh=6uUshEoqskJZkUMTBH7lulb68Pe9YzNAhNHKOcOySHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQ42qT8OzwkfCEOn8y4/F3TTBWJZnkz/lf1Qa0C0l0XfUQvKMT40rcb1eprvJoOaA
	 mH9IYJ8ugY14jMrtpc3suCsSaYhX+gB0JVuAhSGsvJ/OB06Bg9korrdPCdB/0+mrcc
	 onF/FY2ExQMYKjqM4MYrY6VUMVnaaU2eIOhtrdZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.6 0588/3318] landlock: Fix superblock use-after-free in release_inode()
Date: Wed, 18 Nov 2026 15:20:10 +0100
Message-ID: <20261118150335.208197841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,7 +45,7 @@ static void release_inode(struct landloc
 	__releases(object->lock)
 {
 	struct inode *const inode = object->underobj;
-	struct super_block *sb;
+	atomic_long_t *inode_refs;
 
 	if (!inode) {
 		spin_unlock(&object->lock);
@@ -61,8 +61,8 @@ static void release_inode(struct landloc
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
@@ -76,8 +76,8 @@ static void release_inode(struct landloc
 	 */
 
 	iput(inode);
-	if (atomic_long_dec_and_test(&landlock_superblock(sb)->inode_refs))
-		wake_up_var(&landlock_superblock(sb)->inode_refs);
+	if (atomic_long_dec_and_test(inode_refs))
+		wake_up_var(inode_refs);
 }
 
 static const struct landlock_object_underops landlock_fs_underops = {


