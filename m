Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E7234B1A3
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 11:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788608988; cv=none; b=n8Vd3vEHx/lPQjMWsprUwEkYyd9M6ZyzNwiaK5Dc+ECfCDNNZN9BJ/ypHzo1CC1bxaSyWu9Bg9H7zjdrGFc1yafwuIAaxptOIN9klddlPRCE9iaOs7wwQIMgP4sA5hGxUm8gl7zLtykewbzwGcF0l62RWMhGOqCoAwFikEME3xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788608988; c=relaxed/simple;
	bh=75R0SyjY2VntmHcW+KcrtdNx25trMvyoyeBa7ykzQXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcBlJyFC4nZjaq84D9+VxeIXjtIiBwm74G6fQIW96IpCSDDMTi1ucNBU+QVCQsgJXNz27StaPr0CVSKA5hPMId7a6fcGQKmj5B7WwyRBm05i17lb3UDedzGRUT81zEzI2ZBcUfwhd2eEBn9Dbcq1bDLQatCWdm1QHUk6DjWOh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=MRiP0p+A; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="MRiP0p+A"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id EB42014C2D6;
	Sat,  5 Sep 2026 13:49:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1788608970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Bu7zhBODPx9OVIj9kI9Cw1nNDBcCS9dXlz9GgaYwCk=;
	b=MRiP0p+APtwWGq7nqcMTUXcXnX1Rp4Ot3CBYsNBuCSxEDHzaM37F3IZw7rUw7zihCjh19l
	IKEli+6W7tjafk9BZVuzO5RCsDb46aUQn0VOifmyYJXqj07Dh0YaBAgfvy4cMmotZxUc+6
	gur34LYPLAa0pJP4OulRrjRHanfS9sYO8tikO2hODNpfZsJ2w6nX3QZre7n4zB4sJpxVO7
	6p+3MJkGAILxtpSHRK3niKb+p+9zzn/DBBgPW0I7hvn1/aMaBuVcv6dj4bf/bQ8SDCM0Zj
	kpPQhAdanri4iEvqS2vR2vXhMnytBJ4tTo0nfqBJwFLeE7it5Msx3a2Er5/zRQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id e27ca948;
	Sat, 5 Sep 2026 11:49:19 +0000 (UTC)
Date: Sat, 5 Sep 2026 20:49:04 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Message-ID: <apwBsCGpUG69KdGc@codewreck.org>
References: <20260904045747.813364717@linuxfoundation.org>
 <20260905114111.124795-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260905114111.124795-1-ojeda@kernel.org>

Miguel Ojeda wrote on Sat, Sep 05, 2026 at 01:41:11PM +0200:
> I see the same arm32 build issue:
> 
>     mm/page_vma_mapped.c:110:11: error: call to undeclared function 'huge_ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>           |                         ^
> 
> In addition, in UML (x86_64) there is also nearby:
> 
>     mm/page_vma_mapped.c:110:9: error: assigning to 'pte_t' from incompatible type 'int'
>       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>           |                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       111 |                                       pvmw->pte);
>           |                                       ~~~~~~~~~~

See this 6.12 thread[1] for this build failure (I didn't check but
assume it is the same, that missing commit only made it 7.3-rc1 but was
also backported to the 7.2 tree, which also explains 7.2 didn't build
fail)
---
This builds on master because this commit:
f5407e9b697c ("mm/rmap: use huge_ptep_get() in try_to_unmap_one()")
added a function declaration in linux/hugetlb.h !CONFIG_HUGETLB_PAGE
code:
```
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 817b8b4223fa..95b1b6ee1f96 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1270,6 +1270,8 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
 
+pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
```

The rest of that commit isn't applicable, so we either need to roll that
change in 'mm/migrate: use huge_ptep_get() in remove_migration_pte()' or
add it separately (or drop that commit)
---

[1] https://lore.kernel.org/r/apq_s8mFJJPzoIdo@codewreck.org

-- 
Dominique
