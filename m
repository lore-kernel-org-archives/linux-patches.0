Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034697;
	b=IWlFSBhonjGdWwhp0CKGl1rDJX8MGDka8z+O0f6HskkbjFTKYzViO2wbgxM8Lu/UWKVO
	 wYj538rYrl8I8Ww+Wzm87pgTHoV/CoVCNJfp0U1SDYr/f6xHzRwK4F2nLWlWEdMuKEE30
	 difW/0bzy6lZ2/gH6AaBQRniaJnDmLbt/RwMXHFzXWnNtmXsBHqLGL7gZ3TCVGPUMhVS/
	 apwbV1Oqj3VClKhARG4hiAitYBlYbKSPJaNMI8YY6bQk+9JjPyZgCzuHTbcAXcwRJm4oA
	 xdiANXRIdh7idLSR3o1MxvCBw7+ATiugi0kwA2kVf/Qb82fyakczsOkFTqTnY+odw8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BGNM2duf3ah367UKngzW8aSq5XjTtjhzl0d+QSHXq90=;
	b=kXmNHNEa6iexpKY3W5T4WJBrQMzJ2rkqQTJUcZD6y0HKVyapkcSPaPx0uYGkBRh1qGRr
	 9rimicwIyj6qHGLAnjtvuSFCaZFePp/6GIBdEvC66SEsUlcskSZ1UF0HhuvBvm0C9GBNZ
	 xPa1mJohPYis/5WXSGGzi+0gt/R5hHHDaZiY4Qk41Jn6wkPpF452r1/b2s1LwlmBbYFO3
	 e5openTW19v8UQVbxd/GooTd+jj86G4DehvkwH8JF0D6lNdG1KdjQrpJ0fasluyWrRBHi
	 aB1w9H7HBNm2Ybq7Y6FLR+zbGYGG8pktJDOf3trlUAEpluzRa9hE2dSfj8I3X8sd7sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/KCCSF5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C11606A325;
	Wed, 18 Nov 2026 20:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/KCCSF5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619E81F000C4;
	Wed, 18 Nov 2026 20:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034696;
	bh=BGNM2duf3ah367UKngzW8aSq5XjTtjhzl0d+QSHXq90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/KCCSF5g/d8OceUFta3bT0UQZK8ZSQLaWYP+heSW2Xil9LeQva6C2p5CfUHSs+hh
	 1ZKkppD/2F7byqokCyVddBPf0QG59CmmcVfihobcUCq1j1z0yB3684VAS3w2Ufc2QL
	 4P+dA0gnJLSAwNZd1tJ4IjHxVnRGBXA9aAjEp6z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0460/3318] cifs: Remove struct reparse_posix_data from struct cifs_open_info_data
Date: Wed, 18 Nov 2026 15:18:02 +0100
Message-ID: <20261118150330.629101856@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 65ccccee4eb1a8147a3242238f7730bd8359077e ]

Linux SMB client already supports more reparse point types but only the
reparse_posix_data is defined in union of struct cifs_open_info_data.
This union is currently used as implicit casting between point types.

With this code style, it hides information that union is used for pointer
casting, and just in mknod_nfs() and posix_reparse_to_fattr() functions.

Other reparse point buffers do not use this kind of casting. So remove
reparse_posix_data from reparse part of struct cifs_open_info_data and for
all cases of reparse buffer use just struct reparse_data_buffer *buf.

Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65d5dbdc089b ("smb: client: fix file type corruption in posix_reparse_to_fattr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 5 +----
 fs/smb/client/reparse.c  | 5 ++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b6a89d0515757..126cd0e31704e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -224,10 +224,7 @@ struct cifs_open_info_data {
 			struct kvec iov;
 		} io;
 		__u32 tag;
-		union {
-			struct reparse_data_buffer *buf;
-			struct reparse_posix_data *posix;
-		};
+		struct reparse_data_buffer *buf;
 	} reparse;
 	struct {
 		__u8		eas[SMB2_WSL_MAX_QUERY_EA_RESP_SIZE];
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 5dd333e2893c2..10dc0be26bcec 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -294,7 +294,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 
 	data = (struct cifs_open_info_data) {
 		.reparse_point = true,
-		.reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
+		.reparse = { .tag = IO_REPARSE_TAG_NFS, .buf = (struct reparse_data_buffer *)p, },
 	};
 
 	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
@@ -753,8 +753,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_fattr *fattr,
 				   struct cifs_open_info_data *data)
 {
-	struct reparse_posix_data *buf = data->reparse.posix;
-
+	struct reparse_posix_data *buf = (struct reparse_posix_data *)data->reparse.buf;
 
 	if (buf == NULL)
 		return true;
-- 
2.53.0



