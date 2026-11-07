Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061400;
	b=cvDMmKx4gNDzFbUqbw7s05VA8zbHQi7ynNlipRlnCfDCYkIuVzn4IIV0DvZZWKm4thre
	 GVrATZkD0Scnpya6bwHLnSh+RkEc9938feEDbU5ifY6bjjzqMdogmSvrrckz7b6gIeh4g
	 9TskbZvbutnagOnZT273Mv5LsnPzwYrbjSb3YvCIuzbG2iX4R5TubyK/wp78Y8WNgk6Js
	 tggYJRAqS379Cy8TvZlbTOe7rX29OIHPwErbQi0nfQz93auzdui2UfiCCjTkFJDmahKbb
	 RXc1G2lyzC+SkSHmwsipMYTqhdUuxBkh5rM3hn32m5d13GXsvo59M9PKfQ2pcWRVImg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dOe6jcYWEaubFyDvLSh8StFI7+OMtSkXJXXhMRVo/bc=;
	b=uJJBskjv7BRwSx5MFi9worcJzUZnPGuX1oOnpMrht8XJsU9mCd8EK+Uh36w5bkypnSN0
	 rOEbTA4r8fWJBWuziCWHDunFnJZsh0LO31E4iGET+LCt6uXcWi6gkJ/y3WF2rX90zrqKr
	 3MSA6Bi+sSPcpcjW4ebRuf0w8MPfCjK1DEd6QI1lvC9jgPJjnJ9H6ZdMP7WD5QAjhuSdl
	 FK17HrvngT09X00LzTFpn4HvF/q5Bp8v25QDWu+K8gbLtiarNYpfPhcMjq8AQ7auaUHDu
	 KcD0D6i+7W+0Z7sAP2967jO6urBpiEuoAgRs0ICw1PIpa7/rIszIr6B4UZlNyzf9QwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppJuSTrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151BC606A332;
	Sat,  7 Nov 2026 14:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppJuSTrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6621F0089F;
	Sat,  7 Nov 2026 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061399;
	bh=dOe6jcYWEaubFyDvLSh8StFI7+OMtSkXJXXhMRVo/bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppJuSTrRlj2rKoIc2gWOKMMJMMIgQYxbZ0EtNWXCN82sv8rQDRNaBY7RzQvQUvHHA
	 afj2SZXNyjMOtkCzNEQJswKxZnxW99eUS2E75YyPxLBoOS5bwgLVahHU2yrDTjh3LN
	 qSTsNbZ+oAmCKENPZ22LSfpbAIR1bdvFvaKE3LDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0518/1536] smb: client: fix fattr leaking on wsl_to_fattr() failure
Date: Sat,  7 Nov 2026 08:42:14 -0500
Message-ID: <20261107135011.981313318@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit e1253a82bb4c0fed6706a5839fc8b6e01be1abe2 ]

wsl_to_fattr() mutates fattr fields as it parses each WSL EA.  If
validation later fails, the function returns false with partially
mutated fattr fields that callers do not reset.

Fix this by parsing into local variables and only committing them to
fattr on success.

Closes: https://sashiko.dev/#/patchset/20260906200517.725015-1-pc%40manguebit.org
Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
[ sashal: Kept cifs_sb->mnt_cifs_flags instead of the missing cifs_sb_flags(cifs_sb) helper in the declarations context; the rest of the change matches upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index ceddb4ec10ba1..bdc1322199026 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -680,29 +680,30 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 u32 tag, struct cifs_fattr *fattr)
 {
 	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
+	kuid_t uid = cifs_sb->ctx->linux_uid;
+	kgid_t gid = cifs_sb->ctx->linux_gid;
 	struct smb2_file_full_ea_info *ea;
 	bool have_xattr_dev = false;
+	dev_t rdev = 0;
+	umode_t mode;
 	u32 next = 0;
 
-	fattr->cf_mode &= ~S_IFMT;
-	fattr->cf_uid = cifs_sb->ctx->linux_uid;
-	fattr->cf_gid = cifs_sb->ctx->linux_gid;
-
+	mode = fattr->cf_mode & ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
-		fattr->cf_mode |= S_IFLNK;
+		mode |= S_IFLNK;
 		break;
 	case IO_REPARSE_TAG_LX_FIFO:
-		fattr->cf_mode |= S_IFIFO;
+		mode |= S_IFIFO;
 		break;
 	case IO_REPARSE_TAG_AF_UNIX:
-		fattr->cf_mode |= S_IFSOCK;
+		mode |= S_IFSOCK;
 		break;
 	case IO_REPARSE_TAG_LX_CHR:
-		fattr->cf_mode |= S_IFCHR;
+		mode |= S_IFCHR;
 		break;
 	case IO_REPARSE_TAG_LX_BLK:
-		fattr->cf_mode |= S_IFBLK;
+		mode |= S_IFBLK;
 		break;
 	}
 
@@ -726,26 +727,29 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 
 		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen)) {
 			if (!(sbflags & CIFS_MOUNT_OVERR_UID))
-				fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
+				uid = wsl_make_kuid(cifs_sb, v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen)) {
 			if (!(sbflags & CIFS_MOUNT_OVERR_GID))
-				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
+				gid = wsl_make_kgid(cifs_sb, v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(get_unaligned_le32(v)))
+			if (S_DT(mode) != S_DT(get_unaligned_le32(v)))
 				return false;
-			fattr->cf_mode = (umode_t)get_unaligned_le32(v);
+			mode = get_unaligned_le32(v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
-			fattr->cf_rdev = reparse_mkdev(v);
+			rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
 		}
 	} while (next);
 out:
-
 	/* Major and minor numbers for char and block devices are mandatory. */
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
 		return false;
 
+	fattr->cf_uid = uid;
+	fattr->cf_gid = gid;
+	fattr->cf_mode = mode;
+	fattr->cf_rdev = rdev;
 	return true;
 }
 
-- 
2.53.0



