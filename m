Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4D33229
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 16:44:12 +0000 (UTC)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-58de42f9f05so11183447b3.2
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 09:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692377051; x=1692981851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9P7447XsqgIF8Zs3AF355EyK2GKzJK0n7pd9FK7O74c=;
        b=AVR8drzzV1jSIeS+6WTiIUSSUB8ZYXltISVhJBEn8PrLH0osW2yszwCzu7JBSdDJrY
         7bs/r10buSJ5QfBO30XP7gYuern4TaeS/XhNtN/HOHNLuqjwGZ99S3nDStB83ZVFI5qH
         6bndknIMHLDom9WPne/d9DviiSasD/JHcmy2ZyaNAeHxKkIhNc2YCo+p08P3y0pQz45y
         PgnPQgkaaUe22gM6oW6o+2ftvxm8J4/z0nnhcLe0QMRoqvADnRTPZ6vkUdq+qsuQSiqu
         a7HEmJtox31ZtxdYSulJjNkUqY/MX6tFuRO4pDE0KEAVzTMcUnNj8zqQ4zbYVebw7Fgr
         jg4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692377051; x=1692981851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9P7447XsqgIF8Zs3AF355EyK2GKzJK0n7pd9FK7O74c=;
        b=iNUspPqAl3il1t4WZLpZakbiiwPVDYIpT1aHl6JUoitF556YAf7sgOA4EaUSR6PwXE
         qvvHM63EQoFtsPfU604hBbEo1ory1Qma9KVSJ1Q06lkV2shaHZWGOGJLy/+5oRIy6Nes
         u9w8YaY9MUuJNLxoojvB6H7GyP0goIY/sHofbI650dhOJfJm8N70MSXWhy0UTVlIcCiA
         Hh9NRSNEUVBt3j58cG3qB52XMJan8lYeaUWbdXp3fDmLJA3ztB7gPA8hYfsa9LQj6rnO
         4oJue6NO8pbnOojItVre6zW/w1qgqv44O1X+4R0VNH7Jf+7z91cHVYswJwpjwADyK1OO
         652Q==
X-Gm-Message-State: AOJu0YxYBIXOSKLHpq4fh7TChxGxGyvoDkZ7NK8iiAoJopq8jg+iAcNc
	ll2PmYoiKXozG3p49iJ9gawdPaCh0fFbPRUKVfEZLw==
X-Google-Smtp-Source: AGHT+IGacrk6tM8XfvYr6ThN49LbIVHzdTS1nW+KqSygNVELulS+P9RtU5E1u49WaXElBwnyPH/RTDuRygmQ1LIUH5o=
X-Received: by 2002:a05:6902:1505:b0:d1f:6886:854a with SMTP id
 q5-20020a056902150500b00d1f6886854amr4225556ybu.9.1692377051051; Fri, 18 Aug
 2023 09:44:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230810163627.6206-9-vbabka@suse.cz>
In-Reply-To: <20230810163627.6206-9-vbabka@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 18 Aug 2023 09:44:00 -0700
Message-ID: <CAJuCfpHoFrCQxHwa9gdf4G7Bps3GaZzosKcu1O-2Bm34oENeGA@mail.gmail.com>
Subject: Re: [RFC v2 0/7] SLUB percpu array caches and maple tree nodes
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 10, 2023 at 9:36=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Also in git [1]. Changes since v1 [2]:
>
> - fix a few bugs
> - SLAB marked as BROKEN so bots dont complain about missing functions
> - incorporate Liam's patches, which allows getting rid of preallocations
>   in mas_prealloc() completely. This has reduced the allocation stats
>   further, with the whole series.
>
> More notes wrt v1 RFC feedback:
>
> - locking is still done as in v1, as it allows remote draining, which
>   should be added before this is suitable for merging
> - there's currently no bulk freeing/refill of the percpu array, which
>   will eventually be added, but I expect most perf gain for the maple
>   tree use case to come from the avoided preallocations anyway
>
> ----
>
> At LSF/MM I've mentioned that I see several use cases for introducing
> opt-in percpu arrays for caching alloc/free objects in SLUB. This is my
> first exploration of this idea, speficially for the use case of maple
> tree nodes. We have brainstormed this use case on IRC last week with
> Liam and Matthew and this how I understood the requirements:
>
> - percpu arrays will be faster thank bulk alloc/free which needs
>   relatively long freelists to work well. Especially in the freeing case
>   we need the nodes to come from the same slab (or small set of those)
>
> - preallocation for the worst case of needed nodes for a tree operation
>   that can't reclaim due to locks is wasteful. We could instead expect
>   that most of the time percpu arrays would satisfy the constained
>   allocations, and in the rare cases it does not we can dip into
>   GFP_ATOMIC reserves temporarily. Instead of preallocation just prefill
>   the arrays.
>
> - NUMA locality is not a concern as the nodes of a process's VMA tree
>   end up all over the place anyway.
>
> So this RFC patchset adds such percpu array in Patch 2. Locking is
> stolen from Mel's recent page allocator's pcplists implementation so it
> can avoid disabling IRQs and just disable preemption, but the trylocks
> can fail in rare situations.
>
> Then maple tree is modified in patches 3-6 to benefit from this. This is
> done in a very crude way as I'm not so familiar with the code.
>
> I've briefly tested this with virtme VM boot and checking the stats from
> CONFIG_SLUB_STATS in sysfs.
>
> Patch 2:
>
> slub changes implemented including new counters alloc_cpu_cache
> and free_cpu_cache but maple tree doesn't use them yet
>
> (none):/sys/kernel/slab/maple_node # grep . alloc_cpu_cache alloc_*path f=
ree_cpu_cache free_*path | cut -d' ' -f1
> alloc_cpu_cache:0
> alloc_fastpath:54842
> alloc_slowpath:8142
> free_cpu_cache:0
> free_fastpath:32336
> free_slowpath:23484
>
> Patch 3:
>
> maple node cache creates percpu array with 32 entries,
> not changed anything else
>
> -> some allocs/free satisfied by the array
>
> alloc_cpu_cache:11956
> alloc_fastpath:40675
> alloc_slowpath:7308
> free_cpu_cache:12082
> free_fastpath:23617
> free_slowpath:17956
>
> Patch 4:
>
> maple tree nodes bulk alloc/free converted to loop of normal alloc to use
> percpu array more, because bulk alloc bypasses it
>
> -> majority alloc/free now satisfied by percpu array
>
> alloc_cpu_cache:54673
> alloc_fastpath:4491
> alloc_slowpath:737
> free_cpu_cache:54759
> free_fastpath:332
> free_slowpath:4723
>
> Patch 5+6:
>
> mas_preallocate() just prefills the percpu array, doesn't preallocate any=
thing
> mas_store_prealloc() gains a retry loop with mas_nomem(mas, GFP_ATOMIC | =
__GFP_NOFAIL)
>
> -> major drop of alloc/free
> (the prefills are included in the accounting)
>
> alloc_cpu_cache:15036
> alloc_fastpath:4651
> alloc_slowpath:656
> free_cpu_cache:15102
> free_fastpath:299
> free_slowpath:4835
>
> It would be interesting to see how it affects the workloads that saw
> regressions from the maple tree introduction, as the slab operations
> were suspected to be a major factor and now they should be both reduced
> and made cheaper.

Hi Vlastimil,
I backported your patchset to 6.1 and tested it on Android with my
mmap stress test (mmap a file-backed page, read-fault, unmap all in a
tight loop). The performance of such tests is important for Android
because that's what is being done during application launch and app
launch time is an important metric for us. I recorded 1.8% performance
improvement with this test.
Thanks,
Suren.

>
> Liam R. Howlett (2):
>   maple_tree: Remove MA_STATE_PREALLOC
>   tools: Add SLUB percpu array functions for testing
>
> Vlastimil Babka (5):
>   mm, slub: fix bulk alloc and free stats
>   mm, slub: add opt-in slub_percpu_array
>   maple_tree: use slub percpu array
>   maple_tree: avoid bulk alloc/free to use percpu array more
>   maple_tree: replace preallocation with slub percpu array prefill
>
>  include/linux/slab.h                    |   4 +
>  include/linux/slub_def.h                |  10 ++
>  lib/maple_tree.c                        |  60 ++++---
>  mm/Kconfig                              |   1 +
>  mm/slub.c                               | 221 +++++++++++++++++++++++-
>  tools/include/linux/slab.h              |   4 +
>  tools/testing/radix-tree/linux.c        |  14 ++
>  tools/testing/radix-tree/linux/kernel.h |   1 +
>  8 files changed, 286 insertions(+), 29 deletions(-)
>
> --
> 2.41.0
>
