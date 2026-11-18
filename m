Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034689;
	b=RZaPZvOrM2p87Yj/Cmqj7ixVcinNtOwSnhfXw4s3SeouxsweZ+gqj2ChIOKt0CfTBOyf
	 PAquI7y5u/58mrzeQjVQr/NGe7dblSjoMcvrr8BVY4dtb95s7tx0ucQ/4vEu938/5EXKS
	 Z1kjebKcqsK/EFv8iE/07W5n4CjVZR9SSuRCcP1hnBhNt5kRC9V7ZQ0n+okdAeW7I97Yl
	 dLbJ3EWnn+PefK8pBWpUOncQ1u/7nKGBGy6N1SeaqBGmTrFaQR9GssQAFV/QpCU8kd3Pd
	 OB5V/NzIHwkqhfC2gMYJIHHER/GLwVY+5MhQvekvOSjLrxeqQky3Fhk5Cy6SSMNogIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4x3P6c5R9VUO8lj0eik5ltBtPECkfGeQWf+3bBuhlTU=;
	b=Y9+b2u/4nc9dMh53TgibrvRtEt1mxSkpKBTKIadec8f30/O2GbzU1OpNo8yV0Qd1uFxJ
	 08MZMFu24b52xvtmIc/A/2rqvNRS/JnHVrg3WdpkQkU9/lJh+c0NWAfCQk0KrZK4ito8J
	 21U0dFSZ4fWJw1JZDAhviFcI1EivM8xRGDg9taNkyVvaE+a9fABJ2wkpvmsuh8ZIuHOSV
	 hx9891ShtAfrBpcIY1k9V5Slsn72qz1H4qtegjFKn4QNwwiPXunnlfGwi3UXNdTs8hSlT
	 Qhvm2DF4vmlx6HEtEN3O5EU7jtSOS9ioKHxWL0Mn2fyjzld4ZOPB9dALowcp8qT5MCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enn51joq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7426606A31C;
	Wed, 18 Nov 2026 20:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enn51joq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C701F000C4;
	Wed, 18 Nov 2026 20:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034688;
	bh=4x3P6c5R9VUO8lj0eik5ltBtPECkfGeQWf+3bBuhlTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enn51joqnvOM9PYSImvkgq9VQJZrgblRO/27Oxi2QY7umzf/iCQK+6J8vCiHtjy7S
	 iy1prDtZikNwcrS/xS76ScSAR+MuMmILuEKcJYylq9RPtPIAXX6I/9KHY5BuuuSDIL
	 Bn9GsN/0LenpyeNIPF6V2lyxRvHQ05f0ugQvBaOw=
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
Subject: [PATCH 6.6 0458/3318] smb: client: fix WSL reparse point uid/gid override
Date: Wed, 18 Nov 2026 15:18:00 +0100
Message-ID: <20261118150330.556673286@linuxfoundation.org>
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
[ sashal: Replaced the missing cifs_sb_flags(cifs_sb) helper with cifs_sb->mnt_cifs_flags in wsl_to_fattr(), and adjusted context for the existing cf_mode line. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index fe1fa561e4950..5dd333e2893c2 100644
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
 			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
-- 
2.53.0



