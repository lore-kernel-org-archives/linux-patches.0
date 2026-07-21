Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFD246A603;
	Tue, 21 Jul 2026 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649420; cv=none; b=nvb46/FKd2C0cHz0dw9cLXkH8a5NplcM4A7QFxWrvIFUuuopDYV1XiREEnVLFmyeQ8qJMosam6txbsAwdvXdxhTUJ28da0PIFVFbkH0IeRE0xhSdeUdHZLsAGCTYihnqo3FPXkZKYcL7SWeWvW6gHxos7iT0qhor0b7eZhIpCU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649420; c=relaxed/simple;
	bh=VS2Xmo01C2ayICplV3uYrADIR4pfam9ueGX1HWVqwnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usMLCxaKtj7mHyR3JIULMVUCYBs5QCntE61foZLTEHmMft0ZlmmjMVwE8RWzorA63F2tw/BSRNRR4mEuiCi/4C7bU50MY9Fo6gQnKl4rmmi4yd0+FmSmwv2M3H2La6kgrsHqZuXy74xfGosg4RIx/8k84vrdlseceyixnFXnOG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqODEOcr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqODEOcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601331F00A3F;
	Tue, 21 Jul 2026 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649418;
	bh=bHtmn9mwUkiZ3inzTLG3o7ElHaTmWfD5awuc3IPDl6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqODEOcrv1rqf3oYjOSgoyZXBI1iKd3CODS6nqSFe2Fdapxd8x5n7MSMpH+nZp7+Y
	 PMEUNmRJeYmECCTSwoDyIxCOgHMFBNnmm1SuVKq/74a2JZgeIZReXXdc1Z6p3HfV4V
	 MNnIuVy/xlFqdUHS5cAB7fDskQ0MtjKT9KsVS9kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <hao.ge@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0571/2077] lib/test_hmm: fix memory leak in dmirror_migrate_to_system()
Date: Tue, 21 Jul 2026 17:04:04 +0200
Message-ID: <20260721152606.275685196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <hao.ge@linux.dev>

[ Upstream commit 8f7275c174bc5bcc8fc1bec8024e2b3e6fe17f46 ]

Move the kvcalloc() calls after the early return checks to avoid leaking
src_pfns and dst_pfns when end < start or mmget_not_zero() fails.

Link: https://lore.kernel.org/20260528011336.20797-1-hao.ge@linux.dev
Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_hmm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 38996c4baa4080..1e2b76e79c74e9 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1111,9 +1111,6 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 
-	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-
 	start = cmd->addr;
 	end = start + size;
 	if (end < start)
@@ -1123,6 +1120,9 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
+	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+
 	cmd->cpages = 0;
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-- 
2.53.0



