Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270567460
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 21:43:54 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id k25-20020a7bc419000000b003ed23114fa7so1915816wmi.4
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678916632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GhDkz9cygAKI6omptYlnjhp4nG7oC/xwiqYxOhUgxAM=;
        b=aE0XYUOcNXfXFpaLBC++6d3u8Kk2RlEEz6Y66yRnKWOVYhoUaN4wmFtWUcdjvaHJxQ
         akQVx4kr5UApgcHzP512dvIqexA0xTwkSOmkXlXOgaVFYTiGM2iMmsuA5ydb5L/heQiE
         wQPEYWtpnGhSWRFInFQ/Ky4QJZZQ1Db4WTCS8SWEYoSuaGR/hPsFs1WHaKkfikUDa5p2
         RE7rjXwTiHRBt5kax1WQAYa61eVWM2u5eQ0dMsB/6rDBGuB9X7yevBG4HZRAN2C/PJYQ
         yU6DeltiLiM9sYayTzC/PL6HvhTuxbqiMkhphooapR8nSS3L29diLRg0Mki1KQZRNTWs
         d18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678916632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhDkz9cygAKI6omptYlnjhp4nG7oC/xwiqYxOhUgxAM=;
        b=0lGvwXpQZN06065gvNwS+CfIBRiyow5mBbk4ilBxKoKajp4Jh4HOYVR+jfuM7SnCbV
         2f8LGWM6RRWAhXPKfXZPzd+CVG9EfNFUA/Whf2Rt8JkpysCnBom8a6IDbl61aADXVUA3
         sLfy5S/9T0iupvj2gg+a0m20cTRBb+ONOGd/Ro3L26OSkwb99XzckV718iZeZmYdRG8U
         cbvWrjO43ALlAUTpPFsE7WB8LTLBuB2GcyQhnyOA4hKUeN6F/QZRCWzSFKNLLBsfRNWT
         Ww7YULU3kceHyylB5kPm98RpaFFpBblncAGa6BIC9oS/oHZQQ5yUGmtvV2c9rUjPvNTj
         t7wA==
X-Gm-Message-State: AO0yUKXnDhIA16+mhy7kEM74UXKANxlpGFtHBUbtyW4jzPQM9HPSvHem
	biuyt2mNzJM7wc/4B9/oG2U=
X-Google-Smtp-Source: AK7set86HOVQ82UwG/kVRuAVCpV3DYDglhRDXQl7KOgfCK+DCRVtD1aXn6D8jDqb+r3VGL+ykb5a9A==
X-Received: by 2002:a1c:cc06:0:b0:3eb:42fa:39d5 with SMTP id h6-20020a1ccc06000000b003eb42fa39d5mr19470523wmb.29.1678916632156;
        Wed, 15 Mar 2023 14:43:52 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id d12-20020a056000114c00b002c6d0462163sm5587695wrx.100.2023.03.15.14.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:43:51 -0700 (PDT)
Date: Wed, 15 Mar 2023 21:43:50 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 08/10] mm/mmap/vma_merge: convert mergeability checks to
 return bool
Message-ID: <7c7f9045-feda-446c-826c-5061534afcc0@lucifer.local>
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-9-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309111258.24079-9-vbabka@suse.cz>

On Thu, Mar 09, 2023 at 12:12:56PM +0100, Vlastimil Babka wrote:
> The comments already mention returning 'true' so make the code match
> them.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mmap.c | 53 +++++++++++++++++++++++++----------------------------
>  1 file changed, 25 insertions(+), 28 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c51d69592e4e..d20bbe9ec613 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -744,10 +744,10 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
>   * If the vma has a ->close operation then the driver probably needs to release
>   * per-vma resources, so we don't attempt to merge those.
>   */
> -static inline int is_mergeable_vma(struct vm_area_struct *vma,
> -				   struct file *file, unsigned long vm_flags,
> -				   struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
> -				   struct anon_vma_name *anon_name)
> +static inline bool is_mergeable_vma(struct vm_area_struct *vma,
> +		struct file *file, unsigned long vm_flags,
> +		struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
> +		struct anon_vma_name *anon_name)
>  {
>  	/*
>  	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
> @@ -758,21 +758,20 @@ static inline int is_mergeable_vma(struct vm_area_struct *vma,
>  	 * extended instead.
>  	 */
>  	if ((vma->vm_flags ^ vm_flags) & ~VM_SOFTDIRTY)
> -		return 0;
> +		return false;
>  	if (vma->vm_file != file)
> -		return 0;
> +		return false;
>  	if (vma->vm_ops && vma->vm_ops->close)
> -		return 0;
> +		return false;
>  	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
> -		return 0;
> +		return false;
>  	if (!anon_vma_name_eq(anon_vma_name(vma), anon_name))
> -		return 0;
> -	return 1;
> +		return false;
> +	return true;
>  }
>
> -static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
> -					struct anon_vma *anon_vma2,
> -					struct vm_area_struct *vma)
> +static inline bool is_mergeable_anon_vma(struct anon_vma *anon_vma1,
> +		 struct anon_vma *anon_vma2, struct vm_area_struct *vma)
>  {
>  	/*
>  	 * The list_is_singular() test is to avoid merging VMA cloned from
> @@ -780,7 +779,7 @@ static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
>  	 */
>  	if ((!anon_vma1 || !anon_vma2) && (!vma ||
>  		list_is_singular(&vma->anon_vma_chain)))
> -		return 1;
> +		return true;
>  	return anon_vma1 == anon_vma2;
>  }
>
> @@ -795,19 +794,18 @@ static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
>   * indices (16TB on ia32) because do_mmap() does not permit mmap's which
>   * wrap, nor mmaps which cover the final page at index -1UL.
>   */
> -static int
> +static bool
>  can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
> -		     struct anon_vma *anon_vma, struct file *file,
> -		     pgoff_t vm_pgoff,
> -		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
> -		     struct anon_vma_name *anon_name)
> +		struct anon_vma *anon_vma, struct file *file,
> +		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
> +		struct anon_vma_name *anon_name)
>  {
>  	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
>  	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
>  		if (vma->vm_pgoff == vm_pgoff)
> -			return 1;
> +			return true;
>  	}
> -	return 0;
> +	return false;
>  }
>
>  /*
> @@ -817,21 +815,20 @@ can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
>   * We cannot merge two vmas if they have differently assigned (non-NULL)
>   * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
>   */
> -static int
> +static bool
>  can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
> -		    struct anon_vma *anon_vma, struct file *file,
> -		    pgoff_t vm_pgoff,
> -		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
> -		    struct anon_vma_name *anon_name)
> +		struct anon_vma *anon_vma, struct file *file,
> +		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
> +		struct anon_vma_name *anon_name)
>  {
>  	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
>  	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
>  		pgoff_t vm_pglen;
>  		vm_pglen = vma_pages(vma);
>  		if (vma->vm_pgoff + vm_pglen == vm_pgoff)
> -			return 1;
> +			return true;
>  	}
> -	return 0;
> +	return false;
>  }
>
>  /*
> --
> 2.39.2
>

Partying like it's C99 :) Good improvement, feels sensible to move on from using
return types as if the 1st edition of The C Programming Language were still
current! Therefore,

Reviewed-By: Lorenzo Stoakes <lstoakes@gmail.com>
