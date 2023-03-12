Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FAB1C30
	for <patches@lists.linux.dev>; Sun, 12 Mar 2023 09:51:36 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso8954900wmq.1
        for <patches@lists.linux.dev>; Sun, 12 Mar 2023 01:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678614695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYJHI/EfuMD9TjucsF8nMSkY3NaUSb9pPppxfCuZDtQ=;
        b=OiBlMquFJnyyh0cAOpI2tT1Me3j63TVo647wS6ZQswQBwnUeQ8LgvVpjlys9jG25og
         vdv8uSLoo7AUTayhdsyH1O8dgkDZ37x328pHo08RFZ5Xuk/48Rcop4yvzh0A1gy1Txj5
         EtIVxwohuMaInKlyst/QMyenkSXOSuVw31f7OPghF6U1B0J8u+HLKPplK7EnA0jNDZEw
         yiUrWFpjtDT+fuQLwUaFWwQBXHuGnrpWPT266/16zOwe4Gj8iDI38YvDWqogbhEyC0f9
         pcG7CecBK8fm/W49akwnJhN7juow123XP57SY5v3uApZwwOppBnuEImLdsoQ5sCavKSY
         k0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678614695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYJHI/EfuMD9TjucsF8nMSkY3NaUSb9pPppxfCuZDtQ=;
        b=23iwCfXQeTspCutjVKR7rWTjOU9iOVfofxUj53I6rzPIh/o5CXJuq1D/SgvlHy6fNi
         nlrQVktkb2z8hJz+ypYrGjuMLA1vmiEfUSnksgynbvh1RjP6SqZlfUn46mqAbQxhDa2z
         Ug2eQwLg+QfwOBvnsaUSpYxCIBIegTeDHRgR/3xze63G/yp1NSuC9lDGarSWQe4WW7HK
         4zFxhXD3D/8Dzv/LH8E/1ZgWndkOCmzTekvZt7txNZJIa3xrMUEXIhjYZohQQr2zlBvl
         uIkk6d4cj7KEapsWa0qS5Ut034EsNhRLV+249dTXMcvChTaH+HO3U9JFFdsXzMsNg6bx
         FblQ==
X-Gm-Message-State: AO0yUKW/Ji5ZiVB1C4xkThNXmwzBhnSXkDknxplf8rrRPUkzzDd245uJ
	VDmeLPgVRzfKxazX2FQe5fU=
X-Google-Smtp-Source: AK7set8I3/sMJfHoJWj4ZIL2psjhEh4qxAjjoLRfwfTwFlR33kxlCpaOUoNVNDvt8zsUZAGLuExwBQ==
X-Received: by 2002:a05:600c:45d2:b0:3ed:1fa1:73c5 with SMTP id s18-20020a05600c45d200b003ed1fa173c5mr1583270wmo.27.1678614694886;
        Sun, 12 Mar 2023 01:51:34 -0800 (PST)
Received: from kernel.org ([46.120.23.99])
        by smtp.gmail.com with ESMTPSA id hn4-20020a05600ca38400b003dc1d668866sm5407218wmb.10.2023.03.12.01.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 01:51:34 -0800 (PST)
Date: Sun, 12 Mar 2023 11:51:29 +0200
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Message-ID: <ZA2gofYkXRcJ8cLA@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>

Hi Vlastimil,

On Fri, Mar 10, 2023 at 11:32:02AM +0100, Vlastimil Babka wrote:
> Also in git:
> https://git.kernel.org/vbabka/h/slab-remove-slob-v1r1
> 
> The SLOB allocator was deprecated in 6.2 so I think we can start
> exposing the complete removal in for-next and aim at 6.4 if there are no
> complaints.
> 
> Besides code cleanup, the main immediate benefit will be allowing
> kfree() family of function to work on kmem_cache_alloc() objects (Patch
> 7), which was incompatible with SLOB.
> 
> This includes kfree_rcu() so I've updated the comment there to remove
> the mention of potential future addition of kmem_cache_free_rcu() as
> there should be no need for that now.
> 
> Otherwise it's straightforward. Patch 2 is a cleanup in net area, that I
> can either handle in slab tree or submit in net after SLOB is removed.
> Another cleanup in tomoyo is already in the tomoyo tree as that didn't
> need to wait until SLOB removal.
> 
> Vlastimil Babka (7):
>   mm/slob: remove CONFIG_SLOB
>   net: skbuff: remove SLOB-specific ifdefs
>   mm, page_flags: remove PG_slob_free
>   mm, pagemap: remove SLOB and SLQB from comments and documentation
>   mm/slab: remove CONFIG_SLOB code from slab common code
>   mm/slob: remove slob.c
>   mm/slab: document kfree() as allowed for kmem_cache_alloc() objects
> 
>  Documentation/admin-guide/mm/pagemap.rst     |   6 +-
>  Documentation/core-api/memory-allocation.rst |  15 +-
>  fs/proc/page.c                               |   5 +-
>  include/linux/page-flags.h                   |   4 -
>  include/linux/rcupdate.h                     |   6 +-
>  include/linux/slab.h                         |  39 -
>  init/Kconfig                                 |   2 +-
>  kernel/configs/tiny.config                   |   1 -
>  mm/Kconfig                                   |  22 -
>  mm/Makefile                                  |   1 -
>  mm/slab.h                                    |  61 --
>  mm/slab_common.c                             |   7 +-
>  mm/slob.c                                    | 757 -------------------
>  net/core/skbuff.c                            |  16 -
>  tools/mm/page-types.c                        |   6 +-
>  15 files changed, 23 insertions(+), 925 deletions(-)
>  delete mode 100644 mm/slob.c

git grep -in slob still gives a couple of matches. I've dropped the
irrelevant ones it it left me with these:

CREDITS:14:D: SLOB slab allocator
kernel/trace/ring_buffer.c:358: * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
mm/Kconfig:251:    SLOB allocator and is not recommended for systems with more than
mm/Makefile:25:KCOV_INSTRUMENT_slob.o := n
 
Except the comment in kernel/trace/ring_buffer.c all are trivial.

As for the comment in ring_buffer.c, it looks completely irrelevant at this
point.

@Steve?

> -- 
> 2.39.2
> 

-- 
Sincerely yours,
Mike.
