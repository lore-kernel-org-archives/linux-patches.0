Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034223;
	b=aeaBjmIGmjk8wx5Fa+UVdbfNDCCLouGUf96mnX9U/oCHbnC7fqp8Qsgb0TV3EHrHpJ1J
	 BpYDNxiOyxt176s1pvoW2lAua/s+USrTJeaKKDd5P8LX/dybBD7m305ffiV1BpkbT+4Nd
	 FR6hIej4eLXnl8yyeK8fb35gSjGi3OsQ+Tn11aJwthva7GbpHKJ4pWkIElYUAGgPMFtsh
	 1obrxzJ1jbIeNfmKIogRVthnLpn43n+4qdI9fpxknPOQWjwpdq1UN+ka+wZ9lKNIYGkIV
	 2x9zzYLuAvAeSZoU4epSSNcpovDvuVH9TXkIZ51WluPh+HlVarBFnySgSAE6DJ8yl3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q5yCOMndUr8OQOmlFIU9Y4ABLTfLJAiI4dlgzk2LxEc=;
	b=C818gp9b2ZfWz65LoZiQV5Rq1Vs0sGgYY3O2CnMfMKRG+oTMzklwGc7FsFavLmnek3RX
	 Msby2zoZR112GyBuNY2f0j13HrwOO/6OT+1b1gS3NPKLxmlMSYS8F+JficXv2TnrCjBtw
	 Z84Wym+NENwnNI/TeHaN5JvHxjxcj7ox3sEkkvO1IGJYXfrvJYhSWEN+vpKuNEpJln6EX
	 G7Mpo22aikMwQh0UOBIlZLbn7xWGwUzv+NzZXVkV6cMFW63PDLCQQkK7rhujYZ5/KbVvq
	 FfWFc2bvDbV5sqAhKUp3RNt3fwbgOQqmLkcyDllJp1KAGjix2EOxDJ7/2yoLJQPzkhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgV0ojx2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F229606A336;
	Wed, 18 Nov 2026 20:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgV0ojx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC521F000C4;
	Wed, 18 Nov 2026 20:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034222;
	bh=Q5yCOMndUr8OQOmlFIU9Y4ABLTfLJAiI4dlgzk2LxEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgV0ojx2wX0J80wy/C42zWlaMmCgczsBXiHdv/8D5DkGCCFi3tBwENtBcd4EG0HuG
	 Xo6nu874j1tfn0ZQLSOTtqB1Q9RleDk3Jv+GpKTaly8cTsTq9AbNr5Q5BZcDKcI/yD
	 i90BXyYLQrdKhLxiFvz4y+nrtEcG1d8dsOBr/mz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0294/3318] ksmbd: report actual xattr value length in stream enumeration
Date: Wed, 18 Nov 2026 15:15:16 +0100
Message-ID: <20261118150324.459596125@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit 689f1eb3719d61700b58f984ac8602837f004f8c ]

get_file_stream_info() (FileStreamInformation QUERY_INFO) reported
each enumerated stream's StreamSize/StreamAllocationSize as
stream_name_len -- the byte length of the stream's *name*, not its
data. This is the same bug class already fixed for EndOfFile/
AllocationSize on an open stream handle (ksmbd_stream_eof()), just
missed at this second site: a client enumerating streams sees a size
derived from the name string length instead of the stream's actual
content length, inconsistent with what querying the same stream by
handle reports.

Compute the real value length the same way ksmbd_stream_eof() does,
via ksmbd_vfs_casexattr_len() on the already-known xattr key.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 58d2113cd44b2..5d6469c759074 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5138,6 +5138,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 	struct kstat stat;
 	const struct path *path = &fp->filp->f_path;
 	ssize_t xattr_list_len;
+	ssize_t slen;
+	loff_t ssize;
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
 	int buf_free_len;
 	int ret;
@@ -5199,8 +5201,20 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		streamlen *= 2;
 		kfree(stream_buf);
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		file_info->StreamSize = cpu_to_le64(stream_name_len);
-		file_info->StreamAllocationSize = cpu_to_le64(stream_name_len);
+		/*
+		 * stream_name_len is the byte length of the xattr's *name*,
+		 * not its value -- same class of bug ksmbd_stream_eof()
+		 * (smb2pdu.c) already fixes for EndOfFile/AllocationSize on
+		 * a stream handle; this enumeration path needs the same
+		 * real xattr value length, not the name length reused as a
+		 * size.
+		 */
+		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
+						path->dentry, stream_name,
+						strlen(stream_name) + 1);
+		ssize = slen < 0 ? 0 : (loff_t)slen;
+		file_info->StreamSize = cpu_to_le64(ssize);
+		file_info->StreamAllocationSize = cpu_to_le64(ssize);
 
 		nbytes += next;
 		buf_free_len -= next;
-- 
2.53.0



