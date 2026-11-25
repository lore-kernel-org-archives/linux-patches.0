Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619051;
	b=3AhXh53aDX2hub6/WDqTAu8t5zz18uw7+kFJO2X1uUFNoTeL5yzgM6gy9Q3t0lRdmUtz
	 cEFJV2pn8LhERkbtWxr6izwldwc5wwWV/+xV3NWupYzIOGvU0yScNjZYzW+/D97AxWPx4
	 AOh1v/TYgctxwS3EVWyvjQ3kQDIQs2wBU9FDbrtIb45xMH/RU3F3/PYqsYtEawkbJ+cN/
	 ofSKERilCV5tORdWS7Ya3/aPJuozvxLtchRj1cg1JrIPYTMr96FYAVbK9L3UcUKFT1Bvf
	 WGiUEL1fcEiBhuCyq23EXzzsgnUba82cBV9GdT7WC4YdrfbFCzVBD2KzNFZbWOvG1FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etmX/JGbbpXZxGfMr/pXSqEYr49GIG+QkkpGcgErw+A=;
	b=2pNcsWfiNynuRj6QPTKMT6tstDdwwByVySrd3qWaxtmyXdOxFWSljCi1ipsJ/69H9pM+
	 Jt1xFU5dX3kedldsvZMpeCcN3ftGhFm3UqBkp6W3O/Nzi+/6I8DWoRthXJADSexaqtjAL
	 dBrVIlzW5PCCqbGE59IqQ6FJayKFE1hp99eebH+vq2pHgFj3nb0scHxtngaIzx/wGKTPB
	 xq3h+gMw9z3lv10HCqMayFIb/NdIpihnfWA8Par8WBTjShcXVemYwyMB5v75UCs/sF3Pn
	 2RoLJeW9Jbhc+ODGs95kX5N+d1RgOdkUU4G+9AjRW+aJCe8FNy7TQy39aOCnGac0M+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMNfaTkP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF1D606A31E;
	Wed, 25 Nov 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMNfaTkP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB341F000C4;
	Wed, 25 Nov 2026 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619051;
	bh=etmX/JGbbpXZxGfMr/pXSqEYr49GIG+QkkpGcgErw+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMNfaTkPZBunXo7bX8GUMeIi6IpOmtBemL7UFdZ4Rrk0lkgKkpi/OMFMmxtERXYOz
	 pBB4wa7ftmQLnolNbCqrPAgzHV4E7ew4QAbuXnSw572ex6XLPC5NnjLQjNb0AWwyU4
	 pgmt5U3O1ECPESAAuVK7K2ZGLtu2x3Qg9oIwEAHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0473/1005] NFS: dont let delegated c/mtime stamps go backward
Date: Wed, 25 Nov 2026 15:30:11 +0100
Message-ID: <20261125143832.825606754@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 427d4cd8048c8e18e7d0c7d0637e7fbec9fba078 ]

With a timestamp delegation the client stamps c/mtime from its own
coarse clock. That can land before the server's fine-grained ctime the
client cached from the OPEN or SETATTR reply, e.g. on a WRITE right
after an exclusive create. The server then either rejects the times
(they don't pass dl_ctime) or can't apply the ctime, since
inode_set_ctime_deleg() never moves ctime backward. Either way the
c/mtime the client reported while holding the delegation changes
after DELEGRETURN; git t1092 over NFSv4.2 sees a stat-dirty file.

When a delegated stamp isn't after the cached ctime, use the cached
ctime + 1ns instead. Compute the stamp before storing it, so lockless
readers (getattr, CB_GETATTR) never see the trailing coarse time.

Fixes: e12912d94137 ("NFSv4: Add support for delegated atime and mtime attributes")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index cb414396063d4..c07e56c313903 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -623,25 +623,33 @@ nfs_fattr_fixup_delegated(struct inode *inode, struct nfs_fattr *fattr)
 	}
 }
 
+/*
+ * With delegated timestamps, the client's coarse clock can trail the
+ * server's fine-grained ctime cached from an OPEN or SETATTR reply. The
+ * server won't move ctime backward when the times are returned, so a
+ * new stamp must land after the cached ctime.
+ */
+static struct timespec64 nfs_delegated_stamp(struct inode *inode)
+{
+	struct timespec64 ctime = inode_get_ctime(inode);
+	struct timespec64 now = current_time(inode);
+
+	if (timespec64_compare(&now, &ctime) <= 0) {
+		now = ctime;
+		timespec64_add_ns(&now, 1);
+	}
+	return now;
+}
+
 static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 {
 	unsigned int cache_flags = 0;
 
 	if (attr->ia_valid & ATTR_MTIME_SET) {
-		struct timespec64 ctime = inode_get_ctime(inode);
-		struct timespec64 mtime = inode_get_mtime(inode);
-		struct timespec64 now;
-		bool updated = false;
-
-		now = inode_set_ctime_current(inode);
-		if (!timespec64_equal(&now, &ctime))
-			updated = true;
-
+		/* The stamp is always after the old ctime */
+		inode_set_ctime_to_ts(inode, nfs_delegated_stamp(inode));
 		inode_set_mtime_to_ts(inode, attr->ia_mtime);
-		if (!timespec64_equal(&now, &mtime))
-			updated = true;
-
-		inode_maybe_inc_iversion(inode, updated);
+		inode_maybe_inc_iversion(inode, true);
 		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
 	}
 	if (attr->ia_valid & ATTR_ATIME) {
@@ -659,7 +667,11 @@ static void nfs_update_atime(struct inode *inode)
 
 static void nfs_update_mtime(struct inode *inode)
 {
-	inode_update_time(inode, FS_UPD_CMTIME, 0);
+	struct timespec64 now = nfs_delegated_stamp(inode);
+
+	/* Not inode_update_time(): lockless readers would see its stamp */
+	inode_set_ctime_to_ts(inode, now);
+	inode_set_mtime_to_ts(inode, now);
 	NFS_I(inode)->cache_validity &=
 		~(NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME);
 }
-- 
2.53.0



