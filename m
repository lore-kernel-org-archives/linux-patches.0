Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063207;
	b=YJneVuuyMQ0Dt13vft0k/FUUsXbrc6ts/6cLfgfdgDQie35Bm5czOks5i3JLqGcAYR7s
	 ihYvvemcJiV4P/2RGD/2badSAfC93J/xkCmd5f3LjaW3aTXfodiK1gZYJDrwd6t6iSvUb
	 f4FzRZ4oLlNE3M3RwLJHsm6FmOTbg2/3Ztyk5+9UnY8N+cVYcJcU6+CuU87D7fxkf4X0P
	 I+JoWnE5y87bI5IFIfGfmNToXPPGrOzWv/yFt3aOmKjX7GtEjki0ogdiOrxLzLpzwVXD2
	 DLyPgEkLZEbt3uI3G3W1yOPXTbsC78bvKtjoLHGxM8r9Tv5xvzG5LhkMFwc33d5Ia9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EpcfQhwn8aHveHhfd73+SqW7Yxom94zA5F8if++hW8o=;
	b=vtXdDKM/dOhqTTGxNe9Akc7IaOtjo2kdqBnMT0Byr0MQdU3b2Q4NY7bY3LwE2D5+iymf
	 E6gTy/OmPwQdSmU+S0cbMrrbWSdcsYqI5g0LNDtqSbtIkaFx+jZ1Z7UjtYulQVRXVjTh9
	 I1enldoF3Alqk3inoUKPPcB/3wa9LMTVwAZuXMyeIBeYrENbZZaelK/Ho5YfwwDDFeuWU
	 yfKYC31JNx/3rnx+tcxgxw4cEhgKHnRtlGsfdDVHKMy4y4N/aLjv2FOPusAYOykWfA/B9
	 8I2RIRoKdxMvKlTzgipLE54Yd6VlCtZkO8I+ewEfgMW///rfEE3yltR4lxeXVZVWiCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d/7ID7pu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6E5606D81B;
	Sat,  7 Nov 2026 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d/7ID7pu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF7A1F008A1;
	Sat,  7 Nov 2026 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063207;
	bh=EpcfQhwn8aHveHhfd73+SqW7Yxom94zA5F8if++hW8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/7ID7pu7/Q/my+W/MRavUduQe3oYNxwGmV3yIr0IaAWupWx/YWV/QLgTgUzvnNiQ
	 wm6NXzFA6FGmaliINtqD6mejnQbTco2jKFtaKK6EHzmh+Fg20Ct3aa2uqXiOYJBloh
	 KaqZl7DmmwSogTyU7WLA4oo/hDwCMVKqMRNoy8oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yu Junzhe <junzheyu1@gmail.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 419/869] jbd2: dont advance j_fc_off before the buffer is recorded
Date: Sat,  7 Nov 2026 08:51:41 -0500
Message-ID: <20261107134907.630043315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 9f359c031885bb50add7d23c7a5a0e9755b134c9 ]

jbd2_fc_get_buf() increments journal->j_fc_off before jbd2_journal_bmap()
and __getblk() have had a chance to fail.  When either does, the slot
j_fc_wbuf[fc_off] is never assigned, but j_fc_off already counts it.

ext4 then fails the fast commit and falls back, and the fallback path
reaches jbd2_fc_release_bufs() via ext4_fc_commit ->
jbd2_fc_end_commit_fallback -> __jbd2_fc_end_commit -> ext4_fc_cleanup.
That walks down from j_fc_off - 1 and put_bh()es every slot until it
sees NULL, so it also touches the slot that was never written.
j_fc_wbuf comes from a plain kmalloc() and is never zeroed, so a slot
used for the first time holds uninitialised heap data.

Advance j_fc_off only after the buffer head has been stored.  That
restores the invariant that j_fc_off covers exactly the filled slots,
which is what jbd2_fc_release_bufs() relies on: the live buffers of the
current fast commit sit above the NULLs the previous one released, so
stopping at the first NULL is correct.

Reproduced on a KASAN kernel with an ext4 fast_commit filesystem on a
loop device, truncating the backing file under the live mount so that
only the journal's fast-commit region falls past the end of the device.
__getblk() then fails for the first fast-commit block while the rest of
the journal is still addressable, so the journal is not aborted and the
fast commit reaches the fallback path.  j_fc_wbuf was poisoned to make
the read of the never-written slot visible:

  BUG: KASAN: wild-memory-access in jbd2_fc_release_bufs+0x6b/0xd0
  Write of size 4 at addr 5a5a5a5a5a5a5ab2 by task sync/961
   jbd2_fc_release_bufs+0x6b/0xd0
   ext4_fc_cleanup+0x97/0x830
   __jbd2_fc_end_commit+0x37/0xc0
   ext4_fc_commit+0x524/0x560
   ext4_sync_file+0x3c4/0x4b0
   __x64_sys_fsync+0x20/0x30

With this patch the same run leaves j_fc_off at 0 across repeated
__getblk() failures and completes cleanly.

Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
Cc: stable@kernel.org
Reported-by: Yu Junzhe <junzheyu1@gmail.com>
Closes: https://lore.kernel.org/linux-ext4/7e4b109d-64c3-444f-a5dc-93c2ca4576cc@gmail.com/
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index fa0fb738db0c4..1184dbad43e57 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -844,7 +844,6 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 
 	fc_off = journal->j_fc_off;
 	blocknr = journal->j_fc_first + fc_off;
-	journal->j_fc_off++;
 	ret = jbd2_journal_bmap(journal, blocknr, &pblock);
 	if (ret)
 		return ret;
@@ -854,6 +853,7 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 		return -ENOMEM;
 
 	journal->j_fc_wbuf[fc_off] = bh;
+	journal->j_fc_off++;
 
 	*bh_out = bh;
 
-- 
2.53.0



