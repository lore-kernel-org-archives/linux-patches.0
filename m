Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFD015699E;
	Tue, 18 Jun 2024 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715589; cv=none; b=W3ZSMy2pbMyUE1o0+2hDjxcrfG8HC07bl6etmTCghog5sEu3qYamqpkP5RLC8v7RI9kadUel8hNzV1rhjTf/cshDSjoyHFmGI4GMFQm0pW4rPXPcsAjgQedM1xIxHAz46MwM261/m6fy0/gJvD7fUyW3SdbH/J+e+O0pVaTbwKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715589; c=relaxed/simple;
	bh=HxBhlM5siuNKMT5Vj9yCHVCpJRmY/lLK7+l7U40Vvis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCjwopOloznxddIADrsivbhlJ4ZJo1gXJx2zfjwGXpWVKYcmbDRwmX8gCVIebH8PYai/qgaraSBZoD68ic5OOFtQODWbLQLOWKk1KV2Pz3fQ5ZobyRZcX4/mLL68YJu3evm7hqNPHFSm3dtqtHcwACjlJEt29d6QlWZJ5EeOLww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwoPy1yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwoPy1yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89112C3277B;
	Tue, 18 Jun 2024 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715588;
	bh=HxBhlM5siuNKMT5Vj9yCHVCpJRmY/lLK7+l7U40Vvis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwoPy1yyeobcOJsWDSYzvnI45LcDs0SBO6JHAeL4Ven+GOBnUpjHA1zhCYeDaIUDM
	 XvqWdu4BB5YXmKZ98VlapO7VnAL6ohe0RD+myBlLDrEV3LqmsqbgIXcQodpyPWO+In
	 GvJ+Kfy/Ov6n0Zbewszxb+MiDcv1Y875YSOeUl6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/770] nfsd: Fix a warning for nfsd_file_close_inode
Date: Tue, 18 Jun 2024 14:33:33 +0200
Message-ID: <20240618123421.164694480@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 19598141f40dff728dd50799e510805261f48850 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d0748ff04b92f..87d984e0cdc0c 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -541,7 +541,7 @@ nfsd_file_close_inode_sync(struct inode *inode)
 }
 
 /**
- * nfsd_file_close_inode_sync - attempt to forcibly close a nfsd_file
+ * nfsd_file_close_inode - attempt a delayed close of a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
  * Walk the whole hash bucket, looking for any files that correspond to "inode".
-- 
2.43.0



