Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ED851B167;
	Thu, 17 Sep 2026 17:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664851; cv=none; b=TtDdnZJzrQvlLGTZGbryBFlQsqcsiKr9WyEs6Ytoh3myFezj4T2ssVk8xnKNQUiaNKJu7Kh3QaR5enSwhMevykCHZSx0pq5sdf1WRnEASdZlcw2r1FzfIuSMKwaVP2EGnrh1d9EZSWlS/ZycUbdEwKBwfXjHkMM0IU0ohuSaYS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664851; c=relaxed/simple;
	bh=YuKf1h4MTC17jP+0qxVr5JTPsIbT9MoB+aBIrX5OtU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXUqstGO2ARKd7J8LSZ4QXodTsb64Wwth5tPQ0VgHq/mA0WAyKb13g/P3XCka70Qo3x0OrbI0QIERJHWLGFfax1485E2bb3aF9x5w4A2aHvo4sUmhooGrid4Zodx9zAh9gLsqzKUrgHQ18ipWqD4Oqi/lif/RlV88qANTcs1XFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaR+fiyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaR+fiyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB541F000FF;
	Thu, 17 Sep 2026 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664849;
	bh=AHyKySlKJw1TC2dFWwOX4Za2lVJG3JH0xS9o5xhsqeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaR+fiyUivtF9prqpKaK8ccRDJIJ0auyJIryAzU128QuzSInvbNI0v2+hypN2O9eK
	 e/v/p9jy1phxLguMjomCxVW7HtoYk0KBdA8Nz0VScumnh26e2cX+Sk4Dj9C+12UX2f
	 FyBoqWMssg3Ff7tJAKUbVwWrrd7OHUedjCm1w4z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0508/1250] smb/client: zero-initialize stack-allocated cifs_open_info_data
Date: Thu, 17 Sep 2026 16:05:03 +0100
Message-ID: <20260917151605.727657360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 70f3c0c67eebd..0b8cf3dd65d97 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -234,7 +234,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index ef2670bb2ce9a..39a4896ff5d5d 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -791,7 +791,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_open_parms oparms;
 	struct cifsFileInfo *open_file;
 	FILE_BASIC_INFO new_buf;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 	__le64 write_time = buf->LastWriteTime;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index cd3694f7179d2..248ad60586e2e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5296,7 +5296,7 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
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



