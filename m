Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211178;
	b=VaqZ48e0Zu3eFSHmkaeb+g3o2urLsxq3Y1hs0SQM40Xq2A18yg5BCAKvObG82uPiZwdw
	 W7HmXcoXNt3N/bjuOR8QySEFAzkLLoCMJt6HBfRqHqSOyc9snGSQX7Iq5JRdGgV38NGrP
	 /YeKvX54Mg4UcbZZ0cxT6Kz80Ynmv65cFIYAyc/de055GBinzFoaAqsQ+19wn3853AVDM
	 e2xqaEu+rcvFCk3Ra1MouJIWsRZV5sYdcCfvvDU2JVbJ60F1VL40iOiwunnPKbNGmitRd
	 ga4s5Og1YGPQvs4NWh7PHGLxs/83oZWpJ8sCrEz1GGXK7tPnCoQIdYHvj7/EEg67N7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dXoUK+gYdLPggHO8O/3oJMW7hdLHQ4CX12mqU/b9UZ4=;
	b=QhvP8ufpuBiizg4E3GsWWHp30fDUSK0qk4pOSxB4A6cohDEd4Jr1zJjC+h3A/8QZ01rP
	 vM9b1Q3Ak+c/reEtdZDboZkXjJ41pgLoUWcG6Kh7Kww8SPaEjiXk9RNLBUb9k3pbXAG29
	 JIeOlC97ShvIl2Ms32x9Q6lXj3/HylzXu7tAT7sZIu2Iy1cw0SYYnXq03JNRjR7wL9YlG
	 T5481GAsLlFCT87FZ7VJR6kExhzqtREzz+GBPGUTnh5SBTjA45BEsebBrOvK0+FRmcETP
	 qoO6Hds4Ryo8yEjWSxwQ/PwmHc58Xt1vffQzvSdWXgBk8Aw8lf8b5zcidnJJsUOsnNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGj328Fa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C61C60A2614;
	Wed, 28 Oct 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGj328Fa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8651F031E7;
	Wed, 28 Oct 2026 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211177;
	bh=dXoUK+gYdLPggHO8O/3oJMW7hdLHQ4CX12mqU/b9UZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGj328Fajn0H9agwrBVaJQHyBcPDGw7ni5YjUGhhe+QwCC13avDqX7KUKUOwHt0WT
	 QLy2Nf/EluIMkO3/L6VtAiBaOA+eIL22ZkUIrRoq4HLoyfODSiSaH03ur5ugf7L9Qv
	 ZXYCEo0ov236azrMyGsAtqzcWB7S7RToLBeEJ/uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/571] smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions
Date: Wed, 28 Oct 2026 17:57:14 +0100
Message-ID: <20261028170014.811030482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit b8e5dc4f95e5484159b343903f302eb6d783f2e6 ]

When a file has the setuid or setgid bit set and is written to, the VFS
strips those bits and issues a setattr with ATTR_KILL_SUID/ATTR_KILL_SGID
together with an ATTR_MODE carrying the already-cleared mode.

Both cifs_setattr_unix() and cifs_setattr_nounix() unconditionally dropped
ATTR_MODE in that case:

	/* skip mode change if it's just for clearing setuid/setgid */
	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
		attrs->ia_valid &= ~ATTR_MODE;

This is fine for the default mount, where the mode is only emulated via
the DOS read-only attribute and cannot represent the setuid/setgid bits
anyway.  However, with the "cifsacl" or "modefromsid" mount options the
mode is stored on the server through an ACL (id_mode_to_cifs_acl()), with
the SMB3.1.1 POSIX extensions the mode is sent to the server directly,
and with the SMB1 Unix extensions (cifs_setattr_unix) the mode is sent
via CIFSSMBUnixSetPathInfo().  In all those cases dropping ATTR_MODE means
the cleared mode is never pushed to the server, so the setuid/setgid bit
survives the write.

This is a security issue: on local filesystems the setuid bit is stripped
when a file is written, but over these cifs.ko mounts the bit persists on
the server, potentially allowing an unexpected privilege escalation on
subsequent execution.

Fix this in two places:

  1. cifs_setattr_nounix(): only take the "skip mode change" shortcut
     when the mode is emulated via the DOS read-only attribute (i.e.
     neither cifsacl/modefromsid nor the SMB3.1.1 POSIX extensions are
     in effect), so that the cleared mode is propagated to the server
     in the ACL / POSIX cases.

  2. cifs_setattr_unix(): this function is only called when Unix
     extensions are in effect, so the mode is always stored on the
     server.  Remove the shortcut entirely so that the cleared mode is
     always pushed.

Fixes: d32c4f2626ac ("CIFS: ignore mode change if it's just for clearing setuid/setgid bits")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Backport note for 5.15: code lives in fs/cifs/inode.c; no sbflags
  local exists here, so test cifs_sb->mnt_cifs_flags directly (same flag
  bits). Drop the upstream posix_extensions clause: 5.15 lacks
  d413eabff18d ("fs/smb/client: implement chmod() for SMB3 POSIX
  Extensions"), so cifs_setattr_nounix() has no POSIX ATTR_MODE branch;
  match its CIFS_ACL/MODE_FROM_SID check. ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Assisted-by: opencode:kimi-k3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 388904b6bc030..dae9d2d97475d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2714,9 +2714,13 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 			goto out;
 	}
 
-	/* skip mode change if it's just for clearing setuid/setgid */
-	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
-		attrs->ia_valid &= ~ATTR_MODE;
+	/*
+	 * This function is only called when Unix extensions are in effect,
+	 * so the mode is always sent to and stored on the server.  Do not
+	 * skip the mode change when clearing setuid/setgid bits: dropping
+	 * ATTR_MODE here would leave those bits set on the server after a
+	 * write, which is a security issue.
+	 */
 
 	args = kmalloc(sizeof(*args), GFP_KERNEL);
 	if (args == NULL) {
@@ -2899,8 +2903,22 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
 		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
 
-	/* skip mode change if it's just for clearing setuid/setgid */
-	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
+	/*
+	 * Skip the mode change if it is only being done to clear the
+	 * setuid/setgid bits *and* the mode is emulated via the DOS
+	 * read-only attribute (the default, non-ACL case), which cannot
+	 * represent the setuid/setgid bits anyway.
+	 *
+	 * When the mode is instead stored on the server - i.e. with the
+	 * cifsacl or modefromsid mount options (via an ACL) - the cleared
+	 * mode must be pushed to the server.  Dropping ATTR_MODE here
+	 * would leave the setuid/setgid bit set on the server after a
+	 * write, which is a security issue (the bits are not stripped as
+	 * they are on local filesystems).
+	 */
+	if ((attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID)) &&
+	    !(cifs_sb->mnt_cifs_flags &
+	      (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)))
 		attrs->ia_valid &= ~ATTR_MODE;
 
 	if (attrs->ia_valid & ATTR_MODE) {
-- 
2.53.0



