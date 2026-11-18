Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059129;
	b=0WEPQgmid/EjTMfu2Tj3mbmr6AF9yhOOhhMb8L3e3ncoRZJjq6c1IAC8LYbqSchWRBZY
	 4xfiNR0Zdmqcwa7i7abLLqRB/Dm0VHb6Iwv7iUSZudnKXfgTJKgCmHKoV2GTayZS5Kjgf
	 zka7LCF4gPOjNxyR1rtj73kJQjrHauKyZF3QBJ1O7iE7c9YCToJR1h9Ry+/uBQ1u4dS3+
	 TUCtyOvQHg8QuZT7HYHghskPW8UMx7e6nQJmmPzSQLGx3Eta4W2vWci8pvXHc8Hzwsp4f
	 nA6wA5Ugds93nUz28B0EMr48O4hXEx/MFwA30J1/ZJVa7FBBGjj22DP8G0sRkMicA5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=di+far4wcJbG/Oa6p1AdUXpcL7YEZhPlsNAucs0DbL0=;
	b=I8Fb1ioXX7jkC1IvVjWJ0BiT5VXQeSNqGrV6LI3r1RlmJKk6iPC/0438+lr2EJoF4T9N
	 YIQoL98PJu39lj6l4H5U+JYtHVd+f6LpwtPFQSbvqd/FFpoBca8ZxqIPo7jOxGd7AWaBC
	 g91KWBMPENX89NBoIIn0Rvm0TpHoEnvN107tdz6twNcc7FJrEO1MFSnKemq6r74RiXyur
	 ozzCFkxVk34pIqtY9DNjWl8oBY8mqcTIF/LBjobp4jZUV5ATDG8DjgJcJiPE1TmcgfOfg
	 1nRt88pGi9OSToQD5lR2BV9yp6Ng4wfteNvewW1CEX8rbmYPJr6m6uQ94aQtN5fsXdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h9U+nXMn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1FA606A326;
	Thu, 19 Nov 2026 03:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h9U+nXMn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918E11F000C4;
	Thu, 19 Nov 2026 03:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059129;
	bh=di+far4wcJbG/Oa6p1AdUXpcL7YEZhPlsNAucs0DbL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9U+nXMndgnfz4WLifiWYVVbkScFqsXICs+mRkC/oQvBS5h1pcvAG/kMPuHZkhM8J
	 2bUrnAouiD1MbaL7U7SOclIhNGb6rb8GQOPPu/YW8aMutDE20w55/d4gFV9Poi/rrC
	 MSwcVyvfbPA8LPlrp0BQhkH91d2AfQ1MVv8RpHpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0732/1848] mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
Date: Wed, 18 Nov 2026 15:46:10 +0100
Message-ID: <20261118145946.803680380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7a81bc23dade8082187be6d9cc36e4be4b7207e2 ]

Commit 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
made holebegin and holelen unsigned before they are shifted, by casting
them to pgoff_t. That is an unsigned long: on a 32-bit kernel the cast
cuts off the upper half of the two loff_t values, so a hole which begins
at 4 GiB or beyond is taken for one in the first 4 GiB of the file.

truncate_pagecache() passes the new size of the file and asks for private
COWed pages to be unmapped as well. If a file of 6 GiB is truncated to
5 GiB, everything from 1 GiB on is unmapped, and what a process has
written to a private mapping of the range between 1 GiB and 5 GiB is
lost: it reads the contents of the file again.

Where the range has an end, the wrong range is unmapped instead of the
right one. The page cache copes with that, as it unmaps every folio that
it removes. The callers which only have unmap_mapping_range() to get
rid of user mappings do not, for example drm_vma_node_unmap(), whose fake
offsets reach beyond 4 GiB on 32-bit, and revoke_iomem() with physical
addresses of more than 32 bits.

Cast to u64 instead. Nothing changes for 64-bit kernels.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-36-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3ebf3f1da428b..403fcef10bdac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3328,8 +3328,8 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	pgoff_t hba = (pgoff_t)(holebegin) >> PAGE_SHIFT;
-	pgoff_t hlen = ((pgoff_t)(holelen) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hba = (u64)holebegin >> PAGE_SHIFT;
+	pgoff_t hlen = ((u64)holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {
-- 
2.53.0



