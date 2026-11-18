Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054158;
	b=QM0qfIBaBzStMdgqAjDrGDL+wo7TdxYLNwiSc38JaF2qi4pVL+sSo5YZE67D8hUZL1t6
	 J54VWFkk7hnZFTZbhenefLPnNZEBR1L9wXMHNslRR+KuGhlK+QwO0tZ+QeRdj7MhJ60ob
	 dPznZ5V+v3lYIhZlmD9rJ7NSyVcpy78ZtynnyksqfqHPomz9lp5MWW/Nrg3hTCaciX6rH
	 GIRAufUfkpLxVZ5rB6ieAySXIORNqDc1RMgj5nAeK+/nTpj1gFERUPtoX6FNywqTa4lhQ
	 J5CmtNVB2z4Z9y2kl3lTEtnCOwA7l4RY0vXIOrCRNqB7POVxjD2wgLQ6ktWr461hSTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KWOCC/H5NFYKWOCyUW6rQo1M/QewNSSZYgrfyX+SSz8=;
	b=aoivjTqGByiwCXLD/aiyrE558i9dVKmjqO5qBjSIiEJqy81Zyb2GcwSYmqcTTshsPZ4D
	 6Lqbqbbr6qwVU8zV/8eaVwpLnK7yj+Y0ySa1ojHlQbfGlwGmsCPZXiziarQqY9vQ8YMXF
	 wZJij5b/UkRPb0QDHBsSxbXhd31ylDotmLJwB0Nwm7BnJT6VulTjziym040BrTh8NrXd6
	 OM/Imj7RHnjbpJwoqS5kyRTo3OCLN5pWjXt9FWXefSKUxGxnWvNZgI4vOnXT6mlBUOLYH
	 0MmepszB1/WYufeRQ0fhW5D8SoLvFs4/38hOFL1BoAIeEZkYLxi2noWT9e7y1Ctm10Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIpOcZVk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0ED606A331;
	Thu, 19 Nov 2026 02:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIpOcZVk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC5F1F000C4;
	Thu, 19 Nov 2026 02:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054158;
	bh=KWOCC/H5NFYKWOCyUW6rQo1M/QewNSSZYgrfyX+SSz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIpOcZVkHmyRhDujS9cmCxMHA7m+M7vqCpSWDwAr7w7rjXU/76ITCiDMDfc72QMxS
	 e+e9BzXLQwn0+zUYivHE1pLMx4iER5wSh6VnFLfgCqegm8P3Bjp0B6wVz5IkYvXku4
	 HE4J4oSm4mwBJwB4u8YzsC58FobgAUcouakpwqjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1175/2214] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
Date: Wed, 18 Nov 2026 15:47:31 +0100
Message-ID: <20261118150058.979743246@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 21a3888d3d2f87b7f15ccea1f0befd57346fe899 ]

The overflow check in gup_fast_fallback() only covers the addition to
start. The preceding nr_pages << PAGE_SHIFT can already have truncated
the length on 32bit.

Users such as RapidIO's rio_dma_transfer() can derive such page counts
from a 64-bit userspace length.

Let's just check_shl_overflow() to reject any such overflow with
-EOVERFLOW early.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-22-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: adapted the overflow check to internal_get_user_pages_fast(), changing its existing failure return from 0 to -EOVERFLOW ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c1508281c2f93..3f828fb456e2c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2898,9 +2898,9 @@ static int internal_get_user_pages_fast(unsigned long start,
 		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
-	len = nr_pages << PAGE_SHIFT;
-	if (check_add_overflow(start, len, &end))
-		return 0;
+	if (check_shl_overflow(nr_pages, PAGE_SHIFT, &len) ||
+	    check_add_overflow(start, len, &end))
+		return -EOVERFLOW;
 	if (unlikely(!access_ok((void __user *)start, len)))
 		return -EFAULT;
 
-- 
2.53.0



