Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046966;
	b=clYUwdlac8UKQCdmxY7XVeUBlAUk5YIpxryflJ/XVLyt48c7imQH15R0vKsxA0CoSaQZ
	 LFLYM3sYAVJKj/mEwNM9JL0JJ6FOJzv8WUTJy5313Alp5WOlKSFyu7I6XxKTuZEaiDEwl
	 +335r1C1m46wuxxMSZ5x9QXLRz01lzRWr154sJiWsz0r9br+EQEu4Cb9KbUamwqSUEujL
	 OfySZzbxHJcAn+H1Yl5hycfcweCyjajzYLI1XADZao+Ru/kQ8jrNaCUKb7Xj/4YNdI8lW
	 kbJDRZw2CdH/ah2qj1csVjESVl2CkLj+f+/KgYjUVY63BrSFycoYa4MX1XC5K4Batag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bzI7Ic6G8uW3IRP6gV3DAdT2aJUv9Xd9PywTqo7WT4g=;
	b=lJoEzHsLqkxEhg3vPLQpf112PYk2kYZgbamdlXPLNxfWIjmywxy5daEnOTgu/dXhIV7D
	 oh5XDXG03ut2xia2AhOt3MQoF/mrphsBwVBvgoTK1L3s3AO8x0XIsAZ1Uh1GiIOvHZGoo
	 iL4TZxZ3idj9SuIvYL5mXMlx20KGiVdMqr2Lv8HntRUXxyrFZTK1h/7zAlGzEEGI9n7TH
	 +XUbhxRpw7py5d2Fyq/u1Y0GiGWyxqjImMh1CyPIUyg6nKKdYZ6TkhVfDFzpUiR0SK2PT
	 AQod7qg60RmrtrWm6t/gtrEyhExQQAZDmYPGkWJxxrEQkFx47PGa78pG4ivGQ1AXMtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3NCF4gr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46567606A325;
	Thu, 19 Nov 2026 00:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3NCF4gr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7696F1F000CE;
	Thu, 19 Nov 2026 00:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046966;
	bh=bzI7Ic6G8uW3IRP6gV3DAdT2aJUv9Xd9PywTqo7WT4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3NCF4gr2BdZX6s++uenFMyzGGEGgh4vdX7dRSCTGr8SHhvuidonGPll21YB0Afky
	 TVSOUZgrbpA0c7ERGqT3CazE20V/Kd143h9xUoiVs/Jh4QCu55H1xl132hsHt9n2dW
	 UMJA8ZVxI5RU3ktMW9cdJPSW0LEO1VcCWHeMOAwQ=
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
Subject: [PATCH 6.1 1419/2857] mm/migrate: untag addresses when querying page nodes
Date: Wed, 18 Nov 2026 15:40:53 +0100
Message-ID: <20261118150252.416742986@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 7d8746d7dc9cc4003661011424e5880ea7ae364b ]

When move_pages() is used with nodes == NULL, do_pages_stat_array()
uses each page address as-is for its VMA lookup. A valid tagged address
therefore gets -EFAULT in its status entry instead of the NUMA node
reported for the corresponding untagged address.

Strip the tag before the VMA lookup while holding the mmap read lock.
Use untagged_addr(), the helper available in 6.1 and already used by
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
index 72ee6896a2cb2..09acee0c43569 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2168,7 +2168,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr(*pages);
 		unsigned int foll_flags = FOLL_DUMP;
 		struct vm_area_struct *vma;
 		struct page *page;
-- 
2.53.0



