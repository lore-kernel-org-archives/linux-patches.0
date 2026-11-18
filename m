Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053393;
	b=nijNsGvzOF15mEt27PaYvLpbCYXixDFy6WXCfuV1Lya4guTxhOIcJOx0OSdmCD6tWyYX
	 jprKiVMdhxvfPitzcFNPrH0x7/zTAl1KP0rtVrXWNUPLMIeS0M7mhDtaNjhbr7Q1/C7F3
	 SNfnJJpDofo4OyQMGSPaybSFv/RUFZsH2crOzAqYETWgjHewo/2xbRJCb2JJcZfPDKX50
	 dRywmYDWao9rWQzgZVw3ZUZa8I8qFhRRGgWZrNDwBPDsECWmqkB+IziDdTs0UghX3Crnh
	 4Yi7c+PN8Mr+3KA54p7L+gqz53UIUhprSeD0s89oRaxDwypxPb1NL2HhENaMppbdixg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+S3dhiI8IDZUq8NHlGlrWNwvPeTLEvmHhOZlpHMR2+k=;
	b=L8FyH2nHxkv2qE04rFW+enq4TdIL2OCbnon0cYv87sSbpoLozQbjNJ6kg7K3dyHsdZ+S
	 AKH0Ll722H23ys9lMpaytFrQ4phWRAJXkQ9qm7SELgt/LSjbdbQ6jJyXpo4kMo+RxIneu
	 1wkytgqzvLQy9YbHmwyiY41x1x5gFM5/ehMs1nB+ytVNJXQJxtUJJshaCN50+vj3kNTGo
	 30N0youT6bzG9EVnsGgP9rQkMasGUVOvHcn00GUDfg+j7Z9aQZ4ck1h/JhBqb7uCOk7qx
	 rcWAt+THdGK+UTLmxrfF/N9OucVOZpAZ1lIqNjbsoaxDLQl3zQSfD1hc0vQYUEU8z7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zu9pIQlr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3191606A31C;
	Thu, 19 Nov 2026 01:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zu9pIQlr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092EF1F000C4;
	Thu, 19 Nov 2026 01:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053393;
	bh=+S3dhiI8IDZUq8NHlGlrWNwvPeTLEvmHhOZlpHMR2+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zu9pIQlrw3zTuJGUUir5NAM9GvJM29CEEc3me4bVLsLxTqM2RQFOriYUBtILMOtW5
	 bQSdfNqLA4G8X3G1bE9Mgs5BhYWirVOsmmDNNLa8D5ciCleBtJxh8CqLpUhxcLgxND
	 Bo48pxy11F88Qi+7z3aAvR1Oba2BMHueLWXC0qZo=
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
Subject: [PATCH 5.15 0905/2214] mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
Date: Wed, 18 Nov 2026 15:43:01 +0100
Message-ID: <20261118150048.477788196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4998b4c490529..e5c54f39e7e04 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3481,8 +3481,8 @@ EXPORT_SYMBOL_GPL(unmap_mapping_pages);
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



