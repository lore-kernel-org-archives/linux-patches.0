Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034869;
	b=fbMMq3BVOoxOWNIyTGqPJBp5Z743GsHkyJdWAe2efyPqy8qJufhY0x7IRePK5reQHyED
	 br5cyt9YJ3O5qDjJZcTYGhzgIz6aE/TGIfZOKMp9RliDycZhtI/uVOeC0l79VwJn48F7L
	 HJwQkoOvZOFwhCMCHHsohMVDHYF+FGXILvqI9h2flW9IaB2Vbfi3vbBsoqvKhxlAwtI5B
	 QLLuAvcuV1RyvkNZknv8cPPzOblJR7x4jZu2uviUVnzqqEkCff+rcdHrMyMlmzB0v3MHv
	 TQrm726yvFRbURU5C2PtAEpoNjDUb+oI4iKGY0mOrNYxHIdfGy59nLK2uBu4Ahks1vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/akPgjYWtkP+EB7OJ+2GjTdRpg53SM5EyXYw9q9lkFM=;
	b=Vk8WkqFWA1AhhLsheNII0/dRnXmFZEWtvs+SUpfEf/S2Qtu4K/Pn9DsepdrpHp6qdhxc
	 H8XtpuEdkUi3rm0M9RbrMLwZx95hXprO5Jm1WDBIEKIq2jh4OvE5uP3gzZOjSzPxzLWVh
	 FElUXhV9o5reTwYk7sZggoJNjk5EZtNPd5NxBTBNfWg/8HYaJ6c5fIyP8lyOUtmLT3Vjl
	 dvS+y8RymY1rm7NE+IqQyi71hfdQaVb44V8ExSIQcCfVZ1QPXuYCdUTiSr3xE8dD+SVuO
	 SfikCvFJhxyBhcUB87AR37/x0FHmKoU/D1NxpqbiBud2HXpe83eirtvO1d7Wbr4zD5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9qEBPoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71603606A31C;
	Wed, 18 Nov 2026 20:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9qEBPoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8833E1F000C4;
	Wed, 18 Nov 2026 20:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034869;
	bh=/akPgjYWtkP+EB7OJ+2GjTdRpg53SM5EyXYw9q9lkFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9qEBPoAKv2qEgLxUnNShGwmjho5XpJDK7PqlJ/f4FlsHQHxIu6poA0v5yONYg2uK
	 V5Cjh+Iw4sWxJ0IGEqORgQgvXuv5itQ+o7Y6Fmn/QNK+TOMcBoNFlb24hqYT6lzA3W
	 bNp0nDQsZ0XxdSQwPDgPe7uRMmk+SIqk7eDqmutE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0522/3318] smb: client: flush and commit data before querying allocated ranges
Date: Wed, 18 Nov 2026 15:19:04 +0100
Message-ID: <20261118150332.839361359@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit aa994489bd835547c191827acc460192e147032d ]

The mode 0 / FALLOC_FL_KEEP_SIZE fallocate emulation for small interior
ranges in smb3_simple_fallocate_range() issues
FSCTL_QUERY_ALLOCATED_RANGES and zero-fills any sub-range the server
reports as an unallocated hole, to force block allocation without
changing file contents.

This is unsafe against Windows servers.  Per the Win32 documentation,
FSCTL_QUERY_ALLOCATED_RANGES only reports ranges that *may* contain
nonzero data and is explicitly not coherent with recently written data:

  "a call to FSCTL_QUERY_ALLOCATED_RANGES [after writing to a network
   file] would not necessarily return a correct list of allocated
   regions.  To ensure coherency [...] flush the data to the file"

fsx (generic/363) reproduces the resulting corruption against Windows
Server 2022: a range is written, an uncached read returns the data, yet
the next FSCTL_QUERY_ALLOCATED_RANGES on that range reports it as a whole
hole, so the emulation overwrites live data with zeroes.  A network trace
confirmed the WRITE, the READ returning data and the query returning an
empty range list within microseconds.  Samba does not exhibit this; its
query is coherent with the written data.

Write back the dirty pages, drain any outstanding I/O and issue an SMB2
FLUSH to force the server to commit the data before querying the
allocated ranges, so the query reflects the data actually present.

With this, generic/363 passes against both Windows Server 2022 and Samba
over 100000 fsx operations.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Dropped the upstream setup hunk and the missing netfs wait call, added an inode local, and routed the late buf allocation failure to out_unlock (removing the unused out label). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index bf858ae988853..968643f4ecdd4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3463,9 +3463,27 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	u32 out_data_len;
 	char *buf = NULL;
 	u64 range_start, range_len, range_end;
+	struct inode *inode = d_inode(cfile->dentry);
 	loff_t l;
 	int rc;
 
+	filemap_invalidate_lock(inode->i_mapping);
+
+	/*
+	 * Flush and commit the data to the server, otherwise
+	 * FSCTL_QUERY_ALLOCATED_RANGES might report recently written data as
+	 * unallocated holes on Windows Servers, and the loop below would
+	 * then zero-fill them and corrupt the file.
+	 */
+	rc = filemap_write_and_wait_range(inode->i_mapping, off,
+					  off + len - 1);
+	if (rc)
+		goto out_unlock;
+	rc = SMB2_flush(xid, tcon, cfile->fid.persistent_fid,
+			cfile->fid.volatile_fid);
+	if (rc)
+		goto out_unlock;
+
 	in_data.file_offset = cpu_to_le64(off);
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
@@ -3475,12 +3493,12 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
 	if (rc)
-		goto out;
+		goto out_unlock;
 
 	buf = kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 
 	tmp_data = out_data;
@@ -3491,12 +3509,12 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		if (out_data_len == 0) {
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, len, buf);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
 			rc = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		range_start = le64_to_cpu(tmp_data->file_offset);
@@ -3504,7 +3522,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		if (check_add_overflow(range_start, range_len, &range_end) ||
 		    range_end > S64_MAX) {
 			rc = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		if (off < range_start) {
@@ -3519,11 +3537,11 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, l, buf);
 			if (rc)
-				goto out;
+				goto out_unlock;
 			off = off + l;
 			len = len - l;
 			if (len == 0)
-				goto out;
+				goto out_unlock;
 		}
 		/*
 		 * We are at a section of allocated data, just skip forward
@@ -3542,7 +3560,8 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		out_data_len -= sizeof(struct file_allocated_range_buffer);
 	}
 
- out:
+ out_unlock:
+	filemap_invalidate_unlock(inode->i_mapping);
 	kfree(out_data);
 	kvfree(buf);
 	return rc;
-- 
2.53.0



