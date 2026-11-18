Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060155;
	b=Qz0Xhel70zAIjjZZdeVBfP3uasEYP7wFbMSKeUrDhFZnvnioNZi4SzIK+3lkcJLkrent
	 r3v+IxEvcOWxWvkFCkUGW4JIUC6g+Na2URBz/K/d23TORCK9uU+nz9N9zFteSx6d2Q9w6
	 svRj26DiJsADzk2xRHg+UGKAnBMY57X0JH381rz4K7nBH0j8M1B59NQmGIkefUhGapSYq
	 UijYp0KgfsFWiFpRTjzCceoGDZerdHObNcvRPx4FWNjdzLXHi3manqTrhS/25Wd/gGdgx
	 KK4Wne4wkrhLZoS0RVPRxzhuopRcQHPHNnnG885bfULGywuYzqEo+PzFTQRaGCEQjfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+xxKrgEODPNeVzEKKFrhavnSaWoK6HGmRbHmcN7dwH0=;
	b=nLjhtAzYnsBWr0fS0ALbPjyZzMdrRAZg/ZnSOXYd0ohw+A7pUnreL1T8l/HxOrfJMs6q
	 k1xFryne2VQkhzj2uuoQyo2rViUOxstC1buMjKwAPoq++9oERxqQazStUNwTK+eD4J5FW
	 sAspYoS10jw3eP5cdU1IXNgZ1poQLZBohKejLk4sgTGb1tE7redh6sFdEg99vBqw0vW1T
	 zdp0EbLOoCkQJKyUMpEE5za9NpVzYroyfvq8aKZFu/EVKRIbccvTtjz443HCyP8Kw/XSQ
	 sZOBHyLenEmRfWe6HWDrneAhkkuQBob0k0K/KApSlgKOxWNBjxrXb1PZCzvAL/mlBsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b69oOMPK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA03606A325;
	Thu, 19 Nov 2026 03:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b69oOMPK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329591F000C4;
	Thu, 19 Nov 2026 03:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060155;
	bh=+xxKrgEODPNeVzEKKFrhavnSaWoK6HGmRbHmcN7dwH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b69oOMPKzECH8a9jFjBhFFw5xaMvJCgA2uQFukuOHr4RPXNs7rOZ2zWk6AdkYRLQk
	 HTFnjwLIuT9DSyromHISVCy3LGwIEm2VOwihrssjmKcvqG9MYGfSPd6m2XRZf152oK
	 G2bIuqA1RpU3hp+kxPupiexPX5A48+q5wXgKDJ/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1097/1848] mm: document mmu_notifier_invalidate_range_start_nonblock()
Date: Wed, 18 Nov 2026 15:52:15 +0100
Message-ID: <20261118150004.882768949@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

[ Upstream commit 7ced098fcfe596feab3cea4f40128b0119c7bf1a ]

Document what mmu_notifier_invalidate_range_start_nonblock() is for.  Also
add a __must_check annotation to signal that callers must bail out if a
notifier vetoes the operation.

Link: https://lkml.kernel.org/r/20230918201832.265108-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6d65925777ec ("mm/mmu_notifier: finish non-blocking interval invalidation on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmu_notifier.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 1a6a9eb6d3fac..0346fffecb6c6 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -455,7 +455,14 @@ mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 }
 
-static inline int
+/*
+ * This version of mmu_notifier_invalidate_range_start() avoids blocking, but it
+ * can return an error if a notifier can't proceed without blocking, in which
+ * case you're not allowed to modify PTEs in the specified range.
+ *
+ * This is mainly intended for OOM handling.
+ */
+static inline int __must_check
 mmu_notifier_invalidate_range_start_nonblock(struct mmu_notifier_range *range)
 {
 	int ret = 0;
-- 
2.53.0



