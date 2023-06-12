Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0951519523
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8449AC433EF;
	Mon, 12 Jun 2023 10:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565912;
	bh=DYFhqVohNDLi4aW1HLIDStGyfnABCNRW6+o2Z1Q3Lxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCq6TwuGnJ201VNgGqq9LQHbAz9Iiw8TRfYH/srfcVgZ1W2sOPj7r6xpo5KF9PYZk
	 ziruvSyu/EVuaUIBmXdJGTTwasNCLlwkNsMEkHGEBCHbz71DvcanCEu2c3PwMrxFy3
	 GRM/MtqO8ADOUzmtR2nf8og+9BATImAyueK4QAI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Aurelien Aptel <aaptel@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4 38/45] cifs: get rid of unused parameter in reconn_setup_dfs_targets()
Date: Mon, 12 Jun 2023 12:26:32 +0200
Message-ID: <20230612101656.210793408@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

commit baf3f08ef4083b76ca67b143e135213a7f941879 upstream.

The target iterator parameter "it" is not used in
reconn_setup_dfs_targets(), so just remove it.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -469,8 +469,7 @@ static void reconn_inval_dfs_target(stru
 }
 
 static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
-					   struct dfs_cache_tgt_list *tl,
-					   struct dfs_cache_tgt_iterator **it)
+					   struct dfs_cache_tgt_list *tl)
 {
 	if (!cifs_sb->origin_fullpath)
 		return -EOPNOTSUPP;
@@ -515,7 +514,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 	} else {
 		cifs_sb = CIFS_SB(sb);
 
-		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list, &tgt_it);
+		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list);
 		if (rc && (rc != -EOPNOTSUPP)) {
 			cifs_server_dbg(VFS, "%s: no target servers for DFS failover\n",
 				 __func__);


