Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051500;
	b=lI8UaqWu5assWoUd2eOqB4bPPu0XSh6gACP8qPXqU5vEn72+noXHZsNHbcynBWCAraDR
	 kGPE7lygyiJabLbun5NwR/9xD5PzAVC9ivDSLdP4RE7rvJFXrjX0LoxqnCdDV2huVWtL/
	 aXOSk1WULPaJpzKKjjYB7pY+rSXYb/XTNU2/bWlCMuaQqKFydvwBcoHsO1pGRj1FLP+eQ
	 yfl1SC692zjKoKMHsdPRBoFOvdpgFz9I0nKZ75JWXoGJr3aZTBq5CweezMTGyEYZJP90h
	 yED9vyGrIaN/X5BnDmpshBzPJgicYzsDesNovXGBJWpIdGi28zKYCYD6HRoLs9AA2RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oF9ZYdjHtgr/v6SCrGjx+Kwviu8pm5NR3ptvzklxBWQ=;
	b=cGeJ6l39VwFH/J9MgbDLDOthmIoC4JWY83SZsiVN08RQJ51sqiL0Dc3qYp3l26KbiZJL
	 6irUMXZ3L4LOXwM9M2azZEb+icVojtBKvQSwv7eokDsPe546Hf5WiIg4lqwylryX5tzuj
	 EISFdC0rB8IvJZq6nev+vZH5RpxAWw1u6lcWRuVFc9pJf/8iZYgatDUlxPjPhPXopSEVy
	 37A3rAD4V/xdfEWbJI7ZfbhihETGM/VNDV35PD0sXbIASI30JV/iFZhg5zOaekS6FyV/i
	 UeyBsO0dNu3uSGauldixe/9OQvUDRwbgWXKqZv7xvq5wFnW4neGx5X+HagqE8wBm/DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eYVV/uT2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4660B606A325;
	Thu, 19 Nov 2026 01:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYVV/uT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2571F000C4;
	Thu, 19 Nov 2026 01:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051500;
	bh=oF9ZYdjHtgr/v6SCrGjx+Kwviu8pm5NR3ptvzklxBWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYVV/uT2GB/UuqfsbFkQ0DFEWfvnxxSRNKQ9Mwv/GfjgOj/YHLqcPA04F0HKnp/6P
	 dDZFTUzVEVUk6LBXtg1h1YlWs4psDVEGWhvg5DQPvhTVBJkFUVDGQX/O7t9z13G4S4
	 Y0lvCKP3+bBepE+QUgIM2LsxFSWozZXFaMWBbC/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0230/2214] f2fs: avoid setting SBI_NEED_FSCK on transient resize failure
Date: Wed, 18 Nov 2026 15:31:46 +0100
Message-ID: <20261118150019.434519530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 258c95150c26a30db1896eacd3bdef26314f2ca1 ]

When free_segment_range() fails in f2fs_resize_fs(), no on-disk
superblock or filesystem metadata has been modified yet, and
free_segment_range() safely restores all in-memory counters before
returning.

However, the current error recovery path unconditionally sets the
SBI_NEED_FSCK flag and prints a scary error message on any error,
forcing an unnecessary and time-consuming fsck.f2fs repair on the
subsequent mount/reboot.

Fix this by separating the error recovery path with a dedicated
recover_user_blocks label to bypass setting SBI_NEED_FSCK on
free_segment_range() failures.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 663835527298f..2401ad9a24e43 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2092,7 +2092,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
-		goto recover_out;
+		goto recover_user_blocks;
 
 	update_sb_metadata(sbi, -secs);
 
@@ -2113,11 +2113,14 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 		f2fs_commit_super(sbi, false);
 	}
 recover_out:
-	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	if (err) {
+		f2fs_bug_on(sbi, err == -EAGAIN);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_err(sbi, "resize_fs failed, should run fsck to repair!");
-
+	}
+recover_user_blocks:
+	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
+	if (err) {
 		spin_lock(&sbi->stat_lock);
 		sbi->user_block_count += shrunk_blocks;
 		spin_unlock(&sbi->stat_lock);
-- 
2.53.0



