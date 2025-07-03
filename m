Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B0C2EF67F;
	Thu,  3 Jul 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554889; cv=none; b=gD0fIkby4bfONHOpqFZS9/QfyF8KZUhLxAOFu6oDco1c28TD742sz5Y1CT7Ik3IkNuLOFqAiLc5hjPa+Stu/LFdAPcPTjck7MhAeAB+i6LMwKZz41iAhFoDYWVDqhPp7z4tIOXFTMTEDOwhDGmV3kCU4xtwmW8Qhtk+/Qo1aCmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554889; c=relaxed/simple;
	bh=qdDZ7Z70yq18vvG8Ji2f1Q2ngptSUu3rFgrnnD8bO8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZVT/MLQVPeQUFkACw6BNSn1SzryFVAz1XOFqC5ojv6hQdU65BmI/AYw6ktlvCgIokYgFxkAye9tYHGICaaGsAWOQ3gsxfzq5WDCQ8oSgGrG80huiw5dASeES8GSESgHWs0CEQaWWlw/YMuqj2wqXaUJkNDGdpHYCyQZWbyK00s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGa3uJBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGa3uJBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C220BC4CEEE;
	Thu,  3 Jul 2025 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554889;
	bh=qdDZ7Z70yq18vvG8Ji2f1Q2ngptSUu3rFgrnnD8bO8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGa3uJBUQd0/1EUEBXlzdAh/bJIWUlpy8IvfGtcrMnarr1bwEjDoS1VB+lsnhXfzP
	 lJISKp8lwkUHvUxu9BltADJeTo4SmOpyk0VDA9j1gVEhv98oSfrfosTsY/LYyW6IPq
	 lJk1p0Um97puxYchyvkVcC+3uY9syR3JnJ3EZLcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 110/263] smb: client: remove \t from TP_printk statements
Date: Thu,  3 Jul 2025 16:40:30 +0200
Message-ID: <20250703144008.753118243@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -794,7 +794,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_err_class,
 		__entry->status = status;
 		__entry->rc = rc;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
 		__entry->sesid, __entry->tid, __entry->cmd, __entry->mid,
 		__entry->status, __entry->rc)
 )
@@ -829,7 +829,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_done_class,
 		__entry->cmd = cmd;
 		__entry->mid = mid;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu",
 		__entry->sesid, __entry->tid,
 		__entry->cmd, __entry->mid)
 )
@@ -867,7 +867,7 @@ DECLARE_EVENT_CLASS(smb3_mid_class,
 		__entry->when_sent = when_sent;
 		__entry->when_received = when_received;
 	),
-	TP_printk("\tcmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
+	TP_printk("cmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
 		__entry->cmd, __entry->mid, __entry->pid, __entry->when_sent,
 		__entry->when_received)
 )
@@ -898,7 +898,7 @@ DECLARE_EVENT_CLASS(smb3_exit_err_class,
 		__assign_str(func_name);
 		__entry->rc = rc;
 	),
-	TP_printk("\t%s: xid=%u rc=%d",
+	TP_printk("%s: xid=%u rc=%d",
 		__get_str(func_name), __entry->xid, __entry->rc)
 )
 
@@ -924,7 +924,7 @@ DECLARE_EVENT_CLASS(smb3_sync_err_class,
 		__entry->ino = ino;
 		__entry->rc = rc;
 	),
-	TP_printk("\tino=%lu rc=%d",
+	TP_printk("ino=%lu rc=%d",
 		__entry->ino, __entry->rc)
 )
 
@@ -950,7 +950,7 @@ DECLARE_EVENT_CLASS(smb3_enter_exit_clas
 		__entry->xid = xid;
 		__assign_str(func_name);
 	),
-	TP_printk("\t%s: xid=%u",
+	TP_printk("%s: xid=%u",
 		__get_str(func_name), __entry->xid)
 )
 


