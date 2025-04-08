Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D609264F87
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 09:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744104881; cv=none; b=CO5x6lpbofZIIjekcF/dzgvEgMp/rkVyhuXbpnxFJoD1RKduBZ/PJSdw8E1h+LJTROxKrs9dG6lXSBLrIxzguv08YvPMbgnPFgY361cobgAhCEF+BKsIyE0bHgVzNdjY2SqEwK+7Zs7XZnBBJR2tMGgZHLoC1PxY4mO/mWOMjAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744104881; c=relaxed/simple;
	bh=Mw9BipaX03ecmtlnzgP3qZmLo1pRUnsgk//oLUm+1HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iajI3Q3Bae4/2bdappcILWCYXYDCMiDSOfQ6pTE37fGpXbTdHSm90G7uEjHhtw2bh9bWYn5OWokMEL/aXPUABLE1xkfssgsCxzYkr6pXpz6yRemP/fpeGlW2iIL0qh2wboJGuoexJ5TAjjks/DneJfPj1AnfyBdgazDBOteqgwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BBQMny3Z; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BBQMny3Z"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso34079065e9.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 02:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744104877; x=1744709677; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AtwwP4HqDMoVhJV9AOJlIF1w0v00JywAQfC5Yv29UZk=;
        b=BBQMny3Z0iCA0+ttoIaSk7ekgJ2gXtRoBDr6u2oPxgFytXMqHDWpo4piGCo8YSt2Ql
         xOm64hs3pgZDJu6xVusckzy/u6f7vLDyjcApXVMP/auLJc42Tp8++PDwJdbrDUqX1p8v
         g8s90yiau5LsNvT9imnlkhBDhMxsnoKRHhV8/+no7BG0M8dsF5AXqJBUxajaZhZeJ0UZ
         fvnMom2Z+cTTI6HyivnaCrvz4KR01mPtguKWgJwJlnaHFfqpthykIw01T8niaWECQA3w
         7tHJjALlq/GnqYP+vAd+oyVUElNry6bci5BpqhkL9YqQW+jUjhdzmj4boZ53baJ7cQpI
         m3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744104877; x=1744709677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtwwP4HqDMoVhJV9AOJlIF1w0v00JywAQfC5Yv29UZk=;
        b=CrSVeSZD/L4OnWXCui5cZJC6qCF3LTJZNgH7rnlEi+le3ZIqS/SUxQJ5UiovHykWKh
         5DyZBlngrinN9Tn57uT0tLrettjr5K9GvIZXV6TI8/wreuowG3SLPau4FrYKSmeZNUNL
         qMus60N8Wt4UqFXJ3oiBHpgkPAZfkPPXiKB9U7z0SQ51z60MVw0dZV1qTt3xRhasSyDW
         71MpI8RbPJAa3AFavebepGS9e7SzqdFPasuoRjmvKCkdDWPhDnPSPpL5YxOZIZ+8VPBU
         wJahE6KrVms/cGtBa0DN4mDY7yvke6VXPtZHOPkuJPmibhf3XQVaMNDQKDw9Sn3SLMTV
         yedg==
X-Forwarded-Encrypted: i=1; AJvYcCUCVH1Aqio6TticVXReCLSTdci5uhnI2AmhkEbLSy51UoraoA1+tpQKX9rZT8CVifRlUj91qYuy@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0RTCY9UuAolrEM5oAnP70MwtDjV89wzI61FDIavipjSSNJLtw
	uSAAWaeu6/l8pmP9omcLSc08RDKUUlYq2BgjsG0Ik90G/uCX9t/RLUK7w41G3Uk=
X-Gm-Gg: ASbGnct+pRzH0ArMAKmZUEHfchlMEyS0xBR+rxfafPkT8xvPbTPAfa6u3x0c3ZNC2DM
	F4BSFjNkVss937Bf0uRjvUoNPBU6K4thZ72fQhTqnvIhQGKBz/Y90ughvPN8z9wJZNRfagUkgI3
	bzVELH5eLytkUNu47ZSrYBO0C0QTux6MacIn+rsV49h0IUTv45lV+O/jnoKfvAhv6rwZ9pXSgd6
	EKq6YOvkT/jsKpRjBoHipjrIWRMG21E1S2j/lC2h3SOuIaac5Of8c1iwuB3liG+gxUm1UAEavje
	yD/sS7hUOScr46yw1piqn8YWdh3J8bG87ttIf9tjjidUWnB+osX97zw=
X-Google-Smtp-Source: AGHT+IEjRZm4TK0RyiZ3PAjlRVU6L5oyxaErbz97TRvApb6+B+nBpIqS5LQTTXTNW8eDHsr7ZSAprw==
X-Received: by 2002:a05:600c:3b13:b0:43c:f050:fed3 with SMTP id 5b1f17b1804b1-43ed0bde8a8mr144207385e9.11.1744104876909;
        Tue, 08 Apr 2025 02:34:36 -0700 (PDT)
Received: from localhost (109-81-82-69.rct.o2.cz. [109.81.82.69])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43ec364d07csm154393655e9.28.2025.04.08.02.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 02:34:36 -0700 (PDT)
Date: Tue, 8 Apr 2025 11:34:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page
 allocator
Message-ID: <Z_Ttq-uBXdqlewEa@tiehlicka>
References: <20250407200508.121357-3-vbabka@suse.cz>
 <20250407200508.121357-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407200508.121357-4-vbabka@suse.cz>

On Mon 07-04-25 22:05:10, Vlastimil Babka wrote:
> Add a subsection for the page allocator, including compaction as it's
> crucial for high-order allocations and works together with the
> anti-fragmentation features. Volunteer myself as a reviewer.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Michal Hocko <mhocko@suse.com>

Feel free to add
R: Michal Hocko <mhocko@suse.com>
Thanks

> ---
> Extra reviewers would be welcome, including/not limited the people I
> Cc'd based on my recollection and get_maintainers --git
> Also if I missed any related file please lmk. Thanks.
> 
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4fe7cf5fc4ea..610636f622b1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15511,6 +15511,16 @@ F:	mm/numa.c
>  F:	mm/numa_emulation.c
>  F:	mm/numa_memblks.c
>  
> +MEMORY MANAGEMENT - PAGE ALLOCATOR
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +R:	Vlastimil Babka <vbabka@suse.cz>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +F:	mm/compaction.c
> +F:	mm/page_alloc.c
> +F:	include/linux/gfp.h
> +F:	include/linux/compaction.h
> +
>  MEMORY MANAGEMENT - SECRETMEM
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Mike Rapoport <rppt@kernel.org>
> -- 
> 2.49.0

-- 
Michal Hocko
SUSE Labs
