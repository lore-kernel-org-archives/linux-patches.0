Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034470;
	b=RxpwvbzvL4NHKEzWxzbVl/TvQnD5QNHorwinEUns5SxbEP3svzXcfeKXXKRDvN+gDn8c
	 6f5vLuE0/IbfMZsRfvzwxwgXqCXiinlWc1vVWPRIgX4TESRzNKZQtM3xkRFCXwCO7v+7R
	 qYlw9th5VPDTlegUXpGLyqd6KLfg5QJTZpSJu+AKd4NwgjlvSdGn7UQwqq0ogWd7Bsmxx
	 s9LlubTGEg0y+GOKsIywNaE1zctlzsLsI5FZc6KWMImBjITqXnRV594cL/BezSnQ4tvQd
	 5oZ4JOpHhQwDk+6DWH6JjYmHtVn4F7c4GgJq+mFWQHnomUczvF8pKAtxVXxB6j0kjqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vn1DrbJgdQ3X7jjn3G2n5/85Qj6cPAUC09jtmmOmwEM=;
	b=DZvY3CVmy1u95LTiLiZfauze/TB9BqoMW9DmLvusxkt6sUL86do0mqoqHgsPfLiajAEk
	 oUN1eV8fOTBuitMVPBwKEcqymsD2w4KBIyu5goLHs5qSpC+1iZneaLG4wJj24eH1seeVJ
	 PJc2QKSsfzlIDFq8DtUA4tPY55l6oOsMhvnQxW1hQUCpP6hXo4ut/v6yG6rzL8Chlp7i3
	 SrCLqHBrItiy9XmPwtIoO2YkFavkSxY4j34ooo/qSk2S6GqUg4nQM46AMrQ0YQ3MWxEQk
	 amlnibjzwP3XWWiMOeiZNhX4/FOglX0jiSbKM69W6ZHOalLclrOTYZLsq/NUv+aq8fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFxmE3KQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDB3606A320;
	Wed, 18 Nov 2026 20:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFxmE3KQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3793E1F000C4;
	Wed, 18 Nov 2026 20:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034470;
	bh=Vn1DrbJgdQ3X7jjn3G2n5/85Qj6cPAUC09jtmmOmwEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFxmE3KQVQJAiWzUOvP7QLTZu9ZOhvMhgDqvVGiEQp05Dk8pi2ucEfy+K2YecR8pW
	 tiUKPohoeyAq7SbbdPYhKapTtoQZt7a/34xP8tTikJF6nzsIDxpFmAo+xluMd93Nwg
	 8x/mshpoUtr5YlFnhKTRMiNaTfseLLd93g7X1szU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0334/3318] ksmbd: handle allocated range queries on dense files
Date: Wed, 18 Nov 2026 15:15:56 +0100
Message-ID: <20261118150325.965194940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 350684e0498512d06963858b810101f58563810b ]

FSCTL_QUERY_ALLOCATED_RANGES currently relies on SEEK_DATA and SEEK_HOLE
for every file. That works for files with holes, but it is not a good
match for dense files.

A zeroed range in a dense file may be represented as an unwritten extent
and skipped by SEEK_DATA. The server can then return no allocated ranges
even though the file should still be treated as allocated from the
protocol point of view.

For dense files, report the requested range clipped to EOF as allocated
instead of probing holes. Keep using SEEK_DATA and SEEK_HOLE for files
marked with FILE_ATTRIBUTE_SPARSE_FILE, and wait for writeback before
probing so punch-hole updates are visible to the filesystem seek
implementation.

This fixes the case where a query after zeroing data could return no
ranges for a dense file.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 86cd9e0481cd4..144e49f1d616a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1027,7 +1027,8 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 {
 	struct file *f = fp->filp;
 	struct inode *inode = file_inode(fp->filp);
-	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end;
+	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end, query_start;
+	loff_t query_length, size;
 	loff_t extent_start, extent_end;
 	int ret = 0;
 
@@ -1043,11 +1044,33 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 	if (length > maxbytes || (maxbytes - length) < start)
 		length = maxbytes - start;
 
-	if (start + length > inode->i_size)
-		length = inode->i_size - start;
+	size = i_size_read(inode);
+	if (start >= size)
+		return 0;
+
+	if (!length)
+		return 0;
+
+	if (start + length > size)
+		length = size - start;
 
 	*out_count = 0;
+	query_start = start;
+	query_length = length;
 	end = start + length;
+	if (!(fp->f_ci->m_fattr & FILE_ATTRIBUTE_SPARSE_FILE_LE)) {
+		ranges[0].file_offset = cpu_to_le64(query_start);
+		ranges[0].length = cpu_to_le64(query_length);
+		*out_count = 1;
+		return 0;
+	}
+
+	if (start < end) {
+		ret = file_write_and_wait_range(f, start, end - 1);
+		if (ret)
+			return ret;
+	}
+
 	while (start < end && *out_count < in_count) {
 		extent_start = vfs_llseek(f, start, SEEK_DATA);
 		if (extent_start < 0) {
-- 
2.53.0



