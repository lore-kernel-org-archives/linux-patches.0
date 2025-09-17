Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9265336998C;
	Wed, 17 Sep 2025 12:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113655; cv=none; b=kL3JrMfJKLT09n7dIsLUxnH05mF0vS2Z4zEmpZ00zcxIDDPhQVCRAwgBz/8awIJ0PV7ubVoecsBaWE1bsCVVLo6akw0pkV8xm+Kfth6NBiMdx94YlCOk9LOvu2jUkj/TrP5lXN6L7Q/kuyP4sy/m8bX58PlLjIHgmty/vLC8LJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113655; c=relaxed/simple;
	bh=5oU/XkthF9zIRS9TKbK1tky24rjccHutCepCcOQy8PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7dol41wqgWR9IEJf6oKSF95CCxofXmy31/xHLv+4Gd12Gkd8r+TZEbfSIzg9Ys8XuZT2Ol9/sFtgK6Y5UoKZ33A+cUclzOaZrVM2gWkwKmK2ebbxkoODP5lInBWG9bTz+Y7k530+rI41ohaOaNRPSykd585QvD7uPaAGv6Rg6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJDb2eAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJDb2eAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4DBC4CEF5;
	Wed, 17 Sep 2025 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113655;
	bh=5oU/XkthF9zIRS9TKbK1tky24rjccHutCepCcOQy8PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJDb2eAWLk1YDHdMLeK6YlO8/Ifz9MZSCt3OGXjrKD2r9HQWNGIYgLeuxfv/KzWZ6
	 u/3tD3E4XtyKr+Qo59MsxJC3eHi59YhfawCWiPCT5omjVZVTqij4au5ZKbBuJSSO3r
	 BHoDAJ6MZXVIgLWCbxendUvApT7ZADd/uEydkTC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/101] NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server
Date: Wed, 17 Sep 2025 14:33:56 +0200
Message-ID: <20250917123337.186883195@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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
index cc764da581c43..1bcdaee7e856f 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -873,6 +873,8 @@ static void nfs_server_set_fsinfo(struct nfs_server *server,
 
 	if (fsinfo->xattr_support)
 		server->caps |= NFS_CAP_XATTR;
+	else
+		server->caps &= ~NFS_CAP_XATTR;
 #endif
 }
 
-- 
2.51.0



