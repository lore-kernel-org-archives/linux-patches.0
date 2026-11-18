Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039130;
	b=D6uZ+qtiITtMEd9WZkdT7b4JkHlX9To8reqVysAk0ghBJHAjnvDbHouR96H3HE70jO0C
	 3M5MmSBe1lBDGsxZH2ZaQ+YNiAw8M8XAxjUe9f+wGqZeVQYg3+YmS6wGGTA8jtzY/U4J4
	 8GH+YeLD4tVPIzVvQbxhSB9Y64cSUqdQEJClSYnLJQSpHrPUwcOtew1mj2td3TtUkA3kh
	 jplDhzhKZ1i9hgEYAuAU1zUGKEGtvdAtMeY3PXVNlmBteJRRbfSuUK2Cvd12TgxwIVdwE
	 Z1Fh5yDsn+eRl4oIvK73BC75cGxrRCUogeXYpE+SVWbps2A7wwrRW4rxng39O6LQHiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ton9pE9600hGONO7+rTa2Kh7TAVOyog00UcW4MWebXU=;
	b=FZ8F9iC1gBX0rJ2ix1O6kglR9F+u6RzLi+pWruVRQlTMx2Sn6wJxoY3q4FEcuSm1ctuG
	 RuxVVoyi82Q0Q6ID4jzixXn/7vOTnWDYITrWzITdPRQjy+Rzg6fX4NfIJE1INRh3/5T9r
	 Tzo/vz/FFf5LST5etrCyvdLvQSMsf/AvLV8H7v8KTKFEgGV0b1lnqPykuB6ZSID7F9l7v
	 no17Vup03KqYwv9rB3pypiLQweUJ83G+vkvcGJJBPy44WTPafLpIWLQt+8oxJz1yWCqA7
	 Ye3drsacvX5PTm3QHY0S4nff8OblLq4SaHxixn55BSx2OZwfx6510x2x6q+kTkQY0MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=010bfDqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03B1606A32A;
	Wed, 18 Nov 2026 21:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=010bfDqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258C51F000C4;
	Wed, 18 Nov 2026 21:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039130;
	bh=ton9pE9600hGONO7+rTa2Kh7TAVOyog00UcW4MWebXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=010bfDqZqhJA+rpXj1x+wY3Ne3w9EnM241CNrSxY3+wzLJ88i9WFLRpqxVxbVevKZ
	 JMaTibjtFmyUbUpmTaZBNDJph2uNV/7HXzzrkjnj7nODlAZBhF8fqMZlhssGua1IGo
	 7yhBEj8/Dy/uEwFIoYICaAEidNsu+dd20M+PzR9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1963/3318] mm: document mmu_notifier_invalidate_range_start_nonblock()
Date: Wed, 18 Nov 2026 15:43:05 +0100
Message-ID: <20261118150420.977121930@linuxfoundation.org>
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
index 6e3c857606f19..f349e08a9dfe1 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -459,7 +459,14 @@ mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
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



