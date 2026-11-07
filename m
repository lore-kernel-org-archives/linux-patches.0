Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065172;
	b=1FWNkjVA6ryavK4a5Rb7A4/hKp43NaU0FF76l2ysgZvtocJVek0V6dD/Kqa/Ftr9kAij
	 BM86t4DIIv6relKJE499GficJbqYNn1SVBA9eC14HGxDLI28g93UYS1VRYSb2u+Gb/9FJ
	 LEZLHrQDHGjvA218oRgXJPeojTZL8x1akE6TUPqpW4Rw9yce3b4m1A7MV1zIwVf5UU0DA
	 2x1t+TZAEE5q1M6HiUr/DsJaHShs6bWAYz+TRrOpCEEi6xyKb6hnhMy6QTvCo9qK5oyi8
	 pR28iixWVZ2MT5UWqiWbe/64kfxGwP/acBTdwrHVTcHHYIGl8kwhB8DP91XywbXztXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ACJ922UkjREpM4VTypxbT53Nw0HVC8PQDz6OH9ER7UY=;
	b=hCTk4l6IzLmOKMoguO4C4F8mF3M4rMa8TauCfnlSM6htb2Fdcak2N+uFPDspC4e34Nzl
	 q7Hs5vH97ziiFyGTa+0Wk9QVpEzKKL8+BSev9GIkXOjcTjIL8gcRMZEBpM7/H5TeBSfac
	 IjrL4kQwR8UIMUcX2deNwYXKGe/7TUP/0CCFNHnuMNLqJNs6CG/EhcP1I/A1/wzBo6J4t
	 cUkzfALLmCNI45bZbqSBTk+pM7DRFzPPZl751zA7X/0ZxdIVRQgPf4l5gEJkDjzpo47ZV
	 VMNFnN2JEr1VnFL8gYJlKhs1R33tGqq2EOkCf2uLRCwdKZVYVxXkqrRH6MuYTGmAuBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwpFSXUC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA7B606A32E;
	Sat,  7 Nov 2026 15:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwpFSXUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D958A1F0089F;
	Sat,  7 Nov 2026 15:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065172;
	bh=ACJ922UkjREpM4VTypxbT53Nw0HVC8PQDz6OH9ER7UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwpFSXUCqkkc/i0fGjAd0v5TGHry6auNPt5MJKCVsKFYvvqM1GGmYdm9rSC7Knzkf
	 aCDR2XzWI9DpH1XnIUHAwWg2ZMSYmTBMbq8du24mhnqEA5fZjGaJEX/13kYUeWf2NO
	 scwgLa+uz7XY1zkkUeesOWvTQABepxMt9pP6sF2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0926/1257] ntfs: mount hibernated volumes read-only regardless of errors=
Date: Sat,  7 Nov 2026 08:53:42 -0500
Message-ID: <20261107135004.930664898@linuxfoundation.org>
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

[ Upstream commit 749357bd48c16c4cdc09093450deca609492f012 ]

The hibernation check in load_system_files() only converts the
superblock to read-only under errors=remount-ro.  With the default
errors=continue (and with errors=panic), a hibernated volume is
mounted read-write and the mount-time $LogFile emptying writes to it,
although a hibernated volume must not be written to at all.

Drop the on_errors term so that a hibernated volume, or a volume whose
hibernation state cannot be determined, always mounts read-only.
NVolErrors() is still recorded, so ntfs_reconfigure() keeps refusing
remounts to read-write, and the $LogFile emptying is skipped by its
!sb_rdonly() check.

The check itself must not apply the errors= policy either: it runs
before SB_RDONLY is set, and ntfs_lookup_inode_by_name() and ntfs_iget()
call ntfs_error() internally on corruption or I/O errors, which under
errors=panic would panic the machine before the read-only fallback has
made its decision.  Temporarily substitute errors=remount-ro for
errors=panic around the check: nested ntfs_error() calls then fall
back to read-only, and any read-only transition they trigger is
preserved even when the error is not propagated to the check's return
value or recorded in NVolErrors().  This is safe during initial mount,
before the super block is published.

If the check reports hibernation or fails, set SB_RDONLY and record
NVolErrors() unconditionally: hibernation safety takes precedence over
the errors= policy.  A volume with errors recorded during the check or
earlier in the mount, e.g. when loading the LogFile, also stays
read-only, matching what ntfs_reconfigure() enforces for remounts.

Fixes: 6251f0b0de7d ("ntfs: update super block operations")
Cc: stable@vger.kernel.org
Suggested-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/super.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index c6f820707ef21..6d70352136b0c 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1577,6 +1577,7 @@ static bool load_system_files(struct ntfs_volume *vol)
 	struct ntfs_attr_search_ctx *ctx;
 	struct restart_page_header *rp;
 	int err;
+	u8 saved_on_errors;
 
 	ntfs_debug("Entering.");
 	/* Get mft mirror inode compare the contents of $MFT and $MFTMirr. */
@@ -1751,8 +1752,19 @@ static bool load_system_files(struct ntfs_volume *vol)
 	 * NVolErrors() without setting the dirty volume flag and mount
 	 * read-only.  This will prevent read-write remounting and it will also
 	 * prevent all writes.
+	 *
+	 * Nested lookup and inode-loading errors must not panic before the
+	 * read-only fallback has run.  Temporarily use errors=remount-ro
+	 * instead of errors=panic, preserving any read-only transition even
+	 * if an error is not propagated to the check's return value or
+	 * recorded in NVolErrors().  This is safe during initial mount,
+	 * before the super block is published.
 	 */
+	saved_on_errors = vol->on_errors;
+	if (saved_on_errors == ON_ERRORS_PANIC)
+		vol->on_errors = ON_ERRORS_REMOUNT_RO;
 	err = check_windows_hibernation_status(vol);
+	vol->on_errors = saved_on_errors;
 	if (unlikely(err)) {
 		static const char *es1a = "Failed to determine if Windows is hibernated";
 		static const char *es1b = "Windows is hibernated";
@@ -1760,17 +1772,21 @@ static bool load_system_files(struct ntfs_volume *vol)
 		const char *es1;
 
 		es1 = err < 0 ? es1a : es1b;
-		/* If a read-write mount, convert it to a read-only mount. */
-		if (!sb_rdonly(sb) && vol->on_errors == ON_ERRORS_REMOUNT_RO) {
-			sb->s_flags |= SB_RDONLY;
-			ntfs_error(sb, "%s.  Mounting read-only%s", es1, es2);
-		}
+		/* Hibernation safety takes precedence over the errors= policy. */
+		sb->s_flags |= SB_RDONLY;
 		NVolSetErrors(vol);
+		ntfs_error(sb, "%s.  Mounting read-only%s", es1, es2);
+
 		/*
 		 * Remember it for the lifetime of the mount: see
 		 * ntfs_sync_volume_dirty_state().
 		 */
 		NVolSetHibernated(vol);
+	} else if (!sb_rdonly(sb) && NVolErrors(vol)) {
+		/* Match the read-write remount restriction for recorded errors. */
+		sb->s_flags |= SB_RDONLY;
+		ntfs_error(sb,
+		    "Errors were recorded during mount.  Mounting read-only.  Run chkdsk.");
 	}
 
 	/* If (still) a read-write mount, empty the logfile. */
-- 
2.53.0



