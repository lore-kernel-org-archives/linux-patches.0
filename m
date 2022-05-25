Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB362566
	for <patches@lists.linux.dev>; Wed, 25 May 2022 21:37:00 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id g7so6544903lja.3
        for <patches@lists.linux.dev>; Wed, 25 May 2022 14:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f/I4M8Sb3pZ5Nw6BzyhaOB507ih22zxAYT/4oQhTECY=;
        b=C6J2Bv4rnpDvfR3Q9wsPFBY17dXDPH4VZquZVqQT9mvDj6LxbHYdPrpepIIZO6B0vc
         uOFmnp//W8Q9oxTTbdO5QsSB68wWY+4qbbExWWLl4NMKwQOUd8CY9sbb4eVDaIMkYlfF
         LCzqhrcqfEBHe1eV4YCsaipKMXGsds9ZCywfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/I4M8Sb3pZ5Nw6BzyhaOB507ih22zxAYT/4oQhTECY=;
        b=wE+JGsrqk9eR7zu1VC+qdmYaM/bKahHTchEYX5M2bzkY/lYt+erLFeuOcu2x8V2AiX
         SJ2RjhkWQQkz2hfyAPy+Q08ZixkH2wXFF3+cjCXgiBpAhuFvCZeFs57bSCTDxE8AP3jT
         WLdXbVk99+vzXpt544pkxYeSFwEfVJ4L6PUkowztLuiEZk3sk0+zqHWtIdjYYib260Q8
         ccjUtWrbR3zmhd7oQR2P8KaYeGknK1JATO+SZYe1sKXgFcrbDQgz1cdHTphOW3y+yo34
         O5SKYhPdLrrlpgOKvY/lPS4mFApKuIsb3npGcMM7Oy3ZJ3CJJJGrWCF0UvWRIP/yyXTz
         /u4w==
X-Gm-Message-State: AOAM531t1JBSfLmBQ6wf6FcxygcQ7DYgUu9SDi40EEfab4m9xTiY8Sza
	org6/j1eRqXeiheK+/Uvw0KZ/+6z1T6DgQwXX30=
X-Google-Smtp-Source: ABdhPJzVRnJAJqBzw1TF7SZDLIYxrT5NnwnhaxGJYk7jZO8iLh/7NRadHdnRQnJoQQiR26Y4L05ouQ==
X-Received: by 2002:a17:906:4fce:b0:6f4:f41c:3233 with SMTP id i14-20020a1709064fce00b006f4f41c3233mr29120401ejw.117.1653514608143;
        Wed, 25 May 2022 14:36:48 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id bf15-20020a0564021a4f00b0042a9fcd7c73sm11285785edb.46.2022.05.25.14.36.47
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 14:36:47 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id v4-20020a1cac04000000b00397001398c0so1845325wme.5
        for <patches@lists.linux.dev>; Wed, 25 May 2022 14:36:47 -0700 (PDT)
X-Received: by 2002:a7b:c4ca:0:b0:397:3bac:9b2a with SMTP id
 g10-20020a7bc4ca000000b003973bac9b2amr9722202wmk.154.1653514606752; Wed, 25
 May 2022 14:36:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz> <CAHk-=wiztQWhEw4tLiH3t5gw=gKB7XtoTXC=S2bhxBxoxOVZLw@mail.gmail.com>
 <6cdbe746-2c6f-f698-11d4-9f86d2c4e5cc@suse.cz>
In-Reply-To: <6cdbe746-2c6f-f698-11d4-9f86d2c4e5cc@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2022 14:36:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjC5nS+fnf6EzRD9yQRJApAhxx7gRB87ZV+pAWo9oVrTg@mail.gmail.com>
Message-ID: <CAHk-=wjC5nS+fnf6EzRD9yQRJApAhxx7gRB87ZV+pAWo9oVrTg@mail.gmail.com>
Subject: Re: [GIT PULL] slab for 5.19
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 25, 2022 at 1:56 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> As I understand it's a tradeoff between memory overhead due to hash
> table size and cpu overhead due to length of collision chains.

... but why is that a build-time kernel config question? And when does
it actually end up triggering?

I didn't much care - and clearly small machines like m68k didn't
either - when the whole stackdepot thing was a "odd configuration
issue".

Because it used to be that stack depot users were fairly easy to
figure out. It was all about pretty special debug options that enable
a lot of very special code (KASAN and PAGE_OWNER - is there anything
else?).

Very clearly just debug builds.

But this slab change means that now it's basically *always* enabled as
an option, and that means that now it had better do sane things
because it's enabled by default and not something that can easily be
ignored any more.

The kernel config phase is something I'm very sensitive to, because
honestly, it's just about the worst part of building a kernel.
Everything else is pretty easy. The kernel config is painful.

That means that we should not ask insane questions - and asking what
static size you want for a data structure that 99% of all people have
absolutely _zero_ idea about or interest in is wrong.

So the problem here is two-fold:

 (a) it introduces a new compile-time question that isn't sane to ask
a regular user, but is now exposed to regular users.

 (b) this by default uses 1MB of memory for a feature that didn't in
the past, so now if you have small machines you need to make sure you
make a special kernel config for them.

And (a) happens unconditionally, while (b) is conditional. And it's
now clear exactly what all triggers the actual allocation in (b).

I _hope_ it's never triggered unless you actively enable slub debug,
but at least from a quick grep it wasn't obvious.

For example, if you happen to have rcutorture enabled, do you get the
allocation then just because rcutorture uses

       kcp = kmem_cache_create("rcuscale", 136, 8, SLAB_STORE_USER, NULL);

even if you have nothing else that would enable slaub debugging? It
*looked* that way to me from a quick grep, but I could easily have
missed something.

             Linus
