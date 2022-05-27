Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5927C
	for <patches@lists.linux.dev>; Fri, 27 May 2022 23:45:02 +0000 (UTC)
Received: by mail-lf1-f52.google.com with SMTP id c19so8992140lfv.5
        for <patches@lists.linux.dev>; Fri, 27 May 2022 16:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IALt29wlC4JKslLVMsLFRhR5StYJLg09Im2CzgSWtjU=;
        b=BSKfdkBpBFTf6f+PiPWq/EXSKA9i8id4uv80ipDYcRnsAuJgnz/nDzvg02VDbWclCK
         1TAP2co9doBzOdEdmkdVHP8qaNrTPtRuT7tuB4UXYWjHiP/oWai5WXRAVAtk8lZJeJik
         zzPZ5AQ/Epvcm6XRPzH+jWa0V+SFaFv+OGLsrS5r+m8oB253MVhhyqZL447hADuQyV/y
         0Nw031lvGm96EZhNUMbUaK4GF3vPSZO4tONyWX2dqdmllE0icr1nUcfAF1zNjNLeSSkl
         zCA+TmnbcOmXugIUnJ8to7IfOB1iJr1RLAiQPDxiXgFXwZMeedcnL2Mva5gSpKT5gaWg
         qJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IALt29wlC4JKslLVMsLFRhR5StYJLg09Im2CzgSWtjU=;
        b=kHuD9VYcWumwliMli/KR2Q2X82oO1z7SqNYyEbdUfRRS65TDPHs4guQAeQYSM/5zmC
         gxTmJQqczfQphGT2aUr3uXkq0Z9lDbtY3bfzqXCIM7st3Ax39VR4yBbCJCU4zMVC2QQm
         1ZieVsLlIweZfe1q9FuxlrfJWaS6zWgWXQE0AyxavInPlGFG/VLZrWwPYsQUl+v/wxQS
         M4S+sIrPzHIHv7aXs7UC9aLMTR5+Uo8e9161Tlmbf90apg/rwOHRODtCCP4RhRUkSpXm
         Fo/BSJpIrXxB3W1fX8qPqWd0ysSuabVVAkViff5qi/fFUMRU0+JIDe11G/Z0Typar9rd
         dVNA==
X-Gm-Message-State: AOAM530kSHw23T9RLpmVcCZFZp6f/TKlESSDM8gtqgZtx/Ui6zzQl+eV
	l2M3mlD1b2u4ft1SibM7r1Pikw==
X-Google-Smtp-Source: ABdhPJztWwtE94iIyLx6oVtYfG/pmmvgHHVHI/8vyuAAuATDZ9rdARTLukXZNRS229FkwcWe0iv5VQ==
X-Received: by 2002:a05:6512:130a:b0:477:b632:27eb with SMTP id x10-20020a056512130a00b00477b63227ebmr31008546lfu.131.1653695100867;
        Fri, 27 May 2022 16:45:00 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id q20-20020a05651232b400b00473c87152bcsm1061360lfe.127.2022.05.27.16.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 16:45:00 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
	id 783451094B9; Sat, 28 May 2022 02:46:57 +0300 (+03)
Date: Sat, 28 May 2022 02:46:57 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
	mgorman@techsingularity.net, willy@infradead.org,
	liam.howlett@oracle.com, hughd@google.com, riel@surriel.com,
	rostedt@goodmis.org, peterz@infradead.org
Subject: Re: [PATCH 2/2] [PATCH 2/2] mm: add merging after mremap resize
Message-ID: <20220527234657.nsn6e7jjwttblzyi@box.shutemov.name>
References: <20220527104810.24736-1-matenajakub@gmail.com>
 <20220527104810.24736-3-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220527104810.24736-3-matenajakub@gmail.com>

On Fri, May 27, 2022 at 12:48:10PM +0200, Jakub Matěna wrote:
> When mremap call results in expansion, it might be possible to merge the
> VMA with the next VMA which might become adjacent. This patch adds
> vma_merge call after the expansion is done to try and merge.
> 
> Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
> ---
>  mm/mremap.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 303d3290b938..c41237e62156 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/mm.h>
> +#include <linux/mm_inline.h>
>  #include <linux/hugetlb.h>
>  #include <linux/shm.h>
>  #include <linux/ksm.h>
> @@ -1022,8 +1023,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
>  				}
>  			}
>  
> -			if (vma_adjust(vma, vma->vm_start, addr + new_len,
> -				       vma->vm_pgoff, NULL)) {
> +			vma = vma_merge(mm, vma, addr + old_len, addr + new_len,
> +					vma->vm_flags, vma->anon_vma, vma->vm_file,
> +					vma->vm_pgoff + (old_len >> PAGE_SHIFT), vma_policy(vma),
> +					vma->vm_userfaultfd_ctx, anon_vma_name(vma));

The arguement list gets busy. Maybe some variables would help.
Calculation around vm_pgoff is not obvious and requires some explanation.

> +			if (!vma) {
>  				vm_unacct_memory(pages);
>  				ret = -ENOMEM;
>  				goto out;
> -- 
> 2.35.1
> 

-- 
 Kirill A. Shutemov
