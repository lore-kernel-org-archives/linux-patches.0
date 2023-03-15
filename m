Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7986FBB
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 19:54:25 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id k25-20020a7bc419000000b003ed23114fa7so1766839wmi.4
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678910063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCSxA22SVm2VVHTdwZU+aI7cTzpxyEJzg2GfMCeHww4=;
        b=ckXUmTVEo3xD771xIooynrnHGnLgWkoiXWuSCUXbS6hPckGoWE2gRZrcGBKET5O7iD
         p8gO2UfRmImBZ93ZIzskQ8OZXecW90USqCKBCS227xfHgb/TD6Munj4/lL/tw31iRqsK
         C7SWg0MeCSTovdWjFjeWwOWF7BkfINpbhfjOgYNkofrD9+6ukpZm0wbFElg3gcW9+kX2
         sTeVnKnrAoHbCfq22gYR/DyitJO4avo4yppFhWzWzGUexINyHE/JGPmdkloPKHjffKZC
         L5te0MX9bGt5qd710X7CeTmd7WgAvqv2TrrSpx515Q3uE1sB7Qm27/yOVAImSy7IMqQF
         QmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678910063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCSxA22SVm2VVHTdwZU+aI7cTzpxyEJzg2GfMCeHww4=;
        b=6F8uVSDW9WzUDur9RIvbF926GnsK8lsXmTIp1ZyjgzHqpi3PV3pp8Q7ytBa+nzjhgT
         7fkixRvDJ5hlbnvh6WPYfMdbdKsoHmH5hNXct48A9lrCe6imk+naWOIwZa/5lwtbs1JS
         xqqLHOjHP3z00beI1Ibm2GGJ/ERx4F+j5PhCIHU+QMvnDqUHF1NGchgsbjfUjOlO32zR
         6HBoj3P6xx7yl66GDSpXVGs9lVd8m4SBBSO0CXWADUMvHbL0Tr7+gSZ9nlRqfnlMChAq
         b69UVt/k2694ALu3ukM5OJUGE4VkRI7cGsJKBMWXRG3/G1VmOSLM3nInMOC8FNGaPLKa
         q8OA==
X-Gm-Message-State: AO0yUKWF4HvrZWJCbjfG6DxSAKDGnvHBMSl9nG3AcgInE6EQNLQ4wOK3
	KesOggDSOzboM9wIMPLAs6w=
X-Google-Smtp-Source: AK7set/JfTQ2o9CSsTNqTelAhywJgcjTZfTTQjho9/QNQwzz85bIKlQGIvuidMNUtqZDDf7M5k+HdQ==
X-Received: by 2002:a05:600c:1d97:b0:3ea:f132:63d8 with SMTP id p23-20020a05600c1d9700b003eaf13263d8mr19821484wms.5.1678910063192;
        Wed, 15 Mar 2023 12:54:23 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id q7-20020a7bce87000000b003e8dc7a03basm2720397wmj.41.2023.03.15.12.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 12:54:22 -0700 (PDT)
Date: Wed, 15 Mar 2023 19:54:21 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 04/10] mm/mmap/vma_merge: use the proper vma pointer in
 case 4
Message-ID: <3052d4e5-fcb5-479e-8691-b218a31b6243@lucifer.local>
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-5-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309111258.24079-5-vbabka@suse.cz>

On Thu, Mar 09, 2023 at 12:12:52PM +0100, Vlastimil Babka wrote:
> Almost all cases now use the 'next' pointer for the vma following
> the merged area, and the cases diagram shows it as XXXX. Case 4 is
> different as it uses 'mid' and NNNN, so change it for consistency. No
> functional change.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mmap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c33237b283c9..420d6847c94c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -851,9 +851,9 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
>   * vma, PPPPPP is the prev vma specified, and NNNNNN the next vma after:
>   *
>   *     AAAA             AAAA                   AAAA
> - *    PPPPPPNNNNNN    PPPPPPNNNNNN       PPPPPPNNNNNN
> + *    PPPPPPNNNNNN    PPPPPPXXXXXX       PPPPPPNNNNNN
>   *    cannot merge    might become       might become
> - *                    PPNNNNNNNNNN       PPPPPPPPPPNN
> + *                    PPXXXXXXXXXX       PPPPPPPPPPNN
>   *    mmap, brk or    case 4 below       case 5 below
>   *    mremap move:
>   *                        AAAA               AAAA
> @@ -972,9 +972,9 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  		res = next;
>  		if (prev && addr < prev->vm_end) {	/* case 4 */
>  			vma_end = addr;
> -			adjust = mid;
> +			adjust = next;
>  			adj_next = -(prev->vm_end - addr);
> -			err = dup_anon_vma(mid, prev);
> +			err = dup_anon_vma(next, prev);
>  		} else {
>  			vma = next;			/* case 3 */
>  			vma_start = addr;
> --
> 2.39.2
>

Reviewed-By: Lorenzo Stoakes <lstoakes@gmail.com>
