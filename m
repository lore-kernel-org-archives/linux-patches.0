Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061389;
	b=H7br4jJm0aFNReVRiMPYuMaevdzrkJu6MNat/mZHwkkukmreKM2RmOV9FWBJZ7ISRBcp
	 SxqY509FJojBbygy36wuQi6r1QJ4Ilwerde6PEk40o3BHhRyx2XiPdK0BKt0DXWLMJBX4
	 cha3VCWUjrUUQRG+m/vbvIWA9Wmt4I3r9E6LMuMJksHeKouNwQ/Pju0vK6Tk5zUpHuO0/
	 hl6SEJZoVGXHyp4dfxoKRHuagt8YaxtumIECYt7F/QE6Ujl+znp4vdcSGyiSOttuksXg/
	 mtO+/EJxXTesYYppKyhldCtdjV05GoVsHzwsH6v4pYTONUTIiRdq2u5bChu5YoZimDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3T/jKjHKiwTgD9o+u6+Jf+/6eR3kSLXY73mZhah4khc=;
	b=bIbMRoPXnShbW0r5+XbG2VBXC/jGoZFrr2m8rJA2i+cTpBGurha63WHVfImQ70vDtmVi
	 z+vuPeGDJlVmr/qTEW61rVSLWYiddfa9M36Yrh6+xGVK/Kn5+bLMBXbS7klFjyYkUlSRM
	 PEmXmxpY8xVgNLO0xUEnXnO/vuP9Hy+zOaql9liorWv+TOtPDXz4bZ8L9UP2PQ2+GqjgT
	 GD9EWPCiPwVXRw75R9MaJu3T2f8IRqsnC4ev55t/mwqAzf2+I1ODsKaT72jZF4QPe8mIL
	 7aBMpNW4Zncb/yaYTTuZ5aAsA5PUS7XvHEfHzwPCvIL6QjHkMO6YrwZfGbLiOUd55dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="raN5/ZuJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A58606A33A;
	Sat,  7 Nov 2026 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=raN5/ZuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872961F0089F;
	Sat,  7 Nov 2026 14:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061388;
	bh=3T/jKjHKiwTgD9o+u6+Jf+/6eR3kSLXY73mZhah4khc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=raN5/ZuJkIYM5ZpJEwfGg9sukDHWhJvMu7Nih9RWXOpexSa240KtFioWuHW2jMwRa
	 TvWgK40Ok/HeLFbL0RmYF1awZvJSKFsd5F1DtreyS2YXTLPLLBKWeW/1K6Irk8niLy
	 HgYc47TWc7xRZATo3ZpANLgnDPvncoAlKSEeOuuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0510/1536] cifs: Remove struct reparse_posix_data from struct cifs_open_info_data
Date: Sat,  7 Nov 2026 08:42:06 -0500
Message-ID: <20261107135011.762941899@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0fbb3cd0daf5d..f5ca2cd653e95 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -227,10 +227,7 @@ struct cifs_open_info_data {
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
index 727db70a61147..de070b108180b 100644
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



