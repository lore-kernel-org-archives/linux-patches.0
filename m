Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061078;
	b=uy8TiHNvTxpht1+8ylmjuashAbMD+/rVPrwKKBcLXjoxI8RE6NMyiSHyzop960rBwHpk
	 5zZ29PpvscDaPTevlTywmvDWMhp/Wr1vwmFyLy7r9ttHK727wd0rDXwEqp7+8NiZPEkhI
	 eRLqInfpanQ0OC2bkeSxmqao08A5RuP/qjZJ7wUOLfdIy9/Z+n5VynJre2PVgUCk/zp8V
	 z05MvpD3svh0enNHZfhN82hl2UM6ZeZeGp+nQBHNHPnXECdMRTnCWF0k+vi+SBk+AaD2e
	 alWkOy6JtFKA6qSMMUhf1cWNJU2xLWppHPr0Jj8PZiDeXzrqUHKv7OxBpC6RXkeGYeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jv3cTumzdc3cAYrG4L01rRIJX7szilCr4uD0NEav9S4=;
	b=eE+EMG2zOI9zCDHG6VZ1SadQ1oTh5LWTrsoYkvL+u93UiUpuNOcd4GJCHgSQgyDMpc9g
	 4O29QwfK9/JsIZ6DLeY8/oquX/PEobjBk7joUS3JvARi+yFBlDyhTQcQ2MM1f4GsEmUOn
	 IK85e8490JGHk6yzvmlvgktg4ot6aiuefWOl7uL1IW+BI+RJwpM08samcvGrQYuTe3O17
	 oQQwXbqn6gfltpwL63cWR9zpYF8aUrNO/sBzwJLbrfUEFYN5aOEUWbz+5Ui5NpmqCVVGe
	 67pnRknnPBXsvFbY7z/T1+zEYBOlUb3342kcO5J1MiZxoaoy/PTIBjFerdm5+q57GYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GktuWOA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E637606A33B;
	Sat,  7 Nov 2026 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GktuWOA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAAE1F0089F;
	Sat,  7 Nov 2026 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061078;
	bh=Jv3cTumzdc3cAYrG4L01rRIJX7szilCr4uD0NEav9S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GktuWOA4RkQsAKSEuiUncCYegCC7gZ8N3tDKXP5bXWByzq5AYJMWd3EMy7mvclKvd
	 E1lXh1fiiZUHLb5YY90Ql3DCkIweFZjOMzsEmOd5L/w6FVUBXT6f1FT/mFoKS5Sa93
	 4oH50GzdT5/pRt9re8aClLtRGdfVFqxqaCG55k7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0402/1536] ksmbd: handle allocated range queries on dense files
Date: Sat,  7 Nov 2026 08:40:18 -0500
Message-ID: <20261107135008.876518461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 32ef9618a4af6..ed0702cdbf3e9 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1031,7 +1031,8 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 {
 	struct file *f = fp->filp;
 	struct inode *inode = file_inode(fp->filp);
-	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end;
+	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end, query_start;
+	loff_t query_length, size;
 	loff_t extent_start, extent_end;
 	int ret = 0;
 
@@ -1047,11 +1048,33 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
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



