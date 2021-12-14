Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F3A168
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:46:22 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id n15so18601346qta.0
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Sa4biLo+l4U8810pSbNuMBlGBmEdccS3RLB33BjV/U=;
        b=qjSfbc/U92ai97493r0S5YPhzcPtcUu4z+RVKN0JZLsUKsI3K65FAarILGoNE8ZavK
         PDg3JtG4t8S1rQQHZUTS41GW5VoVByrlMhN3FEiDE/9L7j++IRF7mYBq3aL5CiaXnddq
         c2LlBzSzY4t2AX77OYS0Z5dfwENNSyVu0+r2lX5aQ1dNMz8UXQ6X3zzcHPdplPNeCO57
         2T2MRzTZskGlqRERXxGm6Jbfj96QtzKImsqjmfba3VV4k8yImNZNesuCx0q5emPbmIj9
         x1RLmgv07TtzJ4DdtbcfBGqPO5C9z3aG3mnUKIgZ6sXRqO6bwTflk4q62wj2tSqsrIDg
         SStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Sa4biLo+l4U8810pSbNuMBlGBmEdccS3RLB33BjV/U=;
        b=tiRKCEZzEzm0Ap5XFit5ng+Kog9AnyMr3sSf9mSxMpYULmasIofez8zS8L08gkLGpf
         xReOwZZuGVfTYQu0xo6ehnnwV3uqQV/Yd2GEECJzK2kCPHPyb/JhqGr7iXinrF4Ixeed
         OJEOi2AFkVh5+j7EL9gcgsxmPylAYCfH6B9GC4NJj/IIfYQhD6Xu/XjQuDp+NvvAZBGE
         hVDUcOkija82VLBPBh4E4c4+Un8RWaP9Iijy7mNqAKZuYnznxZmqtZ84PjjDnzO0s3XT
         be96Jj/gd/vHn3AAklBVHUgmHicpV0sR1sI40KkG0ob5oW5O7vqsf89dPEQWNzJJ98nt
         KGTg==
X-Gm-Message-State: AOAM5310zlqZVAa9yxcye36jVn0SEeTwB6I8v3aGJhOqKG01/+8RoGHz
	i8/SL0Q0lfni/9jOSrpv8dTe9g==
X-Google-Smtp-Source: ABdhPJwJQlaiUsmjEzcQ7FfFvqGUQfkHMhlPyo/0nyFBLqMeC/KYcEUKZJXXDoQA2gs11UDZ7AvHLA==
X-Received: by 2002:ac8:5a42:: with SMTP id o2mr6332442qta.400.1639493181352;
        Tue, 14 Dec 2021 06:46:21 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id d9sm10368qkn.131.2021.12.14.06.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:46:21 -0800 (PST)
Date: Tue, 14 Dec 2021 15:46:18 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 30/33] mm: Remove slab from struct page
Message-ID: <YbiuOik7okqgLQaV@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-31-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-31-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:07PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> All members of struct slab can now be removed from struct page.
> This shrinks the definition of struct page by 30 LOC, making
> it easier to understand.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
