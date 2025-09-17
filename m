Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5EC333A8E;
	Wed, 17 Sep 2025 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113984; cv=none; b=PWzlTb7l4GEQg0N5dind+qnEMd4GL3/epwdwsY8YQf42rL0seHBRCPjHjbtMq2Fk+YP8EQZYGgw2Udzj1Zy6mEL9A1sKQOaZE9jS7SXl/gGftWW43ajOVmZKu7qWsUSTxDzfcp+mRReN+ka77tfQm/D0xijyeGdlTESj/AHflzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113984; c=relaxed/simple;
	bh=xBNXtJest5DRc4k9GDEmZJAlRA23BjKN056EjVBcYHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBITLdwCI8XQ6a4DbGS2sa7W8FQlQ+usFygyQ6Ah8oq0MPDR4rmxpMcmogP2Z0MwmqXrVuR9P2ZMJ2oNwYj+QgiQ033OGPVNGuR4G59cPU7YrXKzW2dxV77HbEa1zumCNQefHhvrG+i0wx6hprsJOY4W4+9VHoPubI7Auvs+XBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXUuEXFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXUuEXFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEFCC4CEF0;
	Wed, 17 Sep 2025 12:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113983;
	bh=xBNXtJest5DRc4k9GDEmZJAlRA23BjKN056EjVBcYHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXUuEXFHe9Z8hdWtWR55xPJpG33Y+4Or/wJVDpGag95NPjDi1Hq2GUkd10ta/Cj9c
	 vFGNOG4htIPPTZTZW3fkr8p9Qs7ntWVGhA4JCd5nFcVVHJ40y83gRURiYbtY8Cwua6
	 ChknsO82FigHfkT1plVcFmLuWLMbX2ozVZ5fEesA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/78] NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server
Date: Wed, 17 Sep 2025 14:34:33 +0200
Message-ID: <20250917123329.868692111@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 4fb2b677fc1f70ee642c0beecc3cabf226ef5707 ]

nfs_server_set_fsinfo() shouldn't assume that NFS_CAP_XATTR is unset
on entry to the function.

Fixes: b78ef845c35d ("NFSv4.2: query the server for extended attribute support")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 36025097d21b8..2ca04dcb192aa 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -859,6 +859,8 @@ static void nfs_server_set_fsinfo(struct nfs_server *server,
 
 	if (fsinfo->xattr_support)
 		server->caps |= NFS_CAP_XATTR;
+	else
+		server->caps &= ~NFS_CAP_XATTR;
 #endif
 }
 
-- 
2.51.0



