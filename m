Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061616;
	b=p0NG4rdX9+sbhmRii4uXwLd4C65OuO+hIS/ktgxWPFrlRnqv4fACBHZ08wgM1kEuX6vI
	 SMhR+ys42j/zQ8NAtmxwsX6x3LuF6i6SfKU3IwgOhZi0OfT/Z0A2vSFs2u/83B5oQB2st
	 BS5kt7sEWuj1ynRLhTiNPfIbalLfrwcfoWhjVeex/oaOJDuJZZVx7F8HoYpwHc/43e5PA
	 JaxZiUAvGbRwb6BDG3jeM6BF8PsM4opTvuBBM1wP2p/j0IToqzM0KHPb+6YfkWCWIm4Op
	 GDQkSG3vyQmK+iiL0V/Rr94k8kumY8jUyk+vraoo7cYdDMDmLwUvcmHcAeQZMfdKsGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U6bpT/QeaGZtEiQyJl4e/XhoQwj4Stf/3hieM25Nms4=;
	b=AOGUdaSEYUlVwPI5L3rZUQbE2v3YiCFy0K1UZogcu74stfCqTAYIPyuM9M2OCe6sFc57
	 jWfZALdq1tpYgQDKIJVs308SgGyqi35loPfo+bIog+DUIQMKtSrNcnWlplowcpgzsqOSc
	 8GM/vUkcREHs6BEzXvDYTsMmI+mXgkb9mHl2feDRiCyNNUPehxkDZu9TSUWy8vQhQAfc6
	 qoTYtNPHXLcAoQ3JjtXin4H7LpR9zUquckZ3+3IH0jzvEN5tpTEsnLigylkESOa2BPvRX
	 4eU3A5zAPrglBQT/p4gPWqnlr4HMv6tT1I/91eYwjzG3pxryR6RDcbmyaGmPzAt/5pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0RZs3jT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDD3606A326;
	Sat,  7 Nov 2026 14:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0RZs3jT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0665B1F0089F;
	Sat,  7 Nov 2026 14:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061616;
	bh=U6bpT/QeaGZtEiQyJl4e/XhoQwj4Stf/3hieM25Nms4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0RZs3jToZIWPC0pYnBUMe924pCw7wdQNeXMrPdztEr6nsqaLwAY2cylywlMO4Et2
	 XSKM9hI3Ey9elt4Niwz8OVay7LMN86mKCTpUNWiwBnlu7z8sVQeMaIjzFXQL/73XC2
	 zqIRyBid7SfnaKHqRRyegg48NEBx8fsvz8ziPDEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 0685/1536] ovl: set the revalidate flags after d_instantiate()
Date: Sat,  7 Nov 2026 08:45:01 -0500
Message-ID: <20261107135016.727323654@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 75e89c0055c1d7f7eeb462995f11253ca5864f79 upstream.

stat() of a file on an overlayfs mount triggers a kernel warning and
fails with ECHILD if another task is creating that file at the same
time. This happens on an overlay with a FUSE upper layer, which is the
layer where overlayfs creates new files. Write access to a directory on
such an overlay is all a user needs to run the two tasks.

The revalidate flags are DCACHE_OP_REVALIDATE and
DCACHE_OP_WEAK_REVALIDATE. They tell path walk to call ->d_revalidate()
or ->d_weak_revalidate() on a dentry, so that the filesystem can check
that the cached dentry is still valid. An overlay dentry only has one of
these flags if a dentry in one of its layers has it. FUSE dentries have
the first one.

When a flag is set on an overlay dentry, path walk calls
ovl_dentry_revalidate_common(). That function only expects a dentry
without an inode in RCU walk, while the dentry is being destroyed. For
such a dentry outside of RCU walk, it hits a WARN_ON() and
returns -ECHILD. So a negative overlay dentry must never have the flags
set.

ovl_instantiate() breaks this rule. When a task creates a file, the
overlay dentry for the new name is hashed but still negative.
ovl_instantiate() then works in this order:

- It copies the flags from the new upper dentry to the overlay dentry.
- It calls ovl_get_inode(), which can sleep in a getxattr request to the
  FUSE server.
- Only then does it call d_instantiate().

A second task that looks up the name between the first step and the last
finds a negative dentry with the flags set and revalidates it.

Reproduced with a FUSE server that delays its getxattr reply: stat() of
a name that was being created hit the WARN_ON() and failed with ECHILD.

Fix this by setting the flags after d_instantiate().

Fixes: bccece1ead36 ("ovl: allow remote upper")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -269,7 +269,6 @@ static int ovl_instantiate(struct dentry
 	};
 
 	ovl_dentry_set_upper_alias(dentry);
-	ovl_dentry_init_reval(dentry, newdentry, NULL);
 
 	if (!hardlink) {
 		/*
@@ -299,6 +298,13 @@ static int ovl_instantiate(struct dentry
 		d_mark_tmpfile(tmpfile, inode);
 
 	d_instantiate(dentry, inode);
+	/*
+	 * Unless it is a tmpfile, the dentry is hashed and a path walk can find
+	 * it at any time.  Set the revalidate flags only now, because
+	 * ovl_dentry_revalidate_common() does not expect them on a negative
+	 * dentry.
+	 */
+	ovl_dentry_init_reval(dentry, ovl_dentry_upper(dentry), NULL);
 	if (inode != oip.newinode) {
 		pr_warn_ratelimited("newly created inode found in cache (%pd2)\n",
 				    dentry);


