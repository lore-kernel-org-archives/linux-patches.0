Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9FF173
	for <patches@lists.linux.dev>; Sun, 12 Dec 2021 05:54:27 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id h24so9647089pjq.2
        for <patches@lists.linux.dev>; Sat, 11 Dec 2021 21:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ENK+0yKya7IQicbCDEeQU/Qo9FMF4UqG6i5xVlrxVaY=;
        b=o37rdZ0Gt/FC9sifOFJ0ORRQnofs4eXW/G5oz6azQD1ipZwZ29WszkMGjzy93ZCCm3
         7URHidBMAedI4oizi1LnuQdx5A7GeNE/Z74c8l21FHQf+FRrYYcDYTu1AAdON0D1+l8C
         5O5K1qn+RYaNqjvwLimFcV/QNzWrgFL4ptxu6kokpfh3783v9sj0Y9tCs0n0DzR3mRbH
         jhmPKQkZOnzqIRdE0vAzaW7HzyfMiyRTkNXJE49d1mu77tQtF+xR+4m7aoTkwZ8xXukF
         Yr29nK5tBXRmukaqYEomox6/8dN9kcCe7ZxWmKs/QQn+TTkN0KnMzdWDYIok8WELvzk3
         XsEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ENK+0yKya7IQicbCDEeQU/Qo9FMF4UqG6i5xVlrxVaY=;
        b=3PKetn9r9o1PCcZpnrAjQEpDLIAne6e0sXDoKQFhvG6aoqxRZzH1rWfs/JvUD5H8tj
         jx3qYV99p5YUEATewy9jJgN40ZALni+9dqPPxXMTNuqlEao4e0wBPUKcm7ArlI6gUhef
         UBlW4Ga9wrgaw/iVDib/HUEipKxux1ouml60rEy1cqt0Ny9EP105zWUuxE946CHyZORk
         ISCutjAX9h9xW46wGhUUe6QmfLE9Auu7WHKs+iR5gWezIr5cUc97EVaG0qCPka69MhJo
         dSKiK8CiyGe46kLxhEC8kn8qHfETtQSgEwx+5Lv7NhJCRbldH2ZRxBokry1eZWPnfXTy
         wXPQ==
X-Gm-Message-State: AOAM531xy76UgM5tYgdaA47COMI5EsygoEFAa5O/RfcjEwqlII2NAcLO
	QupFMSoA7pnQ871YuiN0S1c=
X-Google-Smtp-Source: ABdhPJxbxVNBAF7cLZXZ8UnIQ3EeBCQ3238lOBMZ2VFW9TXQN3eO8aZTGMX/tsyoTX15jE+4+2OJQA==
X-Received: by 2002:a17:90b:4b4c:: with SMTP id mi12mr35546234pjb.66.1639288466879;
        Sat, 11 Dec 2021 21:54:26 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id x37sm8530902pfh.116.2021.12.11.21.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 21:54:26 -0800 (PST)
Date: Sun, 12 Dec 2021 05:54:20 +0000
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
Message-ID: <20211212055420.GA882557@odroid>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-32-vbabka@suse.cz>
 <20211210163757.GA717823@odroid>
 <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>
 <20211211115527.GA822127@odroid>
 <YbTXXwVy/a+/9PCn@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbTXXwVy/a+/9PCn@casper.infradead.org>

On Sat, Dec 11, 2021 at 04:52:47PM +0000, Matthew Wilcox wrote:
> On Sat, Dec 11, 2021 at 11:55:27AM +0000, Hyeonggon Yoo wrote:
> > On Fri, Dec 10, 2021 at 07:26:11PM +0100, Vlastimil Babka wrote:
> > > On 12/10/21 17:37, Hyeonggon Yoo wrote:
> > > > On Wed, Dec 01, 2021 at 07:15:08PM +0100, Vlastimil Babka wrote:
> > > >> With a struct slab definition separate from struct page, we can go further and
> > > >> define only fields that the chosen sl*b implementation uses. This means
> > > >> everything between __page_flags and __page_refcount placeholders now depends on
> > > >> the chosen CONFIG_SL*B.
> > > > 
> > > > When I read this patch series first, I thought struct slab is allocated
> > > > separately from struct page.
> > > > 
> > > > But after reading it again, It uses same allocated space of struct page.
> > > 
> > > Yes. Allocating it elsewhere is something that can be discussed later. It's
> > > not a simple clear win - more memory used, more overhead, complicated code...
> > >
> > 
> > Right. That is a something that can be discussed,
> > But I don't think there will be much win.
> 
> Oh no, there's a substantial win.  If we can reduce struct page to a
> single pointer, that shrinks it from 64 bytes/4k to 8 bytes/4k.  Set
> against that, you have to allocate the struct folio / struct slab / ...
> but then it's one _per allocation_ rather than one per page.  So for
> an order-2 allocation, it takes 32 bytes + 64 bytes (= 96 bytes)
> rather than 4*64 = 256 bytes.  It's an even bigger win for larger
> allocations, and it lets us grow the memory descriptors independently
> of each other.

Oh I thought there won't be much win because I thought it was
just allocating additional memory for struct slab and still allocating
memory for struct page as we do now.

It will be more efficient if we can allocate descriptor of slab/page/...etc
per *allocation*, which may have order > 1. And currently we're
duplicating memory descriptor (struct page) even on high order
allocation.

Even if we do not allocate high order page at all, it's
still efficient if we can reduce struct page into double word.
And we can allocate something like struct slab only when we need it. 

One challenge here is that we should allocate the descriptors
dynamically... I'm going to read the link you sent.

> Everything currently using struct page needs to
> be converted to use another type, and that's just the pre-requisite
> step.
> 

Oh, you're planning to separate *everything* from
struct page, not only struct slab!

So your intention of this patch series is preparing for
physical separation. It's fascinating...

> But it's also a substantial amount of work, so don't expect us to get
> there any time soon.

Yeah, that will require much work. But I'll wait for your good work.
It's so interesting.

> Some more thoughts on this here:
> https://lore.kernel.org/linux-mm/YXcLqcFhDq3uUwIj@casper.infradead.org/
> 

Thank you for the link.

> > > Yeah. Also whatever aliases with compound_head must not have bit zero set as
> > > that means a tail page.
> > > 
> > 
> > Oh I was missing that. Thank you.
> > 
> > Hmm then in struct slab, page->compound_head and slab->list_head (or
> > slab->rcu_head) has same offset. And list_head / rcu_head both store pointers.
> > 
> > then it has a alignment requirement. (address saved in list_head/rcu_head
> > should be multiple of 2)
> > 
> > Anyway, it was required long time before this patch,
> > so it is not a problem for this patch.
> 
> Yes, that's why there's an assert that the list_heads all line up.  This
> requirement will go away if we do get separately allocated memory
> descriptors (because that bottom bit is no longer PageTail).

Yeah, we don't need to care that if we separately allocate memory for
struct slab.

Thanks,
Hyeonggon.

