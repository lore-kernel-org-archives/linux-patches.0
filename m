Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036447;
	b=cv2E5NeWsPNVo5L5FMejEiU08g6s69dh+rITNjIC2rToeSZuBy5sgGW8otcFqS/N3Vda
	 z82Ha2mR30LutS9CZ/XlEEZ3YdY1bann7nNKvh5x2Hx3VLBm9EVb2JfDI3Xn/HqzCKyA/
	 YG68yoKUg6rgXr7g8hTX27HioMnnVkkP42gaxO3WrryNleIuNqK+vlY3CdlA7ndcmDk4R
	 AmiBnZBr8jaCz+f09oBGk2W0QqZb9iF5zE5bEu6bUsTkugc2UBZobWinESoY24MXiaKrC
	 o76a/wH6lp8HxNjObQdcUY0etNCaCHOV8DOZSzC9CpmuBMowrfpy7E2y/VYn7gjwDSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UgfvMb3lNhWqnpq8lYy5923Byp1ork6OHjXAtGjmPs0=;
	b=o3QOWcbtiKw1eXHcmLXX3hndTlJlgrvHqUW+FjdgzjDn7ow+SAMPbrQNwOTiqSt+HrEq
	 0X7c34WcdHo6K51cDdAJxKnx6YSMSbyyn78A3FMYqK/WQ6wl5zfHQGOR28z4lX+/S/etu
	 5xpGQSrXw9lga+qk147pfgrAemSk9Pi+ZxN1bs+hKDXO7YNUKfSW+lgQbljr8IpuuPIm+
	 gEvCBAUEer6pzz6HClrKRG+LqYpEsExSreaE3r1+M1+Mvi9b+X9gQCeQiaiSfYVBSOlAW
	 X5fvXBRGshZH05Q1iMv5L4/nZSN6ZMtOSWQJIjIfFe/159Bm7jAZwJDeJTXGCTMuBDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2chnexUm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999D3606A31C;
	Wed, 18 Nov 2026 21:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2chnexUm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C377C1F000C5;
	Wed, 18 Nov 2026 21:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036447;
	bh=UgfvMb3lNhWqnpq8lYy5923Byp1ork6OHjXAtGjmPs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2chnexUm+cH0xGhfn818rfrRoJw9+54OXR4KR1sTizZ1/R17CemaNMMHLEZomuKnG
	 V0rcKA60GPyd+tOnmvlGovHueruqV0GSl2ew+HmzstTovHj25ro3g5KOwfgptcRf+c
	 kQJKiK2Y/u+QAAFa/vOKIjhn5SCssv3GbXf+baDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Chenwandun <chenwandun@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1019/3318] mm/mempolicy: take a cpuset cookie for the interleave node count
Date: Wed, 18 Nov 2026 15:27:21 +0100
Message-ID: <20261118150350.453285629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit bbeeb4a29dc4ca6ac18ab3bafa3728bc984a4cde ]

alloc_pages_bulk_interleave() counts pol->nodes without a cpuset cookie:

	nodes = nodes_weight(pol->nodes);
	nr_pages_per_node = nr_pages / nodes;

nodemask_t spans several words once MAX_NUMNODES exceeds BITS_PER_LONG, so
a concurrent cpuset rebind can tear that read and yield an empty mask even
though neither version of it was empty.  The call then allocates nothing
and returns 0.

Some compilers will hoist the loop entry test above the division,
because nr_pages_per_node is dead when the loop does not run.

	682e:	call	...		<- nodes_weight()
	6838:	test	%eax,%eax
	683a:	jle	692d		<- nodes <= 0 skips the loop
	684a:	div	%rcx

So in most deployments, this div/0 is unreachable - but nothing in the
source guarantees that, it's just not easily exercised.

Take the cookie around the count and bail if the mask really is empty.
Only the count needs it, interleave_nodes() takes the cookie itself so so
a torn read there is already retried.

A rebind landing mid-loop can still leave the count disagreeing with the
mask, so the loop may revisit a node or skip one - but a rebind where
nodes change causes migration, so a handful of misplaced pages isn't
catastrophic in any sense.

Measured on a 72 node VM (NODES_SHIFT=10) with a cgroup v2 cpuset flipping
cpuset.mems between a word 0 and a word 1 node set, and the two word read
artificially widened: 330 zero counts in 130414 calls without the cookie,
and 401 retries with it.

Link: https://lore.kernel.org/20260828193111.1023497-1-gourry@gourry.net
Fixes: c00b6b961099 ("mm/vmalloc: introduce alloc_pages_bulk_array_mempolicy to accelerate memory allocation")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Closes: https://lore.kernel.org/all/20250907160829.91628-1-chelsyratnawat2001@gmail.com/
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Assisted-by: Claude:claude-opus-5
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chenwandun <chenwandun@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5d4a9f67bfc4d..0d31b705015d2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2285,6 +2285,7 @@ static unsigned long alloc_pages_bulk_array_interleave(gfp_t gfp,
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
+	unsigned int cpuset_mems_cookie;
 	int nodes;
 	unsigned long nr_pages_per_node;
 	int delta;
@@ -2292,7 +2293,16 @@ static unsigned long alloc_pages_bulk_array_interleave(gfp_t gfp,
 	unsigned long nr_allocated;
 	unsigned long total_allocated = 0;
 
-	nodes = nodes_weight(pol->nodes);
+	/* count the nodes, retry if a rebind happened during the read */
+	do {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nodes = nodes_weight(pol->nodes);
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+	/* if the nodemask has become invalid, we cannot do anything */
+	if (!nodes)
+		return 0;
+
 	nr_pages_per_node = nr_pages / nodes;
 	delta = nr_pages - nodes * nr_pages_per_node;
 
-- 
2.53.0



