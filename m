Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055121;
	b=SUxDFOrWynvNy6pOWd7me30AiH8WpoBSHY6qPg7g/VL3RmP+ntd8PGTCLkVLNCOICOPb
	 Rm7nIoAz3y4eXOv/KBxvNgHO4vN8jCIrMzl2RqGOsfr2X1ayUE7v6NHQnB1fuVq3TD2Em
	 Rbk91SOgLliWd9CekHyk6GT1hKF0q1HrvqyO6H50BEF1PV7nri4WwtQ/WSeA9Ofn8cSL0
	 9seykvPgP20Y5ULsxNmCKiMM+HHF33fR2gg5SH5bRWk6hMCa1mwNzeXsqr2eJasz0E0Yx
	 +NGAe95QLbbQt9S0N3RvKb/sl2REk9dq/WeuK2Q5/wsWfgbnIVFRqRUxndngoVObNtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kXawK0FNUwEweacx+3toRU5xUz8Zc+GsGHutcinNgRs=;
	b=ti9LGH59mZ/dZ52iAlTD77BDHZHkCuky46Z41Hazv18tHNVi6ZRm0yWX43ISrNLvNNy4
	 V8eZGsOcxnP+kMPoKC8zeUXRIqIfg3nV4zmR5NHlkpb1DzAHucp7ulZGTlBs52Qtbonni
	 SWKl5v23mDyyRQyo/AoP1cMCVzDYwU2J3Q2Gai+kMOZn0Iuf+XeEV9EsMaOytjbyrPx1A
	 PS6uzYO9nOvytAHkfN0uIpuadZ7jULppY3eaOpd1ZcBdHKNu3aAcxIIbHtEvbrfgJP7cV
	 jGnTNdBV/6z1dJ+KgKBXsm0gtc1NxNr2dw8FrzPfuA26J57tAQjo/krPq6u+0vfSpHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcIB67s8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3B7606A325;
	Thu, 19 Nov 2026 02:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcIB67s8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAC31F000C4;
	Thu, 19 Nov 2026 02:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055121;
	bh=kXawK0FNUwEweacx+3toRU5xUz8Zc+GsGHutcinNgRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcIB67s8Yn5cnoK9fUo97SKuPrgmJtUYsZ6DIWIkjjzleckw/4I4cFUHzhzkG2Iow
	 tNaTtA5wNIQL2RSc1LPUl92JBpbjZvhdFdwV61Enxy46XQN8E4QCZRf8q566UqOzVV
	 zW4yu3zVFyWhvRkwQaQP3jW4WjXCe8uO2cmv25Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1519/2214] md/raid5: dont BUG() on an inconsistent reshape state from the superblock
Date: Wed, 18 Nov 2026 15:53:15 +0100
Message-ID: <20261118150112.853561650@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 0669c7dbd1d375f279e607a24addc2f1dae2d4f3 ]

raid5_run() branches on mddev->reshape_position. When it is MaxSector --
no reshape in progress -- the else branch asserts that nothing else
describes one:

	BUG_ON(mddev->level != mddev->new_level);
	BUG_ON(mddev->layout != mddev->new_layout);
	BUG_ON(mddev->chunk_sectors != mddev->new_chunk_sectors);
	BUG_ON(mddev->delta_disks != 0);

Nothing enforces that invariant. Both superblock validators copy the
reshape fields straight off disk without cross-checking them against
each other: super_1_validate() takes reshape_position, delta_disks,
new_level, new_layout and new_chunk from the superblock whenever
MD_FEATURE_RESHAPE_ACTIVE is set, and super_90_validate() does the same
for minor version 91. A superblock that sets the reshape feature while
leaving reshape_position at the MaxSector sentinel therefore reaches the
else branch with a non-zero delta_disks, and assembling the array takes
the machine down:

  kernel BUG at drivers/md/raid5.c:8117!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
  Call Trace:
   md_run+0xc2f/0x2510 drivers/md/md.c:6779
   do_md_run+0x36/0x660 drivers/md/md.c:6880
   array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765
   md_attr_store+0x1c5/0x330 drivers/md/md.c:6158
   sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
   kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345

This is reachable by anyone who can present an md superblock, so BUG()
is the wrong response. Refuse to start the array instead, the way the
reshape_position != MaxSector branch a few lines above already refuses a
reshape it cannot resume. Nothing has been allocated at this point --
the journal-and-bitmap check just above returns -EINVAL the same way --
so there is nothing to unwind.

Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
Fixes: 91adb56473fe ("md/raid5: refactor raid5 "run"")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260910131103.988-1-yogeshgaur.83@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 943bbe0526542..0017e530745e7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7593,11 +7593,17 @@ static int raid5_run(struct mddev *mddev)
 		}
 		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));
 		/* OK, we should be able to continue; */
-	} else {
-		BUG_ON(mddev->level != mddev->new_level);
-		BUG_ON(mddev->layout != mddev->new_layout);
-		BUG_ON(mddev->chunk_sectors != mddev->new_chunk_sectors);
-		BUG_ON(mddev->delta_disks != 0);
+	} else if (mddev->level != mddev->new_level ||
+		   mddev->layout != mddev->new_layout ||
+		   mddev->chunk_sectors != mddev->new_chunk_sectors ||
+		   mddev->delta_disks != 0) {
+		/* No reshape is in progress, but the array describes one.
+		 * The superblock validators do not cross-check these against
+		 * reshape_position, so this is reachable from disk.
+		 */
+		pr_warn("md/raid:%s: inconsistent reshape state - aborting.\n",
+			mdname(mddev));
+		return -EINVAL;
 	}
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) &&
-- 
2.53.0



