Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AE6AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB04C433D7;
	Thu, 27 Oct 2022 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890490;
	bh=/1/fHHHyTCPbazGczitn/5P21xY/nMcHsq2AoX3DCKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPvHvq+v8AwFYICmQE2W4pPErS8AhosRw7AMbEAFD6R5wjXLALFzjhz2dHzUmNiiX
	 DH50KVd43PsMfTOjmWyvZNfwPZGZQPalHn0wUXBeeAgmPAvVRuxWH2A5yzG14hmUsV
	 fuFj80fd8R2Zln4iL0qhNEa2iuLId2QH/XW05ec4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Reichl <preichl@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 11/53] xfs: remove the xfs_dq_logitem_t typedef
Date: Thu, 27 Oct 2022 18:55:59 +0200
Message-Id: <20221027165050.242411710@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Reichl <preichl@redhat.com>

commit fd8b81dbbb23d4a3508cfac83256b4f5e770941c upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c      |    2 +-
 fs/xfs/xfs_dquot.h      |    2 +-
 fs/xfs/xfs_dquot_item.h |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1018,7 +1018,7 @@ xfs_qm_dqflush_done(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
+	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
 	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -40,7 +40,7 @@ struct xfs_dquot {
 	xfs_fileoff_t		q_fileoffset;
 
 	struct xfs_disk_dquot	q_core;
-	xfs_dq_logitem_t	q_logitem;
+	struct xfs_dq_logitem	q_logitem;
 	/* total regular nblks used+reserved */
 	xfs_qcnt_t		q_res_bcount;
 	/* total inos allocd+reserved */
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -11,11 +11,11 @@ struct xfs_trans;
 struct xfs_mount;
 struct xfs_qoff_logitem;
 
-typedef struct xfs_dq_logitem {
-	struct xfs_log_item	 qli_item;	   /* common portion */
-	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
-	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
-} xfs_dq_logitem_t;
+struct xfs_dq_logitem {
+	struct xfs_log_item	 qli_item;	/* common portion */
+	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
+	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
+};
 
 typedef struct xfs_qoff_logitem {
 	struct xfs_log_item	 qql_item;	/* common portion */


