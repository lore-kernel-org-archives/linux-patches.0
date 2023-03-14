Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B37197
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 22:36:59 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id m35so1846598wms.4
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 15:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678833418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6l4jnUPgiSL9pwE7XPhJHqJWDs8eBCpbTvbsPB+B0A=;
        b=igGLKO/amsFm2CuBDjGiFD2P4Vb8eBCG+38gyP5ACSj6Mk3L+PH70NcKWjCMJUD1bq
         WRpVxjeHiOOeYJBCS6UXYD2hc9a8WW1dYEYUWTeqcHz9i5VEStSk9WYXRiETB5DGv9CW
         i7VZwrlAwQWK4qelWd9pgQzNj+tz6OvSlU7TZ9TO9dJqnR9xD4X8J0YsQ3iefKmzHd1j
         FQKqrIpcWI8oBAAwaJx7pZOC1fPddtImqJwawqBAPs+eeKgEk5NIt7enJHAiON8dIO0f
         ZOGULCfGzM1k0Do67XCQsOJFB2VmW5YnPVpkzwy0HWVw49UCiuM6r0K0XpYjivnmYeF8
         pyfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678833418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6l4jnUPgiSL9pwE7XPhJHqJWDs8eBCpbTvbsPB+B0A=;
        b=ACgc6pYII5cBogdifJ4bPHF/1aBr1UNiBAPDifna5twtmceP36AEFSiJ9fl6N5XEVE
         vYClX3cION9cUtxxQc63+kaV2IAHYJlVl52wHGPXm5KN5HYXkg80gKtcNMxjJ3FimO4y
         ORvYiFVPhBIWFtFO4tZZTerqBvQEpVQAYn6hQkQJ0ZDlaOs5o4QUtQVZUw6O/lzVT8ia
         XRaqToVyb6F59ApXSb0G+1CbDyEDzqtZa5SVaqz95bjhJsUZPBo8RmlHGA3uKcZNgLd6
         8sm/Hc63bYOiaGObfb+6DW2MEpvG6MfREIRSioZtCTO2oD4DkoCUmMxWwKUBzFEtRvO6
         +swQ==
X-Gm-Message-State: AO0yUKXXcyCmGzI0cuAYDxYWsQYSMWBz3Wow1kOznUtlEYf7uG+a9lt4
	31Hl6NwDbkQIofG+1DxKLSw=
X-Google-Smtp-Source: AK7set8B+/2sE9/73LsBJy9qXjVPNWmDNhuCtXSX+pPd41Zq6FBHcSzizIIxnlvNwOCRrZfz8uFzmA==
X-Received: by 2002:a05:600c:19d3:b0:3eb:3945:d3f9 with SMTP id u19-20020a05600c19d300b003eb3945d3f9mr15857968wmq.4.1678833418226;
        Tue, 14 Mar 2023 15:36:58 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003ed2fb86f85sm1525693wmi.47.2023.03.14.15.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:36:57 -0700 (PDT)
Date: Tue, 14 Mar 2023 22:36:56 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 07/10] mm/mmap/vma_merge: rename adj_next to adj_start
Message-ID: <8dcd3ff4-bcf3-4960-973a-d494d8bd5b11@lucifer.local>
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

It looks like Suren's dc72d59c416d ("mm/mmap: move vma_prepare before
vma_adjust_trans_huge") trivially conflicts with this change.
