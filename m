Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831231;
	b=erSHPgCqn03byHUUHXBDpmuUIeqyJWH9fLwPGUAO7FpJDGfxd3UB+AIP1vwwF/BHbqb1
	 7Z24oxw3J/brpShEOupnxbDaxhGPknatcMoVnmAoaXSrSdyE1eQ3gUlHntVVCXk5OE29o
	 r06pcgO3FYMpK+1MDx5lMvYqoQTXqAShcgMw+JPZCWt0DxwdKtr/JpThBIumzuy0iPKZ7
	 99zaIm4LZMLo4i2xBT4zg+7gv7jeCyj80xXl9+l6/JIWKhUz6+a/DTqiSJ35+UzNE/g+a
	 R+egbw3TujoqJFVMgG7MLp18fjqq+giPoMjHtO880MHbUvKycblkyQpa3E60nS7on/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Q8ENYDYhFfbtZIeUdcEhekfwwEfJfrDg1/Ud0DK/8M=;
	b=B7L7dhOtJaTnx5Ta/gLFOC9XKz0W9vUQLDjgYQsYxU/8O2cfB4yH3mgya2G+D4xL3gHL
	 edDk8rCkaCwqsg0xPtvOTKySBc7uaqOoTGfh9SB6mozZvWJGXR6QTEftGDVHrTRRzDgaS
	 1zTnn7wrwXB0/V1lr3sQDhr4zJczy7GPphbPhlMT5dKbBlZqF2KHNJUmWC+OEGh1C3D5o
	 e5lgNVitIkcN5YqxSWinXB7V0emVLSYaxkClXO4wBwDrNiLK7nHIatEWXRZx+32EVyRTP
	 fxqJ1fP4L34ewhhYRi5O2SVceEiWUTK8jHUkUKDWWj7dAwGKHCXq9/AO8KMihOol6EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZGSTRvt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC864606AB32;
	Wed,  4 Nov 2026 22:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZGSTRvt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1AF1F000C1;
	Wed,  4 Nov 2026 22:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831230;
	bh=/Q8ENYDYhFfbtZIeUdcEhekfwwEfJfrDg1/Ud0DK/8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZGSTRvtm8hcqiah1QdGskwNMK+VyNM4vUER8583u+RMg4BIi2yVhO7y0olZSov3J
	 s9Iag59/s3ahNZAG73FHIdWU9kpIzZ1NzE0nJfLz7tF01fbUQVK6+1Odo2MzWXFjkc
	 HBGbYSYWvVSOavlFpAnP0RB55pCsqilYVFq4OwJM=
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
Subject: [PATCH 6.18 0577/1005] smb: client: fix WSL reparse point uid/gid override
Date: Wed,  4 Nov 2026 16:05:10 -0500
Message-ID: <20261104211100.028829428@linuxfoundation.org>
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
[ sashal: Kept the existing fattr->cf_mode &= ~S_IFMT; line and added the new uid/gid default initialisation after it, and the S_DT() comparison context uses get_unaligned_le32(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 2e773a1a67142..124ad21d6dff6 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1109,11 +1109,15 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
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
@@ -1150,11 +1154,13 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
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



