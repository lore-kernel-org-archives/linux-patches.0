Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADEB483833
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526543; cv=none; b=YR/Af64q0d9OvOVgKULXNp78BhTYAiqOHOorVDlxOj4rVomjVqSpfRv+2OD65uSHhhO8Dwkx8lR4SRPBJRsgMgz78IchAfUFe14bsG3zqkDmoc9/Pjx4ZkwKWwdzmM3BUHqUzxkhFyH85EIEwgkWMxB/lzLtKtHoAuNpOSoYNkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526543; c=relaxed/simple;
	bh=+z90C1dIxuN3pgN0nJTwAm+SZfruPKtHgx3WGuwaIP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ea8rWbQGh/E19UphtZzzOUZ+7rNpN337CcOqDQZt0rccFFFwRXlTbKweUHWjPp5EkoQY7fOQxzYRkDvD3kOUgT8kpCMZbWJtscaS2VhWUvhaHlfOIB0RnvwvVIZjvFZSheiSZEd05lecY+g4dbPAYbd9fAKe80k0/ndlmJONqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=BIqK0yIG; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="BIqK0yIG"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 4235A14C2D6;
	Fri,  4 Sep 2026 14:55:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1788526537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=StSS6oP+AvTyHvCs3vmIoWdy/517Or5V/rjbqe5eT6o=;
	b=BIqK0yIGniIARLUL+br0OIoQOVtlo4ky7nnLRmzg34rC8pQ+v2YTXt/cgPGr53twcqdnlt
	7rV4BCBGp5nX1fzyXyvCzwfTqT1RV2xnEy+tWNVEehqDjGmjDh9/WMvzDo7cspsDjiJH+j
	TxQcWPDq32KlkESX5Jalj/p+oLc1Fmu0H1AYiZXdD6fsv3foFSEusauY6rl2rcfgX57Hjg
	FO7MNgjqpF6L6Vzj6kZIlvG/N2WUu0Lqj/7ZHBvBE2sVsGZGla6Xo4oemJbzinEChkkPRO
	nTcBt0iKYZ+PtXjj7W8j8L/7dfJkp06+gFyp3lzzyBA4bt7R1ctNk2BfP69mFg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 49cdb7e1;
	Fri, 4 Sep 2026 12:55:30 +0000 (UTC)
Date: Fri, 4 Sep 2026 21:55:15 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/403] 6.12.109-rc1 review
Message-ID: <apq_s8mFJJPzoIdo@codewreck.org>
References: <20260904045734.806166532@linuxfoundation.org>
 <apqKYeQe-78JWI3u@codewreck.org>
 <88e9b4e7-284b-4943-b0f7-97795d63991b@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <88e9b4e7-284b-4943-b0f7-97795d63991b@nvidia.com>

Jon Hunter wrote on Fri, Sep 04, 2026 at 11:34:27AM +0100:
> On 04/09/2026 10:07, Dominique Martinet wrote:
> > 
> > > Dev Jain <dev.jain@arm.com>
> > >      mm/page_vma_mapped: use huge_ptep_get() for hugetlb
> > 
> > This fails build on arm (config attached)
> > 
> > CC      mm/page_vma_mapped.o
> > ../mm/page_vma_mapped.c: In function 'check_pte':
> > ../mm/page_vma_mapped.c:103:25: error: implicit declaration of function 'huge_ptep_get' [-Wimplicit-function-declaratio]
> >    103 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
> >        |                         ^~~~~~~~~~~~~
> > make[3]: *** [../scripts/Makefile.build:229: mm/page_vma_mapped.o] Error
> > 
> > 
> > Don't have time to look further right now, might have a look after kids
> > sleep if nobody beat me to it
> 
> 
> I see the same (appears to break 6.18.y too) and bisect points to ...
> 
> # first bad commit: [25fb3e9ad3b665b57e218dafb58acd13b1a672b7] mm/migrate: use huge_ptep_get() in remove_migration_pte()

Yeah... So this builds on master because this commit:
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


With that fixed, build passed, and I don't see any other problem in
tests either (arm target still running, but having looked at the diff I
don't expect any failure, will report within ~30mins if something else
comes up):
Tested ee6921fed8a4 ("Linux 6.12.109-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

Thanks,
-- 
Dominique Martinet

-- 
Dominique Martinet | Asmadeus
