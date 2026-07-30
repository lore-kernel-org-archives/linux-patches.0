Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F29383983;
	Thu, 30 Jul 2026 15:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426880; cv=none; b=ZpB+X+EwkuM+mqO8trcaPVcLChC33UkwWEmOM4ah9WaYKsZr7IX7PRvTKc3Nxt96B9x9MwKVw4D5hN33o2o52Cte0Z+SdiAqZgvYSUrumwFsZTOFm6eJ+fivauUUFZJ3QVfMK9yeGWmSe9ZoQ7shZtifeaNI2qNOc8H2arBjcoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426880; c=relaxed/simple;
	bh=5vhPI+YJWtKk+sUk0WMCvP3jlc4SvHInAL5Cwu0KIwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxDKXOH/Ry7SXt0Aqap1i1+wTQUCc5/bp9ueBqnur5AjCP0ajw6YjO7ki2WgQLlj2a95H57wSbiGNJgLJh7lXvMj1bUu1oRUbm7p57xPXal2cD565072wbkPReeSbty5zTmXJ31XKYXLXKJ8muwajdBrVI7uscqCeotCBAmlzzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3aDIihF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3aDIihF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8F51F000E9;
	Thu, 30 Jul 2026 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426879;
	bh=1zbIoGqfpnfS7NKNj5be3819KxVfvHTJmf6SWgXBQ6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3aDIihFpvgIHWcRvBi+DMadqKJl+wIDI8ZitvQBFY4+v2R+ZA8HqlD7DN6XqyorG
	 ncTfn6j4ow9/B86gCfwhgCv7mJZFv14btbIEgS8X9vVW/34kLxyCQoYQFAoNk4KVYv
	 0s04R+3sPjAj52bMmB+xr6jRj75Vu57RM39KPB+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 575/602] afs: Make afs_lookup_cell() take a trace note
Date: Thu, 30 Jul 2026 16:16:07 +0200
Message-ID: <20260730141448.132736114@linuxfoundation.org>
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

[ Upstream commit 92c48157ade88e7a543a64af4a806613fbde2ef3 ]

Pass a note to be added to the afs_cell tracepoint to afs_lookup_cell() so
that different callers can be distinguished.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/20250224234154.2014840-11-dhowells@redhat.com/ # v1
Link: https://lore.kernel.org/r/20250310094206.801057-7-dhowells@redhat.com/ # v4
Stable-dep-of: 330e2c514823 ("afs: Fix dynamic lookup to fail on cell lookup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/cell.c              |   13 ++++++++-----
 fs/afs/dynroot.c           |    3 ++-
 fs/afs/internal.h          |    6 ++++--
 fs/afs/mntpt.c             |    3 ++-
 fs/afs/proc.c              |    3 ++-
 fs/afs/super.c             |    3 ++-
 fs/afs/vl_alias.c          |    3 ++-
 include/trace/events/afs.h |    7 ++++++-
 8 files changed, 28 insertions(+), 13 deletions(-)

--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -233,6 +233,7 @@ error:
  * @namesz:	The strlen of the cell name.
  * @vllist:	A colon/comma separated list of numeric IP addresses or NULL.
  * @excl:	T if an error should be given if the cell name already exists.
+ * @trace:	The reason to be logged if the lookup is successful.
  *
  * Look up a cell record by name and query the DNS for VL server addresses if
  * needed.  Note that that actual DNS query is punted off to the manager thread
@@ -241,7 +242,8 @@ error:
  */
 struct afs_cell *afs_lookup_cell(struct afs_net *net,
 				 const char *name, unsigned int namesz,
-				 const char *vllist, bool excl)
+				 const char *vllist, bool excl,
+				 enum afs_cell_trace trace)
 {
 	struct afs_cell *cell, *candidate, *cursor;
 	struct rb_node *parent, **pp;
@@ -251,7 +253,7 @@ struct afs_cell *afs_lookup_cell(struct
 	_enter("%s,%s", name, vllist);
 
 	if (!excl) {
-		cell = afs_find_cell(net, name, namesz, afs_cell_trace_use_lookup);
+		cell = afs_find_cell(net, name, namesz, trace);
 		if (!IS_ERR(cell))
 			goto wait_for_cell;
 	}
@@ -327,7 +329,7 @@ cell_already_exists:
 	if (excl) {
 		ret = -EEXIST;
 	} else {
-		afs_use_cell(cursor, afs_cell_trace_use_lookup);
+		afs_use_cell(cursor, trace);
 		ret = 0;
 	}
 	up_write(&net->cells_lock);
@@ -382,8 +384,9 @@ int afs_cell_init(struct afs_net *net, c
 	if (cp && cp < rootcell + len)
 		return -EINVAL;
 
-	/* allocate a cell record for the root cell */
-	new_root = afs_lookup_cell(net, rootcell, len, vllist, false);
+	/* allocate a cell record for the root/workstation cell */
+	new_root = afs_lookup_cell(net, rootcell, len, vllist, false,
+				   afs_cell_trace_use_lookup_ws);
 	if (IS_ERR(new_root)) {
 		_leave(" = %ld", PTR_ERR(new_root));
 		return PTR_ERR(new_root);
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -108,7 +108,8 @@ static struct dentry *afs_dynroot_lookup
 		dotted = true;
 	}
 
-	cell = afs_lookup_cell(net, name, len, NULL, false);
+	cell = afs_lookup_cell(net, name, len, NULL, false,
+			       afs_cell_trace_use_lookup_dynroot);
 	if (IS_ERR(cell)) {
 		ret = PTR_ERR(cell);
 		goto out_no_cell;
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1040,8 +1040,10 @@ static inline bool afs_cb_is_broken(unsi
 extern int afs_cell_init(struct afs_net *, const char *);
 extern struct afs_cell *afs_find_cell(struct afs_net *, const char *, unsigned,
 				      enum afs_cell_trace);
-extern struct afs_cell *afs_lookup_cell(struct afs_net *, const char *, unsigned,
-					const char *, bool);
+struct afs_cell *afs_lookup_cell(struct afs_net *net,
+				 const char *name, unsigned int namesz,
+				 const char *vllist, bool excl,
+				 enum afs_cell_trace trace);
 extern struct afs_cell *afs_use_cell(struct afs_cell *, enum afs_cell_trace);
 extern void afs_unuse_cell(struct afs_net *, struct afs_cell *, enum afs_cell_trace);
 extern struct afs_cell *afs_get_cell(struct afs_cell *, enum afs_cell_trace);
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -107,7 +107,8 @@ static int afs_mntpt_set_params(struct f
 		if (size > AFS_MAXCELLNAME)
 			return -ENAMETOOLONG;
 
-		cell = afs_lookup_cell(ctx->net, p, size, NULL, false);
+		cell = afs_lookup_cell(ctx->net, p, size, NULL, false,
+				       afs_cell_trace_use_lookup_mntpt);
 		if (IS_ERR(cell)) {
 			pr_err("kAFS: unable to lookup cell '%pd'\n", mntpt);
 			return PTR_ERR(cell);
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -122,7 +122,8 @@ static int afs_proc_cells_write(struct f
 	if (strcmp(buf, "add") == 0) {
 		struct afs_cell *cell;
 
-		cell = afs_lookup_cell(net, name, strlen(name), args, true);
+		cell = afs_lookup_cell(net, name, strlen(name), args, true,
+				       afs_cell_trace_use_lookup_add);
 		if (IS_ERR(cell)) {
 			ret = PTR_ERR(cell);
 			goto done;
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -290,7 +290,8 @@ static int afs_parse_source(struct fs_co
 	/* lookup the cell record */
 	if (cellname) {
 		cell = afs_lookup_cell(ctx->net, cellname, cellnamesz,
-				       NULL, false);
+				       NULL, false,
+				       afs_cell_trace_use_lookup_mount);
 		if (IS_ERR(cell)) {
 			pr_err("kAFS: unable to lookup cell '%*.*s'\n",
 			       cellnamesz, cellnamesz, cellname ?: "");
--- a/fs/afs/vl_alias.c
+++ b/fs/afs/vl_alias.c
@@ -269,7 +269,8 @@ static int yfs_check_canonical_cell_name
 	if (!name_len || name_len > AFS_MAXCELLNAME)
 		master = ERR_PTR(-EOPNOTSUPP);
 	else
-		master = afs_lookup_cell(cell->net, cell_name, name_len, NULL, false);
+		master = afs_lookup_cell(cell->net, cell_name, name_len, NULL, false,
+					 afs_cell_trace_use_lookup_canonical);
 	kfree(cell_name);
 	if (IS_ERR(master))
 		return PTR_ERR(master);
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -208,7 +208,12 @@ enum yfs_cm_operation {
 	EM(afs_cell_trace_use_check_alias,	"USE chk-al") \
 	EM(afs_cell_trace_use_fc,		"USE fc    ") \
 	EM(afs_cell_trace_use_fc_alias,		"USE fc-al ") \
-	EM(afs_cell_trace_use_lookup,		"USE lookup") \
+	EM(afs_cell_trace_use_lookup_add,	"USE lu-add") \
+	EM(afs_cell_trace_use_lookup_canonical,	"USE lu-can") \
+	EM(afs_cell_trace_use_lookup_dynroot,	"USE lu-dyn") \
+	EM(afs_cell_trace_use_lookup_mntpt,	"USE lu-mpt") \
+	EM(afs_cell_trace_use_lookup_mount,	"USE lu-mnt") \
+	EM(afs_cell_trace_use_lookup_ws,	"USE lu-ws ") \
 	EM(afs_cell_trace_use_mntpt,		"USE mntpt ") \
 	EM(afs_cell_trace_use_pin,		"USE pin   ") \
 	EM(afs_cell_trace_use_probe,		"USE probe ") \


