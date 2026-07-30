Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13913769FD;
	Thu, 30 Jul 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426883; cv=none; b=MB6nrWROdtz3UsvjSH0bUYcgusMGM9eQ75BotzvBhTQPsqDkjhzc318oDU+dE5PFbLUsIQpJ5+zl0qVCSrLDZIjACw1fFCPo9coC9+rOaZg41ZMKep1cETjO97zWA5xIiAP0x3hgnns/Q5O1I+gThMKewaimkIdNN7DuCU3iUTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426883; c=relaxed/simple;
	bh=aDrBYQGbLRJtsSuNJBJVF2wKRrZ5+JsaVPOaXvwghko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oe0cZGsoWUppah5/RQxRkH5Lze+rUzeMU2dapo/j7ym7gylgWpRCS336vwxN92sZyI6ujERno+wmF5uzZfvirqEQt33YZSoyJey2SQCK4jYVuTS8IhNPZmYlOmrrTP6uK5E3lSxcUL9j1OSUk0heitJanEWuvW/VMj1q9fkuyKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giJyS2CB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giJyS2CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593531F000E9;
	Thu, 30 Jul 2026 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426881;
	bh=S4rr00MoGLdMwNhlCWXTfv2G+NfWaDnblRrb5PbDrj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giJyS2CBKb1fzaJdr1ffDQ0/nIj+gz3tjrhwu7+NtarFYoT4rw8sqO/bn5XGoU4+H
	 3m4EUH+ura44ww3jB3NWI1ygy73Dzl5UTWSaxbAtl/T6FNvyE+STrlbHW7aI3Px2Ap
	 TFcss3h8cAZgSo2t5THvmmUX5eKzoeTys86L8Nng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 576/602] afs: Drop the net parameter from afs_unuse_cell()
Date: Thu, 30 Jul 2026 16:16:08 +0200
Message-ID: <20260730141448.155576845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 469c82b558628482002e4819d35b7670f0a989fd ]

Remove the redundant net parameter to afs_unuse_cell() as cell->net can be
used instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/20250224234154.2014840-12-dhowells@redhat.com/ # v1
Link: https://lore.kernel.org/r/20250310094206.801057-8-dhowells@redhat.com/ # v4
Stable-dep-of: 330e2c514823 ("afs: Fix dynamic lookup to fail on cell lookup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/cell.c              |   12 ++++++------
 fs/afs/dynroot.c           |    4 ++--
 fs/afs/internal.h          |    2 +-
 fs/afs/mntpt.c             |    2 +-
 fs/afs/proc.c              |    2 +-
 fs/afs/super.c             |    9 ++++-----
 fs/afs/vl_alias.c          |    4 ++--
 include/trace/events/afs.h |    1 +
 8 files changed, 18 insertions(+), 18 deletions(-)

--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -339,7 +339,7 @@ cell_already_exists:
 		goto wait_for_cell;
 	goto error_noput;
 error:
-	afs_unuse_cell(net, cell, afs_cell_trace_unuse_lookup);
+	afs_unuse_cell(cell, afs_cell_trace_unuse_lookup_error);
 error_noput:
 	_leave(" = %d [error]", ret);
 	return ERR_PTR(ret);
@@ -402,7 +402,7 @@ int afs_cell_init(struct afs_net *net, c
 				       lockdep_is_held(&net->cells_lock));
 	up_write(&net->cells_lock);
 
-	afs_unuse_cell(net, old_root, afs_cell_trace_unuse_ws);
+	afs_unuse_cell(old_root, afs_cell_trace_unuse_ws);
 	_leave(" = 0");
 	return 0;
 }
@@ -522,7 +522,7 @@ static void afs_cell_destroy(struct rcu_
 	trace_afs_cell(cell->debug_id, r, atomic_read(&cell->active), afs_cell_trace_free);
 
 	afs_put_vlserverlist(net, rcu_access_pointer(cell->vl_servers));
-	afs_unuse_cell(net, cell->alias_of, afs_cell_trace_unuse_alias);
+	afs_unuse_cell(cell->alias_of, afs_cell_trace_unuse_alias);
 	key_put(cell->anonymous_key);
 	idr_remove(&net->cells_dyn_ino, cell->dynroot_ino);
 	kfree(cell->name - 1);
@@ -610,7 +610,7 @@ struct afs_cell *afs_use_cell(struct afs
  * Record a cell becoming less active.  When the active counter reaches 1, it
  * is scheduled for destruction, but may get reactivated.
  */
-void afs_unuse_cell(struct afs_net *net, struct afs_cell *cell, enum afs_cell_trace reason)
+void afs_unuse_cell(struct afs_cell *cell, enum afs_cell_trace reason)
 {
 	unsigned int debug_id;
 	time64_t now, expire_delay;
@@ -634,7 +634,7 @@ void afs_unuse_cell(struct afs_net *net,
 	WARN_ON(a == 0);
 	if (a == 1)
 		/* 'cell' may now be garbage collected. */
-		afs_set_cell_timer(net, expire_delay);
+		afs_set_cell_timer(cell->net, expire_delay);
 }
 
 /*
@@ -959,7 +959,7 @@ void afs_cell_purge(struct afs_net *net)
 	ws = rcu_replace_pointer(net->ws_cell, NULL,
 				 lockdep_is_held(&net->cells_lock));
 	up_write(&net->cells_lock);
-	afs_unuse_cell(net, ws, afs_cell_trace_unuse_ws);
+	afs_unuse_cell(ws, afs_cell_trace_unuse_ws);
 
 	_debug("del timer");
 	if (del_timer_sync(&net->cells_timer))
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -125,7 +125,7 @@ static struct dentry *afs_dynroot_lookup
 	return d_splice_alias(inode, dentry);
 
 out:
-	afs_unuse_cell(cell->net, cell, afs_cell_trace_unuse_lookup_dynroot);
+	afs_unuse_cell(cell, afs_cell_trace_unuse_lookup_dynroot);
 out_no_cell:
 	if (!inode)
 		return d_splice_alias(inode, dentry);
@@ -167,7 +167,7 @@ static void afs_dynroot_d_release(struct
 {
 	struct afs_cell *cell = dentry->d_fsdata;
 
-	afs_unuse_cell(cell->net, cell, afs_cell_trace_unuse_dynroot_mntpt);
+	afs_unuse_cell(cell, afs_cell_trace_unuse_dynroot_mntpt);
 }
 
 /*
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1045,7 +1045,7 @@ struct afs_cell *afs_lookup_cell(struct
 				 const char *vllist, bool excl,
 				 enum afs_cell_trace trace);
 extern struct afs_cell *afs_use_cell(struct afs_cell *, enum afs_cell_trace);
-extern void afs_unuse_cell(struct afs_net *, struct afs_cell *, enum afs_cell_trace);
+void afs_unuse_cell(struct afs_cell *cell, enum afs_cell_trace reason);
 extern struct afs_cell *afs_get_cell(struct afs_cell *, enum afs_cell_trace);
 extern void afs_see_cell(struct afs_cell *, enum afs_cell_trace);
 extern void afs_put_cell(struct afs_cell *, enum afs_cell_trace);
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -87,7 +87,7 @@ static int afs_mntpt_set_params(struct f
 		ctx->force = true;
 	}
 	if (ctx->cell) {
-		afs_unuse_cell(ctx->net, ctx->cell, afs_cell_trace_unuse_mntpt);
+		afs_unuse_cell(ctx->cell, afs_cell_trace_unuse_mntpt);
 		ctx->cell = NULL;
 	}
 	if (test_bit(AFS_VNODE_PSEUDODIR, &vnode->flags)) {
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -130,7 +130,7 @@ static int afs_proc_cells_write(struct f
 		}
 
 		if (test_and_set_bit(AFS_CELL_FL_NO_GC, &cell->flags))
-			afs_unuse_cell(net, cell, afs_cell_trace_unuse_no_pin);
+			afs_unuse_cell(cell, afs_cell_trace_unuse_no_pin);
 	} else {
 		goto inval;
 	}
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -297,7 +297,7 @@ static int afs_parse_source(struct fs_co
 			       cellnamesz, cellnamesz, cellname ?: "");
 			return PTR_ERR(cell);
 		}
-		afs_unuse_cell(ctx->net, ctx->cell, afs_cell_trace_unuse_parse);
+		afs_unuse_cell(ctx->cell, afs_cell_trace_unuse_parse);
 		afs_see_cell(cell, afs_cell_trace_see_source);
 		ctx->cell = cell;
 	}
@@ -394,7 +394,7 @@ static int afs_validate_fc(struct fs_con
 				ctx->key = NULL;
 				cell = afs_use_cell(ctx->cell->alias_of,
 						    afs_cell_trace_use_fc_alias);
-				afs_unuse_cell(ctx->net, ctx->cell, afs_cell_trace_unuse_fc);
+				afs_unuse_cell(ctx->cell, afs_cell_trace_unuse_fc);
 				ctx->cell = cell;
 				goto reget_key;
 			}
@@ -520,9 +520,8 @@ static struct afs_super_info *afs_alloc_
 static void afs_destroy_sbi(struct afs_super_info *as)
 {
 	if (as) {
-		struct afs_net *net = afs_net(as->net_ns);
 		afs_put_volume(as->volume, afs_volume_trace_put_destroy_sbi);
-		afs_unuse_cell(net, as->cell, afs_cell_trace_unuse_sbi);
+		afs_unuse_cell(as->cell, afs_cell_trace_unuse_sbi);
 		put_net(as->net_ns);
 		kfree(as);
 	}
@@ -606,7 +605,7 @@ static void afs_free_fc(struct fs_contex
 
 	afs_destroy_sbi(fc->s_fs_info);
 	afs_put_volume(ctx->volume, afs_volume_trace_put_free_fc);
-	afs_unuse_cell(ctx->net, ctx->cell, afs_cell_trace_unuse_fc);
+	afs_unuse_cell(ctx->cell, afs_cell_trace_unuse_fc);
 	key_put(ctx->key);
 	kfree(ctx);
 }
--- a/fs/afs/vl_alias.c
+++ b/fs/afs/vl_alias.c
@@ -205,11 +205,11 @@ static int afs_query_for_alias(struct af
 			goto is_alias;
 
 		if (mutex_lock_interruptible(&cell->net->proc_cells_lock) < 0) {
-			afs_unuse_cell(cell->net, p, afs_cell_trace_unuse_check_alias);
+			afs_unuse_cell(p, afs_cell_trace_unuse_check_alias);
 			return -ERESTARTSYS;
 		}
 
-		afs_unuse_cell(cell->net, p, afs_cell_trace_unuse_check_alias);
+		afs_unuse_cell(p, afs_cell_trace_unuse_check_alias);
 	}
 
 	mutex_unlock(&cell->net->proc_cells_lock);
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -197,6 +197,7 @@ enum yfs_cm_operation {
 	EM(afs_cell_trace_unuse_fc,		"UNU fc    ") \
 	EM(afs_cell_trace_unuse_lookup,		"UNU lookup") \
 	EM(afs_cell_trace_unuse_lookup_dynroot,	"UNU lu-dyn") \
+	EM(afs_cell_trace_unuse_lookup_error,	"UNU lu-err") \
 	EM(afs_cell_trace_unuse_mntpt,		"UNU mntpt ") \
 	EM(afs_cell_trace_unuse_no_pin,		"UNU no-pin") \
 	EM(afs_cell_trace_unuse_parse,		"UNU parse ") \


