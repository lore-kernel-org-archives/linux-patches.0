Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FC11A5B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGYIqIPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51230C433CA;
	Mon,  9 Oct 2023 13:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857443;
	bh=DeWTyKYlC2+KGNWa9Ab3sl5/I7NkDTwR8BdRH8UKBkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGYIqIPRb4JLxvWZBccp2oiSipJFEVI5vJMYD914kLbpYnSykNk/ypxIraCy/NWNU
	 idZkn0Laye7VxrNU4Io+CUcHJPTe3ZJDzSmmY/ZjA62cZz6RcbitiXnkpH6VRUQZZo
	 4Zj58nI71z4FLAdwBqomX5Mjr2FnQmvfANK2GQI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/162] NFS: Cleanup unused rpc_clnt variable
Date: Mon,  9 Oct 2023 15:00:02 +0200
Message-ID: <20231009130123.534722170@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit e025f0a73f6acb920d86549b2177a5883535421d ]

The root rpc_clnt is not used here, clean it up.

Fixes: 4dc73c679114 ("NFSv4: keep state manager thread active if swap is enabled")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 956fd46f97d2 ("NFSv4: Fix a state manager thread deadlock regression")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 5b49e5365bb30..1b707573fbf8d 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1209,10 +1209,6 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 {
 	struct task_struct *task;
 	char buf[INET6_ADDRSTRLEN + sizeof("-manager") + 1];
-	struct rpc_clnt *cl = clp->cl_rpcclient;
-
-	while (cl != cl->cl_parent)
-		cl = cl->cl_parent;
 
 	set_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state);
 	if (test_and_set_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state) != 0) {
-- 
2.40.1



