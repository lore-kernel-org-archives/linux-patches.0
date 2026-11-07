Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061047;
	b=5Lsga1EKijQb+83eZRzz+jOndRTFbidv7AukSTl7q4NmHqHdsNR3jrF5S/mTT/SA7pnb
	 kjjhFJplfsq5opxKBI5AP9AJGjPXw9fX1EbRT1c/jI8hTfRpDsmhCF5rq4oDmRO2Qgzdm
	 3/3p9STLId8ROvSDW2hPDKAHBC8wPTsRb3W9xTVIiHbzmJr1j8841Vs0mZrwZMdNNXSgo
	 qUQfHsvco71+5gFjwy93BbWLh5MJNWJg1j1jUhR73pmgFRLS5pfrzNCRME6PvkSBIA4Rn
	 DHPA/1fsl2k2/RF2tTLFvwJnPXFXJodLJ1BjWqat8Yq22BhZICElKWp4gd2DwreFozA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwzMPOZNX/mBAfROMZpMYh+qaffaPn3TUL6CU6//WIA=;
	b=RQbomFodMhDu3KyaF0Z3cIWcgHIIxm1h3Dvfiyn39+ZOR35AMsE0Jg8au4J5JwDkZJlk
	 PGu9LxAtbGcUmOKAAFq9+wfLG2vCXINff7r9yRAPptHBnk0zfyYPGDG/EjBk7iX2A6xlh
	 umdyZMY9KZV5dSTR0fajm9A37wiaD6ldon/djHU9JsZuJQK5UdgF0nhyz3fZBIjeJn46W
	 WjQme1PgUZ7gwqTNIqpia3X79DN5FqtuAEaxFKSE8SCV2S9+FL05UfczpBKhMEUQ+C5yr
	 elzZUw1VjiLGzr/45TehRiXSwrVaAi40pzo9OPp7fDcZ7oei9d2UlReujHqqPMmX5EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZy1wqOy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977EE606A339;
	Sat,  7 Nov 2026 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZy1wqOy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D55E1F0089F;
	Sat,  7 Nov 2026 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061047;
	bh=MwzMPOZNX/mBAfROMZpMYh+qaffaPn3TUL6CU6//WIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZy1wqOyqxnblH6CRPFYeNYtNvKnLjUWK2FfxAv+Kb8yi7QTADpQqXpnEoit2Ud7Q
	 4QzI41WH1VW1r0BQjkWdG/7Unpe97DLG8K+50iMxl9EbpIf2ywUGl36ZUKomseFmQ1
	 uyN+RYwS+iEIFZT0SXZ2/Pv0rwwdqlF23Gf9HPNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0380/1536] f2fs: avoid setting SBI_NEED_FSCK on transient resize failure
Date: Sat,  7 Nov 2026 08:39:56 -0500
Message-ID: <20261107135008.296800429@linuxfoundation.org>
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
index 6924876f1c2f5..bd8e0aaff102a 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2392,7 +2392,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	set_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	err = free_segment_range(sbi, secs, false);
 	if (err)
-		goto recover_out;
+		goto recover_user_blocks;
 
 	update_sb_metadata(sbi, -secs);
 
@@ -2414,11 +2414,14 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
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



