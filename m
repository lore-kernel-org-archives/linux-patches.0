Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618886;
	b=XG2DV1Lt8jYax7S39CFocLu2uQnPzCdo+YtBQBjCv78ffiYumHjyb7fi1NGpWLD8X2WS
	 LbKjIG5EVNmiyloqeM5iQTBHbEfDD6JJutapb3v/YMPman+G7nylpu6qSZTscx/zl2z/n
	 ySFFzvEPzEjai1EQdi0s2FWouOkwBNtzYc3O/gijlzHI2Vw1FXoJWsC6JCLvl5pw1ywh/
	 4+rkSKRPgqarSbRNla/eugkk+uCXAtS1A0y7TZGdmhRtiu7gcus2lQ1k7X1pQzN4EwZqC
	 AD5uKLYyztVxkC12ch+2+8oA9vDv99dJ+GF4GgCsDarN9fr/w1XBpVGfCs2X2vcw6qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MlM6y3SgH069bD+YZkpAAHfOV2AuFN94Afj7oFg7ZrQ=;
	b=WArlj6QTDUjRmMwIIQFgueYA3rfKuwr4MrDKVzeHGxOGV/MlRZO5Tz/FCi60FiE44qHK
	 basRkcqUGYEt9t+07cq+D7EtZIXlpcoxoukJHaxS6BXqpceavnvC6Jm2Q8eb9Xx+8J108
	 /SNFY9jXPVvYLTys8FCTcT4/US6xjZmhhBf6Oari4UQ+7i6/eKA4VHOp97WgLeoPmnNuM
	 QdtC14+XsOPjMH9qXED9tP/OwU302rlOHOjRj/ybk8uzSsk/TGaRb72kvJ/GcoQKFvKAK
	 BndQiRFKw50sG95q3mz5HhLRRIOwpX43jtK2bw8aBaNRNeFoPVOUoGgag2KV6Sss9Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7EDZKgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB0606A321;
	Wed, 25 Nov 2026 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7EDZKgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E171F000D4;
	Wed, 25 Nov 2026 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618886;
	bh=MlM6y3SgH069bD+YZkpAAHfOV2AuFN94Afj7oFg7ZrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7EDZKgT8iSMmj8sMDfgzgXrDsyUUHkXfNTN+i4CHdoqG2B1KBdpboksvrxds8Vc3
	 U06t7EnhTlGD93EqGlTj0epLLhKyRSp+VFzcDV4fCrzun5/1x8gFuRk3VyGBsS2u92
	 SGqfXU1fRLGzAcrSGNiCv68nay1QH5uxL5NLm3ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0421/1005] btrfs: zoned: dont wait for ordered extents in do_zone_finish()
Date: Wed, 25 Nov 2026 15:29:19 +0100
Message-ID: <20261125143831.616639835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit bcad7df05237382237ad1517411721d839174009 ]

do_zone_finish() calls btrfs_wait_ordered_roots(), which holds
fs_info->ordered_operations_mutex while waiting for writeback. It can be
reached from writeback itself:

  cow_file_range()
  `-> btrfs_reserve_extent()
    `-> find_free_extent()
      `-> btrfs_zone_finish_one_bg()
        `-> do_zone_finish()

If another task holds the mutex and waits for that writeback, this
deadlocks.

In general, we want to ensure all writes in the block group to
complete before finishing the zone, as relocation does. However, the
current callers do not need the wait (or cannot wait) in do_zone_finish():

- Relocation already waits for reservations and ordered extents itself
  before calling btrfs_zone_finish().
- btrfs_delete_unused_bgs() checks that ->reserved is zero and sets the
  block group read-only while holding groups_sem, so there can be no
  in-flight data write.
- btrfs_zone_finish_one_bg() is called from the allocation path and
  cannot wait.

Dropping the wait is still safe. Once the block group is read-only,
->reserved can only drop, and for data it only drops after the ordered
extent's I/O has completed. So if ->reserved is zero, no data write is
left in flight. If it is non-zero, do_zone_finish() returns -EAGAIN,
which all callers handle.

This makes btrfs_zone_finish_one_bg() fail with -EAGAIN when it races
with an allocation in the selected block group.

Fixes: 393f646e34c1 ("btrfs: zoned: finish least available block group on data bg allocation")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index fbde21946a36d..a1e681d77e9a2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2610,9 +2610,10 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 		/* Ensure all writes in this block group finish */
 		btrfs_wait_block_group_reservations(block_group);
-		/* No need to wait for NOCOW writers. Zoned mode does not allow that */
-		btrfs_wait_ordered_roots(fs_info, U64_MAX, block_group);
-		/* Wait for extent buffers to be written. */
+		/*
+		 * No need to wait for NOCOW writers, as zoned mode does not
+		 * allow that, only wait for extent buffers to be written.
+		 */
 		if (is_metadata)
 			wait_eb_writebacks(block_group);
 
-- 
2.53.0



