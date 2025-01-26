Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179CD3E47B
	for <patches@lists.linux.dev>; Sun, 26 Jan 2025 07:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737875196; cv=none; b=JVGBHLt1e6RcFsyTxC633zSOhu9dVWMMTvOS/U/Hge0+4wrRGAf5B4cEKv3bJa6K4hozjJ+fq9ikIDIFqqgLblpvLuFPRItnGVzeYiI1jyNsuBe92tjAYJDNX2iMH5aSuL/b+c4GJkkSKxfF/IAyl1DzHwX7NQIlrOIE5ECmGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737875196; c=relaxed/simple;
	bh=DokAvFMYHvCS7wwzqg/QbP3GSVrjtUU72Ulg1mCoC+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dnb5ymcb6sjdedlZpnvB6Vem+wwTyIv6qaAvA39k071UdUTZc5XxAGSBLb0E8edJptiSzqFhp2ggnVERarv1xnzbFJAht5Udi2s09c1BmteRXUYxq9ESBWimfUHqP3CmBgl17HlCQZ1cPbBEVVvWAGU3UTJIXwyLA6uYjeuGArU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P6wRcAyz; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6wRcAyz"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2efe25558ddso4606690a91.2
        for <patches@lists.linux.dev>; Sat, 25 Jan 2025 23:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737875194; x=1738479994; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jp7vJlctohKjGrnhTeUGmb5s8Xd2NGxP7ChmuU+0czI=;
        b=P6wRcAyzNYgdbMpbCXKUqGc8NhP+YrjSY/ly96VD58URgU++zZDMN7JdhroFodUal6
         rHDdimPYS1quUiSm5FXUGiZOZDHjwPP43qgu9ogGgg2v3Qc2jtuJc0SBQG5hZ9nnR7dP
         GszlORJ8JhLgfRbbCQO3H3rpao6PAHWurrIfkUJeaG1WCjLB93Yduxg3BqAdpb+7+mGz
         yCKkMchc2LCizHQMeklIgI+/d0iptnekjTCzxyvpp5KZnDxdX82QjQmbUWRcvbY1UQ3q
         YuFB5ila228z/y+YOpzgRgsqHnUzBEfQdPeFqqkx5vepgb0+Jp/0aYIOgI/Ty7TK3Spf
         5GLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737875194; x=1738479994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jp7vJlctohKjGrnhTeUGmb5s8Xd2NGxP7ChmuU+0czI=;
        b=ehAPAmMKmuWgfa6nm7yeSO4Xl33mC63LkdRp1i1wa8hSWYHEWS70KgeJ8b3nzCcUMQ
         HlCKVBXoEfVIjQpsNEMSwtMIiXoCzANZHhCveFsO6BxgpCkOKQgd/XOynGCocq77ePLb
         H3DnstKhuUAbxokzkAhcSxZ8E9dTzyoQ64cRET6S45IJdq/OAdZ9LpzAV+FiPFRwlOHj
         fHEaQHqp55R0onM9hkDATXPwHPwmLvAqqDl+RwauZrEXq8XV0T6cSd0kEKh2uTIcjiqo
         6nT5IoHC3UXfMglsMarcva7JYVqWRFD4TYAS2XcxilwKiP9a8l2SF4BFq36NHuvsXiUB
         ds8g==
X-Forwarded-Encrypted: i=1; AJvYcCXuTMbpvy6GqQg4OO7AednoTRTjZAba8nxJXIH57BNXzMWJRPYCd7tV77wthiTngpgnpxX1pTgO@lists.linux.dev
X-Gm-Message-State: AOJu0YwCRuOXdhbGeouEGjfjUAJwtTM4q+MvdEbh5PqDFaU8E8+ZcD6g
	lCR5y71xzKRXeX5GkZ5DZndoLC3U4Kwq6k/hqFICN1v964spJgzB
X-Gm-Gg: ASbGncsD0ZvHCS30VvTNCRnP3WCZd93pPsKr4imI2XGnXJqJA+QKPx1pOYXYbd4OnhL
	ePNilOArjuaom23ZKbvJ68XrJO42pq1euC0OXO0cAj2NkpyQrTY0T+DTF5R/azU7054/o6p2Fob
	6F90a+eJMeflK4iGwZgL75RXc02xWz22q0fkHsMEtHjFyPGuH79f72EB3Eor9ulGImgoVVjZOOz
	ed9aTjaWeAu7T8fW1N+fcTeMjLvepX/teF3gf4e3GC/kCU6fPTRj5SvhYDWCMtoFQgXwv9hBRTh
	8YGvK5uopK3MXaV8PdLQUFn6YjUy
X-Google-Smtp-Source: AGHT+IGVUgql88xL7lvmloKC6GraKhyom+fznIVGV33PTFWKzYWPbpAU52q//gQzVZ77A8dSRI3eyw==
X-Received: by 2002:a17:90b:280e:b0:2ee:7c65:ae8e with SMTP id 98e67ed59e1d1-2f782c700c6mr52588232a91.11.1737875193857;
        Sat, 25 Jan 2025 23:06:33 -0800 (PST)
Received: from jren-d3.localdomain ([221.222.59.31])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa77043sm5209527a91.35.2025.01.25.23.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 23:06:32 -0800 (PST)
From: Imkanmod Khan <imkanmodkhan@gmail.com>
To: stable@vger.kernel.org
Cc: luis.henriques@linux.dev,
	tytso@mit.edu,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@kernel.org,
	Imkanmod Khan <imkanmodkhan@gmail.com>
Subject: [PATCH 6.1.y] ext4: fix access to uninitialised lock in fc replay path
Date: Sun, 26 Jan 2025 15:06:20 +0800
Message-ID: <20250126070620.8071-1-imkanmodkhan@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>

[ commit 23dfdb56581ad92a9967bcd720c8c23356af74c1 upstream ]

The following kernel trace can be triggered with fstest generic/629 when
executed against a filesystem with fast-commit feature enabled:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 866 Comm: mount Not tainted 6.10.0+ #11
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-3-gd478f380-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x66/0x90
 register_lock_class+0x759/0x7d0
 __lock_acquire+0x85/0x2630
 ? __find_get_block+0xb4/0x380
 lock_acquire+0xd1/0x2d0
 ? __ext4_journal_get_write_access+0xd5/0x160
 _raw_spin_lock+0x33/0x40
 ? __ext4_journal_get_write_access+0xd5/0x160
 __ext4_journal_get_write_access+0xd5/0x160
 ext4_reserve_inode_write+0x61/0xb0
 __ext4_mark_inode_dirty+0x79/0x270
 ? ext4_ext_replay_set_iblocks+0x2f8/0x450
 ext4_ext_replay_set_iblocks+0x330/0x450
 ext4_fc_replay+0x14c8/0x1540
 ? jread+0x88/0x2e0
 ? rcu_is_watching+0x11/0x40
 do_one_pass+0x447/0xd00
 jbd2_journal_recover+0x139/0x1b0
 jbd2_journal_load+0x96/0x390
 ext4_load_and_init_journal+0x253/0xd40
 ext4_fill_super+0x2cc6/0x3180
...

In the replay path there's an attempt to lock sbi->s_bdev_wb_lock in
function ext4_check_bdev_write_error().  Unfortunately, at this point this
spinlock has not been initialized yet.  Moving it's initialization to an
earlier point in __ext4_fill_super() fixes this splat.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Link: https://patch.msgid.link/20240718094356.7863-1-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Imkanmod Khan <imkanmodkhan@gmail.com>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b2591c07166..53f1deb049ec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5264,6 +5264,8 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
 
+	spin_lock_init(&sbi->s_bdev_wb_lock);
+
 	ext4_fast_commit_init(sb);
 
 	sb->s_root = NULL;
@@ -5514,7 +5516,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	 * Save the original bdev mapping's wb_err value which could be
 	 * used to detect the metadata async write error.
 	 */
-	spin_lock_init(&sbi->s_bdev_wb_lock);
 	errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
 				 &sbi->s_bdev_wb_err);
 	sb->s_bdev->bd_super = sb;
-- 
2.25.1

