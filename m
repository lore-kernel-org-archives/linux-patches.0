Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08D21D54FA;
	Thu, 17 Sep 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668385; cv=none; b=YqCWg2AzIA6G/DGuEhNlaJwiRPG0lRdf84NceMgHTcAdGTgUf15pWoXs4pGb5294ZezixdubfwXph2QjbXctwSfAJLUynzhLy9sPa9RH7Qzf5NerGf3sNQ463nNm+LnEm//2YgDwYhnjlWGdyI9eyyx9xrSy8agCkeJxxi5w5wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668385; c=relaxed/simple;
	bh=dNVCUQpRBs9j8ow+ETdY4aGoIHOqghApNKILit9oVY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nz/aPu9NypLpQu55+jxdNbo03+WfM+uFjt5Ue72EYabx8TT8cuuCHK2zTVy/0SRmC3ZsuqiNYtiDZTu9BmO91NydaK/FYHniWXCVFrWRkBNc1/Oo1OfvywIsml4MB1vnItSN8qiEiUp3xukXOw5Sw6sEJExCpcTrw4MMP2an2Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8h6C9BM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8h6C9BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5C41F000FF;
	Thu, 17 Sep 2026 18:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668383;
	bh=qOGTtCX5k8qUj8PqDwr0KmKJ+QfQVHlVBxU5bOV0rVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8h6C9BMQqLQRsm+fHHxZwlcTgbmdKtG+d1W1SyPMbx7lPNjn8ZBN4SaU+aNz7PdU
	 P4/FcruI0SmdTQv93oVFiyEDGvbkcbXxdQKZA+g1DizA+dzKfe4deeYKhlM50xqoot
	 M/Ztz3rVD4Kr6aSHFchz1q4sfCQiegvY7XHlisqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0405/1102] smb/client: zero-initialize stack-allocated cifs_open_info_data
Date: Thu, 17 Sep 2026 16:05:48 +0100
Message-ID: <20260917151549.831024776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 8fce4cf4369c766a3293a05419500cbfde72e60d ]

Stack-allocated cifs_open_info_data may contain random data.
This can make some fields have wrong value if they are not set later.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c    | 2 +-
 fs/smb/client/smb1ops.c | 2 +-
 fs/smb/client/smb2ops.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index aa45ef6ae99a6..82156543f1f91 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -257,7 +257,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 1bad3fb4e0a8c..eafdf6c38796a 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -971,7 +971,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_open_parms oparms;
 	struct cifsFileInfo *open_file;
 	FILE_BASIC_INFO new_buf;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 	__le64 write_time = buf->LastWriteTime;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0c5ea91077b90..7d91bde2fcaa3 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5167,7 +5167,7 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
-	struct cifs_open_info_data idata;
+	struct cifs_open_info_data idata = {};
 	struct cifs_io_parms io_parms = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
-- 
2.53.0



