Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9EF130E4A;
	Tue, 18 Jun 2024 12:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714631; cv=none; b=I9LWext0qc0Lo8W5NBuVDVquG53HPMmuY9dUVbE7tCftCwkWxGvNiaZ3xzq/kAy2yiiT353S59fOich+DwVitnsCPDhL8NZpzbbhi1i1oFk+MIkQDD6KCFnsc+i5MgHAcRkToN+1kYM9bSQWa0N+jDx3lRfSe+54RS/vzJLK8Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714631; c=relaxed/simple;
	bh=+5BBSEpGD0INJNcCFlDStAdDKBQBTad0SyMX101L+XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7lmm33WqmuVQRYeHrevsdo4VthhqP6I52kvbT+D4wimlGrDeoLcc7OcLc0GCh2knz7iKzmJeGOi4DhUlU+EeCWvokj2lSDuVbFX6X2DcKu7a7+m6l22d+9AXKxOne02pEuk1Mh2l5VshgASHaZprtE1+dRkw0o02xXeQ5r0lgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFITSzXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFITSzXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B28CC32786;
	Tue, 18 Jun 2024 12:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714630;
	bh=+5BBSEpGD0INJNcCFlDStAdDKBQBTad0SyMX101L+XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFITSzXwNnnsuRKaPbzDKW/1f8J1PL2S43JhcMhcTNpM/NXRJXjlrXXF5yBHFgCwM
	 9bio8g32k5u/T6GBzZPaLRyK4nSxPK0jxF5sfESoqCj3Yz9F0/0t6m5XSwtEFF7N1Q
	 F09BLtLbuzCMEmjLwpxEzs06cBMbgkFKdgPB0cbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/770] NFSD: Remove extra "0x" in tracepoint format specifier
Date: Tue, 18 Jun 2024 14:27:39 +0200
Message-ID: <20240618123407.535604127@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3a90e1dff16afdae6e1c918bfaff24f4d0f84869 ]

Clean up: %p adds its own 0x already.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 7bb1c398daa51..9239d97b682c7 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -444,7 +444,7 @@ DECLARE_EVENT_CLASS(nfsd_file_class,
 		__entry->nf_may = nf->nf_may;
 		__entry->nf_file = nf->nf_file;
 	),
-	TP_printk("hash=0x%x inode=0x%p ref=%d flags=%s may=%s file=%p",
+	TP_printk("hash=0x%x inode=%p ref=%d flags=%s may=%s file=%p",
 		__entry->nf_hashval,
 		__entry->nf_inode,
 		__entry->nf_ref,
@@ -495,7 +495,7 @@ TRACE_EVENT(nfsd_file_acquire,
 		__entry->status = be32_to_cpu(status);
 	),
 
-	TP_printk("xid=0x%x hash=0x%x inode=0x%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=0x%p status=%u",
+	TP_printk("xid=0x%x hash=0x%x inode=%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=%p status=%u",
 			__entry->xid, __entry->hash, __entry->inode,
 			show_nfsd_may_flags(__entry->may_flags),
 			__entry->nf_ref, show_nf_flags(__entry->nf_flags),
@@ -516,7 +516,7 @@ DECLARE_EVENT_CLASS(nfsd_file_search_class,
 		__entry->hash = hash;
 		__entry->found = found;
 	),
-	TP_printk("hash=0x%x inode=0x%p found=%d", __entry->hash,
+	TP_printk("hash=0x%x inode=%p found=%d", __entry->hash,
 			__entry->inode, __entry->found)
 );
 
@@ -544,7 +544,7 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 		__entry->mode = inode->i_mode;
 		__entry->mask = mask;
 	),
-	TP_printk("inode=0x%p nlink=%u mode=0%ho mask=0x%x", __entry->inode,
+	TP_printk("inode=%p nlink=%u mode=0%ho mask=0x%x", __entry->inode,
 			__entry->nlink, __entry->mode, __entry->mask)
 );
 
-- 
2.43.0



