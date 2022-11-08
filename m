Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7543D28EE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B5FC433C1;
	Tue,  8 Nov 2022 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667914857;
	bh=KxmMjUrn/H/5RJNj26oMzMnxxZzzGs7q1hka+krfQwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZbijT06u+ko0xF3KcCn9n1zXtn7ZJarZcc2f20B9NeboRceiVmfjUwSrnbgLqCOS
	 qUqUnenePjxgIkmslYYsOvZdIPe/jiTB3N1BcbsssdWo98KWpC2swphr3DsfUU4nHm
	 +OW9jZp278tOKw0FDUtAWdE+tNqr+dWmY6Wh9QaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/30] NFSv4.1: Handle RECLAIM_COMPLETE trunking errors
Date: Tue,  8 Nov 2022 14:38:49 +0100
Message-Id: <20221108133326.774582256@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 5d917cba3201e5c25059df96c29252fd99c4f6a7 ]

If RECLAIM_COMPLETE sets the NFS4CLNT_BIND_CONN_TO_SESSION flag, then we
need to loop back in order to handle it.

Fixes: 0048fdd06614 ("NFSv4.1: RECLAIM_COMPLETE must handle NFS4ERR_CONN_NOT_BOUND_TO_SESSION")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 466c07bd0629..2df0a1be5974 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2487,6 +2487,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			if (status < 0)
 				goto out_error;
 			nfs4_state_end_reclaim_reboot(clp);
+			continue;
 		}
 
 		/* Detect expired delegations... */
-- 
2.35.1



