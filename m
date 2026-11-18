Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029677;
	b=xNUZbiGySHuun7kvI/5VDG1s7hzZGWJ1zfNZdNyJafBXDIsyt5FKCsDII3gQ8eflPSFk
	 tIJO1VMVfs1SoiHtRq7w0Ws/VV6apFC3YG/oTkbWbdHnxhuBdN7Fx3eiPzhsBgO3wQ55N
	 FTJ+fmU8hzkt8BohV1g9h5rXvN28+llSt7TnM4Ptg87R7xGMpmDYmow/I+7HYhC6gnqpd
	 LrWWX+Y/uJZfc1/eTHYhwi9q20OkX+zUMXuvYJBYhbX/uJ8B7g+t6WOt5Da/TDOf87S30
	 9XStvKM19LJOoPoNEIw+v4MduTwJOH/20X2icyMVzTZTH7MP3c/Ugy8bfirqwlEtbLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pu7auj7ewLMeCei28TLXSW7cFKtY89A9SsDGz9V+TfY=;
	b=U7DlRpGLMnBNNWNzgpPzr5gZ9no2owjgkVdccBf0xod2xap5DI4HnSXOJA6M2Kzq5o1C
	 37i8acCKJ7n9QEIHdyx+wHemdVDVZ5SR0FAprg7brtOrlcQN4DwPCFN4ow2LNDRpiLXuy
	 cWpUCRwj1YB4q/9e2abLvVQzjU9BJxovFLfgp9keKmLeRVeNmnp9F0b7DWoCa7yWp4/Ny
	 lElwGoCXg3FNg/4VyF30MIWDgif3/FjK+nqj6qZYIpIyP+do5FJycWkeLkami0Gwyv/OH
	 8yirP/eZcVQvvOLheIsFVFdI3m5qBsq2pZ/+ODFA3aM33yj0r9ZC9LNhqEvfvxY5+Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GYJ0UZ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCD7606A32F;
	Wed, 18 Nov 2026 19:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GYJ0UZ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9440F1F000C4;
	Wed, 18 Nov 2026 19:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029677;
	bh=pu7auj7ewLMeCei28TLXSW7cFKtY89A9SsDGz9V+TfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GYJ0UZ6yJQa2YDr6b46aARFYhuQNGaUzqyj4laz7oYuA/dQfPktYjvp8Y1PnjCvm
	 mGlOL0h/ZnBEQ3sZfy8ZJklnX1UiNP2Ay3hJg5yT1qfoG7cnPQ4qxplgoqkOyUjmQ/
	 w+iBBaOY6lnOhhL63k62ipw/vxN3XbaJQhi3f/i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0436/1756] md/raid5: dont BUG() on an inconsistent reshape state from the superblock
Date: Wed, 18 Nov 2026 15:42:43 +0100
Message-ID: <20261118150026.101202800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 605e89f95c36c..399ed941ed9c2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7959,11 +7959,17 @@ static int raid5_run(struct mddev *mddev)
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



