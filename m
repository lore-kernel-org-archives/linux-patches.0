Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214009;
	b=gl2sy9J+lazfpRSkSGp46oxD61Cly+vSGY29wfo2VfD91c833OWPAcohgcsFdekyGTP+
	 HGWeVmJdRYygkI8No6GuFCggYiGnFTEOJAB5TyTaBsUpagwbMi9DngusxSLT+A/aQLM2o
	 u7L+RGI/wE6mTmyDnI3rWoEeK9DB0mehdologttovZvQi/Knq9rMMLGOKgGnKcag3sZMw
	 bV9r4SEz1OI1LLsWbtry8f6Tv0OCvzkKCEct1F3GLlqTGDpljGVgUWLDD8JuVeoOW6vU0
	 k82njamMu4z0fiPS3eCbQhNBTitsDOjtw2nqiBMgHZ+ENYmU0C8UhIDESGmYxPDkfgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oV9vkqMNl4MXejlHw4Flw6rz6O+7sxbdCZ1NhihJV8E=;
	b=1syjoZxaUAAsgW6dfGxJ5piiL+9cm6RCc7q5dxYXB5RNAxRTKUEsGOWzmx94XiKoI8kQ
	 WiCaDakL1aWiuv0gLfbLZPIYCPd5NqKk1wm+Kv2Y1GqVlOdAD3iN5DAW/6EgUzX81okVn
	 23C3z6Cjlw6sTehhZKhbQ7IOdyM8BC4eby2v8g5K10ltj/VttGStbiYAEDR0Fl/83P68U
	 bP5ZQrDKp7lRWTf+A0IReExv4Jcw8n+o7T0a+SO9lSkkzxxBXQEvk/iOKaztrqmyFT2LA
	 +6rrtunv3V0Wicvhegg3XuCeQHfSFG8sl3mmcKGfBV9d8T7ZfYFYKsYYpeAYBwsBpbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkK8swGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EC160A263B;
	Wed, 28 Oct 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkK8swGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DF71F031E4;
	Wed, 28 Oct 2026 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214008;
	bh=oV9vkqMNl4MXejlHw4Flw6rz6O+7sxbdCZ1NhihJV8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkK8swGOI/s1VgUifCdUFdSA9KA3KMAzgmdr3aZWO8Z3eLjtFs04nZjWycWNEZL0d
	 8J70CMhHnGdzrNl3EWG2aSj+AiSMElIX+iO4NWs5EwsUcEICi0Uv418hjw0SVGEKhH
	 mrnKwoJXCvZFBNsmfy3wD1JPzB8YsqEoDeQ+Llcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0706/1887] f2fs: fix to drop all discards after creating snapshot on lvm device
Date: Wed, 28 Oct 2026 17:46:42 +0100
Message-ID: <20261028170515.476885430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit bc8aeb04fd80cb8cfae3058445c84410fd0beb5e ]

Piergiorgio reported a bug in bugzilla as below:

------------[ cut here ]------------
WARNING: CPU: 2 PID: 969 at fs/f2fs/segment.c:1330
RIP: 0010:__submit_discard_cmd+0x27d/0x400 [f2fs]
Call Trace:
 __issue_discard_cmd+0x1ca/0x350 [f2fs]
 issue_discard_thread+0x191/0x480 [f2fs]
 kthread+0xcf/0x100
 ret_from_fork+0x31/0x50
 ret_from_fork_asm+0x1a/0x30

w/ below testcase, it can reproduce this bug quickly:
- pvcreate /dev/vdb
- vgcreate myvg1 /dev/vdb
- lvcreate -L 1024m -n mylv1 myvg1
- mount /dev/myvg1/mylv1 /mnt/f2fs
- dd if=/dev/zero of=/mnt/f2fs/file bs=1M count=20
- sync
- rm /mnt/f2fs/file
- sync
- lvcreate -L 1024m -s -n mylv1-snapshot /dev/myvg1/mylv1
- umount /mnt/f2fs

The root cause is: it will update discard_max_bytes of mounted lvm
device to zero after creating snapshot on this lvm device, then,
__submit_discard_cmd() will pass parameter @nr_sects w/ zero value
to __blkdev_issue_discard(), it returns a NULL bio pointer, result
in panic.

This patch changes as below for fixing:
1. Let's drop all remained discards in f2fs_unfreeze() if snapshot
of lvm device is created.
2. Checking discard_max_bytes before submitting discard during
__submit_discard_cmd().

Cc: stable@vger.kernel.org
Fixes: 35ec7d574884 ("f2fs: split discard command in prior to block layer")
Reported-by: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219484
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c |  9 +++++++++
 fs/f2fs/super.c   | 12 ++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 4b13e04c6e608..bf52ba8a32c04 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1125,6 +1125,15 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK))
 		return 0;
 
+	/*
+	 * stop issuing discard for any of below cases:
+	 * 1. device is conventional zone, but it doesn't support discard.
+	 * 2. device is regulare device, after snapshot it doesn't support
+	 * discard.
+	 */
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
+
 	trace_f2fs_issue_discard(bdev, dc->start, dc->len);
 
 	lstart = dc->lstart;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 375daa37b3795..a1c33931d175e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1742,6 +1742,18 @@ static int f2fs_freeze(struct super_block *sb)
 
 static int f2fs_unfreeze(struct super_block *sb)
 {
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+
+	/*
+	 * It will update discard_max_bytes of mounted lvm device to zero
+	 * after creating snapshot on this lvm device, let's drop all
+	 * remained discards.
+	 * We don't need to disable real-time discard because discard_max_bytes
+	 * will recover after removal of snapshot.
+	 */
+	if (test_opt(sbi, DISCARD) && !f2fs_hw_support_discard(sbi))
+		f2fs_issue_discard_timeout(sbi, false);
+
 	clear_sbi_flag(F2FS_SB(sb), SBI_IS_FREEZING);
 	return 0;
 }
-- 
2.53.0



