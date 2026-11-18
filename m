Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053148;
	b=VoewYYQzcjJW/ClSnG62QMtTl+I6E9VczgtccHKjGwxQdRMQdg3SCQulotlDy7qoUDFQ
	 1/XGIvFwcRu3rEj0sz5sKkvilKNAYlt8WtH16kA9qglMKQ2C59HF9VPlATTR9jG743B1W
	 vRu1WARgmtEu813xjc5jGAi9LM1T/aSuCu5Ai1fRlhZGB/CcMda6hKVIr1MEtnbgmycKu
	 fEm2b8+kTO8ZQRLaL0X+AWhXcwdQUdZyhNuGpTIlofK9pXHeLMw7CcQvsI7SZrl5snwV0
	 lLZnfNE++hrdobqtoknjpvWN8AWkjOvqCwllc2aSmFZIV+PuyBRj314FA/A+0QlxA9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NGceKg5XzOwxQ5eVb3HjHUX0s0RQR/hp4NhSDwvIye8=;
	b=seNer6ASwMwGCGLWERa0UAVQNxKCSYqUOd78yOKWlKWgnw8ZKtXJWXlLugHwbzhr8O1L
	 CPPmQi4vIWzPnlIZsGWI+LFqgDmJaUX0Q2QkS54ClLBEVJpThJDld3e7EbUhZUCa/P3Ua
	 GmaQm8aaMeXKve+Okfa7lEOG4mIU6QD4Y+eVfVQQUaqe6ImVZeLCZgGL0bj295aZEGgkE
	 xMwbAhaBRCzysZB1uqXdb8UJ/+X6bhInhvAU2DVbbzBwUZGProfdRu0CpoPCyZ6VWGZM1
	 6wDPwPCLyQYGTD9UGfQYQ8LMO20DbyLEqKLTqwksagW1QPA3yI4ex3O5oI+uZTb94nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gr466TGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A52C606A31C;
	Thu, 19 Nov 2026 01:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gr466TGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1151F000C5;
	Thu, 19 Nov 2026 01:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053148;
	bh=NGceKg5XzOwxQ5eVb3HjHUX0s0RQR/hp4NhSDwvIye8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gr466TGMvwH4Jm+UAfEAq9ORD55g0zQ6eFs93DcU8zE/N/xCxLL6Bfc9t6XawMjWP
	 UFhrspUaCIISurwrxwkgdgrIHOhV8FRNz9YKq7c12SXFR5SaRL2Q25YzJNs3jeIsFH
	 YwzOyKv/trHBkARAHtHV2BM0khCw0mq5UFf79u8M=
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
Subject: [PATCH 5.15 0815/2214] jbd2: dont advance j_fc_off before the buffer is recorded
Date: Wed, 18 Nov 2026 15:41:31 +0100
Message-ID: <20261118150044.168054946@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

commit 9f359c031885bb50add7d23c7a5a0e9755b134c9 upstream.

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

[ Context: in 5.15.y, jbd2_fc_get_buf() still advances j_fc_off inside
  the if/else bounds check, so the increment is removed from there.
  The change is otherwise the same as upstream. ]

Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
Cc: stable@kernel.org
Reported-by: Yu Junzhe <junzheyu1@gmail.com>
Closes: https://lore.kernel.org/linux-ext4/7e4b109d-64c3-444f-a5dc-93c2ca4576cc@gmail.com/
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 96fc25907c42f..449b4a1286a0b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -884,7 +884,6 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 	if (journal->j_fc_off + journal->j_fc_first < journal->j_fc_last) {
 		fc_off = journal->j_fc_off;
 		blocknr = journal->j_fc_first + fc_off;
-		journal->j_fc_off++;
 	} else {
 		ret = -EINVAL;
 	}
@@ -902,6 +901,7 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 
 
 	journal->j_fc_wbuf[fc_off] = bh;
+	journal->j_fc_off++;
 
 	*bh_out = bh;
 
-- 
2.53.0



