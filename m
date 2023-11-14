Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6AE3B798
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 12:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y63T0LL+"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4ac3083ca04so2531454e0c.1
        for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699963287; x=1700568087; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w+cNKD/DZD2lkmgn//C/a4VZOCUEay1a0fxR4tTnP1Y=;
        b=y63T0LL+5unjEIuqfXVqzAD14R+ZqXNmITZfIkJzrOGL3fOt+SrXQ3pxvSm2l3n1kh
         Bw7WGSIAk6oMTnTGmZqYteXiq+azudNUpOXGAsp/a4tFnfTr1cuHg42GmG1fWLZUBikI
         Nc2nD4ZLJByWkTXRIY6hQqVnKlW2B/79j2Vb3drvISS+Yo8aw9xZAX+ZZAH/lXXJAWmA
         notRWu5rHHsbgpyxFmGGUUVvAbilXzxk0840/n0UzyLkV6XI4qP1IIneEmnAZhOegJKr
         v8lJxGDy08TSqlB2TbAn7ALPrwhrpsT3IYVVOewvJCkBzJKBZu6awxf63r8tD9cilFQ/
         K3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699963287; x=1700568087;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w+cNKD/DZD2lkmgn//C/a4VZOCUEay1a0fxR4tTnP1Y=;
        b=ATFhKsyJ1Q6GYap8GBYKsG6EQ3EnBx2AlLGqmgFSr2R4nt2yzQhcwdi4NICChUGyip
         T7aEUP2h10L4zQXIf/QOPLLNpcybWOp1z+kbHY4ULRQsd//78hV9AbVGlRy7rW5OeVi9
         VgpHy860tCEDjyPtfFaNre4k2AZ2W0Hsw4eZxTRgAncdtHtPg8MKflhNn2uiA/JVyodn
         XYuggEMouQEmxVNNIXZgWHip6Ob89VyH6hZpWQYrKMrmAo0olwgTRvBah9EBF6DgO23h
         RPUdmZKmyzfFZenEkjhH5Eht/qUg8wFEmbIrbtY7lzjnRZ5S/4jF0hjvuAhoYItB8Irs
         mzAQ==
X-Gm-Message-State: AOJu0Yz8Y25cDiIU+birRq5LsqAeCqXy3OS3QsFfond5QmC/oU8p0zg9
	E5Da7FzVs3r8uSjSMNTUuXS1YADMfxMh3x4lV7by7g==
X-Google-Smtp-Source: AGHT+IGdPTgrNucIG+Lo6vRM+7FUzSZPC0zMXelLtqwy0mDzkjNg/l2YT2+nTW9YrVKzffzwqrRySMvvW/+/It1UJuA=
X-Received: by 2002:a05:6122:1689:b0:4ac:593b:e9f4 with SMTP id
 9-20020a056122168900b004ac593be9f4mr9715321vkl.9.1699963287127; Tue, 14 Nov
 2023 04:01:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231113191340.17482-22-vbabka@suse.cz> <20231113191340.17482-24-vbabka@suse.cz>
In-Reply-To: <20231113191340.17482-24-vbabka@suse.cz>
From: Marco Elver <elver@google.com>
Date: Tue, 14 Nov 2023 13:00:00 +0100
Message-ID: <CANpmjNOy+K_jBkaZ9_+He9tT83PaYLama517YvQ1TH13ayg3vg@mail.gmail.com>
Subject: Re: [PATCH 02/20] KASAN: remove code paths guarded by CONFIG_SLAB
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Kees Cook <keescook@chromium.org>, 
	kasan-dev@googlegroups.com, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Nov 2023 at 20:14, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> With SLAB removed and SLUB the only remaining allocator, we can clean up
> some code that was depending on the choice.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  mm/kasan/common.c     | 13 ++-----------
>  mm/kasan/kasan.h      |  3 +--
>  mm/kasan/quarantine.c |  7 -------
>  3 files changed, 3 insertions(+), 20 deletions(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 256930da578a..5d95219e69d7 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -153,10 +153,6 @@ void __kasan_poison_object_data(struct kmem_cache *cache, void *object)
>   * 2. A cache might be SLAB_TYPESAFE_BY_RCU, which means objects can be
>   *    accessed after being freed. We preassign tags for objects in these
>   *    caches as well.
> - * 3. For SLAB allocator we can't preassign tags randomly since the freelist
> - *    is stored as an array of indexes instead of a linked list. Assign tags
> - *    based on objects indexes, so that objects that are next to each other
> - *    get different tags.
>   */
>  static inline u8 assign_tag(struct kmem_cache *cache,
>                                         const void *object, bool init)
> @@ -171,17 +167,12 @@ static inline u8 assign_tag(struct kmem_cache *cache,
>         if (!cache->ctor && !(cache->flags & SLAB_TYPESAFE_BY_RCU))
>                 return init ? KASAN_TAG_KERNEL : kasan_random_tag();
>
> -       /* For caches that either have a constructor or SLAB_TYPESAFE_BY_RCU: */
> -#ifdef CONFIG_SLAB
> -       /* For SLAB assign tags based on the object index in the freelist. */
> -       return (u8)obj_to_index(cache, virt_to_slab(object), (void *)object);
> -#else
>         /*
> -        * For SLUB assign a random tag during slab creation, otherwise reuse
> +        * For caches that either have a constructor or SLAB_TYPESAFE_BY_RCU,
> +        * assign a random tag during slab creation, otherwise reuse
>          * the already assigned tag.
>          */
>         return init ? kasan_random_tag() : get_tag(object);
> -#endif
>  }
>
>  void * __must_check __kasan_init_slab_obj(struct kmem_cache *cache,
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index 8b06bab5c406..eef50233640a 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -373,8 +373,7 @@ void kasan_set_track(struct kasan_track *track, gfp_t flags);
>  void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
>  void kasan_save_free_info(struct kmem_cache *cache, void *object);
>
> -#if defined(CONFIG_KASAN_GENERIC) && \
> -       (defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
> +#ifdef CONFIG_KASAN_GENERIC
>  bool kasan_quarantine_put(struct kmem_cache *cache, void *object);
>  void kasan_quarantine_reduce(void);
>  void kasan_quarantine_remove_cache(struct kmem_cache *cache);
> diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
> index ca4529156735..138c57b836f2 100644
> --- a/mm/kasan/quarantine.c
> +++ b/mm/kasan/quarantine.c
> @@ -144,10 +144,6 @@ static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
>  {
>         void *object = qlink_to_object(qlink, cache);
>         struct kasan_free_meta *meta = kasan_get_free_meta(cache, object);
> -       unsigned long flags;
> -
> -       if (IS_ENABLED(CONFIG_SLAB))
> -               local_irq_save(flags);
>
>         /*
>          * If init_on_free is enabled and KASAN's free metadata is stored in
> @@ -166,9 +162,6 @@ static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
>         *(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREE;
>
>         ___cache_free(cache, object, _THIS_IP_);
> -
> -       if (IS_ENABLED(CONFIG_SLAB))
> -               local_irq_restore(flags);
>  }
>
>  static void qlist_free_all(struct qlist_head *q, struct kmem_cache *cache)
> --
> 2.42.1
>
