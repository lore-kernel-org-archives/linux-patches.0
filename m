Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047636;
	b=IXj1MNCYXcXWncCo/QUWqMq2fZqfXrsQjMyyD8kqD6BJrg3LmNxtXnS2XMvOCGLFUMCN
	 U+NCEDd1/NUemh1HTd6n4gJScXfu8s+Rvk6hr1y/TpCK0whhhtfZ4BEKiVFXI8tQADZD9
	 trAUm+r+n+92t4JBfLJ+ihGSS4ln2l3kP0Ett9GO5LvtaDwutkzJf5OMDObLYkwRyq6Az
	 i+qPtrj6dyVz6xwLez3DKZK+Dy1MUGQext/Si+HEiWic1+FqadQNsjz9Q5nDU1/+hJ53B
	 6/C6E8n454zI63OQeerOY/Du9Ivni2asgRZ2v/qYuqV2o8rhg1aR6lSznViI53ZKHPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wyH+1vNZ2KskJ6lpmPVoxCv9OWaVnJHG8fAyalXUWW4=;
	b=c1tXayXrgp1GakhOVI/lgpn/DfOGHUHRNatPIzveTfLKL2KlwQ7P/JHf5vhntNQU9h7S
	 XbsLmICgy0nGGCXHf0of/cXO6DTZgtNOQsVVqZ4VrINOFOz+7HRBRCxrmbUBFGpp4wh5D
	 o/3rKGHCKCBX1G3GaPXP3s8P9vafZkN16IRGsKXiipMq37dTuxQxWlQRn8mLApHTw1MPu
	 B70r5Y2IlRWQdbrC1/n/i9MIdkakqE3h1iWg/GCUn2/xLkFWqIIUWy+lK+T/yjPh2KQ9P
	 mZrI48C8v7U2H+C8jblZTDiCtvrGoSpEprxKrVsqhToqp13S148XMogHTJX+n3k0DZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OMOM28t/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F3C606A31C;
	Thu, 19 Nov 2026 00:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMOM28t/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29141F000C4;
	Thu, 19 Nov 2026 00:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047636;
	bh=wyH+1vNZ2KskJ6lpmPVoxCv9OWaVnJHG8fAyalXUWW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMOM28t/G6c3Yvj2N/5y11Vs54lSAxrCbkXF9nqlpsY7QaXzg6SjV9TzeoRos8fMs
	 lThxacZaUMQxUDqCQPyJqvlVNi8EFbOlK++AjK2VqiiANa4dxNFFpOVHDdW0Nzo4DB
	 sacMXtIQJ1vukGlJREuvvRzs7hlRhzuVACnDAeN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1709/2857] mm: document mmu_notifier_invalidate_range_start_nonblock()
Date: Wed, 18 Nov 2026 15:45:43 +0100
Message-ID: <20261118150302.865467386@linuxfoundation.org>
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
index d6c06e1402771..7c81de8e381e2 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -461,7 +461,14 @@ mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
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



