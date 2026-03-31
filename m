Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CF23F7867;
	Tue, 31 Mar 2026 16:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976122; cv=none; b=qt12Ula3YyboRIoS6RL1LvFW7Alm0KtObjVcO87lRM4W3IvXTweH07Xk/+k4uvX63+vfYacjPybIM6YPq/MirheO/t/9gpCC5u7G8oW2BEY2/uH40SrmfP4t7kO7SjARWkhSRdubsSqdnuraokCe0QJamNu9H1DXuXcACOjJnhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976122; c=relaxed/simple;
	bh=PFmrcSKv1bYE9YZk6OJBYyBTC2GcEgSBYuVzD3pBrO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F65eN/fadLL93aSdILhjGBeBMNgVmmsRzRQOFv52xa1OuxGpk2MhN4qPFHRqAJ2t2I4RmAdAiH3xa3kS9gjrFa+DsU/6cJmUhIUj3puWTR2i0ta9++s2yjbbKPOzMKBbkpQj8h1Y0sUnXLLfX13jw85wJCScmeu3A8nhBBHdIn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZX3lyL+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZX3lyL+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB7EC19423;
	Tue, 31 Mar 2026 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976122;
	bh=PFmrcSKv1bYE9YZk6OJBYyBTC2GcEgSBYuVzD3pBrO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX3lyL+eF1rCW9yrSJQm9EWCMvIXPTROHRbgE/NVdpFmpY5QrnP4Job39nAcDbtwm
	 w7w6qLlB1+VMwb/fpyuTBfuwvNPz4FKqCQxouNR8U5O/TEjFDxZsTavLIS2wWbPdyc
	 qS7BrWuqQ8+AWkYrra+vM96Pr4urxF8fiucu8Ebs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rostedt@goodmis.org,
	david.laight.linux@gmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 182/244] xfs: remove file_path tracepoint data
Date: Tue, 31 Mar 2026 18:22:12 +0200
Message-ID: <20260331161748.479827830@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit e31c53a8060e134111ed095783fee0aa0c43b080 upstream.

The xfile/xmbuf shmem file descriptions are no longer as detailed as
they were when online fsck was first merged, because moving to static
strings in commit 60382993a2e180 ("xfs: get rid of the
xchk_xfile_*_descr calls") removed a memory allocation and hence a
source of failure.

However this makes encoding the description in the tracepoints sort of a
waste of memory.  David Laight also points out that file_path doesn't
zero the whole buffer which causes exposure of stale trace bytes, and
Steven Rostedt wonders why we're not using a dynamic array for the file
path.

I don't think this is worth fixing, so let's just rip it out.

Cc: rostedt@goodmis.org
Cc: david.laight.linux@gmail.com
Link: https://lore.kernel.org/linux-xfs/20260323172204.work.979-kees@kernel.org/
Cc: stable@vger.kernel.org # v6.11
Fixes: 19ebc8f84ea12e ("xfs: fix file_path handling in tracepoints")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |   12 ++----------
 fs/xfs/xfs_trace.h   |   11 ++---------
 2 files changed, 4 insertions(+), 19 deletions(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -959,20 +959,12 @@ TRACE_EVENT(xfile_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		*path;
-
 		__entry->ino = file_inode(xf->file)->i_ino;
-		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
-		if (IS_ERR(path))
-			strncpy(__entry->pathname, "(unknown)",
-					sizeof(__entry->pathname));
 	),
-	TP_printk("xfino 0x%lx path '%s'",
-		  __entry->ino,
-		  __entry->pathname)
+	TP_printk("xfino 0x%lx",
+		  __entry->ino)
 );
 
 TRACE_EVENT(xfile_destroy,
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4710,23 +4710,16 @@ TRACE_EVENT(xmbuf_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		*path;
 		struct file	*file = btp->bt_file;
 
 		__entry->dev = btp->bt_mount->m_super->s_dev;
 		__entry->ino = file_inode(file)->i_ino;
-		path = file_path(file, __entry->pathname, MAXNAMELEN);
-		if (IS_ERR(path))
-			strncpy(__entry->pathname, "(unknown)",
-					sizeof(__entry->pathname));
 	),
-	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
+	TP_printk("dev %d:%d xmino 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->pathname)
+		  __entry->ino)
 );
 
 TRACE_EVENT(xmbuf_free,


