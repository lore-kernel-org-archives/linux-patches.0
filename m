Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A2173
	for <patches@lists.linux.dev>; Sun, 12 Dec 2021 06:00:07 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id j11so11640060pgs.2
        for <patches@lists.linux.dev>; Sat, 11 Dec 2021 22:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kB9exNo42Y5DkFvS1nHe23MR4UO4ZzBwWX7LEeG3EKg=;
        b=Fx13XGlXT0MPzeOlvY8MMP5rweR2HmS+fXHOoqLuUGKhiS3SzeKHUUxBfaY8ioE+ts
         dDiw1QygdB40R1DQ5USwseXdhPZW17utITvi8XqCESsBe+IJPRZGuBxmq1UCceqfEwfS
         oJH1wNR54vPDr5B/LTz21Fnqwah2jUvb/SrezFQAz3vxWwLrelCi8hfk22BCwwtxjgcu
         zs64Ra6ck7YLWZCJ0h2pQ2RJxUaS31740zTEUqku3QUHX2uhqSi1QLwP41Pcy9/Rcab8
         Ds8DsXLuq4NNL2GDyOQ5zxMDlUctyvuzU0bpKSDAvUFCZ6elsA1nElN/oNfA/WA5NqLR
         3m8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kB9exNo42Y5DkFvS1nHe23MR4UO4ZzBwWX7LEeG3EKg=;
        b=3mcxeHONTFKC5iEw7witn4oie/gDoozORU14GNYmynSKORfPXSDx8aU4YtQt5vLi4G
         nr/WOKO+StsHzzODXZ572C3I6Zx/K0wSQHBKLmOx+80ATWgjuZR5vz1hoh3uVyv0bSCG
         VU3U4ddCfU7rvhJRXch9X3bVYPTQYxOIUcL8qrR7uEqsaBvK0kHHKgkDfEQ4/XwxKDFo
         2de4mMfkOGMcPO+iuWCdFaSq/D0QvpIUWM5ejiTsqh/pYYaKtSeQNE+JKWwmN0m+YQvo
         pgS+Oh3Zi6ditP2FL1lhJQm9idG05jpGPqTKhxDHJu6JHA0htshfcaakOcbMGqtjQROd
         XSlA==
X-Gm-Message-State: AOAM533iv5algw+1lJSaQ61LIm5lKfRYHUhWggG73HOFQfRUc5beTnPo
	DoKk7OINDQ/0A9SvZ4s4bHM=
X-Google-Smtp-Source: ABdhPJwoGCL7eY9t4ARqcSPOFxTcOYgTKU5ihYyZWDzdV45N9WElBOPbInt9CTFqoS+AByoPwwfjOw==
X-Received: by 2002:a63:5407:: with SMTP id i7mr37203096pgb.242.1639288806677;
        Sat, 11 Dec 2021 22:00:06 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id ng9sm3492264pjb.4.2021.12.11.22.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 22:00:06 -0800 (PST)
Date: Sun, 12 Dec 2021 06:00:00 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v2 31/33] mm/sl*b: Differentiate struct slab fields by
 sl*b implementations
Message-ID: <20211212060000.GB882557@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-32-vbabka@suse.cz>
 <20211210163757.GA717823@odroid>
 <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>
 <YbTQk9Dj+kUYAX09@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbTQk9Dj+kUYAX09@casper.infradead.org>

On Sat, Dec 11, 2021 at 04:23:47PM +0000, Matthew Wilcox wrote:
> On Fri, Dec 10, 2021 at 07:26:11PM +0100, Vlastimil Babka wrote:
> > > Because SLUB and SLAB sets slab->slab_cache = NULL (to set page->mapping = NULL),
> > 
> > Hm, now that you mention it, maybe it would be better to do a
> > "folio->mapping = NULL" instead as we now have a more clearer view where we
> > operate on struct slab, and where we transition between that and a plain
> > folio. This is IMHO part of preparing the folio for freeing, not a struct
> > slab cleanup as struct slab doesn't need this cleanup.
> 
> Yes, I did that as part of "mm/slub: Convert slab freeing to struct slab"
> in my original series:
> 
> -       __ClearPageSlabPfmemalloc(page);
> +       __slab_clear_pfmemalloc(slab);
>         __ClearPageSlab(page);
> -       /* In union with page->mapping where page allocator expects NULL */
> -       page->slab_cache = NULL;
> +       page->mapping = NULL;

Didn't know your original patch series did it already.
Vlastimil, would you update that patch?
