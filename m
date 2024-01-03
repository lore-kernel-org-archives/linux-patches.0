Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A3F1BDFE;
	Wed,  3 Jan 2024 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwM6OZn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAD2C433C8;
	Wed,  3 Jan 2024 17:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301999;
	bh=UIBvRyQkITPL4Nu4Gp6xIUWN22xVMOSTQVrfwCfaHW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwM6OZn9bOWT2RJqnSnCYI0AanyoPdQZWj0di2M1Vd5ZyR8+QLGewXZVpvcrDCPdi
	 V3UkttWfNUoUAYZ15yMFGFsFKs/VVxR3kNQ870t62YQlsxXhVwXVhhlgqr+xZtQ65a
	 KlLv/LOZDm3FsrVnw+K+w7lMGdPs9ClgtLzNyPFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/49] ksmbd: fix kernel-doc comment of ksmbd_vfs_setxattr()
Date: Wed,  3 Jan 2024 17:55:23 +0100
Message-ID: <20240103164835.474316203@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3354db668808d5b6d7c5e0cb19ff4c9da4bb5e58 ]

Fix argument list that the kdoc format and script verified in
ksmbd_vfs_setxattr().

fs/smb/server/vfs.c:929: warning: Function parameter or member 'path'
not described in 'ksmbd_vfs_setxattr'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 5a41c0b4e9335..183e36cda59ec 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -906,7 +906,7 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
 /**
  * ksmbd_vfs_setxattr() - vfs helper for smb set extended attributes value
  * @idmap:	idmap of the relevant mount
- * @dentry:	dentry to set XATTR at
+ * @path:	path of dentry to set XATTR at
  * @attr_name:	xattr name for setxattr
  * @attr_value:	xattr value to set
  * @attr_size:	size of xattr value
-- 
2.43.0



