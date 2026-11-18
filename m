Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035570;
	b=oEgKwZLEcjkLXqnees6LC+rRiSlgdVZiTYUjUZz1pqc4+GEE8BCdxGqQ9iCxsd/cv5N5
	 dSyfc4txSO+Sl8toJ/gON678bOQ05A+n+8rZhqv6WXJ0VUKo/WUL5wvXPTQk3PhHRxuxP
	 ddmgWBpSBD3GMN1xTxTh3MZ/6r6gN1o7sg0La+fD0NjcPyGcg6uuViPwSTtWLr5oGy4kj
	 SLx/NIacfjCkPP/oV05W9jx8zW73hrlhfD3VwhjoQ4bhaygIX433kDpqxNr5df8GFL+EO
	 0c9KsC/5hcx7jAP9ehK252gnL1o+SxhBxzEHTpCzjbm2WDnXQU1Cfm+M5Lo+6fsEIeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qF8MYNmlkB/wZXbqOTKTfWG1oC230gEifc8GLZwBuzg=;
	b=zn/RjxCLKXgJmjvnm8z9q0hM90sikCOkhUYrAO8sR+PbDJmHy7gyJZzO7GHaWjRiucjV
	 0/XTfIw3vX3VplWfvSJcweYu3WwHLZmWEIXkwgxC3H7/pLYKsrIKp582ZzZqcJUtA66d5
	 3dXrYbmf1lV13ecpmogkXcDc0cnpFfbmZ4XpDO65y9bV4hHvpyUOGl/19kRywvnL6z91o
	 /2jXm29GEBspUHkCPPY6RRtnh7nfKNmNloMMuKyNDwHhZVwMhN2h/TrzMhHtiCdqvl/Ye
	 MM9jyurLY8znoDaBw1hmLFj9DdHy7MYBUiCCNU9Ul/GLvIfSMKx+YYzruCi/Dbh2CJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3wmP2cb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBED1606A31C;
	Wed, 18 Nov 2026 20:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3wmP2cb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4181E1F000C4;
	Wed, 18 Nov 2026 20:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035569;
	bh=qF8MYNmlkB/wZXbqOTKTfWG1oC230gEifc8GLZwBuzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3wmP2cbGBqS/JFF4lRXHPZYq52Y7Kn5ZgAzUXLO1JolJ0uXE1dOzFEOS2tviwbUp
	 rEha5mBxKomfNXaWH/cGOFC9UggSj8PN+XrzlBN1TmtKatZ0iSxtetbLTRXvr7TCHn
	 jWOPLSuGVgp0+TNfBgxorXQvo1VbQP8MRp2E4cBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 0744/3318] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed, 18 Nov 2026 15:22:46 +0100
Message-ID: <20261118150340.933241818@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit cbec8610ec5aaf35df50094ff639febc23f20773 upstream.

Listing a directory while it is copied up causes a use-after-free of
the readdir cache.

A merge directory must never be iterated as a real upper directory:
that mode frees the cache in OVL_I(inode)->cache without looking at
its refcount, while files opened in merged mode still use it.
ovl_copy_up_workdir() publishes the upper dentry before it sets
OVL_WHITEOUTS, and ovl_dir_open() samples both without a lock, so an
open between the two stores finds the upper directory and takes it
for a real one.

With a delay between the two stores, an unprivileged process that
listed a directory during its copy-up saw only "." and "..", and its
next getdents freed the readdir cache of another descriptor.

Fix this by setting OVL_WHITEOUTS before ovl_inode_update(), so that
ovl_dir_reset() agrees with ovl_dir_open(), and by testing
OVL_TYPE_MERGE() of the path type in ovl_dir_open(), so that an open
that observes the upper dentry never iterates a merge dir as a real
dir, regardless of the order in which it observes the flag.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: test OVL_TYPE_MERGE() instead of smp_rmb() in ovl_dir_open()]
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
[ backport: context: the store is followed by the unlock: label ]

 fs/overlayfs/copy_up.c |    2 +-
 fs/overlayfs/readdir.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -772,9 +772,9 @@ static int ovl_copy_up_workdir(struct ov
 
 	if (!c->metacopy)
 		ovl_set_upperdata(inode);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
 
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -947,7 +947,8 @@ static int ovl_dir_open(struct inode *in
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(inode);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 


