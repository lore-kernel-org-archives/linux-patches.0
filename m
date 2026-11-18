Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047256;
	b=B4JYatFEt5TAK0fp8ycYBTXp5NRBrNbv+2FCNsxCJNSXYYc3WRcc5dF6Yxte33NR4xNr
	 mt6HbQncZHb+TsA4RmsNcXe1Ex00ePEy3kTRFVS4yBe31cFTuWNh09l8DeP6+6yw5e94U
	 FYCnwMS4SrjsYco8TeOIJOe8ZvLSKjGZhaSE0xZoXPPDijQUBsO8kK43SWdPeByLHKoVS
	 rKT5DeE3u7PUaXioEYIhaGhQlnFVcmmMVl27e7infm9/xRFdq+81uVUFoct8ExoyQhQs9
	 bByHaxnT6n8Cop7AWabNaraHepTrRyOgsgg7EwnSqBBl6H7ili4CCDeZdUQR65cXgWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwIUHoo8x9ypbfzqJnV+LNi5/zip5wigmHrJbsl8EHA=;
	b=JlXfn9tseZOeQBdwxad+MzB5gbUWLq8cNz1+OgFHU4pi7Af6FkUznz/2XEsSEC+XaL+Z
	 LaSS5GfvujBwueeA4YpFgzpI0oysCDSCjKecmb7dAa6UhABR/Gskl/z6OmiGbpCowSJWV
	 ur7XhFgl0/sxCkbZg33oULwiofbKMh5UNqVZR6MBNorC2SIwuIessK2BG7OWS7Bd7AkqS
	 wydCRVXMJMylBsDgUi6C7ovlcQnCDqfIrHImFtH+GKCVe/ecIQdIG1w3w6f47KcmcF47j
	 iJqxfbDe1/Da/0WJVU8lIYiX5X4KJ7cHGAa1fdL4Da9hGsf7DajxtVWHCr0nwmMWmtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nKyisZp8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763EA606A31C;
	Thu, 19 Nov 2026 00:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nKyisZp8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895D41F000C4;
	Thu, 19 Nov 2026 00:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047256;
	bh=bwIUHoo8x9ypbfzqJnV+LNi5/zip5wigmHrJbsl8EHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKyisZp8dPhhBvyx4BVT0K0rHfHRTChYRIPn4HCHMdlmbsMF0hjXPvNDT/bC9DBit
	 desJ+7ujHXP9+ynDgrIZ30ieFOtT3qpiwLu6XWGCjC5CmJVl0lLE3ik0kpAu0/JYtL
	 q6eqX5Wyeign+wMMLILHj0jxx8oRa2sqezqZbyfA=
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
Subject: [PATCH 6.1 1574/2857] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
Date: Wed, 18 Nov 2026 15:43:28 +0100
Message-ID: <20261118150258.055665003@linuxfoundation.org>
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
[ sashal: adapted gup_fast_fallback() changes to internal_get_user_pages_fast() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b3b6de2c37c12..8629b2e145460 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3065,9 +3065,9 @@ static int internal_get_user_pages_fast(unsigned long start,
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



