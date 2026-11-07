Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062250;
	b=L85qtAgROh0PKvzYv2jl7hcuXD29fgTg9eI2ZWVDepwLdlb6ItbxqNjr8zIKiC6C8Sob
	 PV7aneAoL/6hDVphe1pNfH9yY8UsHFyit3Hdxg/Dyqtvum51CavypiPDDhZfiANVOZ5wH
	 fAy/w20xXn5UI0WCRgV2BuECufXBw67nORqi2fYpShM+IfiwWM/LEHE8H2HYVw1Vi2K9L
	 An7VU+tacNR5d1IDc7IWYAQJmqWokQPyLbMwl7T5zGcg+79YKEZ73nzZpaGt1d3XTFjAZ
	 wGp7EUvhSsCKgD7pAMHcjev97jPBqKBkyqnHBZWfzlhX/yv3BlPBkXBAw8+2ubuJQdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hRMyeU7uTvQWQ2ma2bcLJVFo3cpn+XeEPVe1KU8KP+w=;
	b=p2T/7dLIsnWvkMn8OWokPpM6Of6PL5hdYmmyZ6M/v04mpcz8EuKX9TIKeq5BFNcgXm+8
	 88ExwIF45SKKYCmdgcWwSt6Wq4E4PlCwWRIJjeFSlfEvkFq/Gm0035DuW43gKgcbW7XZz
	 6IfqUbLPgdVOgYxDaEq3aBgErHGTg3gM5HH2ItruCYpGwFYgcU/PFrplSYA5UxgACscAS
	 nOaelgdptM9Z9pPuq6svHq44zm3reWytDTFaN6vuQiB4HQb3nYOc3OerMkHzTKLEAw7Qe
	 5m04XVO6BeT/xI5hEyZNqmAf03v/FZgaIu0jZR8Sdcxt1y9e6MZtskzZ5m1XV8iW4+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fv88KaRg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6083A606D83E;
	Sat,  7 Nov 2026 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fv88KaRg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97631F0089F;
	Sat,  7 Nov 2026 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062250;
	bh=hRMyeU7uTvQWQ2ma2bcLJVFo3cpn+XeEPVe1KU8KP+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fv88KaRg/TFP8M6N2ytyrzf3f2xgi/1O8GohGYpiT6m5FK3ucbuLui9Fdu5v1tkyt
	 +VwfqiLv1ODJMLseG1PwMzdzk6r9YbOdH91GvIBLl6WI5fdih3qDBEVWKisIYYMXTL
	 rFwydInv4Gh1RS3KyjQL/VDmsWBJ4er0Wsu4OKEQ=
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
Subject: [PATCH 6.12 1193/1536] jbd2: dont advance j_fc_off before the buffer is recorded
Date: Sat,  7 Nov 2026 08:53:29 -0500
Message-ID: <20261107135031.254585052@linuxfoundation.org>
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
index c7b042c67a75d..67dc1903d53dc 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -842,7 +842,6 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 
 	fc_off = journal->j_fc_off;
 	blocknr = journal->j_fc_first + fc_off;
-	journal->j_fc_off++;
 	ret = jbd2_journal_bmap(journal, blocknr, &pblock);
 	if (ret)
 		return ret;
@@ -852,6 +851,7 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 		return -ENOMEM;
 
 	journal->j_fc_wbuf[fc_off] = bh;
+	journal->j_fc_off++;
 
 	*bh_out = bh;
 
-- 
2.53.0



