Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520D0262A6;
	Tue, 31 Mar 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975424; cv=none; b=lzg6ArcIJKO3sshuiblyObRWOVXgf1SaEv0izyoIrXN5HT95GIaqIBFzyLzUlV+UTcljSTN5ImLmJBJ9IVKi3ChPvYs1tFOAk1wPk5NkOJJBv7FAZVaon7Y+QS87S9ID+xpK+Wzkr90y6LtQwNq5Mup6n5vS4ef8/y8U8//VARo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975424; c=relaxed/simple;
	bh=LzmNfeFXt7byRM/TYzuL1WQCJAngB9zhF0q9116hITE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCxBG+EK2OjtEzgOo5Y3wbdHi+rcoHuiV1PpaKe+cQA59fcHjTRG/4vDKBphMg0OCDrFVHynKO+244KREXzk6YUfh4ekTbm0mYo1PmrGn9eoY4gqkevipEtl6IR9F7ruuBgfPYs2zAcHp99OqSfg+3N1AKdkH/7igx521DKL820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHI/Ut24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHI/Ut24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92F2C19423;
	Tue, 31 Mar 2026 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975424;
	bh=LzmNfeFXt7byRM/TYzuL1WQCJAngB9zhF0q9116hITE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHI/Ut24a6MTAAVwZXcsI2xtEcOhCpR4jC2lB3BzgKsKDXKrGi/YwvBmM68vpcnKR
	 CNHyZ9kpddSyzl9UFwnTpMkuK7rCbBpPUhZUWImz35vkrEiHMHHcHqBlmU2kCVxOz9
	 ighFBnqCg+t3PoXencHWE+KCi1UGoLoAw5HHl3TU=
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
Subject: [PATCH 6.19 289/342] xfs: remove file_path tracepoint data
Date: Tue, 31 Mar 2026 18:22:02 +0200
Message-ID: <20260331161809.574770603@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -972,20 +972,12 @@ TRACE_EVENT(xfile_create,
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
@@ -5115,23 +5115,16 @@ TRACE_EVENT(xmbuf_create,
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


