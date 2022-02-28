Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62B853A4
	for <patches@lists.linux.dev>; Mon, 28 Feb 2022 10:51:27 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2d07ae0b1bfso102900997b3.6
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 02:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYkiTGE+IL621wQjI8CgMwBjCYo+uE8eI9lxYVOTdh4=;
        b=RgzHqIp1vA8is+C2ytkSxIxm4DQxeOY/hmAu6Qz3W1Q93ZAHaBl9TSm9MdRE48hQHp
         EcIAdPLfPu6/h7lXHaroH40GzxJBOSc0ioDrKP4QB8iOQlbT4slFg2FSDyrWxg4UgjE3
         bOM9MSgnY3oaG+1e30qKUFXA4jeONfittua8vGZfygqJ/HPOqUbs7Q8OJ7QitjMJxPhS
         ZrsJDGMk23U2ili69HorKtfW6zbNnbsOYRaRVp6Tt345WWGtGJjQo0l4LAGmA0PKIsgt
         FUfFiZ4o46XXMd2vFJsoOHHII2yv9PvbSmtMIqAd8a/+ZEnDLxV+vb07oex9eUIV/9lw
         GgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYkiTGE+IL621wQjI8CgMwBjCYo+uE8eI9lxYVOTdh4=;
        b=lvtEGB3CPhxv4wA8C2UOdXVyHbt3/OjsYf8gIKVwqM9J7gp0YmwvuP2VYMxXz84Mny
         nVsEQ5UfoQZGS8bukthD9tDXmlKm7fOQs4jT9wsLWcKU38ursRANtowSwGDJgZGNAe/M
         Wxk/5343hk4sqBXJUGykI+S1mMQ6mimPBdP5njLKk+Lam2QvDqQyR7l3/LWboESTtu4i
         R8oudITDteFB239SDWFsz1qL6YSyx61Nx6MiJ1xjsHYK5Vrs7vzWE5yFY5acci7HchGi
         YjufCa3g84Z9DJWAXMjbjziHvrzwVoq+hWduDl5Q95unXbvU6krb7wwd1H+t09PrEqpo
         bo+w==
X-Gm-Message-State: AOAM533TuPh936LAJS/dvnX9ai6ZvxxGzhOZLZntLOIY1UAhJyGL0Scr
	kf0rFwOmPyzeNq/AimpUFw32hBwsSPpTQv71SQsFhQ==
X-Google-Smtp-Source: ABdhPJxNJhPVWSLXvI3iBbzOTe+qklatZ5k5QaYFXfBVeasYi8gKHeTY8TCV153zvQlSda9HbUSe36S5qOS966ph55M=
X-Received: by 2002:a81:1a49:0:b0:2d7:fc73:dab2 with SMTP id
 a70-20020a811a49000000b002d7fc73dab2mr19291710ywa.316.1646045486359; Mon, 28
 Feb 2022 02:51:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220225180318.20594-3-vbabka@suse.cz> <YhrrM7NTYXG5JluY@ip-172-31-19-208.ap-northeast-1.compute.internal>
 <CANpmjNOyVTQZroOEVF_ZLASCtQ=SiC12WGWEwOib3vDk3sCbtw@mail.gmail.com> <YhyeaP8lrzKgKm5A@ip-172-31-19-208.ap-northeast-1.compute.internal>
In-Reply-To: <YhyeaP8lrzKgKm5A@ip-172-31-19-208.ap-northeast-1.compute.internal>
From: Marco Elver <elver@google.com>
Date: Mon, 28 Feb 2022 11:50:49 +0100
Message-ID: <CANpmjNOOhuoU7T4UqHbzkRAvM+b-gvt+Qtx41va=9ixGgUSWaQ@mail.gmail.com>
Subject: Re: [PATCH] lib/stackdepot: Use page allocator if both slab and
 memblock is unavailable
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, 
	Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Oliver Glitta <glittao@gmail.com>, Faiyaz Mohammed <faiyazm@codeaurora.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Johannes Berg <johannes.berg@intel.com>, 
	Yury Norov <yury.norov@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, Matteo Croce <mcroce@microsoft.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Imran Khan <imran.f.khan@oracle.com>, 
	Zqiang <qiang.zhang@windriver.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 28 Feb 2022 at 11:05, Hyeonggon Yoo <42.hyeyoo@gmail.com> wrote:
[...]
> > This is odd - who is calling stack_depot_init() while neither slab nor
> > memblock are available?
>
> It's not merged yet - but Oliver's patch (2/5) in his series [1] does:
> If user is debugging cache, it calls stack_depot_init() when creating
> cache.
>
> > @@ -4221,6 +4220,9 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
> >       s->remote_node_defrag_ratio = 1000;
> >  #endif
> >
> > +     if (s->flags & SLAB_STORE_USER && IS_ENABLED(CONFIG_STACKDEPOT))
> > +             stack_depot_init();
> > +
>
> Oliver's patch series enables stack depot when arch supports stacktrace,
> to store slab objects' stack traces. (as slub debugging feature.)
>
> Because slub debugging is turned on by default, the commit 2dba5eb1c73b
> ("lib/stackdepot: allow optional init and stack_table allocation by
> kvmalloc()") made stack_depot_init() can be called later.
>
> With Oliver's patch applied, stack_depot_init() can be called in
> contexts below:
>
>   1) only memblock available (for kasan)
>   2) only buddy available, vmalloc/memblock unavailable (for boot caches)
>   3) buddy/slab available, vmalloc/memblock unavailable (vmap_area cache)
>   4) buddy/slab/vmalloc available, memblock unavailable (other caches)
>
> SLUB supports enabling debugging for specific cache by passing
> slub_debug boot parameter. As slab caches can be created in
> various context, stack_depot_init() should consider all contexts above.
>
> Writing this, I realized my patch does not handle case 3).. I'll send v3.
>
> [1] https://lore.kernel.org/linux-mm/YhoakP7Kih%2FYUgiN@ip-172-31-19-208.ap-northeast-1.compute.internal/T/#t
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slub-stackdepot-v1
>
> > Do you have a stacktrace?
>
> Yeah, here:
>
> You can reproduce this on vbabka's slab-stackdepot-v1 branch [2] with
> slub_debug=U, and CONFIG_STACKDEPOT_ALWAYS_INIT=n
>
[...]
> [    0.000000] Call trace:
> [    0.000000]  __memset+0x16c/0x188
> [    0.000000]  stack_depot_init+0xc8/0x100
> [    0.000000]  __kmem_cache_create+0x454/0x570
> [    0.000000]  create_boot_cache+0xa0/0xe0

I think even before this point you have all the information required
to determine if stackdepot will be required. It's available after
setup_slub_debug().

So why can't you just call stack_depot_init() somewhere else and avoid
all this complexity?

> [    0.000000]  kmem_cache_init+0xf8/0x204
> [    0.000000]  start_kernel+0x3ec/0x668
> [    0.000000]  __primary_switched+0xc0/0xc8
> [    0.000000] Code: 91010108 54ffff4a 8b040108 cb050042 (d50b7428)
> [    0.000000] ---[ end trace 0000000000000000 ]---
> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---
