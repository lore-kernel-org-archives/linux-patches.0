Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB501DC98B;
	Thu,  3 Jul 2025 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554100; cv=none; b=DqEVAva29wFDbzNxoZI/udLfrob8/tG24zRyftnWfEEkpTU7ECyNkNuwO3imT15ErMVI4IYzzSHWsjv7pjyaJojAbSxx230RfSq5KfgFwEGbuy2PlzViFN+req9IEGm7oYv0JtaqtawUXlVLj82JXPvHVXYACMFlUR04eNQv6KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554100; c=relaxed/simple;
	bh=RseqOUN6sFMUJLVnKIooPB25E06NQooYzZbzaehXV50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbIPRh9DV2jQYzL8gw0ecTUoP6n0uiRVwUFyVzQ1JSFfIxpbKZ90wi6/sMyJGaO0B4HcEYLUqJ107iUhRjbLHnMUt1K3XxmvTXISn/x5SxPkEptOc0ccqCPOKOGCY1LDZ/U+fuVZ6ox+1GfwcNd5Lc0LIYp9dQrhwE4PbAO69DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2aUF2Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2aUF2Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902FCC4CEE3;
	Thu,  3 Jul 2025 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554100;
	bh=RseqOUN6sFMUJLVnKIooPB25E06NQooYzZbzaehXV50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2aUF2Ws+EH4lSmS+NWYHBA/z0AJf554CE7cWPqUWwc9Zg2E/hVV5voI+/1C4F2YG
	 g7h/jLh0FGJGPPRHW3MZMTJ9gvhNP9Tw6KgThJFCKabUuJdFW1157d8Kk8PVF0L3EX
	 PTspIevng0AIYyzYjQbux9ExD1L+VAvf+M/ZvZZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 080/218] smb: client: remove \t from TP_printk statements
Date: Thu,  3 Jul 2025 16:40:28 +0200
Message-ID: <20250703143959.143927105@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Metzmacher <metze@samba.org>

commit e97f9540ce001503a4539f337da742c1dfa7d86a upstream.

The generate '[FAILED TO PARSE]' strings in trace-cmd report output like this:

  rm-5298  [001]  6084.533748493: smb3_exit_err:        [FAILED TO PARSE] xid=972 func_name=cifs_rmdir rc=-39
  rm-5298  [001]  6084.533959234: smb3_enter:           [FAILED TO PARSE] xid=973 func_name=cifs_closedir
  rm-5298  [001]  6084.533967630: smb3_close_enter:     [FAILED TO PARSE] xid=973 fid=94489281833 tid=1 sesid=96758029877361
  rm-5298  [001]  6084.534004008: smb3_cmd_enter:       [FAILED TO PARSE] tid=1 sesid=96758029877361 cmd=6 mid=566
  rm-5298  [001]  6084.552248232: smb3_cmd_done:        [FAILED TO PARSE] tid=1 sesid=96758029877361 cmd=6 mid=566
  rm-5298  [001]  6084.552280542: smb3_close_done:      [FAILED TO PARSE] xid=973 fid=94489281833 tid=1 sesid=96758029877361
  rm-5298  [001]  6084.552316034: smb3_exit_done:       [FAILED TO PARSE] xid=973 func_name=cifs_closedir

Cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/trace.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -140,7 +140,7 @@ DECLARE_EVENT_CLASS(smb3_rw_err_class,
 		__entry->len = len;
 		__entry->rc = rc;
 	),
-	TP_printk("\tR=%08x[%x] xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
+	TP_printk("R=%08x[%x] xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
 		  __entry->rreq_debug_id, __entry->rreq_debug_index,
 		  __entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		  __entry->offset, __entry->len, __entry->rc)
@@ -190,7 +190,7 @@ DECLARE_EVENT_CLASS(smb3_other_err_class
 		__entry->len = len;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		__entry->offset, __entry->len, __entry->rc)
 )
@@ -247,7 +247,7 @@ DECLARE_EVENT_CLASS(smb3_copy_range_err_
 		__entry->len = len;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->target_fid,
 		__entry->src_offset, __entry->target_fid, __entry->target_offset, __entry->len, __entry->rc)
 )
@@ -298,7 +298,7 @@ DECLARE_EVENT_CLASS(smb3_copy_range_done
 		__entry->target_offset = target_offset;
 		__entry->len = len;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->target_fid,
 		__entry->src_offset, __entry->target_fid, __entry->target_offset, __entry->len)
 )
@@ -482,7 +482,7 @@ DECLARE_EVENT_CLASS(smb3_fd_class,
 		__entry->tid = tid;
 		__entry->sesid = sesid;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid)
 )
 
@@ -521,7 +521,7 @@ DECLARE_EVENT_CLASS(smb3_fd_err_class,
 		__entry->sesid = sesid;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		__entry->rc)
 )
@@ -793,7 +793,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_err_class,
 		__entry->status = status;
 		__entry->rc = rc;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
 		__entry->sesid, __entry->tid, __entry->cmd, __entry->mid,
 		__entry->status, __entry->rc)
 )
@@ -828,7 +828,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_done_class,
 		__entry->cmd = cmd;
 		__entry->mid = mid;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu",
 		__entry->sesid, __entry->tid,
 		__entry->cmd, __entry->mid)
 )
@@ -866,7 +866,7 @@ DECLARE_EVENT_CLASS(smb3_mid_class,
 		__entry->when_sent = when_sent;
 		__entry->when_received = when_received;
 	),
-	TP_printk("\tcmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
+	TP_printk("cmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
 		__entry->cmd, __entry->mid, __entry->pid, __entry->when_sent,
 		__entry->when_received)
 )
@@ -897,7 +897,7 @@ DECLARE_EVENT_CLASS(smb3_exit_err_class,
 		__assign_str(func_name);
 		__entry->rc = rc;
 	),
-	TP_printk("\t%s: xid=%u rc=%d",
+	TP_printk("%s: xid=%u rc=%d",
 		__get_str(func_name), __entry->xid, __entry->rc)
 )
 
@@ -923,7 +923,7 @@ DECLARE_EVENT_CLASS(smb3_sync_err_class,
 		__entry->ino = ino;
 		__entry->rc = rc;
 	),
-	TP_printk("\tino=%lu rc=%d",
+	TP_printk("ino=%lu rc=%d",
 		__entry->ino, __entry->rc)
 )
 
@@ -949,7 +949,7 @@ DECLARE_EVENT_CLASS(smb3_enter_exit_clas
 		__entry->xid = xid;
 		__assign_str(func_name);
 	),
-	TP_printk("\t%s: xid=%u",
+	TP_printk("%s: xid=%u",
 		__get_str(func_name), __entry->xid)
 )
 


