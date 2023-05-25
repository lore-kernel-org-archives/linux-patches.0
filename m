Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A715F23D6D
	for <patches@lists.linux.dev>; Thu, 25 May 2023 18:50:42 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-96fd3a658eeso155053066b.1
        for <patches@lists.linux.dev>; Thu, 25 May 2023 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685040640; x=1687632640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aIsIFxmLlj97Nfx6D9vKSgsX1a6jDH3TwyPUkCdOSPQ=;
        b=baNIGmCoH4FutF1V6uTprsJt6A5it1rxKqCQZYOX/MldZ8tPo1WiL+FHKf7x1y6KD5
         Vs1Dfz//YqrNgktlcqNunhd6YiVE8S7JiOIo6o+BMgmkuRpQMVObzRwAluvanaA9uJSX
         XkLdX9dR+WDIJrC5DqQ+t7zhQT7bx9TFjtATA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685040640; x=1687632640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aIsIFxmLlj97Nfx6D9vKSgsX1a6jDH3TwyPUkCdOSPQ=;
        b=cu2O5Cj7AiE7plEtBlpsUjiJS0sv+P6WgxYOzCCdLrMegjH/BfyF712x0h2BLwEHL4
         /8buqdXr3ppMb/+ZmLx04xuR8+IXeMdjOVFR2Mi3Tdyh/f/k6yK+Kc9yZ03S+5Nykq4n
         GwEkyt8o7WbUG/TNNlOwr0uUIAkN0JX1rzD2u0XC+Piw22TzWvXx1fsF+KdzSPatY8gy
         /V5rDWwNWqBfSWSbtsqRLLiJibk/kMnqftTw56kV8jerekcZx9gDVTHhtaIzU24DD+V0
         fmktgfKZf39XE12qq2eYEE100kqWixuFhadkF9elbdAeePtc/5U0QDZFqWJ1IAetcK1k
         tGgg==
X-Gm-Message-State: AC+VfDxR104iEeMdjSw9mdXC6g3sJjQY/O9rMtSWgSvpBrOE280faPhB
	/7DseUqlMYVNxb0PS/xvw9aJ8hdMmyk6NhJgV2txHBY9
X-Google-Smtp-Source: ACHHUZ6dfOA0q3EMapPxt89BIt41WSA7pDee2PUF3pWkNB1wjKWLZY+x7Ah/lZRaU2r4AIBoy3Zzpg==
X-Received: by 2002:a17:906:fe0d:b0:8b8:c06e:52d8 with SMTP id wy13-20020a170906fe0d00b008b8c06e52d8mr2371363ejb.36.1685040640707;
        Thu, 25 May 2023 11:50:40 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090686c900b00965e68b8df5sm1183723ejy.76.2023.05.25.11.50.39
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 11:50:39 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-510dabb39aeso4405710a12.2
        for <patches@lists.linux.dev>; Thu, 25 May 2023 11:50:39 -0700 (PDT)
X-Received: by 2002:a17:907:6d9e:b0:96f:4ee4:10d4 with SMTP id
 sb30-20020a1709076d9e00b0096f4ee410d4mr2465428ejc.43.1685040638863; Thu, 25
 May 2023 11:50:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-2-mcgrof@kernel.org>
 <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
 <CAHk-=wgKu=tJf1bm_dtme4Hde4zTB=_7EdgR8avsDRK4_jD+uA@mail.gmail.com> <ZG+kDevFH6uE1I/j@bombadil.infradead.org>
In-Reply-To: <ZG+kDevFH6uE1I/j@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 May 2023 11:50:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgWCDw58fZDLGYVqVC2ee-Zec25unewdHFp8syCZFumvg@mail.gmail.com>
Message-ID: <CAHk-=wgWCDw58fZDLGYVqVC2ee-Zec25unewdHFp8syCZFumvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/kernel_read_file: add support for duplicate detection
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, hch@lst.de, brauner@kernel.org, 
	david@redhat.com, tglx@linutronix.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com, 
	prarit@redhat.com, lennart@poettering.net, gregkh@linuxfoundation.org, 
	rafael@kernel.org, song@kernel.org, lucas.de.marchi@gmail.com, 
	lucas.demarchi@intel.com, christophe.leroy@csgroup.eu, peterz@infradead.org, 
	rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, 
	mhocko@suse.com, dave.hansen@linux.intel.com, colin.i.king@gmail.com, 
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com, 
	rick.p.edgecombe@intel.com, yujie.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 25, 2023 at 11:08=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.or=
g> wrote:
>
> Certainly on the track where I wish we could go. Now this goes tested.
> On 255 cores:
>
> Before:
>
> vagrant@kmod ~ $ sudo systemd-analyze
> Startup finished in 41.653s (kernel) + 44.305s (userspace) =3D 1min 25.95=
8s
> graphical.target reached after 44.178s in userspace.
>
> root@kmod ~ # grep "Virtual mem wasted bytes" /sys/kernel/debug/modules/s=
tats
>  Virtual mem wasted bytes       1949006968
>
>
> ; 1949006968/1024/1024/1024
>         ~1.81515418738126754761
>
> So ~1.8 GiB... of vmalloc space wasted during boot.
>
> After:
>
> systemd-analyze
> Startup finished in 24.438s (kernel) + 41.278s (userspace) =3D 1min 5.717=
s
> graphical.target reached after 41.154s in userspace.
>
> root@kmod ~ # grep "Virtual mem wasted bytes" /sys/kernel/debug/modules/s=
tats
>  Virtual mem wasted bytes       354413398
>
> So still 337.99 MiB of vmalloc space wasted during boot due to
> duplicates.

Ok. I think this will count as 'good enough for mitigation purposes'

> The reason is the exclusive_deny_write_access() must be
> kept during the life of the module otherwise as soon as it is done
> others can still race to load

Yes. The exclusion only applies while the file is actively being read.

> So with two other hunks added (2nd and 4th), this now matches parity with
> my patch, not suggesting this is right,

Yeah, we can't do that, because user space may quite validly want to
write the file afterwards.

Or, in fact, unload the module and re-load it.

So the "exclusion" really needs to be purely temporary.

That said, I considered moving the exclusion to module/main.c itself,
rather than the reading part. That wouild get rid of the hacky "id =3D=3D
READING_MODULE", and put the exclusion in the place that actually
wants it.

And that would allow us to at least extend that temporary exlusion a
bit - we could keep it until the module has actually been loaded and
inited.

So it would probably improve on those numbers a bit more, but you'd
still have the fundamental race where *serial* duplicates end up
always wasting CPU effort and temporary vmalloc space.

                   Linus
