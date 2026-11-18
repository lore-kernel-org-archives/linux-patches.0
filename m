Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034753;
	b=MyF/+T7t53JivjyMag04J26L+6k5lkN7c7e1F2a6b77o9MYItgAbSXwXmi/gqK//6Wlr
	 WLP2IDebhfDouaLCedRKgbb3T9gAvHU+bZKzzTWQOrUPYI/I3GPVVX0JoYErLOHJj/pw2
	 18qoNhXZZMCat2P3CuM63bJl0yj+vXHSTTfrC5g3NiN3rFucU2uoAtpGxz3ZyARJPpoWk
	 iT128BtLPONmWJuVgn2WOyop/7oZU8dXhU9zUiJ8LMxSapf4USL8YIOjXRKSeBfAr8raF
	 kXn7lO6FxVYFbMtYs6VpAMh1d07lLtZdjOmdEHKlB33fsyNcYgpgEmhoWKEG7ztKaKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QonWHmrFN0ZVQx8nJ5AIUlmfJK6MrUFXByAWsU7Zw9I=;
	b=REbptfr42dwAWdxr9GkLPLTinr3mPe7Acd3glsrPqzrds2xWUdJdoRjPpSy9qD59gH3I
	 XSkTqhQXsUrMFBbEue9us9h7Udr4NiZV+IAxfzo6IBpWrwDMpngV5AQ99PcXry0v/MepW
	 hOJApcP4I6BneCUPQ6U+sxQNb38y1jpZNaOnxTu0PB/1YAIIj9RnwvkHhKDUhq0q5zu1W
	 28PHzdqQl6rsTN9+ArtjgGOv4fpZFkFsBMRjzsAn7EQ8lBboQXmeyQgIBfO+spMKSDxzQ
	 LDzTHofx9p5H4LaUjIPYTanbrw0DUDOFAp5QEv2lfdeFo1Cr8+2HYgPT7NnvolI+lcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhsyF27O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD25606A320;
	Wed, 18 Nov 2026 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhsyF27O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A1C1F000C4;
	Wed, 18 Nov 2026 20:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034752;
	bh=QonWHmrFN0ZVQx8nJ5AIUlmfJK6MrUFXByAWsU7Zw9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhsyF27OlGlaQxdgKzgHUOPSDrDubEIqNCGOPUg42ctf4nCcqOHric8d49GdgoGTG
	 v3x4U6QHEnIEWiTcMA+SBJGmCRgpclrLfhu5X/Ee/NcZg4ntD2y/jbxWshana59isV
	 OAK07GxXxpUdrmMyEeWUj88Wv6oAUZQ9xd2J17YM=
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
Subject: [PATCH 6.6 0479/3318] smb: client: fix unaligned access in WSL reparse point parser
Date: Wed, 18 Nov 2026 15:18:21 +0100
Message-ID: <20261118150331.317643533@linuxfoundation.org>
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

[ Upstream commit e1aeaf79dea51e6065da56924bc07e22d59012ac ]

When wsl_to_fattr() parses WSL extended attributes, it computes a
payload pointer from ea->ea_data + ea_name_length + 1.  Since the
smb2_file_full_ea_info struct is __packed and all WSL xattr names are
6 bytes long, the value pointer always lands at an odd byte offset,
never satisfying __le32 or __le64 alignment requirements.

The code then casts this pointer to __le32 * or __le64 * and
dereferences it directly, which may cause alignment faults on some
architectures.

Replace all such casts with get_unaligned_le32() and
get_unaligned_le64() in reparse_mkdev(), wsl_make_kuid(),
wsl_make_kgid() and wsl_to_fattr().

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
[ sashal: Changed the include in reparse.h from <linux/unaligned.h> to <asm/unaligned.h>, since the former doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 4 ++--
 fs/smb/client/reparse.h | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 010d12b557160..ceddb4ec10ba1 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -732,9 +732,9 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(fattr->cf_mode) != S_DT(get_unaligned_le32(v)))
 				return false;
-			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			fattr->cf_mode = (umode_t)get_unaligned_le32(v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index ff05b0e75c928..98da80e1ec97a 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/uidgid.h>
+#include <asm/unaligned.h>
 #include "fs_context.h"
 #include "cifsglob.h"
 
@@ -22,7 +23,7 @@
 
 static inline dev_t reparse_mkdev(void *ptr)
 {
-	u64 v = le64_to_cpu(*(__le64 *)ptr);
+	u64 v = get_unaligned_le64(ptr);
 
 	return MKDEV(v & 0xffffffff, v >> 32);
 }
@@ -30,7 +31,7 @@ static inline dev_t reparse_mkdev(void *ptr)
 static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 uid = le32_to_cpu(*(__le32 *)ptr);
+	u32 uid = get_unaligned_le32(ptr);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
@@ -40,7 +41,7 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 gid = le32_to_cpu(*(__le32 *)ptr);
+	u32 gid = get_unaligned_le32(ptr);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;
-- 
2.53.0



