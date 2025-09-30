Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F12FFDE6;
	Tue, 30 Sep 2025 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244073; cv=none; b=AWCfy5cwIMaMApdlygWklsP9qK7hYBExgCa9TItY5KyOL+0gn6eCqLoR9htbXecI+lBtJjctpRZr+IjgzPvMTI1BlRmMVWFVBq2e997FGRGR4XWS82MoLcvJVPNflOQw9kMT8LZ8gp/uBXxAHw1G2teQO+6VsBrEMYpqZQ+vna8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244073; c=relaxed/simple;
	bh=dNHJ8n/oHnSBnpfaDoe3CT+2wdzJbcPLcw7jEug21do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DM8Fz8WMZpjJJFiROp4QzPyKAf/ZmIkRq+tMTuDWoiJsQ528/Yk+oORrdVTg5W8tgzUOa4LRq3egj7SFALYjQjpWGVRMs/9Na0GHWET6X+YQnwrQALx2DzCWIyM+scn1zzTOzTqn4CmKTO7z8B77HTOHVEZg2fHGpchgL4lzNZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=napoRXTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="napoRXTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8B5C113D0;
	Tue, 30 Sep 2025 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244073;
	bh=dNHJ8n/oHnSBnpfaDoe3CT+2wdzJbcPLcw7jEug21do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=napoRXTxbRrXBRPtCEEHL8KpPU0y4fXiC0bOdJeJnE8176fk9CVJ3mOlkdWC92LiL
	 gU5QUT2vy9pJLw+/hFi9USIuthXdyxZhXpkSHnxV3El4BAu9jT9gCnWMsYwjZEt/GJ
	 ryx22uJm7yxrhjeF+6zfk+7T41Z55Z9+Nycwg1Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/122] NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server
Date: Tue, 30 Sep 2025 16:45:39 +0200
Message-ID: <20250930143823.315126498@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
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
index ac2fbbba1521a..6134101184fae 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -850,6 +850,8 @@ static void nfs_server_set_fsinfo(struct nfs_server *server,
 
 	if (fsinfo->xattr_support)
 		server->caps |= NFS_CAP_XATTR;
+	else
+		server->caps &= ~NFS_CAP_XATTR;
 #endif
 }
 
-- 
2.51.0



