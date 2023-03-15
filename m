Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1446FC3
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 21:34:29 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id q16so18569649wrw.2
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678916067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YLcjo2B8r8ivBq3i6ffImqlDDisi96ITVWAL0NlihTo=;
        b=Q64A6ZlDe5txZwdIUjX+vFEyMP6wKCYqWXROUtY4u6Fzsu5wQ9rLiTGSaJ0Rr6jt94
         tgMo/mBSJw4LF/KTiq+sl/bTusFDK3VNr1dk0sy3aAUC2Sz9c5WnXSRRylLgECuCQF8A
         5IiGAKV+d/4ZHvfHrp/qAWGGhlMj0F1f3nLjzqz4IjZ6O5wg1U9chV4DSgHemsTNIRpF
         7LZKkk6H769QEmaeN0FrgvRc3OWATWb7vTXtc6CIm1AZ4OhL4Pm+zEcUxG6pWnL/tX9d
         tWi+svkYEdpkR2Pod1Ik+eHLTqEm7wXUJjgxchr7uqyDhEutb7XGC5MIGrSXottX+Apr
         gUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678916067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLcjo2B8r8ivBq3i6ffImqlDDisi96ITVWAL0NlihTo=;
        b=Dmc/AUohRRLrC0Gn2u0uRvsdTyJfdVgUdBaP4UeXo65itTsoAF/KSOzLUvjm8JZppg
         ZBdnPKs2CfBcbdDPJWRY7l6PD5743C3wzSWILdk+WrP5C2g/x7K1km3rRi4S4J3Xh2Ft
         ikuZjS8P77aS4KrSWDA+sMQan1cr9Qxr25ejznNLURG0bPNiXXrUb90tJ6m+EMrnPaj+
         DT/W/QTgOna1diafXDV5PrXuGEw9HK/4QZ1M2nUwju6bsuKjfXtFmMIaQNWENTiY2g/9
         OI73jaUN/HRDxfT7mEFs+C6dAiobPIGLmiot6NT+38c+Fvypi91S2E1wSz4hhXOBvGJ3
         Qrqw==
X-Gm-Message-State: AO0yUKUbkwqLIUrs5/LcjRNwZsFy++ipg4z/RuJjQPu4Wt3u1MRsx9Lk
	hYeEVTdAFq3zV8Upfit5Nf0=
X-Google-Smtp-Source: AK7set8I+as2cu3fa3E4ag8Ty+sXQ8g/o8JmFF1c5BVKl1eVfu8Jzv/xGyDQJiKEbVuprWssmI7beg==
X-Received: by 2002:a5d:5003:0:b0:2cf:3396:9126 with SMTP id e3-20020a5d5003000000b002cf33969126mr3277124wrt.10.1678916067184;
        Wed, 15 Mar 2023 14:34:27 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d4a8d000000b002c5534db60bsm5588826wrq.71.2023.03.15.14.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:34:26 -0700 (PDT)
Date: Wed, 15 Mar 2023 21:34:24 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 06/10] mm/mmap/vma_merge: set mid to NULL if not
 applicable
Message-ID: <388605ee-261d-4aa9-8d75-4afbee87adbc@lucifer.local>
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-7-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309111258.24079-7-vbabka@suse.cz>

On Thu, Mar 09, 2023 at 12:12:54PM +0100, Vlastimil Babka wrote:
> There are several places where we test if 'mid' is really the area NNNN
> in the diagram and the tests have two variants and are non-obvious to
> follow.  Instead, set 'mid' to NULL up-front if it's not the NNNN area,
> and simplify the tests.
>
> Also update the description in comment accordingly.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mmap.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index be60b344e4b1..3396c9b13f1c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -848,10 +848,11 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
>   *
>   * The following mprotect cases have to be considered, where AAAA is
>   * the area passed down from mprotect_fixup, never extending beyond one
> - * vma, PPPPPP is the prev vma specified, and NNNNNN the next vma after:
> + * vma, PPPPPP is the prev vma specified, NNNN is a vma that overlaps
> + * the area AAAA and XXXXXX the next vma after AAAA:

I think this is worded in a bit of a confusing way + can be read as 'NNNN is a
vma that overlaps the area AAAA and XXXXXX' whereas you mean to say 'NNNN is a
VMA that overlaps the area AAAA, and XXXXXX is the next vma after AAAA'.

This therefore might be better worded as:-

'PPPP is the previous VMA, NNNN is a VMA which overlaps AAAA and XXXX is the
next VMA after AAAA.'

Also - nit, but there's also inconsistency here between the number of letters in
each block, e.g. 6 P's 4 N's 4 A's and 6 X's.

'N' and 'X' are starting to be horrifically misleading here imo, I feel as if
'N' moving to 'O' (for overlapping) and 'X' to 'N' would make a big difference
here.

>   *
>   *     AAAA             AAAA                   AAAA
> - *    PPPPPPNNNNNN    PPPPPPXXXXXX       PPPPPPNNNNNN
> + *    PPPPPPXXXXXX    PPPPPPXXXXXX       PPPPPPNNNNNN
>   *    cannot merge    might become       might become
>   *                    PPXXXXXXXXXX       PPPPPPPPPPNN
>   *    mmap, brk or    case 4 below       case 5 below
> @@ -879,9 +880,10 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
>   *
>   * In the code below:
>   * PPPP is represented by *prev
> - * NNNN is represented by *mid (and possibly equal to *next)
> - * XXXX is represented by *next or not represented at all.
> - * AAAA is not represented - it will be merged or the function will return NULL
> + * NNNN is represented by *mid or not represented at all (NULL)
> + * XXXX is represented by *next or not represented at all (NULL)
> + * AAAA is not represented - it will be merged and the vma containing the
> + *      area is returned, or the function will return NULL
>   */
>  struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  			struct vm_area_struct *prev, unsigned long addr,
> @@ -918,6 +920,9 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  	else
>  		next = mid;
>
> +	if (mid && end <= mid->vm_start)
> +		mid = NULL;
> +

Might be worth putting a comment with the cases where this will happen, 1 - 4
right? And also something like 'does AAAA overlap with mid?'

And I really think renaming this to 'overlapping' or 'overlaps' or similar would
make a big readability difference.

However we do have the thorny issue of case 4 where A overlaps P... But probably
the fact that we treat this as a separate VMA from prev is enough to make it
clear it being called 'overlaps' means 'separate from prev, also overlaps' so I
think that's fine.

Adding this actually makes me think twice about the previous 'natural order'
patch, because the intuition which that promotes is:-

mid = VMA after prev
next = VMA after mid

[ prev ] [ mid ] [ next ]

But in reality that else branch means that next could be be equal to mid and
now if there isn't overlap we rename mid to next effectively, e.g.:-

mid = VMA after prev
next = mid
delete mid

Which feels like the 'natural' intuition is suddenly broken. Maybe this needs
reworking to be super explicit about this? Such as:-

struct vm_area_struct tmp;

...

/* If there is a previous VMA, find the next, otherwise find the first. */
tmp = find_vma(mm, prev ? prev->vm_end : 0);

/*
 * If the address range overlaps with the input range (which can cover only a
 * single VMA at most), then we are only interested in next if we span right up
 * to its end.
 *
 * Otherwise we are simply left with prev and next.
 */
overlaps = tmp && end > tmp->vm_start ? tmp : NULL;
if (overlaps)
	next = overlaps->vm_end == end ? overlaps->vm_next : NULL;
else
	next = tmp;

Of course I haven't read the rest of the patches in this series so you may
address aspects of this already :)


>  	/* verify some invariant that must be enforced by the caller */
>  	VM_WARN_ON(prev && addr <= prev->vm_start);
>  	VM_WARN_ON(mid && end > mid->vm_end);
> @@ -952,7 +957,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  		remove = next;				/* case 1 */
>  		vma_end = next->vm_end;
>  		err = dup_anon_vma(prev, next);
> -		if (mid != next) {			/* case 6 */
> +		if (mid) {				/* case 6 */
>  			remove = mid;
>  			remove2 = next;
>  			if (!next->anon_vma)
> @@ -960,7 +965,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  		}
>  	} else if (merge_prev) {
>  		err = 0;				/* case 2 */
> -		if (mid && end > mid->vm_start) {
> +		if (mid) {
>  			err = dup_anon_vma(prev, mid);
>  			if (end == mid->vm_end) {	/* case 7 */
>  				remove = mid;
> @@ -982,7 +987,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  			vma_end = next->vm_end;
>  			vma_pgoff = next->vm_pgoff;
>  			err = 0;
> -			if (mid != next) {		/* case 8 */
> +			if (mid) {			/* case 8 */
>  				vma_pgoff = mid->vm_pgoff;
>  				remove = mid;
>  				err = dup_anon_vma(next, mid);
> --
> 2.39.2
>

Other than the nitty comment notes and the conceptual discussion, this LGTM so:-

Reviewed-By: Lorenzo Stoakes <lstoakes@gmail.com>
