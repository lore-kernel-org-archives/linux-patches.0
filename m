Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034685;
	b=cnK0tpynaAzIEaEtD959P/sKLjXKliHjqWqurbknBds/OGkUmRc5fZTj1sXGI4zGUTIe
	 g3MqTF0ZKg9C13w19galCHH5KtiNcMrbRmKWJrBHwR5Mh9LwOOOMdUInBoSNZO9YwDR7a
	 qX5gix13aG5ONqvt5hNIBtBKpSR5Yk/hYzctVz+ffOVoh34EUHYFG2mhOiyd3T3UxAIFP
	 nuFtyVa+4KIJIeATW/1E7BsY09pFP4AA2Eoc4XK4JEo31Bj47JEN8t4PwKL63I8EoWySR
	 D//0FQkMvYkOONRpR55WhfukUJU5ylGMsTsIg9M4WBHUe/f5ZWjVa9F9mt88K5GKCBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zP9ChCXnQTLFItWS1SL8cVr27btniYKTtxgvL8GndVE=;
	b=UimU7d6Qt0CLJInbU8/Kow98gjKrrfvWJS8any3ZL3N7l1Cib694xHsArLzDvuG2uFWt
	 Bhq+iL88zT3iVibzwP0iUF0ywc4IoEnHAeZDriT3jZ7AFpPhx+UM7siaY2InG8glCw+/6
	 jOp58WSQYLHxPQzxcbFDY/Q0PdO0ukHbIoumDVmhSVT2cVoHW52YqKDz3zTfE0kTmgR+n
	 i813zwfFbuTzRo0G2ALDqwJ12o2cEvJK45uhc+DoayikLbnTgI142EYQgjAzs6ZvtwkTk
	 iP8qqzwgda3OiU0FxOV3zKyPj9NEu7l2qmNo9Du7N5apC7sjaTGK3K4dKK16ei1ahMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YErqlvtP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40AB606A320;
	Wed, 18 Nov 2026 20:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YErqlvtP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE3E1F000C4;
	Wed, 18 Nov 2026 20:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034685;
	bh=zP9ChCXnQTLFItWS1SL8cVr27btniYKTtxgvL8GndVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YErqlvtP+nyvVuwECb7fHItB7z4gITOELRs6HRZdiG38E9pB3Ahdz0w7s4TIVMHuJ
	 GlV1AOIZfmfWxCtlGmmgj8h3gxOqNZpiSyeTcWkP9O+Zzd9Hx555cB3AGOfW/kiVWo
	 Yfnlm1X0t8VQJFOWUm7GUaZwRD7blpckg6WNk4us=
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
Subject: [PATCH 6.6 0457/3318] smb: client: fix uid/gid override in getattr with posix extensions
Date: Wed, 18 Nov 2026 15:17:59 +0100
Message-ID: <20261118150330.517827212@linuxfoundation.org>
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
[ sashal: Kept the existing cifs_sb->mnt_cifs_flags accessors instead of the sbflags helper in the context lines, since that helper doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 8d201db930281..85a114f3a6f9d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2838,13 +2838,13 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
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



