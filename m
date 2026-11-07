Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065079;
	b=EekB5HCB6AC5XTEn1vuaIZPkZRKZcgQmR3RJpiyDdfrpBnrjUL6SIp5thYPFCsJe+3qT
	 lunhFfKfdP+vTXWs7uebufqU5KNKT7GiGC8dsQD3kAo7zYjFALTomlXF6OmbviUrBkxOH
	 4+A6xIjrlI8yCnuWRhQ92TUMUshWoU5CyeN8N2nG1lIAWM5fjfc2v8qixFSgQm1iFL4iY
	 Uv381eM8PoaTiY+0nlu/fJGjhBsfksexGkKPlwaF6GA6YVBIQ3vMD8XHPuvuj0SBh1YJR
	 CFL3GBYJYd8CQDPsMSi4SIZgzUQCbfB/xz6y3IxAsY49oybrbJYA12EvdG5eLFAGY1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Z9c4W0yaigR/JXKHXqbHmOdIeLfqpurtU2wtOE+t+8=;
	b=0N7aLG8Ow6K64bPII4aeleiC8tcQ5twYbMgXLqFDu1BA0rqxJM2gJkCHeqY5zW2WVGUn
	 8vhuc+kD7cJ+y24y9YfW91L15/Wz3fzBSGSb4dzqxiwiuaVUYGhiAHY4seJPRkSQ141QA
	 yNH63vrKtub/PEmU3oe68QxYMagj0+RnlvZnQV3c820lBR/+NXUOVLP51HA5XkYii/lE2
	 HNM2pRRGo+/d/xNX+x+7gVyE8Ywlr1IVQuwlSxH+D9loPPz49VjmPLLb1Zn1rfwOHffYC
	 a2asVxRtElrRMhaHxYShRaOS7uhFfuD2dDU96QNpLVrSDSP3KREe9VtTI+3SZ4oqQvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVMLjkl2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4649606A326;
	Sat,  7 Nov 2026 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVMLjkl2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C891F0089F;
	Sat,  7 Nov 2026 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065078;
	bh=9Z9c4W0yaigR/JXKHXqbHmOdIeLfqpurtU2wtOE+t+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVMLjkl25CY/P37+XxyYYglGuKqcKd/FA3TimieCVkArVwI2sdN6Ri6/GbPETSY1h
	 XGNKqfDcWI9BXgoOqAMYzLWs2gQnPcaRm5Z8Nech4Mj2IzZRJrIyMgwY/VFWmekYq3
	 25DyXicVG/dyqR4iEgN80voHuLp/sZn6fIbGpdoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0915/1257] ntfs: NULL vol->vol_ino in the load_system_files() error teardown
Date: Sat,  7 Nov 2026 08:53:31 -0500
Message-ID: <20261107135004.619275639@linuxfoundation.org>
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

[ Upstream commit a0c022c1da5b0fa30c61bd5b28db9f639ace5bf5 ]

The error unwind of load_system_files() drops vol->vol_ino on two
paths but leaves the stale pointer in place while it keeps iput()ing
the remaining system inodes ($Bitmap, $MFT bitmap, $MFTMirr; $MFT
itself is dropped by the caller, ntfs_fill_super()).  A third path
carried an iput() that can never execute: it sits inside the
IS_ERR(vol->vol_ino) branch guarded by !IS_ERR(vol->vol_ino), and is
removed along with the stale pointers.  Nothing in the teardown
dereferences vol_ino today, so this is pure hygiene, but a stale
pointer to a freed inode surviving the unwind is a trap for any
future code walking the volume during teardown.

ntfs_put_super() and the ntfs_fill_super() error path already NULL it
after their iput(); do the same here.

Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 49ec1eb1520c1..9f5cf65fd3a55 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1536,8 +1536,7 @@ static bool load_system_files(struct ntfs_volume *vol)
 	 */
 	vol->vol_ino = ntfs_iget(sb, FILE_Volume);
 	if (IS_ERR(vol->vol_ino)) {
-		if (!IS_ERR(vol->vol_ino))
-			iput(vol->vol_ino);
+		vol->vol_ino = NULL;
 volume_failed:
 		ntfs_error(sb, "Failed to load $Volume.");
 		goto iput_lcnbmp_err_out;
@@ -1546,6 +1545,7 @@ static bool load_system_files(struct ntfs_volume *vol)
 	if (IS_ERR(m)) {
 iput_volume_failed:
 		iput(vol->vol_ino);
+		vol->vol_ino = NULL;
 		goto volume_failed;
 	}
 
@@ -1706,6 +1706,8 @@ static bool load_system_files(struct ntfs_volume *vol)
 	if (vol->logfile_ino)
 		iput(vol->logfile_ino);
 	iput(vol->vol_ino);
+	/* Do not leave a stale pointer behind for the rest of the teardown. */
+	vol->vol_ino = NULL;
 iput_lcnbmp_err_out:
 	iput(vol->lcnbmp_ino);
 iput_attrdef_err_out:
-- 
2.53.0



