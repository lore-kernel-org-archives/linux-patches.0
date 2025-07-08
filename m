Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C158B2E5B15;
	Tue,  8 Jul 2025 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992364; cv=none; b=PUfBjCK1nnCx5ihdx7XgwMBJZ5unwkOPAuz98lrYUZQ7L/K8cp8IQ1IF2FBVC696YxLBb4a/IrXmUcB/cJnc56S2AbT3rDudYA2HNkHizsygPkjUdCrPpmoKCWcrFAtjve7V+kpBMkDebtE3sIspft6oF7CBQTZaUQFhK7wXSzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992364; c=relaxed/simple;
	bh=kgNsivIV/KZ7UtjhpeYF0TO+ms2BIxW/erLpt+nfGMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJVCWUhrLrBEXMrlKifxGvpb4W+IxV5fsB8cTSh4mOmt+q/0x+QHoty9T512QoJaR/9ysBG/bzHsVhd1OnzphgS/gwSp1AfqORBFjqzsPzrv75jmUf/tktlewrw5k56y0SSP62MDKbaFVBnV9NixXFzWqGcYy3G4ceMvLRJ94IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtDLcTpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtDLcTpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5FAC4CEED;
	Tue,  8 Jul 2025 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992364;
	bh=kgNsivIV/KZ7UtjhpeYF0TO+ms2BIxW/erLpt+nfGMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtDLcTpNbvX0T+wnUj/B+4HIAwdz2KiH2XlgZhrcNFNZ242I5k/a0hGAXSslIZ3gF
	 evC0wAOgJOON+LSiD99RuHLIidnjN5KSBiks2JWr/TtzV3WzGA6/o9hCJBU8uZuOHs
	 pjJ9IrLdJIgoKsr0MTWiQsoyU4zLJgMoC0K+9ENw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/132] smb: client: remove \t from TP_printk statements
Date: Tue,  8 Jul 2025 18:22:57 +0200
Message-ID: <20250708162232.584511161@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit e97f9540ce001503a4539f337da742c1dfa7d86a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/trace.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 563cb4d8edf0c..4dfdc521c5c98 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -114,7 +114,7 @@ DECLARE_EVENT_CLASS(smb3_rw_err_class,
 		__entry->len = len;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		__entry->offset, __entry->len, __entry->rc)
 )
@@ -247,7 +247,7 @@ DECLARE_EVENT_CLASS(smb3_fd_class,
 		__entry->tid = tid;
 		__entry->sesid = sesid;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid)
 )
 
@@ -286,7 +286,7 @@ DECLARE_EVENT_CLASS(smb3_fd_err_class,
 		__entry->sesid = sesid;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		__entry->rc)
 )
@@ -558,7 +558,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_err_class,
 		__entry->status = status;
 		__entry->rc = rc;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
 		__entry->sesid, __entry->tid, __entry->cmd, __entry->mid,
 		__entry->status, __entry->rc)
 )
@@ -593,7 +593,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_done_class,
 		__entry->cmd = cmd;
 		__entry->mid = mid;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu",
 		__entry->sesid, __entry->tid,
 		__entry->cmd, __entry->mid)
 )
@@ -631,7 +631,7 @@ DECLARE_EVENT_CLASS(smb3_mid_class,
 		__entry->when_sent = when_sent;
 		__entry->when_received = when_received;
 	),
-	TP_printk("\tcmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
+	TP_printk("cmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
 		__entry->cmd, __entry->mid, __entry->pid, __entry->when_sent,
 		__entry->when_received)
 )
@@ -662,7 +662,7 @@ DECLARE_EVENT_CLASS(smb3_exit_err_class,
 		__assign_str(func_name, func_name);
 		__entry->rc = rc;
 	),
-	TP_printk("\t%s: xid=%u rc=%d",
+	TP_printk("%s: xid=%u rc=%d",
 		__get_str(func_name), __entry->xid, __entry->rc)
 )
 
@@ -688,7 +688,7 @@ DECLARE_EVENT_CLASS(smb3_sync_err_class,
 		__entry->ino = ino;
 		__entry->rc = rc;
 	),
-	TP_printk("\tino=%lu rc=%d",
+	TP_printk("ino=%lu rc=%d",
 		__entry->ino, __entry->rc)
 )
 
@@ -714,7 +714,7 @@ DECLARE_EVENT_CLASS(smb3_enter_exit_class,
 		__entry->xid = xid;
 		__assign_str(func_name, func_name);
 	),
-	TP_printk("\t%s: xid=%u",
+	TP_printk("%s: xid=%u",
 		__get_str(func_name), __entry->xid)
 )
 
-- 
2.39.5



