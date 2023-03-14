Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79626D2E8
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 22:16:30 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso14177437wmq.1
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 15:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678832188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0cgXw1zWR3UzIeNQHSkd/Pe/JYZucLUkg0+siqDji1Q=;
        b=WiWabfdsc40Hw03sHacABR/DpeHPE1ytk52ltiIHJyYU96rC0iS1lraEKpFNPMr7fC
         t88zt7gAQUBBIRqrgzPkQWQDI8IBIwbBSQ44S9GXEjINbumyhcaty1H8Wl8mk8TP7vah
         R+sSYxV3pSFKpraUvvKNT26Tl4bm9IX1cxQTO0YuTtRAf1JyKECbjwfkxjSm3C79t2zu
         WimroFz4zBdQaqQbKrHUb+k9u1UDe/t+bGf+sTOFdiO/SY1n3N2Yrx3e1ZAduqS48kT2
         rVHJ3JqaH5emYPmU4Xh0N/DVVXcX1nJMZW+nmKAVSR8mX825oNgoQNZkzjKn0xyWZeQC
         H2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678832188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cgXw1zWR3UzIeNQHSkd/Pe/JYZucLUkg0+siqDji1Q=;
        b=DlQRPKIz1nKetF4OVKTeqgR8kjHWINqDQB1liJsXnaJOGKE/PsqRKsFkHKr7hQiWXa
         s69ivgcLfivIEeoa54NYFzb41fZh7M9vV12VKFOxPHIqacEiIEIdgNQh05nNlkVeKJaY
         z3ndvy9Kp4OQVG6tHcoMlMPUpNjgr6Oh7j6KOmedbn6W96At0Ukx4TlbuXI6DurK4Ou1
         DGcgfrnI9ikLDUHtOy5/RLsR+WTbzTVB40Djp1HuhBbT/dFNcwKCtezijbs5nPbKqpA1
         EOPaCjyNZrurz/zfFo/gwsNmI4hBO/6Q9+cwAu981n50n6oYQS9bnGWESAH2c+4xnsFz
         kmrA==
X-Gm-Message-State: AO0yUKUXeyAxPZk1dN/Sesdolx+TZHHjwkip3IRlaG+KgjkYmWHYgTao
	/hTzW8C7kDtIdSjoiAePfOqRmU/Vjlo=
X-Google-Smtp-Source: AK7set/LqyA4KOXjYW3gB61Tg1NOLoBdeKaWngQqOyAVUSHmnZgHB0VC+IljqkqXyulD+UybQrzJww==
X-Received: by 2002:a05:600c:1546:b0:3ed:22f2:554c with SMTP id f6-20020a05600c154600b003ed22f2554cmr8549449wmg.29.1678832188560;
        Tue, 14 Mar 2023 15:16:28 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c22c400b003e00c453447sm3977442wmg.48.2023.03.14.15.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:16:27 -0700 (PDT)
Date: Tue, 14 Mar 2023 22:16:26 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/7] mm, pagemap: remove SLOB and SLQB from comments and
 documentation
Message-ID: <a901f00e-99df-4fed-8117-e3735ec7df59@lucifer.local>
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

I mean, perhaps the nittiest of nits but probably that '..' is unintended.

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

Nice catch on the redundant reference to the mysterous SLQB (+ above) :)

>  	 */
>  	if (PageBuddy(page))
>  		u |= 1 << KPF_BUDDY;
> --
> 2.39.2
>

Otherwise looks good to me,

Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
