Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD17197
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 22:52:20 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id l1so15736425wry.12
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 15:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678834339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aRo6A8udz7vMTU2bOR1zXhbLdqVTQmZ/8R5vMq7kqsA=;
        b=gMnv7YC62gXcz6glohYqgwR5fcc0cr0oK67SD7UYTJ4OcShFey80KOTfIRE7VgWIDt
         JFrTuHV7521bLX8F5WsWT7gdoBNL1XIPL6IYJlq62OnCIU7Xe4Ej89rnyBxIcModa/I0
         RSeqMvImGYbdL7El9dXjzMSR8Ydr53FJ9hZuOWBcrk3DThT7rrV+WIoHF8h6M2E+KI7W
         e6b/xxCJ2u/W3gOutWRSC5kORfU+pJWfNES4N7UZgCsF6/7cF0SDzJ50km0Q0DiIfcHa
         hvGPjxoXBek5R4S6lMtF6NW2DglWdYYA9aWX2z02habT7pauMZ0XgnuniReKcT3nayJ5
         Kpug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678834339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRo6A8udz7vMTU2bOR1zXhbLdqVTQmZ/8R5vMq7kqsA=;
        b=XxjsL0D7V4tFD4BcpZEVLcmpzzbLI33uR+3OWfVdnGYu9iJYvALeEW/DjM9Fb3WvaX
         f1MWtQnBZoqsyZkxGmYTBf4w+V8sNdaGnEtoyDlnrfe/k250ZWhR6/+tF1mWiOwiUmVO
         QYnyqRw4NBER0XlZ+p6EuHY+MO+4fiE+KqC/zseNGwK/npBNrSi7RZ4ZaKRd6cC3flZg
         +OkHVVrFKON4bZ8Nkw2aOfvzltMn+ItYwlrG9eNYULcuDl41W3BFf3PImhTWrbrmWSni
         YmLXpovABvXIm95D0bRol6rgLFkD4THlYHo4UhZ8juFU0sypypR22o7cpwDX2b7SFkCS
         hg5A==
X-Gm-Message-State: AO0yUKWQBSuVXkI302SFa0EBXysJDbzVo4HrqYnnoGF/ilAC08P3JSjp
	qtTMfM8Tf1cWxBIEzoWu3VE=
X-Google-Smtp-Source: AK7set/cYhxGfJWpjfFLyQky/1yUlsdvhgUbYSCD6TKzoUKEbeib3e22z9mD5ZXIJp8m8WUSJxjGQg==
X-Received: by 2002:adf:fa09:0:b0:2cf:e58e:2dca with SMTP id m9-20020adffa09000000b002cfe58e2dcamr467660wrr.36.1678834339057;
        Tue, 14 Mar 2023 15:52:19 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id v8-20020a5d6108000000b002be0b1e556esm3046633wrt.59.2023.03.14.15.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:52:18 -0700 (PDT)
Date: Tue, 14 Mar 2023 22:52:17 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 01/10] mm/mmap/vma_merge: use only primary pointers for
 preparing merge
Message-ID: <4385c202-2281-403e-8d9b-9587e88f9009@lucifer.local>
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309111258.24079-2-vbabka@suse.cz>

On Thu, Mar 09, 2023 at 12:12:49PM +0100, Vlastimil Babka wrote:
> In the merging preparation part of vma_merge(), some vma pointer
> variables are assigned for later execution of the merge, but also read
> from in the block itself. The code is easier follow and check against
> the cases diagram in the comment if the code reads only from the
> "primary" vma variables prev, mid, next instead. No functional change.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mmap.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 740b54be3ed4..0a8b052e3022 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -950,16 +950,16 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
>  		remove = mid;				/* case 1 */
>  		vma_end = next->vm_end;
> -		err = dup_anon_vma(res, remove);
> +		err = dup_anon_vma(prev, mid);
>  		if (mid != next) {			/* case 6 */
>  			remove2 = next;
> -			if (!remove->anon_vma)
> -				err = dup_anon_vma(res, remove2);
> +			if (!mid->anon_vma)
> +				err = dup_anon_vma(prev, next);
>  		}
>  	} else if (merge_prev) {
>  		err = 0;				/* case 2 */
>  		if (mid && end > mid->vm_start) {
> -			err = dup_anon_vma(res, mid);
> +			err = dup_anon_vma(prev, mid);
>  			if (end == mid->vm_end) {	/* case 7 */
>  				remove = mid;
>  			} else {			/* case 5 */
> @@ -972,8 +972,8 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  		if (prev && addr < prev->vm_end) {	/* case 4 */
>  			vma_end = addr;
>  			adjust = mid;
> -			adj_next = -(vma->vm_end - addr);
> -			err = dup_anon_vma(adjust, prev);
> +			adj_next = -(prev->vm_end - addr);
> +			err = dup_anon_vma(mid, prev);
>  		} else {
>  			vma = next;			/* case 3 */
>  			vma_start = addr;
> @@ -982,7 +982,7 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  			err = 0;
>  			if (mid != next) {		/* case 8 */
>  				remove = mid;
> -				err = dup_anon_vma(res, remove);
> +				err = dup_anon_vma(next, mid);
>  			}
>  		}
>  	}
> --
> 2.39.2
>

Big improvement in readability already here.

Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
