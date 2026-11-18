Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059486;
	b=v09d7rz6cfg8MuC7euU5ht7geIc6u/bDpRN2hr9glNZqqqt81ZW/9nbuLeNx/8uGLeB+
	 dM1YTF9QFlIwI3I3CHQC049HtGUUxcxkUkO7bG/tW1VDjk48DCcyHH0gpotWPOI6tdbVF
	 K2BpMkwgV9SX+yqDBwiRyrWqci2U4xUslmWOYHSg+VFS+Qws1bvawDvr5n3H0Zj4KETgx
	 UeTNEXKxpY4hM3S0i7U7PjxWHvM31Cq8sNMOkY1n3c2ttftyioJ0QQ9ArpyLi6coJSjw4
	 /FT15p99sLBSn6azW2/mPT21Vpz3APeXOXAsyu4ZutkbpC1W5R1dhBKkuH3MdhlSAKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sCnyBrmLiu3oczyFJMvdkYgTYgzQc3VBGW8kv+qSEQs=;
	b=hufj01u1bvC3xeGO3MUFaIcdNrUNzVxZAIE1ArF8Zpj79yUuRGfMQCauXOGvJTzMXTCG
	 E8pjCUhhi8YB9WwZjya0nB9c32mxQ16pxVuEEhDn1/JzzLt3WmPxPPeA3VZqo3hX9NvXH
	 +Y/XmX+xV/bJQ4TiVAg3DvYFb2JtF+eqL8LBgjITOfAVWMuT13GBM7h6L7CVn/x4ZwNiO
	 H0oHFebqfaHOkbn+E+nvz2XZ864LutfG9K0L4iN1jz2FQ5b0/wVv5IWlKi6UxCP/5t8Id
	 5EDwh30EGR7iZWXHo1FZ8XEQP851BwA3N3RxsXmrJDpy482tZNo1pavwq2LphPJCcUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="alY9qw/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA5B606A32A;
	Thu, 19 Nov 2026 03:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alY9qw/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938C81F000C4;
	Thu, 19 Nov 2026 03:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059486;
	bh=sCnyBrmLiu3oczyFJMvdkYgTYgzQc3VBGW8kv+qSEQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alY9qw/R8GydYa3GtxDBYw0zX/93EEXtnd4PYgF0OTjN/VP33cajnFLx4FeAuRLSE
	 EcDn1iUGKd01Fndm/NYI17CJ5LcDis1nXD6m/F/XtINX7On+9FOTMkQLGu4eycXT9s
	 RzAp2SUn4PnxyXVnYiEOOs3tXmqurAMoi2c36/jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	odys.yuan@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0860/1848] mm/migrate: untag addresses when querying page nodes
Date: Wed, 18 Nov 2026 15:48:18 +0100
Message-ID: <20261118145952.508667403@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 7d8746d7dc9cc4003661011424e5880ea7ae364b ]

When move_pages() is used with nodes == NULL, do_pages_stat_array()
uses each page address as-is for its VMA lookup. A valid tagged address
therefore gets -EFAULT in its status entry instead of the NUMA node
reported for the corresponding untagged address.

Strip the tag before the VMA lookup while holding the mmap read lock.
Use untagged_addr(), the helper available in 5.10 and already used by
the migration path.

Link: https://lore.kernel.org/20261026195330.46757-1-dennylin0707@gmail.com
Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <odys.yuan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index bf59b09455ad6..bf112dac2e73c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1813,7 +1813,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr(*pages);
 		struct vm_area_struct *vma;
 		struct page *page;
 		int err = -EFAULT;
-- 
2.53.0



