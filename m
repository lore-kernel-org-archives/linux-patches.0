Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9801BDFD;
	Wed,  3 Jan 2024 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldEfrsk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ED1C433C8;
	Wed,  3 Jan 2024 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301253;
	bh=tBwxQ4jirYCGkofaz7s5wggTHprH0DPioyVKD2DAP1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldEfrsk8MkS6YJ9RfofTJA0pRGcJV5FYrOiOiWQd5Y7M6SPTyAFIXDMrr+S0c/yE6
	 Sw0AhWfBNnHEM8duMK9fSSZfoRmR9O3MGoZglnyeEcXSMnuDILce7W0bsBFxfsOfSg
	 hm7+lfMeUSYIy0OmjtxjV4ezJHDZI589CnE5Nh5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/100] ksmbd: remove unneeded mark_inode_dirty in set_info_sec()
Date: Wed,  3 Jan 2024 17:54:30 +0100
Message-ID: <20240103164902.200084197@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e4e14095cc68a2efefba6f77d95efe1137e751d4 ]

mark_inode_dirty will be called in notify_change().
This patch remove unneeded mark_inode_dirty in set_info_sec().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 03f19d3de2a17..7a42728d8047c 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1443,7 +1443,6 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 out:
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
-	mark_inode_dirty(inode);
 	return rc;
 }
 
-- 
2.43.0



