Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061385;
	b=GdCVNimRMZ8ljX8853tC39p8m1WgKPJV8eXu6MWDSA300DkaOX3//6ZUZZGQtcBdNKNn
	 Eu6xfG6e2ph+7F8d/oUlfHtTFBGru5nt2IyOmm34cuecQ6/NzvZP+Wowy2mPEufuRzlMe
	 CgbzG+VPee/x78pI2oiOIA0pitJj5NJqI50BPdEpPaMtiBMMYNawMqGki1NT87Xi94/qL
	 lCAseEm3q3ZNchfRfqWV4rQoDYeupf6C3zpMcXi4Hv0C3c7MPyq9M+Aa1WCFox6B2hNs0
	 4VG0Nq95KkYk5dj9O0U2PAQRZUQL9ebilQb4o4UAkZj16zwk6UsPHJsEStgNN1VfMUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pi6gB2TVix6ZZ2C/ttTEuIw7HQHKn7Nk454OGGdgyQw=;
	b=vlbWm4L6v9Wrxnr+bd6EPJHYsqlL2LseNuDlD3RWE5aMj3/pXeQdmWxKHmDF9n3oUVvR
	 wxcQ/T0bTbFu6tU0GsjY/Qa/ayeVJyuu4gy+6Ea9tQ6wZ0yhgXb7NKn+WPfR0dyDOSLZT
	 JdZ741lVUHqH5tkD8HLifzKl+vorBY/VogAHXgGbjUAv/He6E9mHdsgzKKfndCiomwF2Q
	 AILSUmeTI+Vd2r3CbWbGr6sWjS2V7+4uaZuzCUY2JhinTN0yYRtmlQbtUqwUvmuTj//+H
	 oKYycu9/iQhadyEQSg3Ywqt3yA820pYWKOCgjppflxygUzQ1fSPVmB/1j8IdcNf+LkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXSqD6Yn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDD9606A33A;
	Sat,  7 Nov 2026 14:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXSqD6Yn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F063C1F0089F;
	Sat,  7 Nov 2026 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061385;
	bh=pi6gB2TVix6ZZ2C/ttTEuIw7HQHKn7Nk454OGGdgyQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXSqD6Yn0OdxflWFYHDcH65nf5H97YRcNiNrb3qUbd8M0JJGm1YnMbKNn/NqG0L8/
	 z5eFJFT9wt00KYwcATw0hgL1SupA+7a/lfPv7nWOGthEk1ggoZcswy/iSMbrjjYgqb
	 6njsKJr0aVUee1ckQw1lWNjzsdJ+dhocZfC32ivo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Lesuisse <arthur.lesuisse@ulb.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0507/1536] smb: client: fix uid/gid override in getattr with posix extensions
Date: Sat,  7 Nov 2026 08:42:03 -0500
Message-ID: <20261107135011.684369444@linuxfoundation.org>
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

[ Upstream commit cf4d35896621b7298eef51b7a465e5c0cb22f670 ]

When mounting with 'multiuser,posix' options, cifs_getattr() overrides
the server-provided uid/gid with the current process's fsuid/fsgid.
This is because the condition only checks for unix extensions
(tcon->unix_ext) but not posix extensions (tcon->posix_extensions).

With SMB3 POSIX extensions, the server provides real uid/gid values
just like with unix extensions, so they should be preserved rather
than replaced with the caller's credentials.

Add a tcon->posix_extensions check to the condition so that uid/gid
from the server are properly reported in stat results.

Reported-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Closes: https://lore.kernel.org/r/DB9P190MB2012266F6B8DECBE5D26A1798DB52@DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
Suggested-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Kept the tree's direct cifs_sb->mnt_cifs_flags access instead of the sbflags helper, and added !tcon->posix_extensions to the existing condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 4954d42ae8248..8f7bb68565f2f 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2889,13 +2889,13 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_ENCRYPTED;
 
 	/*
-	 * If on a multiuser mount without unix extensions or cifsacl being
-	 * enabled, and the admin hasn't overridden them, set the ownership
-	 * to the fsuid/fsgid of the current process.
+	 * If on a multiuser mount without unix extensions, posix extensions
+	 * or cifsacl being enabled, and the admin hasn't overridden them,
+	 * set the ownership to the fsuid/fsgid of the current process.
 	 */
 	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
 	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
-	    !tcon->unix_ext) {
+	    !tcon->unix_ext && !tcon->posix_extensions) {
 		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
 		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
-- 
2.53.0



