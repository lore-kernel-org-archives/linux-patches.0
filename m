Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620187;
	b=MmaU+r3GXodfp/o6Ev9j9LnAqk5zQHTKs2nkSQLSqyltyc+ovY4u6OMip90ZByx/VFEx
	 A+0amus382eKUO7elyUGGUzpd18Yxuwu9Nr18rgwaDvqM6VJcAYRDGs3T0gYOjupcYVoj
	 GGTdptu0Q+vwsQpp+2uQLMBk5lEzkfE2ZVRlvbKQE9j8mPMT1lQHMVZx66vQQZ6d8teYv
	 cS79hXmQZ5GhrXtU5LaPastTaYVJdIzIveM6Uf8DinMfFDZNZTl1iXM7g5ea4PFQNmvC5
	 xX+1ovVOP71R8Lz8hJxFLjnBw71Mgv6Sr8DD0FPHY0K/EaydNN8muMr1OlOcCnlS5Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pYrwguDniQcK4IhQMz3hVfRj0IYvDTmdl4br5aKsoDc=;
	b=ODO5EGfoIaAcKEmYLsBeLqgqydthoqjZb0Y7ASoMnfXFFhEiAVQo1wkDUEFt/BP9ekel
	 AAjxukDEFPReyQKs3ZWT1GSKVisB7drmv3WqWPf6Ep1HPZZUS/93a6IVGohzJE08OEvMu
	 h+lj6qQNVxAYodZIBeFZO7Zi9TRqYMjEvlNw56zRub2+rKvlLNldJCeDJ6dZr6T+BGK42
	 HfmqYoq4bkzHAgVPThrKFwShUjN6yrAKD6DsJQNEp0Nm8H0lwVuWVArUy/Z1ClfBtqC4O
	 1I4YZy9CLLZPHuZ2lfXl/G/qbwg8BT+yCcTsK4S4y7Rfa5qOCqq8OEzi96yI5QC/Klg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3WuKw0d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BCB606A31E;
	Wed, 25 Nov 2026 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3WuKw0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7082A1F000C4;
	Wed, 25 Nov 2026 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620187;
	bh=pYrwguDniQcK4IhQMz3hVfRj0IYvDTmdl4br5aKsoDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3WuKw0duYQYm9p6E+ZxEgZE60PA1AYjgp5wnCy6c6izAA+Z8o3dBSa+YZ1Xljx/d
	 2AUfbquWy6ojyU3RlLH7A8M5dMxzWPMcpf4md1BonrRxot40r2stnGi+JB1SGcX6iJ
	 LB2rKfWUBu7eb/eNRQt6nSGcY38FmkLnCCtgYmYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 7.3 0835/1005] smb: client: dont block dying tasks waiting for writeback on fsync
Date: Wed, 25 Nov 2026 15:36:13 +0100
Message-ID: <20261125143841.281228681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 0df0f24803061b6c2bef0d24de7c63c9cce46a49 upstream.

cifs_fsync() and cifs_strict_fsync() wait uninterruptibly for writeback
through file_write_and_wait_range().  As with close, a task killed in
fsync(2) on a hard mount with an unresponsive server is stuck in D state
until the server comes back.

Wait killably instead, using the same helper as cifs_flush().  The
writeback keeps going and its errors stay in the mapping; only the dying
caller stops waiting for it.

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   64 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 22 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2877,6 +2877,45 @@ cifs_get_readable_path(struct cifs_tcon
 	return -ENOENT;
 }
 
+static int cifs_wait_writeback_killable(struct address_space *mapping,
+					loff_t start, loff_t end)
+{
+	pgoff_t end_index = end >> PAGE_SHIFT;
+	pgoff_t index = start >> PAGE_SHIFT;
+	struct folio_batch fbatch;
+	int rc = 0;
+
+	folio_batch_init(&fbatch);
+	while (!rc &&
+	       filemap_get_folios_tag(mapping, &index, end_index,
+				      PAGECACHE_TAG_WRITEBACK, &fbatch)) {
+		for (unsigned int i = 0;
+		     !rc && i < folio_batch_count(&fbatch); i++)
+			rc = folio_wait_writeback_killable(fbatch.folios[i]);
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+	return rc;
+}
+
+static int cifs_file_write_and_wait_killable(struct file *file,
+					     loff_t start, loff_t end)
+{
+	struct address_space *mapping = file->f_mapping;
+	int rc, rc2;
+
+	if (end < start)
+		return 0;
+
+	rc = filemap_fdatawrite_range(mapping, start, end);
+	if (cifs_wait_writeback_killable(mapping, start, end))
+		return -EINTR;
+	rc2 = file_check_and_advance_wb_err(file);
+	if (!rc)
+		rc = rc2;
+	return rc;
+}
+
 /*
  * Flush data on a strict file.
  */
@@ -2888,7 +2927,7 @@ int cifs_strict_fsync(struct file *file,
 	unsigned int xid;
 	int rc;
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(inode->i_ino, rc);
 		return rc;
@@ -2920,7 +2959,7 @@ int cifs_fsync(struct file *file, loff_t
 	struct inode *inode = file_inode(file);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(file_inode(file)->i_ino, rc);
 		return rc;
@@ -2955,25 +2994,6 @@ fsync_exit:
 	return rc;
 }
 
-static int cifs_wait_writeback_killable(struct address_space *mapping)
-{
-	struct folio_batch fbatch;
-	pgoff_t index = 0;
-	int rc = 0;
-
-	folio_batch_init(&fbatch);
-	while (!rc &&
-	       filemap_get_folios_tag(mapping, &index, (pgoff_t)-1,
-				      PAGECACHE_TAG_WRITEBACK, &fbatch)) {
-		for (unsigned int i = 0;
-		     !rc && i < folio_batch_count(&fbatch); i++)
-			rc = folio_wait_writeback_killable(fbatch.folios[i]);
-		folio_batch_release(&fbatch);
-		cond_resched();
-	}
-	return rc;
-}
-
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
@@ -2987,7 +3007,7 @@ int cifs_flush(struct file *file, fl_own
 	if (file->f_mode & FMODE_WRITE) {
 		rc = filemap_fdatawrite(mapping);
 		if (fatal_signal_pending(current) ||
-		    cifs_wait_writeback_killable(mapping))
+		    cifs_wait_writeback_killable(mapping, 0, LLONG_MAX))
 			return 0;
 		rc2 = filemap_check_errors(mapping);
 		if (!rc)


