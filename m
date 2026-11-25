Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620257;
	b=cl6mpT4sZgvLToyuCVNVfzHO9PLomt7Ade5qOjMCOEmRza6UxzOQY2XdI4Enooassewz
	 /2NRSpqJzhU/TU2wJGAETsBv/825p3no+RDVeZYwQsEZind3kDNP5YM3Lst7hQGjPqFRn
	 GidkKhXA7qMjoiKLg4ThQaqcvcG47n139+G6SUElGB9ASpiWLIoyafe/YRtSDKNF5Zgue
	 C9Prq5vtwSNnCVjWOspnVyMUlVP6/mt+Q4pjNDJV6dFOaebaKPj8K/YE9gl4s6T+6T9LE
	 S7Vt/cFzA1zmmeMmhG0mHMVkIRiTyr70ogyRCRO+1imXmUkZOnjODU+ppZew0jh/7Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4G50shR96MApUVVmjdSffuk06SYQlMAZlQHrIpml8Qk=;
	b=E/n8YtrjpIgWW7KatNVjH8omVbItrFPHc3WNkAHDQaIAyvGsTI6c+Y1b17POavMydd46
	 Z81mpdCxU/T2x73rmnEJe+GxPXQIcItchE8pEVlwCsK9xOofBO4jtgwc5+95iZ6fPKmmz
	 q2kdnC6t7W943fv3JTB29WnMRYXUTj1M7irfL4Jp+qWiHGH99djVcCR65gQ8LKu21KjM1
	 95In9skWta+fIISJg25i2w0IyyK2cz34wdLhrQjxcC4R9SrOA4Azw4MqAsrjgotWEhGR1
	 pLJI05QW8nKDx7QPE9yp+i2Y/j4d5zh4XDQeKBdTal/jHH6w0964i1oJ8F2FRDv7yYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPA3RH8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DBE606A31E;
	Wed, 25 Nov 2026 15:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPA3RH8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303261F000C6;
	Wed, 25 Nov 2026 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620256;
	bh=4G50shR96MApUVVmjdSffuk06SYQlMAZlQHrIpml8Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPA3RH8zVifSLdUfLrk5liQLgDBQzztwyWoatpUDZRZJbIzNHMT3T/vxYS5/XoYmZ
	 D5EIdwdfQmW0EpNO466IxhAqmajyuvWprX0tuqOYuZ13iW7kJFUDadInlE802Nm3dh
	 lN4JUUTTtH91j3gtQXQJTcNVDx65HbC0Sud3l768=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c8564fc0a96e3ecbe4d4@syzkaller.appspotmail.com,
	Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0859/1005] dm cache: validate the discard block size before narrowing
Date: Wed, 25 Nov 2026 15:36:37 +0100
Message-ID: <20261125143841.831232883@linuxfoundation.org>
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

From: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>

commit df8daa4d916c88ef7888c738e0eb3b6f11714a6f upstream.

The discard block size doubles until the origin fits within the discard
bitset limit. too_many_discard_blocks() passes this sector_t size to
sector_div(), whose divisor is only 32 bits. Once the size exceeds that
range, the division uses a truncated divisor, which can become zero.

Use a 64-bit divisor when checking the block count. The selected size is
stored in a u32, so reject sizes that cannot be represented before the
assignment and before calculating the bitset size. This prevents a
truncated zero size from reaching dm_sector_div_up().

An earlier proposal checks whether the mapped length exceeds the origin
device. This fix also covers an origin device whose valid size requires a
discard block size beyond the field's range.

Reported-by: syzbot+c8564fc0a96e3ecbe4d4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c8564fc0a96e3ecbe4d4
Cc: stable@vger.kernel.org
Fixes: 08b184514f65 ("dm cache: revert 'prevent corruption caused by discard_block_size > cache_block_size'")
Signed-off-by: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -17,6 +17,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
+#include <linux/math64.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
@@ -2383,9 +2384,7 @@ static int create_cache_policy(struct ca
 static bool too_many_discard_blocks(sector_t discard_block_size,
 				    sector_t origin_size)
 {
-	(void) sector_div(origin_size, discard_block_size);
-
-	return origin_size > MAX_DISCARD_BLOCKS;
+	return div64_u64(origin_size, discard_block_size) > MAX_DISCARD_BLOCKS;
 }
 
 static sector_t calculate_discard_block_size(sector_t cache_block_size,
@@ -2422,6 +2421,7 @@ static int cache_create(struct cache_arg
 	struct cache *cache;
 	struct dm_target *ti = ca->ti;
 	dm_block_t origin_blocks;
+	sector_t discard_block_size;
 	struct dm_cache_metadata *cmd;
 	bool may_format = ca->features.mode == CM_WRITE;
 
@@ -2521,9 +2521,15 @@ static int cache_create(struct cache_arg
 	}
 	clear_bitset(cache->dirty_bitset, from_cblock(cache->cache_size));
 
-	cache->discard_block_size =
+	discard_block_size =
 		calculate_discard_block_size(cache->sectors_per_block,
 					     cache->origin_sectors);
+	if (discard_block_size > U32_MAX) {
+		*error = "Discard block size exceeds 32 bits";
+		r = -EOVERFLOW;
+		goto bad;
+	}
+	cache->discard_block_size = discard_block_size;
 	cache->discard_nr_blocks = to_dblock(dm_sector_div_up(cache->origin_sectors,
 							      cache->discard_block_size));
 	cache->discard_bitset = alloc_bitset(from_dblock(cache->discard_nr_blocks));


