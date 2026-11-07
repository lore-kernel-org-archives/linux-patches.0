Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061004;
	b=XHYheevQ8Q+lIqh9gCogXuXvlwZadAoFht9n575IyyQLhHQysprlpESTRQzPOhp7vMqe
	 Dy2uGhLUm5T4UMNclureQ60xNg/N5/OMzrrHaV2NFyMgymlqjsEsP4qpAQuhLI5UyzOIu
	 9H/qToQnxgCwnZhFse6IHT6uxiOLsF+NchFnQLQNOuR+zhnbeW94655AK8P/u0kRU6WFF
	 Ynkg24zK3Un1GzlGtzl4ZD7ivWqVdmW0Pm4TJqTh2cYB15Ht7CLXAEiIU2J/vF2bcctwX
	 6NjUv1qwTGfpvIncMS77P6LS0014Jxp7o8D4Lv7w+HkROBuyt5X5vKK5O+l4+rP9wLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vAbyLU+ToYZ+udCnNTLpuUMJCTsWL113rnbAj0zib8I=;
	b=b3B3/a+IyKAiK9/OkynL2PVM47Nxg08uvZEHJPHa4yvntI9qYTNXABXjSTrG+v8HQ0tg
	 AIUeq6w9tzyOxoH0pJyFnlHjSpF7csZYKI+P0ftIy6TcWqhi+POkHDV7evBgKxcdeWJhi
	 u9+WAnQAwHaM9iWMdpW9u+YgKBfzPCG4XjldUbXmH+gjZetGkvDxV8zvHbsRNYrGU3Xq7
	 g2bGGh47IcZLCyXJnqT3YVpAbso1mBm90pGd/Q3JIPighz8UR0bCxZ7PnQf/SJCmTdwNk
	 gxzAL4+cPyu2qUl5ckHTa0IQhAvf7TkzH8xv2S+99wjTQNpKI44iW9wjqJlu+WM/IXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljwJAeK1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1093B606A33B;
	Sat,  7 Nov 2026 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljwJAeK1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B108C1F008BE;
	Sat,  7 Nov 2026 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061003;
	bh=vAbyLU+ToYZ+udCnNTLpuUMJCTsWL113rnbAj0zib8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljwJAeK1Y17xaky0/415N+EENzVnzOixye5ODC8ZovB7UklkdqyyzHhCRFeURB1rB
	 rdPdPaya832SXp/W2s6oGL5lQ/nU2bY/NFUG5nq5+F7TArOtUI/qbReQm8fUOa3w2h
	 gLSPGgOgG4AIfjumkQGNtp1MVxhIkHAvG+T+w/ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0348/1536] ksmbd: report actual xattr value length in stream enumeration
Date: Sat,  7 Nov 2026 08:39:24 -0500
Message-ID: <20261107135007.451236758@linuxfoundation.org>
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
index b4bdd98bbbe0f..1df6c8a20b458 100644
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



