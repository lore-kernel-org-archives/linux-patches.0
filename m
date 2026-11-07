Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065162;
	b=C4g5pWzAWu5mfcNNwRABu7vdU+A+oHmtok0K3iSkl8DIh7hslVBKuYdPwe4L9QGLUWyt
	 PaFuAzMGvmSWiy+TO1F5jGU+kdkZ0zjuwJIcKPcp1hNF1GV6eTuN+1DxbXgNASQYmShOh
	 FzQJ8Vlhrvgk9l/Tk2dWu3NykzFW9RCGJyjHu3btbOgdSNOgp48/fQg5nOkd6Th+Oisb+
	 +e6rQjm95a1waUPYoalWLKpZ8WaoGv56FTTCOPk14UYv/7o46SJ67BtUUhm8+koLd2r1B
	 5iFR8DLSFpy61ch3eVcSlgreEM0/L43IbtrbUEMVVuYAFhJik2PiX1YNTuR9cilPncQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OosY+GtPsoJIiLXcm5e/N1zmGWRlkTpBCaqfwWTQD+Y=;
	b=ebdDgJYMpC09bI5lGvwBLK9Mw4j0mdcJkI/fnmf2E3tOrUqCyKK0CAb25oR/xrSfJy33
	 bGcoxgiVfXzbywor6RIc9S//KHe6Pa8MYiWs20iLYMHYNnOeCk7szbCw23O8SPqnYUNke
	 B7KPm47wIG0JyRx/5po/+aTg0YJvClMG9Qe30z9A3tYPtFvukd4cMNi3pxsfh5LYmkGh8
	 VQYx2b3/MxPjOOfSHDXmg/UdwSCQickzZ8m0uknonGI0jwqfi5SBnAM84c38vt/3wOgmG
	 P5wkewRSGFGVk6724YuA186HgexncOgtyzYofrxErVMMN7hscnZIeIissesrDwxYRZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOFg59LK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F2C606A32E;
	Sat,  7 Nov 2026 15:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOFg59LK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7623F1F0089F;
	Sat,  7 Nov 2026 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065161;
	bh=OosY+GtPsoJIiLXcm5e/N1zmGWRlkTpBCaqfwWTQD+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOFg59LKIo2JHCH0QITx5vJPd+3iCkK9lCfi6uBbGfBdzQlzXfQ4KrQ8PpTyD9Ld2
	 yx1Os/wKdtLiOtRBw+20iOk7y+0w2jkQmickvpJrJa/eRiCTBc8Lr+hN+gh6Mw3vkh
	 QErNlZFDeA/GsYw4V+mvHssz413yjG45Vhx0RccA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0924/1257] ntfs: fail remount on sync errors and keep the dirty bit on SB_FORCE
Date: Sat,  7 Nov 2026 08:53:40 -0500
Message-ID: <20261107135004.874608392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 17a1edda75fd371f36085b1568e0b70baff99969 ]

ntfs_reconfigure() currently ignores sync_filesystem() errors, allowing
a regular read-only remount to succeed even when dirty data was not
synced. Check the error and fail regular remounts, leaving the
superblock read-write so ntfs_put_super() can retry at unmount.

SB_FORCE does not wait for writers already in progress, so it must not
clear the on-disk dirty bit. Warn and continue on sync errors for
SB_FORCE. A forced remount updates the dirty state only when errors
have been recorded, and never clears the dirty bit. Skip the commit if
that state update fails, since the in-memory flags may be inconsistent.

Reported-by: Hyunchul Lee <hyc.lee@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/super.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 486336508b8c7..c6f820707ef21 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -273,7 +273,13 @@ static int ntfs_reconfigure(struct fs_context *fc)
 
 	ntfs_debug("Entering with remount");
 
-	sync_filesystem(sb);
+	err = sync_filesystem(sb);
+	if (err) {
+		ntfs_warning(sb, "Failed to sync the filesystem.");
+		/* A forced remount must still turn the superblock read-only. */
+		if (!(fc->sb_flags & SB_FORCE))
+			return err;
+	}
 
 	/*
 	 * For the read-write compiled driver, if we are remounting read-write,
@@ -336,11 +342,20 @@ static int ntfs_reconfigure(struct fs_context *fc)
 		 * or flush fails the remount, leaving the superblock
 		 * read-write so ntfs_put_super() retries at unmount.
 		 */
-		err = ntfs_sync_volume_dirty_state(vol);
-		if (err) {
-			ntfs_warning(sb,
-				"Failed to update dirty bit in volume information flags.  Run chkdsk.");
-			return err;
+		/*
+		 * A forced remount does not drain writers in progress,
+		 * so one may still be modifying metadata when the flags
+		 * are committed: never clear the dirty bit then; if
+		 * errors have been recorded, the update preserves or
+		 * sets it; otherwise, skip the update entirely.
+		 */
+		if (!(fc->sb_flags & SB_FORCE) || NVolErrors(vol)) {
+			err = ntfs_sync_volume_dirty_state(vol);
+			if (err) {
+				ntfs_warning(sb,
+					"Failed to update dirty bit in volume information flags.  Run chkdsk.");
+				return err;
+			}
 		}
 		if (NInoDirty(NTFS_I(vol->vol_ino))) {
 			/* ntfs_commit_inode() would discard the error. */
-- 
2.53.0



