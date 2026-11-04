Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830940;
	b=sQZNka/M5+ZttoHUgwCm0lGYt5jZQz4T+oXyVOmbH08fO4Pjd+2uyGv/2K0JEb9SAVnK
	 SRUu3aki+yZfX8UevykqdSZU76WqKIly7Pu2rNbOeBElqZ7T20FAzH4f9yEmnF5R7dvGQ
	 Qkfldm5WDbbqufEwU+HKIef70tc0bLPu4AtAlqnC17EJCN7C8jxhHVMPh8D9GrIuJcal/
	 WH5LDQozgkOanPvGuB7z6vI1k3ZWHFW0lV5vAutJGirOg1QvEhWIXwejAV0ytgJvvjNVc
	 hwx2zlDir10HodvXooeF5oQCvbIi1qlY7vrI0WAfaxQvB1oCEnuRXxyzYvgirUIKKPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AnEzokHKJ2cEf1INa8lq8/i9KXdHUBmrcRORgK3zjCk=;
	b=xYPHeyLpdfPl6XPPc7N5JqAWUGjlKqnK1M9obImWJNeql1jhXKHV9CiGx5upi+sT+Ifm
	 gqbDCPxYV0k/4oi2Dv0FYfSvp/6WuhgMIn6Ij8CWuQ0U8e/0CEvQhJOB8G7EsetYs5NdE
	 CV/Luej/SJ2guzkBpZcb3W1J06hqLMJqMPBSbHf0Sq6PkLeAABincdkdfkCPigRZFrRDq
	 mL1ffT1ieGsxSO4HzThcHn96qqhtPLc6Nr7N/DQLbAlbh28QM3CYw7ClwYrB50R3jC00Q
	 dMuU9xwHso/6dMJDgalvBsZd8Q49sbnhSvQf4pnt3x1O0PHk1toRs3PzViA/Rkz39TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ShZnlSgb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A8C606A844;
	Wed,  4 Nov 2026 22:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ShZnlSgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8101F00919;
	Wed,  4 Nov 2026 22:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830939;
	bh=AnEzokHKJ2cEf1INa8lq8/i9KXdHUBmrcRORgK3zjCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShZnlSgbOYpFnDr6KWrNt/8NT5fz6q1JGyK2GZrztcbFR1Qm7TobxAHUtzxYxnLFl
	 i7GIauvrt1afiN9lFN7q8x4DFxhJc4Ud3CVkfEJS38z9YW5fa7l6B7ukwvClDvNjkR
	 +ZkpWrHmWj+DCuR4wfGpPBiFb9MBfnxEyJtU4ohM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0414/1005] ksmbd: report actual xattr value length in stream enumeration
Date: Wed,  4 Nov 2026 16:02:27 -0500
Message-ID: <20261104211055.684093141@linuxfoundation.org>
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
index e473cd3bbee36..16dea2c8b9267 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5166,6 +5166,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 	struct kstat stat;
 	const struct path *path = &fp->filp->f_path;
 	ssize_t xattr_list_len;
+	ssize_t slen;
+	loff_t ssize;
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
 	int buf_free_len;
 	int ret;
@@ -5227,8 +5229,20 @@ static int get_file_stream_info(struct ksmbd_work *work,
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



