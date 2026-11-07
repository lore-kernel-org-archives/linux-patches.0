Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061386;
	b=W5L3kKNizI3OLiTzvbpCJwK/4pPeFDTQ67afTXoXd72uCYe/ZAL5a03PQ2YhqZ6clPq4
	 HOL/l2e0WE6n75WcUc8SXbc6p+q0b48m/4aJF8lRtHbCYJNkkOkOc+0WDxix7Fln1RIxO
	 zo2roMLM1eHBDrSdOfiL26KWuzs+myWHRsMUPnEFZ/eY08l7pOJQT1BR/x2Kfq26z2mht
	 qBVZ5sOBYJFgpxoGrtEq5JS8kW+s3JD+zYYz2+LBZCHB2a5KmLbAy67ZqOrypf3GVa43z
	 U2rn+7/svgxYoISP7v4s+bkWs2iyYw63R6ZE2qPk2IalzcmezBRu2JyswYghLHh0mFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B6JTI/s6beQAnNn5W/OI4oLXNkWn+aVzwokNJrCoP6s=;
	b=hS/IWKRMX82WjeAqqt5HhFWAzXXYneylJSuvYFMsALDY9QabpJb5GdL9C+0O37VoBA1t
	 PTRVZo15K9U8SQOSS5rDVhuvA32FpHdZ1ffROASrjeg3rXr2j/YucPHi9TaRC8pV4erny
	 JtSnK7ESM3Mp8HNtZzqmNUOmRMhe7qAkkcmTGzYz1N1gLNhY9lnLPiJlgVR6rrLHIWrSn
	 Oe/WyNdtBuLc4MLrsLCBV09XvKlxgdiK+qFJNsdF7sG5o4uGiPZ4K/yGXuZMzj48qbGnE
	 HnW1U00nU5haHbFZz6CvG4UY2I1pG+FtvEbxZh9qj1VMd8BbdfpVWoLCf7d79dmvUzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQnkE0Px;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E48F606A33A;
	Sat,  7 Nov 2026 14:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQnkE0Px
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FC01F0089F;
	Sat,  7 Nov 2026 14:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061386;
	bh=B6JTI/s6beQAnNn5W/OI4oLXNkWn+aVzwokNJrCoP6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQnkE0PxG1142tCeVBC4q2wdBaCWGlb8nx+A8gnwgGpbyUGCr9jMMJmQu1xFrrR1t
	 57Po8tZCM3j8ETcCzJZ6Fm7sCxipQHeO2tuXQOI8jfk2qonSqp8tdW2dOjeMHpLpa6
	 AUTcBsPfVpFXfiIstoi3XilZaX5hVowGoqKsne/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0508/1536] smb: client: fix WSL reparse point uid/gid override
Date: Sat,  7 Nov 2026 08:42:04 -0500
Message-ID: <20261107135011.710391404@linuxfoundation.org>
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

[ Upstream commit cd2b2b57921d4caa7875e83198bb2aa71254328b ]

wsl_to_fattr() unconditionally overwrites cf_uid/cf_gid with values
from WSL extended attributes ($LXUID/$LXGID), ignoring the forceuid
and forcegid mount options.

Fix this by initializing cf_uid/cf_gid to the mount defaults and
gating the $LXUID/$LXGID EA parsing on forceuid/forcegid.

Closes: https://sashiko.dev/#/patchset/20260906190803.667489-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Replaced the missing cifs_sb_flags(cifs_sb) helper with a direct cifs_sb->mnt_cifs_flags read, and kept the existing cf_mode &= ~S_IFMT line alongside the new cf_uid/cf_gid initialisation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index ee630eb575d1a..727db70a61147 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -679,11 +679,15 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct smb2_file_full_ea_info *ea;
 	bool have_xattr_dev = false;
 	u32 next = 0;
 
 	fattr->cf_mode &= ~S_IFMT;
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;
@@ -720,11 +724,13 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 		nlen = ea->ea_name_length;
 		v = (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1);
 
-		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
-			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
-			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+				fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
 			if (S_DT(fattr->cf_mode) != S_DT(get_unaligned_le32(v)))
 				return false;
-- 
2.53.0



