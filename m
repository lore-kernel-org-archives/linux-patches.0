Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831039;
	b=Y3+tg4JvsxH2P/i55piKNBkyeLayGapGZLNuCnARC3NlUoE8zJUBYB4o0wC30+wi0Wz9
	 2Q8dfZva/ZqhebJj0ZCfexv2XShtgQkMcLynN5/fJuBFbqm8MJphkQW4KerGE1LX/uZ26
	 R/JK6m92lEXR0qLhlgffOkMWrPXOFRe9Z4RnSMXvNDDRlvq4THVRCdJbcGyCeoUqyBK5F
	 /c+ZXPasWNCBQslstFxmHiPTB6FSVYsLVPQnMHgUY94y2gMvOXq+sw1wmHrcmo9UYXg8r
	 38qbVmsxjCcV0sV17b6GGsopw8/c+0ERSCMp3u8BiZD5EfZRHtCMHEf3JWP83zpoTwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PDnUpP4TVUyDxAbilFeUf/wYlhqO8ZFGOLZsgurJ22U=;
	b=Poz/D22DSQYRLFKk02UZpR1u5vdOsu1qmPU+DYQ+HGLzuu4BSHL9XNPsD6IGx+By0HoF
	 POO5/I/e9xz1Qck69EmIXTbwLliTYUipNVhk9XQK7RXZT+kKivvBO9hZzpkASEM5I02u/
	 ZA21/xvVi1J2IOVA/a8/ijgWPO+Arm9DzAxvcwio4rIhupjWw7B63aNGHLMo2eW5bDwAK
	 H//v3CzUh8L3PPv0ot+aBc8PxHfOW2XCxZvzsrpsjoqy/MaZORy/RD9XWflEVLJdiNtu7
	 KtZMG7y5S9D0oPPWG3InVxdSgQn7veDhld1OcHajIf4EIOgViGnKX5jGQTJ4EZC8RVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uhNZg4mL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872D5606B2C2;
	Wed,  4 Nov 2026 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uhNZg4mL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26EE1F000C1;
	Wed,  4 Nov 2026 22:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831039;
	bh=PDnUpP4TVUyDxAbilFeUf/wYlhqO8ZFGOLZsgurJ22U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uhNZg4mLWD0I0LwIWxlQhYQkLLjSgWM1TL8azukdqGwP7GGqkR8awJSiO1BgeXiDd
	 dtL3Z1T1hOkW0SzWSCVZcb+8FQ+zdaDOVYiTwY9g6xc1cp34ROt228EQuXPAIyYyeD
	 eANHyEuQdeY84dyn8VHE1fzKavpE5sGn+Q6sHbQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0474/1005] ksmbd: handle allocated range queries on dense files
Date: Wed,  4 Nov 2026 16:03:27 -0500
Message-ID: <20261104211057.280837299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f894092901bc5..cd0d3c13da3e7 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1034,7 +1034,8 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 {
 	struct file *f = fp->filp;
 	struct inode *inode = file_inode(fp->filp);
-	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end;
+	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end, query_start;
+	loff_t query_length, size;
 	loff_t extent_start, extent_end;
 	int ret = 0;
 
@@ -1050,11 +1051,33 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
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



