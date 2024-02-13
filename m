Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60AA633E3
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 21:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707861249; cv=none; b=SOYdbAwlLPiphG+A/RHWz1WMXNDzexBT7ItPphzPhGAH3+gmSk74Lr0v4v56EXUVXb6jq1/M3z5SnGXhTgDzZ14gUJKxTTXuU/Xl97XSDxJ/5zdS07d+Up1MIhiL1kpAwZO6mIbC4VX/mQcIQOJNAMBb9Lv5YM2lXL/6gsbx1DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707861249; c=relaxed/simple;
	bh=YEjdCuL5yKWkN7QxzBGvlvpObgsWijJH0+E1q3ZXhVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMmCi+GqX7kzzBSLHv/CHDUcbVRK8eipRGaQWl1uWQDPlB5vTrkil4wWRI4AjvnzPt44IDjuA0egDIG6zVIcBYAyQqhb8FjRbBDWFWAJJfYG+CaXsFYyVA4Yao9aNQSK3rfyjUrBNvWDx0P9JmZdtMzPuCs5sYmFfQaYGHS02pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=TbDErWqQ; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="TbDErWqQ"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dcbc6a6808fso2072080276.2
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 13:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1707861246; x=1708466046; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YiSBrgcNMXQpKrdt+zpe9I2vnZuMe+BZLRs60AOrzNE=;
        b=TbDErWqQ8euwfNaEwbS2OoycQAteR/hloWtzhZXbbs3JgUT4nUTQybADqeqBdhSPne
         WnsMFF6ZDl+GPwQ+FMpnu/Z8Bw6ksHdRFr5+qdFt6V/+vmOQSGj6yEzfrdOO9nZtYi9E
         SUKcjrfPRBwYWpHXKVt+oTWl8UNSSGn+pTOSx1EeHsMzKfe6qrJL1sKLg53Vp8pmTuzp
         zFONkLnjt2CTGAwF6zdBO/uEkQoniCj4jvC/BmfElzxa9WX58EsfBA9moOCXN+TwIiBH
         2Zr5peyqjKED/rdqkcuaFkyl1lcoSgsKbkpeso/FvmUMDyJyksFnMsjqGB9BNj1oOjef
         eI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707861246; x=1708466046;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiSBrgcNMXQpKrdt+zpe9I2vnZuMe+BZLRs60AOrzNE=;
        b=l8GwPAu1c2GtvlPW3gzaXGFFog02QLRDulCiatW8uVhyheFfqlxr8xZpE/C6aCPebe
         D0Y5Q5w8NBZuDybxkB7qbl0CrRqXo30n9nJp1x7kIOym05TyCFd2TmeypqSgRhruhVNQ
         xg6s39+gzL6IN+96nMHFizXQeYP+sT7mpXnqy9gI682ml6nW2cDOsPg2+4E9VOSixMvB
         FldwaaFHT12TgCS+ZZAmUY7CFGlhHVPpS/vO6LCpWDVQWfQarQPCFxLDqppkf3+6diWD
         972/EqMloggxS7xdmUcnFigLxWTjMkkSca8PN8/xLsdDPLRmCl1DwMF0HB/8yvooEuYs
         sRuQ==
X-Gm-Message-State: AOJu0YzN7ThJjlKinSJksh5EvshPTXTrjM/sd7362t7b5PAXDNsWWt5z
	44pJKs11/zUP4+fZaQMjjAtEPgocrWbsriqTHl52NuqoQOYWN96qCICgmICNhWQ=
X-Google-Smtp-Source: AGHT+IG7XT1xWxLdCMIuHT7v3IZ8xvZzw9XxT1zTWnvHpxQ1DM2esqyBQHDjfIdFgaoG1gaLpqac+g==
X-Received: by 2002:a25:abc1:0:b0:dcc:e187:6ceb with SMTP id v59-20020a25abc1000000b00dcce1876cebmr394122ybi.17.1707861246660;
        Tue, 13 Feb 2024 13:54:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVt4Jq9WCh3PPzLc9Rru/Znz+w8p5oCzAbhntF/R9kGUvW2+iVP33MpHUbOsAc0ZJSY4hmw8YLG0NB6HACBYfGHRcAi6CLvFhgZmiOWi8dlQmB4xyli1TlZhRp4Or+jOIJdIFnaIkT61oqSyliPNA+OXjzHsiDgJ/RgHJBtfzBJxgJb0tw3xINsVOoxXAPWQSceU/NiWk2CCVyb35ShTv+Z1C58rKZzV1SXTEONW3hj+QKHT1wOdonLqq4yXMJqsA8StYwFa7pn7Q==
Received: from [100.64.0.1] ([170.85.8.192])
        by smtp.gmail.com with ESMTPSA id z7-20020ae9c107000000b00787164b8af6sm1300818qki.125.2024.02.13.13.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 13:54:06 -0800 (PST)
Message-ID: <cb0ec33c-fe3e-4384-baf7-3cdc15e2bcd9@sifive.com>
Date: Tue, 13 Feb 2024 15:54:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 085/121] riscv: Improve tlb_flush()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Jones <ajones@ventanamicro.com>, Palmer Dabbelt
 <palmer@rivosinc.com>, Sasha Levin <sashal@kernel.org>,
 Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20240213171852.948844634@linuxfoundation.org>
 <20240213171855.473974449@linuxfoundation.org>
From: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <20240213171855.473974449@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-02-13 11:21 AM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

This patch has a bug that was fixed in 97cf301fa42e ("riscv: Flush the tlb when
a page directory is freed"), so that fix should be backported as well.

Regards,
Samuel

> ------------------
> 
> From: Alexandre Ghiti <alexghiti@rivosinc.com>
> 
> [ Upstream commit c5e9b2c2ae82231d85d9650854e7b3e97dde33da ]
> 
> For now, tlb_flush() simply calls flush_tlb_mm() which results in a
> flush of the whole TLB. So let's use mmu_gather fields to provide a more
> fine-grained flush of the TLB.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> # On RZ/Five SMARC
> Link: https://lore.kernel.org/r/20231030133027.19542-2-alexghiti@rivosinc.com
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Stable-dep-of: d9807d60c145 ("riscv: mm: execute local TLB flush after populating vmemmap")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/riscv/include/asm/tlb.h      | 8 +++++++-
>  arch/riscv/include/asm/tlbflush.h | 3 +++
>  arch/riscv/mm/tlbflush.c          | 7 +++++++
>  3 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/tlb.h b/arch/riscv/include/asm/tlb.h
> index 120bcf2ed8a8..1eb5682b2af6 100644
> --- a/arch/riscv/include/asm/tlb.h
> +++ b/arch/riscv/include/asm/tlb.h
> @@ -15,7 +15,13 @@ static void tlb_flush(struct mmu_gather *tlb);
>  
>  static inline void tlb_flush(struct mmu_gather *tlb)
>  {
> -	flush_tlb_mm(tlb->mm);
> +#ifdef CONFIG_MMU
> +	if (tlb->fullmm || tlb->need_flush_all)
> +		flush_tlb_mm(tlb->mm);
> +	else
> +		flush_tlb_mm_range(tlb->mm, tlb->start, tlb->end,
> +				   tlb_get_unmap_size(tlb));
> +#endif
>  }
>  
>  #endif /* _ASM_RISCV_TLB_H */
> diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
> index a09196f8de68..f5c4fb0ae642 100644
> --- a/arch/riscv/include/asm/tlbflush.h
> +++ b/arch/riscv/include/asm/tlbflush.h
> @@ -32,6 +32,8 @@ static inline void local_flush_tlb_page(unsigned long addr)
>  #if defined(CONFIG_SMP) && defined(CONFIG_MMU)
>  void flush_tlb_all(void);
>  void flush_tlb_mm(struct mm_struct *mm);
> +void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
> +			unsigned long end, unsigned int page_size);
>  void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr);
>  void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
>  		     unsigned long end);
> @@ -52,6 +54,7 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
>  }
>  
>  #define flush_tlb_mm(mm) flush_tlb_all()
> +#define flush_tlb_mm_range(mm, start, end, page_size) flush_tlb_all()
>  #endif /* !CONFIG_SMP || !CONFIG_MMU */
>  
>  /* Flush a range of kernel pages */
> diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
> index 77be59aadc73..fa03289853d8 100644
> --- a/arch/riscv/mm/tlbflush.c
> +++ b/arch/riscv/mm/tlbflush.c
> @@ -132,6 +132,13 @@ void flush_tlb_mm(struct mm_struct *mm)
>  	__flush_tlb_range(mm, 0, -1, PAGE_SIZE);
>  }
>  
> +void flush_tlb_mm_range(struct mm_struct *mm,
> +			unsigned long start, unsigned long end,
> +			unsigned int page_size)
> +{
> +	__flush_tlb_range(mm, start, end - start, page_size);
> +}
> +
>  void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
>  {
>  	__flush_tlb_range(vma->vm_mm, addr, PAGE_SIZE, PAGE_SIZE);

