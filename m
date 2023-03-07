Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED94BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1285C433EF;
	Tue,  7 Mar 2023 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212992;
	bh=uP8NycU8MmBr0GAfc2TEr/+gW6zgMPL6neyvGKCzWOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltlv1v4GYz20VyJX8DVsAIy8uBq2iLJFjKpU3cGxer4A9IMm8jjmp4A6UYiEWpSFf
	 TNoEpARVfee8ojYDGex1JUPY7yYClU6ditEbDAzg4P1S8FweCWOU0Bg0PxM54kCr3J
	 emdiYguNKgPnvYaBbvzh1TjJjYyhYjEdUOsumB8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 363/885] nfs4trace: fix state manager flag printing
Date: Tue,  7 Mar 2023 17:54:57 +0100
Message-Id: <20230307170018.063443935@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit b46d80bd2d6e7e063c625a20de54248afe8d4889 ]

__print_flags wants a mask, not the enum value.  Add two more flags.

Fixes: 511ba52e4c01 ("NFS4: Trace state recovery operation")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4trace.h | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index 2cff5901c6894..3fa77ad7258f2 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -292,32 +292,34 @@ TRACE_DEFINE_ENUM(NFS4CLNT_MOVED);
 TRACE_DEFINE_ENUM(NFS4CLNT_LEASE_MOVED);
 TRACE_DEFINE_ENUM(NFS4CLNT_DELEGATION_EXPIRED);
 TRACE_DEFINE_ENUM(NFS4CLNT_RUN_MANAGER);
+TRACE_DEFINE_ENUM(NFS4CLNT_MANAGER_AVAILABLE);
 TRACE_DEFINE_ENUM(NFS4CLNT_RECALL_RUNNING);
 TRACE_DEFINE_ENUM(NFS4CLNT_RECALL_ANY_LAYOUT_READ);
 TRACE_DEFINE_ENUM(NFS4CLNT_RECALL_ANY_LAYOUT_RW);
+TRACE_DEFINE_ENUM(NFS4CLNT_DELEGRETURN_DELAYED);
 
 #define show_nfs4_clp_state(state) \
 	__print_flags(state, "|", \
-		{ NFS4CLNT_MANAGER_RUNNING,	"MANAGER_RUNNING" }, \
-		{ NFS4CLNT_CHECK_LEASE,		"CHECK_LEASE" }, \
-		{ NFS4CLNT_LEASE_EXPIRED,	"LEASE_EXPIRED" }, \
-		{ NFS4CLNT_RECLAIM_REBOOT,	"RECLAIM_REBOOT" }, \
-		{ NFS4CLNT_RECLAIM_NOGRACE,	"RECLAIM_NOGRACE" }, \
-		{ NFS4CLNT_DELEGRETURN,		"DELEGRETURN" }, \
-		{ NFS4CLNT_SESSION_RESET,	"SESSION_RESET" }, \
-		{ NFS4CLNT_LEASE_CONFIRM,	"LEASE_CONFIRM" }, \
-		{ NFS4CLNT_SERVER_SCOPE_MISMATCH, \
-						"SERVER_SCOPE_MISMATCH" }, \
-		{ NFS4CLNT_PURGE_STATE,		"PURGE_STATE" }, \
-		{ NFS4CLNT_BIND_CONN_TO_SESSION, \
-						"BIND_CONN_TO_SESSION" }, \
-		{ NFS4CLNT_MOVED,		"MOVED" }, \
-		{ NFS4CLNT_LEASE_MOVED,		"LEASE_MOVED" }, \
-		{ NFS4CLNT_DELEGATION_EXPIRED,	"DELEGATION_EXPIRED" }, \
-		{ NFS4CLNT_RUN_MANAGER,		"RUN_MANAGER" }, \
-		{ NFS4CLNT_RECALL_RUNNING,	"RECALL_RUNNING" }, \
-		{ NFS4CLNT_RECALL_ANY_LAYOUT_READ, "RECALL_ANY_LAYOUT_READ" }, \
-		{ NFS4CLNT_RECALL_ANY_LAYOUT_RW, "RECALL_ANY_LAYOUT_RW" })
+	{ BIT(NFS4CLNT_MANAGER_RUNNING),	"MANAGER_RUNNING" }, \
+	{ BIT(NFS4CLNT_CHECK_LEASE),		"CHECK_LEASE" }, \
+	{ BIT(NFS4CLNT_LEASE_EXPIRED),	"LEASE_EXPIRED" }, \
+	{ BIT(NFS4CLNT_RECLAIM_REBOOT),	"RECLAIM_REBOOT" }, \
+	{ BIT(NFS4CLNT_RECLAIM_NOGRACE),	"RECLAIM_NOGRACE" }, \
+	{ BIT(NFS4CLNT_DELEGRETURN),		"DELEGRETURN" }, \
+	{ BIT(NFS4CLNT_SESSION_RESET),	"SESSION_RESET" }, \
+	{ BIT(NFS4CLNT_LEASE_CONFIRM),	"LEASE_CONFIRM" }, \
+	{ BIT(NFS4CLNT_SERVER_SCOPE_MISMATCH),	"SERVER_SCOPE_MISMATCH" }, \
+	{ BIT(NFS4CLNT_PURGE_STATE),		"PURGE_STATE" }, \
+	{ BIT(NFS4CLNT_BIND_CONN_TO_SESSION),	"BIND_CONN_TO_SESSION" }, \
+	{ BIT(NFS4CLNT_MOVED),		"MOVED" }, \
+	{ BIT(NFS4CLNT_LEASE_MOVED),		"LEASE_MOVED" }, \
+	{ BIT(NFS4CLNT_DELEGATION_EXPIRED),	"DELEGATION_EXPIRED" }, \
+	{ BIT(NFS4CLNT_RUN_MANAGER),		"RUN_MANAGER" }, \
+	{ BIT(NFS4CLNT_MANAGER_AVAILABLE), "MANAGER_AVAILABLE" }, \
+	{ BIT(NFS4CLNT_RECALL_RUNNING),	"RECALL_RUNNING" }, \
+	{ BIT(NFS4CLNT_RECALL_ANY_LAYOUT_READ), "RECALL_ANY_LAYOUT_READ" }, \
+	{ BIT(NFS4CLNT_RECALL_ANY_LAYOUT_RW), "RECALL_ANY_LAYOUT_RW" }, \
+	{ BIT(NFS4CLNT_DELEGRETURN_DELAYED), "DELERETURN_DELAYED" })
 
 TRACE_EVENT(nfs4_state_mgr,
 		TP_PROTO(
-- 
2.39.2



