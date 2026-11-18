Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059941;
	b=QeBO3vtwBye+BSuLfcrGJkpVd/QOKErVIpS5gk8QmEINpOg5x1DkGBy+lVSeKcMQA+ZA
	 TGW5mFBgRZvfKiKTsl2qIJNVUjOqLeRFSMoL41LfyyBnLKjYLaTXGxu51alGD0XPYu7Ty
	 54xfa2As6P5vmmWBowD/rh8fXGSeEAYJw140Uvvjm7yhPoWoV98kRi5vLZ6Tb1UY8CoeS
	 m1lzgLCjpFgwqT8r096XTrrTP/b0GCTancyaQ35OidpbToVtIRYkDjnBnIs7WvtYkSU0s
	 uQFMz/LA7NuMQXF/XdL6/aULtxEyiqHU/vREhECVfxg+qtOpbgLgcNjGXbHa8XNm6Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2tYR31G2eG/8tkg+ovPjczzzvKfePRxqWEfHwzPgV8=;
	b=p/WZH2mq4VJj+UWyaKdBJs3um2PLxjLMySPfoURmPhqZLqsPVm57+JNOC6h+JdoOPVZ1
	 fztSq+BRolffP7M84AH+ucdxIeVz6+iNQPCWy72tAa5Jnu+VBoC6feaQ5tgn//Wj90bQL
	 TAKywAyLanrYEFhdFSmp0H7hSiX1zR8RFa128xbcB9e0Htm8Vu9gi0dO4rpWpzsTwPQjK
	 tpmiBeO57lGtRDN0lMK6UF0+vxs8g9PRsjk+fBCywjUPnbghLU/D2k09lEB9+p39lGek6
	 dIrhpqasn3FMw3ud7UMB38BbGEohQXIHBasKtK6Ew1P39eHd1+zuiWqTOB0X3b83tLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olHQZQJY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653F0606A325;
	Thu, 19 Nov 2026 03:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olHQZQJY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B807E1F000C4;
	Thu, 19 Nov 2026 03:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059941;
	bh=K2tYR31G2eG/8tkg+ovPjczzzvKfePRxqWEfHwzPgV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olHQZQJYUPhbIpeHKl89nfy8CWitLqH01HFOeQxJZcDmsa+ErjxDfPS8MvxnGeIwl
	 +qBfPKSiE18q97OioiGe/C5eD84d6ZDC4iLgYg8/Fa4XrvJAt2FA3gmxgt4/IrQf6G
	 5IVnMFWqsx6pIrqDnwIUpGdAetwB/ALffq8g+Pbs=
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
Subject: [PATCH 5.10 0980/1848] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
Date: Wed, 18 Nov 2026 15:50:18 +0100
Message-ID: <20261118145957.953638818@linuxfoundation.org>
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
[ sashal: adapted the check to internal_get_user_pages_fast(), changing its existing overflow return from 0 to -EOVERFLOW ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index e1fe283badf3b..f9316a91df521 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2753,9 +2753,9 @@ static int internal_get_user_pages_fast(unsigned long start,
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



