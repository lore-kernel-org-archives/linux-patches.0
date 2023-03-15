Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90917460
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 21:38:41 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id h17so4553487wrt.8
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678916320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EXOeJTwK4KmrIlxPr5Klq/AQ/BW356EV8A+6kgkSRD0=;
        b=a7dd7ol8g0McRzHN9i+DikaHfAmyHidSQuumacuyPuGkR7b5c7Pex1Zwe5vsDridmY
         ZqXUXQ9S0+QpVKTXvFelyu4lbJIt+Mb5v8Ouf9kU2R3ci02M4bIny2Q4I6TeRgHTcyMA
         +OHeuYvKI8Nsxq4bqNg9XH5rtK9h7E+gcFM+pfGpUB/dBpABMfP2MshZMQhlMq9L24eq
         Jjao0w/tVY1gkq2AMxJbtoK7DeojIHkccR8x8+MhJO5nsu5mrsu0CPNrSkpAtqZkdQ+v
         qsLr37rO5o1yS8QCCSADy/bDKJr8mSeCHxlqmbbnnG5D2H3EgOnmFcb/aUp8rflLLt8n
         Nanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678916320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXOeJTwK4KmrIlxPr5Klq/AQ/BW356EV8A+6kgkSRD0=;
        b=qTykWon/YFs0btHKudl9U2uUJHpH+UJDJhilErheBbPb72sWS/r8KfWxm9vdlAT9PK
         qw8SmWME7Gz0PXxEA4IdbNPPLflT4Hw0l7/kD4tOPsCX+la6g9raTyEP4fjmLJcHZ5IF
         u0nydrnWkznJhLQXWLa2e84CveSPOdxXw1SlJhj4q80RWRJTKXAHiwfsYyB3kTo8XJww
         YEyeXpqtCoha8sMNgLwrVAVbCHhjGbwMBfSiH0IaghcRLlXUwugDBcW3RwrL+chIo8MS
         plvlWPhEbZJ9HpiXljwjXL39pt10Odul93x6jLZPEVzL1i1Dv25VmK93YBohZpKT+HPt
         AqCQ==
X-Gm-Message-State: AO0yUKWdFs1zPWZlFB/RUKw5CUXKWh9/haaGziuYTsRa0PStgOU7oXy7
	hIyMIrkiiQENgBK1KbpHFu0=
X-Google-Smtp-Source: AK7set81j8IB4FbIu43mVKYxxp6kE0h/UZ6TURg26EiYc4FNvjDKvEMTAT/LfN1Vsqopn93EObZbow==
X-Received: by 2002:adf:dcc2:0:b0:2ce:aa2d:c625 with SMTP id x2-20020adfdcc2000000b002ceaa2dc625mr3116855wrm.22.1678916319688;
        Wed, 15 Mar 2023 14:38:39 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id t4-20020a0560001a4400b002be5bdbe40csm5584754wry.27.2023.03.15.14.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:38:38 -0700 (PDT)
Date: Wed, 15 Mar 2023 21:38:37 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 07/10] mm/mmap/vma_merge: rename adj_next to adj_start
Message-ID: <f6a24126-99b8-4b6b-a456-bd6633ec491b@lucifer.local>
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-8-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309111258.24079-8-vbabka@suse.cz>

On Thu, Mar 09, 2023 at 12:12:55PM +0100, Vlastimil Babka wrote:
> The variable 'adj_next' holds the value by which we adjust vm_start of a
> vma in variable 'adjust', that's either 'next' or 'mid', so the current
> name is inaccurate. Rename it to 'adj_start'.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mmap.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 3396c9b13f1c..c51d69592e4e 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -903,7 +903,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  	bool vma_expanded = false;
>  	struct vma_prepare vp;
>  	unsigned long vma_end = end;
> -	long adj_next = 0;
> +	long adj_start = 0;
>  	unsigned long vma_start = addr;
>
>  	validate_mm(mm);
> @@ -971,7 +971,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  				remove = mid;
>  			} else {			/* case 5 */
>  				adjust = mid;
> -				adj_next = (end - mid->vm_start);
> +				adj_start = (end - mid->vm_start);
>  			}
>  		}
>  	} else if (merge_next) {
> @@ -979,7 +979,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  		if (prev && addr < prev->vm_end) {	/* case 4 */
>  			vma_end = addr;
>  			adjust = next;
> -			adj_next = -(prev->vm_end - addr);
> +			adj_start = -(prev->vm_end - addr);
>  			err = dup_anon_vma(next, prev);
>  		} else {
>  			vma = next;			/* case 3 */
> @@ -1002,7 +1002,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  	if (vma_iter_prealloc(vmi))
>  		return NULL;
>
> -	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_next);
> +	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_start);
>  	init_multi_vma_prep(&vp, vma, adjust, remove, remove2);
>  	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
>  		   vp.anon_vma != adjust->anon_vma);
> @@ -1018,10 +1018,10 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  	if (vma_expanded)
>  		vma_iter_store(vmi, vma);
>
> -	if (adj_next) {
> -		adjust->vm_start += adj_next;
> -		adjust->vm_pgoff += adj_next >> PAGE_SHIFT;
> -		if (adj_next < 0) {
> +	if (adj_start) {
> +		adjust->vm_start += adj_start;
> +		adjust->vm_pgoff += adj_start >> PAGE_SHIFT;
> +		if (adj_start < 0) {
>  			WARN_ON(vma_expanded);
>  			vma_iter_store(vmi, next);
>  		}
> --
> 2.39.2
>

This feels like a very silly oversight in the first instance but I imagine one
that is a result of 'code evolution' :) excellent improvement in clarity, so:-

Reviewed-By: Lorenzo Stoakes <lstoakes@gmail.com>
