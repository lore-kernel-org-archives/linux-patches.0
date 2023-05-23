Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39D31D2BF
	for <patches@lists.linux.dev>; Tue, 23 May 2023 08:19:33 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3078a3f3b5fso6992863f8f.0
        for <patches@lists.linux.dev>; Tue, 23 May 2023 01:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684829972; x=1687421972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MDpklUrK+KsfCrW9J+cj1U3VNImhXOwwklHmqV9tRbQ=;
        b=nvBjXPaUtAE20exKxcpajzt0s9UGInpM1IKYKt+mkmJzmgyErp0/zsxncMuSCi6+8+
         fGgYkrBYh8AtqxbnGocsqIxmDuUjvEXXKWGuPjlhWUxfNR6mddf2YGChKhrnEspP5vyn
         2UETpjmeBpqV5KJiRrhze8epT9QkK/BgJRT7aWJXe+CqOM/gzD+u2k+JWEM1duK/b1b6
         lrkTPirKyqIuTj2p+RKSJqWZIjwWw/BR1nmZR6Pt5S8qzAuPByXdbn7W7F84ybc3dDpR
         SHawnjSM1BtccRJZKiRztLAurAYBKctyrkDNFAAmluuUv7QOV7HR3xjtElgIpMxpXSQx
         Bi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684829972; x=1687421972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDpklUrK+KsfCrW9J+cj1U3VNImhXOwwklHmqV9tRbQ=;
        b=LK7Ec8NJxyQYkQFtMd/rbuPKDWcWW+NEPPNF+A9+s2mHYYheqRrqFWVta8JqpdAUo1
         KXgzGbxuqlp9v0LXcd9PZCeGHCfU4GmuzVfH/vYuYb/8ceKoDeDcGDovwtlAaxJ6QHXn
         IuEhHI1tJWSWdC4EKMDCRU0MiX4dCMOT8nnCd2dmmnt/ROAOCBfRVzB2Rpi+UfREu9kQ
         9LoKQT4OW1Rt5YY/gSfTPVfimlWKN8aJa/bVFW01m3U1g+446bUlRyVnfDUDKDQCGNUR
         qsL+krIVw7TXhDz1QoyFyoKjpVOWa+W4rubAW44e/07sOXj631MLEYr9gyl5kFvF0Wmr
         5dgQ==
X-Gm-Message-State: AC+VfDxcrBt2f0SrwUhh9azC9p3DkTziYXfNCmSgcAZq5qjUO1qAxGhI
	ql5BifTRiiyyRQK9iZ9a7/o=
X-Google-Smtp-Source: ACHHUZ5Jx/TmEjjLT2eWEUOapJJs0gZVKqgVZdNUx79sB2n/taEIWzDxtMsresMpxEfdSTrQLYlKBg==
X-Received: by 2002:a5d:5588:0:b0:304:a40c:43c6 with SMTP id i8-20020a5d5588000000b00304a40c43c6mr9680909wrv.11.1684829971883;
        Tue, 23 May 2023 01:19:31 -0700 (PDT)
Received: from localhost (host81-154-179-160.range81-154.btcentralplus.com. [81.154.179.160])
        by smtp.gmail.com with ESMTPSA id f12-20020a5d58ec000000b00309257ad16csm10267702wrd.29.2023.05.23.01.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 01:19:30 -0700 (PDT)
Date: Tue, 23 May 2023 09:19:30 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: remove HAVE_HARDENED_USERCOPY_ALLOCATOR
Message-ID: <4674f97f-5f97-45b7-a4b9-a19ca46b7ce1@lucifer.local>
References: <20230523073136.4900-1-vbabka@suse.cz>
 <310077ed-6f3f-41fe-afcf-36500a9408ec@lucifer.local>
 <623a87c6-c0d2-799a-c39e-0d14dcdfa6df@suse.cz>
 <ae3ff438-5e5a-4a75-b4e9-575324a584f7@lucifer.local>
 <ca7860db-220f-ae77-93e6-2a38f6c1130a@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca7860db-220f-ae77-93e6-2a38f6c1130a@redhat.com>

On Tue, May 23, 2023 at 10:14:24AM +0200, David Hildenbrand wrote:
> On 23.05.23 09:56, Lorenzo Stoakes wrote:
> > On Tue, May 23, 2023 at 09:46:46AM +0200, Vlastimil Babka wrote:
> > > On 5/23/23 09:42, Lorenzo Stoakes wrote:
> > > > On Tue, May 23, 2023 at 09:31:36AM +0200, Vlastimil Babka wrote:
> > > > > With SLOB removed, both remaining allocators support hardened usercopy,
> > > > > so remove the config and associated #ifdef.
> > > > >
> > > > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > > > > ---
> > > > >   mm/Kconfig       | 2 --
> > > > >   mm/slab.h        | 9 ---------
> > > > >   security/Kconfig | 8 --------
> > > > >   3 files changed, 19 deletions(-)
> > > > >
> > > > > diff --git a/mm/Kconfig b/mm/Kconfig
> > > > > index 7672a22647b4..041f0da42f2b 100644
> > > > > --- a/mm/Kconfig
> > > > > +++ b/mm/Kconfig
> > > > > @@ -221,7 +221,6 @@ choice
> > > > >   config SLAB
> > > > >   	bool "SLAB"
> > > > >   	depends on !PREEMPT_RT
> > > > > -	select HAVE_HARDENED_USERCOPY_ALLOCATOR
> > > > >   	help
> > > > >   	  The regular slab allocator that is established and known to work
> > > > >   	  well in all environments. It organizes cache hot objects in
> > > > > @@ -229,7 +228,6 @@ config SLAB
> > > > >
> > > > >   config SLUB
> > > > >   	bool "SLUB (Unqueued Allocator)"
> > > > > -	select HAVE_HARDENED_USERCOPY_ALLOCATOR
> > > > >   	help
> > > > >   	   SLUB is a slab allocator that minimizes cache line usage
> > > > >   	   instead of managing queues of cached objects (SLAB approach).
> > > > > diff --git a/mm/slab.h b/mm/slab.h
> > > > > index f01ac256a8f5..695ef96b4b5b 100644
> > > > > --- a/mm/slab.h
> > > > > +++ b/mm/slab.h
> > > > > @@ -832,17 +832,8 @@ struct kmem_obj_info {
> > > > >   void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
> > > > >   #endif
> > > > >
> > > > > -#ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
> > > > >   void __check_heap_object(const void *ptr, unsigned long n,
> > > > >   			 const struct slab *slab, bool to_user);
> > > > > -#else
> > > > > -static inline
> > > > > -void __check_heap_object(const void *ptr, unsigned long n,
> > > > > -			 const struct slab *slab, bool to_user)
> > > > > -{
> > > > > -}
> > > > > -#endif
> > > >
> > > > Hm, this is still defined in slab.c/slub.c and invoked in usercopy.c, do we
> > > > not want the prototype?
> > >
> > > Well I didn't delete the prototype, just the ifdef/else around, so now it's
> > > there unconditionally.
> > >
> > > > Perhaps replacing with #ifdef
> > > > CONFIG_HARDENED_USERCOPY instead? I may be missing something here :)
> > >
> > > Putting it under that #ifdef would work and match that the implementations
> > > of that function are under that same ifdef, but maybe it's unnecessary noise
> > > in the header?
> > >
> >
> > Yeah my brain inserted extra '-'s there, sorry!
> >
> > Given we only define __check_heap_object() in sl[au]b.c if
> > CONFIG_HARDENED_USERCOPY wouldn't we need to keep the empty version around
> > if !CONFIG_HARDENED_USERCOPY since check_heap_object() appears to be called
> > unconditionally?
> >
>
> The file is only compiled with CONFIG_HARDENED_USERCOPY:
>
> mm/Makefile:obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
>

Yeah ugh at this sort of implicit thing. Anyway it'd be preferable to stick
#ifdef CONFIG_HARDENED_USERCOPY around the prototype just so it's
abundantly clear this function doesn't exist unless that is set.

>
>
> Reviewed-by: David Hildenbrand <david@redhat.com>
>
> --
> Thanks,
>
> David / dhildenb
>
