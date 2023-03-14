Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969F728E8
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 08:19:32 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id ix20so9229369plb.3
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 01:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678781972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8uO2pb0aT1NnyTIVfLkUifV1o9o6G5xDatiTfXnW8OM=;
        b=QCEaXsu/OjbQKOKTYOcfuHjvGyeHK9nYJiXxfEUWECrdKCyWwPq0L0FNqeK2N9n0Ae
         EYhweA0WDiVCNFTXO/Wu2yt+0iX/rIGOjay3O9J0T5PfyRcM9Od/wAOnZeMKsTEccNB1
         kBPODFp6Fy5xfTTUhVz+KrAXlcmQwZdHP+yI41uKkVWzMoTXmLqYZGqI2hHTgzIP5M4q
         /RAASByDELA1VcinP8SU4Nnn47z78AHy+V6TX7KQ4FM3dvquhkssjsbw6ytwlZpCQ4zG
         C1OUBzTPW44akruzEoyygVQ3dj7HZ9nnKMlsFkidV34OJTbRtTmlN9/8JVCA/Jd6/d8K
         AasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678781972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uO2pb0aT1NnyTIVfLkUifV1o9o6G5xDatiTfXnW8OM=;
        b=8M6+Hk7/1ebM42EnGX7pDDZZoijfKzEygSG9ORix1lSjLU29FEm2UtO2CpPmieZUjV
         1uf2ox8UMNV8I+VOtacHMRtaQB2fx2WyFfAPPF0I0MN4PE/Lw0mg5PzmJK2MhdBN+bjl
         OguHNE1NZlsKxvRGh/bEY/KCM0POOhYeWZrx1Hgj4H66coHcWVvhf1tMTt1uuJuGSFMV
         xmiXp0+IcoGpOSuZotym6P6FzaT2aGFaTCUzAbo9jH+KKjaVHBEqQicCGRKY66pUZNAm
         DnXQbJWJK0Wb7Cu4dOI9EFvZldTMp2Ks+E2Zs26dFBPa5fwmD8xecPEKQ1igS+mkPcvc
         4MMg==
X-Gm-Message-State: AO0yUKVR0fXS1XukPSbCAQ+79ZI1GVK8Fsmjf+AZsThxEWXjuUb8NL6J
	sVaoZjrSpec/HBNsrqWyjis=
X-Google-Smtp-Source: AK7set/EQKyfrynoi8fEAytH0KIk6OtEN1YHKRHZ+aytWMZMlLInWc+g/9ht3BCMiq8qdv6zEI7rTA==
X-Received: by 2002:a17:902:c407:b0:19e:7490:c93e with SMTP id k7-20020a170902c40700b0019e7490c93emr49670592plk.63.1678781971870;
        Tue, 14 Mar 2023 01:19:31 -0700 (PDT)
Received: from localhost ([2400:8902::f03c:93ff:fe27:642a])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902d3c500b0019fcece6847sm1113921plb.227.2023.03.14.01.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 01:19:30 -0700 (PDT)
Date: Tue, 14 Mar 2023 08:19:18 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/7] mm, pagemap: remove SLOB and SLQB from comments and
 documentation
Message-ID: <ZBAuBj0hgLK7Iqgy@localhost>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-5-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-5-vbabka@suse.cz>

On Fri, Mar 10, 2023 at 11:32:06AM +0100, Vlastimil Babka wrote:
> SLOB has been removed and SLQB never merged, so remove their mentions
> from comments and documentation of pagemap.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  Documentation/admin-guide/mm/pagemap.rst | 6 +++---
>  fs/proc/page.c                           | 5 ++---
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
> index b5f970dc91e7..bb4aa897a773 100644
> --- a/Documentation/admin-guide/mm/pagemap.rst
> +++ b/Documentation/admin-guide/mm/pagemap.rst
> @@ -91,9 +91,9 @@ Short descriptions to the page flags
>     The page is being locked for exclusive access, e.g. by undergoing read/write
>     IO.
>  7 - SLAB
> -   The page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator.
> -   When compound page is used, SLUB/SLQB will only set this flag on the head
> -   page; SLOB will not flag it at all.
> +   The page is managed by the SLAB/SLUB kernel memory allocator.
> +   When compound page is used, either will only set this flag on the head
> +   page..
>  10 - BUDDY
>      A free memory block managed by the buddy system allocator.
>      The buddy system organizes free memory in blocks of various orders.
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 6249c347809a..1356aeffd8dc 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -125,7 +125,7 @@ u64 stable_page_flags(struct page *page)
>  	/*
>  	 * pseudo flags for the well known (anonymous) memory mapped pages
>  	 *
> -	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
> +	 * Note that page->_mapcount is overloaded in SLAB/SLUB, so the

SLUB does not overload _mapcount.

>  	 * simple test in page_mapped() is not enough.
>  	 */
>  	if (!PageSlab(page) && page_mapped(page))
> @@ -166,8 +166,7 @@ u64 stable_page_flags(struct page *page)
>  
>  	/*
>  	 * Caveats on high order pages: page->_refcount will only be set
> -	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
> -	 * SLOB won't set PG_slab at all on compound pages.
> +	 * -1 on the head page; SLAB/SLUB do the same for PG_slab;

I think this comment could be just saying that PG_buddy is only set on
head page, not saying

_refcount is set to -1 on head page (is it even correct?)

>  	 */
>  	if (PageBuddy(page))
>  		u |= 1 << KPF_BUDDY;
> -- 
> 2.39.2
> 
