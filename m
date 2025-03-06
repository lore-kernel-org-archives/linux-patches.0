Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D251DDC1A;
	Thu,  6 Mar 2025 08:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741248437; cv=none; b=L87sioYI7GzA8DexGG9T9ZVAr/KVGwu7nfLcCn/EoypqHGC2KUopB3DP6MHyLSDM2F425rDDR0nPY6OpX8CFVagEfGrGzz0TzsmKorPd95ocG89eghelM1d6iJKiCpi1cxB+m7iD74qLBoiSx4q9Ag2Rlo36lUYYsd3KHfOlLkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741248437; c=relaxed/simple;
	bh=F+DVaW0MEn8CkvIYJ6JT4xQvSti4q5vM94PkBIoV8fU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWlVQJZtzyLW/toI5p2HKNs3V/QoP0GcYFYBq2leH2prYgHPTlEBYXYMKvbifD1tGlEcJo+jz+txm0sgrRdTsthcCd6rYYa1WSu+9kg5Ss1yYvsu+EXfLZlKihE6efMamy8uc0K1EX7iHZ7oiuLGOEkZgdyDSbf5QR4/SQfrDGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcXQAeGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcXQAeGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B60C4CEE0;
	Thu,  6 Mar 2025 08:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741248435;
	bh=F+DVaW0MEn8CkvIYJ6JT4xQvSti4q5vM94PkBIoV8fU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UcXQAeGSJYouXPqztIk8Tm/A7brrV7d8uP+Tlmbbz/SPIatQM9KXVmC6RyjiBfcp/
	 Yje2jaCaE0zbXK6Fotyp6r01mGT8zcsJPvWsVak1EPK9U0+dvyVgDZ0vrA8y7SHdMg
	 tAiUSXRnSgowx/sNdLJZjeRxIButoTHAroRe692DKPA2C6a62n2nkA6v+EOgbaUCOi
	 gj+0ox+KtMXPM2FNDUvbVOLB2DA7rRpXUHZbe+sNnOuK5W2p7y6NE+fyDWJadwI8gd
	 tn1J1POBHAcgfvPXp/0NpihOE4VDoEDpq8O9gDM/jOhmpQm7J2H1Nv8b9AetYCFULs
	 8JKe5OxnrXvYQ==
Message-ID: <ebf8b6fc-33b8-408b-aeac-96b8495753e6@kernel.org>
Date: Thu, 6 Mar 2025 09:07:12 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 100/157] arm64: hugetlb: Fix
 huge_ptep_get_and_clear() for non-present ptes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174509.330888653@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20250305174509.330888653@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05. 03. 25, 18:48, Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.
> 
> arm64 supports multiple huge_pte sizes. Some of the sizes are covered by
> a single pte entry at a particular level (PMD_SIZE, PUD_SIZE), and some
> are covered by multiple ptes at a particular level (CONT_PTE_SIZE,
> CONT_PMD_SIZE). So the function has to figure out the size from the
> huge_pte pointer. This was previously done by walking the pgtable to
> determine the level and by using the PTE_CONT bit to determine the
> number of ptes at the level.
> 
> But the PTE_CONT bit is only valid when the pte is present. For
> non-present pte values (e.g. markers, migration entries), the previous
> implementation was therefore erroneously determining the size. There is
> at least one known caller in core-mm, move_huge_pte(), which may call
> huge_ptep_get_and_clear() for a non-present pte. So we must be robust to
> this case. Additionally the "regular" ptep_get_and_clear() is robust to
> being called for non-present ptes so it makes sense to follow the
> behavior.
> 
> Fix this by using the new sz parameter which is now provided to the
> function. Additionally when clearing each pte in a contig range, don't
> gather the access and dirty bits if the pte is not present.
> 
> An alternative approach that would not require API changes would be to
> store the PTE_CONT bit in a spare bit in the swap entry pte for the
> non-present case. But it felt cleaner to follow other APIs' lead and
> just pass in the size.
> 
> As an aside, PTE_CONT is bit 52, which corresponds to bit 40 in the swap
> entry offset field (layout of non-present pte). Since hugetlb is never
> swapped to disk, this field will only be populated for markers, which
> always set this bit to 0 and hwpoison swap entries, which set the offset
> field to a PFN; So it would only ever be 1 for a 52-bit PVA system where
> memory in that high half was poisoned (I think!). So in practice, this
> bit would almost always be zero for non-present ptes and we would only
> clear the first entry if it was actually a contiguous block. That's
> probably a less severe symptom than if it was always interpreted as 1
> and cleared out potentially-present neighboring PTEs.
> 
> Cc: stable@vger.kernel.org
> Fixes: 66b3923a1a0f ("arm64: hugetlb: add support for PTE contiguous bit")
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Link: https://lore.kernel.org/r/20250226120656.2400136-3-ryan.roberts@arm.com
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/arm64/mm/hugetlbpage.c |   51 ++++++++++++++++----------------------------
>   1 file changed, 19 insertions(+), 32 deletions(-)
> 
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -100,20 +100,11 @@ static int find_num_contig(struct mm_str
>   
>   static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
>   {
> -	int contig_ptes = 0;
> +	int contig_ptes = 1;
>   
>   	*pgsize = size;
>   
>   	switch (size) {
> -#ifndef __PAGETABLE_PMD_FOLDED
> -	case PUD_SIZE:
> -		if (pud_sect_supported())
> -			contig_ptes = 1;
> -		break;
> -#endif
> -	case PMD_SIZE:
> -		contig_ptes = 1;
> -		break;
>   	case CONT_PMD_SIZE:
>   		*pgsize = PMD_SIZE;
>   		contig_ptes = CONT_PMDS;
> @@ -122,6 +113,8 @@ static inline int num_contig_ptes(unsign
>   		*pgsize = PAGE_SIZE;
>   		contig_ptes = CONT_PTES;
>   		break;
> +	default:
> +		WARN_ON(!__hugetlb_valid_size(size));
>   	}
>   
>   	return contig_ptes;
> @@ -163,24 +156,23 @@ static pte_t get_clear_contig(struct mm_
>   			     unsigned long pgsize,
>   			     unsigned long ncontig)
>   {
> -	pte_t orig_pte = __ptep_get(ptep);
> -	unsigned long i;
> +	pte_t pte, tmp_pte;
> +	bool present;
>   
> -	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++) {
> -		pte_t pte = __ptep_get_and_clear(mm, addr, ptep);
> -
> -		/*
> -		 * If HW_AFDBM is enabled, then the HW could turn on
> -		 * the dirty or accessed bit for any page in the set,
> -		 * so check them all.
> -		 */
> -		if (pte_dirty(pte))
> -			orig_pte = pte_mkdirty(orig_pte);
> -
> -		if (pte_young(pte))
> -			orig_pte = pte_mkyoung(orig_pte);
> +	pte = __ptep_get_and_clear(mm, addr, ptep);
> +	present = pte_present(pte);
> +	while (--ncontig) {
> +		ptep++;
> +		addr += pgsize;
> +		tmp_pte = __ptep_get_and_clear(mm, addr, ptep);
> +		if (present) {
> +			if (pte_dirty(tmp_pte))
> +				pte = pte_mkdirty(pte);
> +			if (pte_young(tmp_pte))
> +				pte = pte_mkyoung(pte);
> +		}
>   	}
> -	return orig_pte;
> +	return pte;
>   }
>   
>   static pte_t get_clear_contig_flush(struct mm_struct *mm,
> @@ -401,13 +393,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
>   {
>   	int ncontig;
>   	size_t pgsize;
> -	pte_t orig_pte = __ptep_get(ptep);
> -
> -	if (!pte_cont(orig_pte))
> -		return __ptep_get_and_clear(mm, addr, ptep);
> -
> -	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>   
> +	ncontig = num_contig_ptes(sz, &pgsize);


This fails to build:

/usr/bin/gcc-current/gcc (SUSE Linux) 14.2.1 20250220 [revision 
9ffecde121af883b60bbe60d00425036bc873048]
/usr/bin/aarch64-suse-linux-gcc (SUSE Linux) 14.2.1 20250220 [revision 
9ffecde121af883b60bbe60d00425036bc873048]
run_oldconfig.sh --check... PASS
Build...                    FAIL
+ make -j48 -s -C /dev/shm/kbuild/linux.34170/current ARCH=arm64 
HOSTCC=gcc CROSS_COMPILE=aarch64-suse-linux- clean
arch/arm64/mm/hugetlbpage.c:397:35: error: 'sz' undeclared (first use in 
this function); did you mean 's8'?
       |                                   s8
arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclared identifier is 
reported only once for each function it appears in
make[4]: *** [scripts/Makefile.build:197: arch/arm64/mm/hugetlbpage.o] 
Error 1

>   	return get_clear_contig(mm, addr, ptep, pgsize, ncontig);
>   }
>   
> 
> 
> 

-- 
js
suse labs

