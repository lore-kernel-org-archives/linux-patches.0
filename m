Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048331;
	b=ehttSYKNzUdQf4sddQtq4bb3CxxUl6ZHeVimmB/2BBytSckij3NAxIBSX74lsKCXD/0v
	 s4+QU7l5rtMZT0or/PWaa82qogXeNL4ZTFhAVx6NXuFZDleBU7GiPSNR20G0Hh1y4ULi9
	 94Y2l5OtxKtNoduuXD3/V6uDoDyv99jxKmMj8eYNjFRh7ahPo3f1vtwbu+3MLi8JuPTA8
	 LoDsc2QLcWZ6KQ/i/yueTy+wBzMM4ZYu921ZYtYEDjq9gaDMNi00y9adDUMqmQ720Vh7A
	 4ubXABj09Izx+tIbTEY8hIZtXhzbckuPiDR/8GVAALE+Ll9Eev/7jPEfmG/uMMrT1XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1uOp2n6RCHWoetJ2JqfvQlpva8+kDB0ISiArlAC2h7Q=;
	b=oqExi2rkbpHg3dJGHga2oY/TARi6qJS7hCrNPSozdq3uvBxCU5RtEok7N9JUG/7j7Xx3
	 K4oPPLuN4bahHQ4j/3lkFVUA+R3zTLy5MshFAGbBvbWi7TBpM1r6zXjiZ7dogwy+/NMlm
	 YKRor9dyNmq0s5npEXvFk6/IOWTeWy2sSOZpnUiZEzAI4Mc9bwN6QOeujlFizVn92Gah7
	 IlPTrXysndO7EWJ1nYuVJDnJM3qAZZscPSSagjPPlth3BSKMyWbSvfjvTWoSP6SR5upBs
	 nLBZXfE6IgmdIzgrfvGyujhFLjYcLDjb4YyFKxr/DFgVLBZHO4v0hp5yYJx/hqExoTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8OcKCzQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8D5606A32A;
	Thu, 19 Nov 2026 00:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8OcKCzQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC0C1F000C4;
	Thu, 19 Nov 2026 00:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048330;
	bh=1uOp2n6RCHWoetJ2JqfvQlpva8+kDB0ISiArlAC2h7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8OcKCzQKKLc8jvnXLVDgSX11ibFGGBHVyxTDJl2+ydmpJ//1a7y5BYSg9LLf/kfS
	 lP7ornCDWUjeBttTSKghxrbH88seL+vtHnHOauqg6uH7+9JEPy///kQnZ/sT/mx0+j
	 EpGzO7pzamEddyhBCuyR0jMyhUPBL+01aTqxYDy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1957/2857] md/raid5: dont BUG() on an inconsistent reshape state from the superblock
Date: Wed, 18 Nov 2026 15:49:51 +0100
Message-ID: <20261118150311.873473244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index a9cb7cedd6053..b022df9fdca0d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7914,11 +7914,17 @@ static int raid5_run(struct mddev *mddev)
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



