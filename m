Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831229;
	b=dIAmobxP9qCsJLQZk5IYoQa8GXWk2x1VvAoSY7uwIzrrKFz14/poHsa4HK6lGHs/OVR1
	 SGpuDdfFySTIzFJjtspHz3cL/ODakVBh8eAueY0TrsxrQaitBz0HAtyJogWIb5nwBfhGT
	 /CIre6pFcnWw59PWHycI9f/rcy7MwIweLV6Sp7jQEOstQkWCUhB+mn4PlX/YefI13RAEH
	 MJdzQYazgJXX4jyf3ajaWBIwC7TegB/Wlae/9IRgGXD9anJRY1PN/hnj6NNM9SlIY8KE5
	 9AcZ9GH1fp/KKZqCtOTua4dRkvlpbI1WLZJD7gr/WQaCH9aScTcdGQsZphjEzZymJcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UJdmJqk3fDeEv0bqjjhE4oj8Oy3vUIVag3sdpZcYGhQ=;
	b=e6QGoNVkBYaU7HyVugRZ0NBdiL+EA1odoMCWwSICIGgmzOHf1qoInVgD9SlWOUwwGQu3
	 X6A16f7xOrTNc1FedUmSNAdpG9Jy31kG4SHc5dKBp4N0o2PfJ1n75wSWFE772RvCfVG/2
	 BkfEuIrAwzEQnnm/8wlUj3pZgLY6TffbfJx1v34LN35+PN+FnF2WcDvGKGNHzWWKXaBhs
	 7keGAyeanExcFSis4kDAfZevj9T7RfU60ubtK33DlW75Neu8e+SD5+VwrTq6SJvxEDJw2
	 e/PtYq3Hl91XgOw6Id/axT83lq68dixHgF8MqRPwMJM38NfAACdp7G0ttPYxmkllrmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jF+KQTxB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E81E606AB32;
	Wed,  4 Nov 2026 22:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jF+KQTxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7701F000C1;
	Wed,  4 Nov 2026 22:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831229;
	bh=UJdmJqk3fDeEv0bqjjhE4oj8Oy3vUIVag3sdpZcYGhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jF+KQTxBjcoR97mWybJqtxVw4TBPifOJLxCXpwr0Zfqy0c/m92XMa2k1cTvSZX/Xj
	 S+/h10VJdjYeC7r0+T0EAcdQ2pbDWRQwxvqlXuwmRK0Z9Do2Do3t48jjt4pTxtscJm
	 tumOPsMrbEe6D4WNT7g2WlGq0RRGvIWl1zhgvPHI=
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
Subject: [PATCH 6.18 0576/1005] smb: client: fix uid/gid override in getattr with posix extensions
Date: Wed,  4 Nov 2026 16:05:09 -0500
Message-ID: <20261104211100.000258027@linuxfoundation.org>
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
[ sashal: Kept the inline cifs_sb_flags(cifs_sb) calls instead of the upstream cached sbflags local, since that cleanup is missing here, and applied only the posix_extensions condition and comment change. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 995d6df9304f4..88d2732b73a05 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2978,13 +2978,13 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_ENCRYPTED;
 
 	/*
-	 * If on a multiuser mount without unix extensions or cifsacl being
-	 * enabled, and the admin hasn't overridden them, set the ownership
-	 * to the fsuid/fsgid of the current process.
+	 * If on a multiuser mount without unix extensions, posix extensions
+	 * or cifsacl being enabled, and the admin hasn't overridden them,
+	 * set the ownership to the fsuid/fsgid of the current process.
 	 */
 	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER) &&
 	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) &&
-	    !tcon->unix_ext) {
+	    !tcon->unix_ext && !tcon->posix_extensions) {
 		if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
 		if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID))
-- 
2.53.0



