Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617644;
	b=ddw+PsRiCpj6mxB6tDJD4ibuvMFLs7DpfNji+0iD3Z/OujREvM0LCgK1yl/0rY77B8eP
	 fZ7oQ++wwda3R/dnvqBGhlONxOS/2XRrN9JuQ1bK7tWE9yse2vShicWfx3zb/5pzGKLT3
	 uKwJB1IzJgww8u5Nycu2Bqwp1kMRSprpcHSihMQnEPKLU5X8X1onhTjI5VvWdN39ir/Ux
	 crpxxJouAi2Lq3Qqfm6REF/wfG+iy2wqesfuOqyqAcwq065KoUNSlvOlu3Xjd12vhk87G
	 XGIn41trz7HrptrZzZ8h09exGg/K9d7rM12fg9kw0Txkf7bitepOtsGPTz2JR2okq2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tSlQeAJsXaFgmpS37w+bRLJuJbbERP8OnlhaPJT/3Vo=;
	b=MKgubPJuDCn5dUKIZBL0VXleIkv/LbsMNFpnAlFf2hT5Uy6624FsxrMCt/2HHjeuKe6m
	 1Hz3KQ4AWYmvo/Y55vlMoUnOOAZHFu6qMFR8ts3NfI0c1d1OB5RWv6//ohFMP/ejFBv4/
	 huqh+EKQ2cYuS0dMfuPgLtdwlZzrdHm/L6LyQ+vDvUc474TBR02MbyqBfWk/4O3Icjo1I
	 8TFl0lZJ/XU1B1RtKMMXZW4jHHobf90NmTZ/aRBz+5zBhQj5qyGUfJtzskplyC6Z/ryEM
	 qM278NUzaFzK6/EzLJeMeB6f2WP1cbnuGRIZlOyF8VjjNzbrjKkBvkn016CJG3CAF3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMzMhnnS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE007606A329;
	Wed, 25 Nov 2026 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMzMhnnS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF2F1F000E6;
	Wed, 25 Nov 2026 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617644;
	bh=tSlQeAJsXaFgmpS37w+bRLJuJbbERP8OnlhaPJT/3Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMzMhnnSIkmy9U9Yl8xrzLap5x9elPkNmeBVpOR0/yHWqcZZdyxGb/Lg8r43VVZ1o
	 9yFw3NSKg2AWMXAai8QNJNA/J+IcbMMCdM2GezmCt/1bcWByEjrbfzKDkjMqM0TWiL
	 0XHnRUmtep1XcRpK0qz8fL/QzE3ST11X1lE4RUHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haobin Wu <853555@gmail.com>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0031/1005] 9p: skip intermediate directory entry name copy in p9dirent_read()
Date: Wed, 25 Nov 2026 15:22:49 +0100
Message-ID: <20261125143822.466071546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haobin Wu <853555@gmail.com>

[ Upstream commit 8bb0279930cc90975f03bad4d83282613e5f57fa ]

v9fs_dir_readdir_dotl() decodes each entry of a Rreaddir reply with
p9dirent_read(), which parses it through p9pdu_readf("Qqbs"). The 's'
conversion in p9pdu_vreadf() already allocates a NUL-terminated copy
of the name from the wire buffer; p9dirent_read() then strscpy()s that
copy into the fixed 256-byte p9_dirent::d_name and frees the original.

The wire format carries the name length in 16 bits, so a name longer
than 255 bytes is valid on the wire and may well be valid on the
server's filesystem, but it makes strscpy() return -E2BIG.
v9fs_dir_readdir_dotl() turns that into -EIO and aborts getdents64(),
so every entry after the long one disappears from the listing.

Drop the second copy: keep the string allocated by p9pdu_vreadf() in
p9_dirent and let v9fs_dir_readdir_dotl(), its only user, free it once
dir_emit() has consumed it. p9_dirent is a short-lived stack object, so
the string's lifetime does not change.

Note that the VFS only rejects names of PATH_MAX bytes or more in
verify_dirent_name(), so after this change a name between NAME_MAX and
PATH_MAX is returned by getdents64() even though any later lookup on it
fails with -ENAMETOOLONG. The next patch skips such entries.

Fixes: 7751bdb3a095 ("9p: readdir implementation for 9p2000.L")
Closes: https://github.com/microsoft/WSL/issues/41192
Signed-off-by: Haobin Wu <853555@gmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <20260918024851.51229-2-853555@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_dir.c         |  6 +++++-
 include/net/9p/client.h |  2 +-
 net/9p/protocol.c       | 12 ++----------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 323f85352f6a4..733ec42258bc6 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -196,8 +196,12 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 			if (!dir_emit(ctx, curdirent.d_name,
 				      strlen(curdirent.d_name),
 				      QID2INO(&curdirent.qid),
-				      curdirent.d_type))
+				      curdirent.d_type)) {
+				kfree(curdirent.d_name);
 				return 0;
+			}
+
+			kfree(curdirent.d_name);
 
 			ctx->pos = curdirent.d_off;
 			rdir->head += err;
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 55c6cb54bd254..0a1de81c8cd8b 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -270,7 +270,7 @@ struct p9_dirent {
 	struct p9_qid qid;
 	u64 d_off;
 	unsigned char d_type;
-	char d_name[256];
+	char *d_name;
 };
 
 struct iov_iter;
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 67b0586d807f9..d4335884e0c08 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -770,7 +770,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 {
 	struct p9_fcall fake_pdu;
 	int ret;
-	char *nameptr;
+	char *nameptr = NULL;
 
 	fake_pdu.size = len;
 	fake_pdu.capacity = len;
@@ -785,15 +785,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 		return ret;
 	}
 
-	ret = strscpy(dirent->d_name, nameptr, sizeof(dirent->d_name));
-	if (ret < 0) {
-		p9_debug(P9_DEBUG_ERROR,
-			 "On the wire dirent name too long: %s\n",
-			 nameptr);
-		kfree(nameptr);
-		return ret;
-	}
-	kfree(nameptr);
+	dirent->d_name = nameptr;
 
 	return fake_pdu.offset;
 }
-- 
2.53.0



