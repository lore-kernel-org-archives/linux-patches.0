Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB65E1B909
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 16:07:34 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-974638ed5c5so138271066b.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 09:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685722053; x=1688314053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSyIWuON41xIpPsAfkdJjA0fkmYqrGMTTzJNJtvl1ho=;
        b=Qk6Af5M/Ix1Djmb9bsxoubYWHC56SDC3mceceR/Tw5PiwA+6ylk2eStsl90WVE9GQv
         RDI7tOjEGSDOwESa6kCZ9hosIrC2uoX2OebapmaFhC2ueMspULXUAZBsqeWRRRNceJBU
         0WTbLXpymiW74OVhfJTfxwtkVW/o8xBRoZf3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722053; x=1688314053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSyIWuON41xIpPsAfkdJjA0fkmYqrGMTTzJNJtvl1ho=;
        b=X2/Rq08O2ZTdtT53h3TppcekRq7MFnepoXRVjADR1+Xx6aU2T3iS9m6BW4WWTpWwi8
         tFGJb3RYdG6cEs8I7i7o27sQFCU8qOzRyT1aIpNCcROzeGFfE6biFEpJnUq2h1tI4MT/
         en3HwmK1k7wU/RU+Mc90tSLthaZbYFkXkteoa0xXdqMHzUySU1uCddPM0bk64NB2fl9G
         dM4vwVaPC4C6cV1oaI5PeHeoUSGHzdY+KsdhOtGL6IaYXVmqart/BJajQzEGVgBsc1NR
         WQqfNaHOmWHNob4sl6baIbHyjnU14IMyTa/yWoP0vEjrmqPs1DneC3oTEeZ1Va4U/uFt
         liNA==
X-Gm-Message-State: AC+VfDwH8LU6kLoPy8C3DqcNMVXu5vlTxtF4xlAxIzOgwtZZKnRy1TlL
	Vqmhj8TelawWED3TVzcfs+MN/z96FjWBDBayuAqmADsd
X-Google-Smtp-Source: ACHHUZ4riMid2IjyhpLd9YMyka4snPz1iPA83rv29fBQGPIEqTxUIQ6uDwnkq5QhiAUaoYUqK5XSFA==
X-Received: by 2002:a17:907:c12:b0:974:6314:105c with SMTP id ga18-20020a1709070c1200b009746314105cmr2103452ejc.16.1685722052756;
        Fri, 02 Jun 2023 09:07:32 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id n12-20020a170906118c00b0096fbc516a93sm889735eja.211.2023.06.02.09.07.32
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 09:07:32 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-96fab30d1e1so482564666b.0
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 09:07:32 -0700 (PDT)
X-Received: by 2002:aa7:c0ce:0:b0:516:2dcf:d027 with SMTP id
 j14-20020aa7c0ce000000b005162dcfd027mr2836164edp.10.1685722030936; Fri, 02
 Jun 2023 09:07:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org> <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com> <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com> <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
 <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
 <ZHYitt7P7W+8ZlSB@bombadil.infradead.org> <499e30cc-d015-8353-1364-50d17da58f47@redhat.com>
 <ZHd8bLPY4OQCb/Z5@bombadil.infradead.org> <ba60bca6-b682-4c27-3c54-2512b6f16151@redhat.com>
In-Reply-To: <ba60bca6-b682-4c27-3c54-2512b6f16151@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Jun 2023 12:06:54 -0400
X-Gmail-Original-Message-ID: <CAHk-=whwFoC30zoTfsQAvkDRvgMCovwKGW_R1PPnqiF+YemcOA@mail.gmail.com>
Message-ID: <CAHk-=whwFoC30zoTfsQAvkDRvgMCovwKGW_R1PPnqiF+YemcOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: David Hildenbrand <david@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Johan Hovold <johan@kernel.org>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, Petr Pavlu <petr.pavlu@suse.com>, 
	gregkh@linuxfoundation.org, rafael@kernel.org, song@kernel.org, 
	lucas.de.marchi@gmail.com, christophe.leroy@csgroup.eu, peterz@infradead.org, 
	rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, 
	mhocko@suse.com, dave.hansen@linux.intel.com, colin.i.king@gmail.com, 
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com, 
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, tglx@linutronix.de, 
	hch@lst.de, patches@lists.linux.dev, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com, 
	prarit@redhat.com, lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 2, 2023 at 11:20=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> What concerns me a bit, is that on the patched kernel we seem to hit more=
 cases where
> boot takes much longer (in both kernel configs).

So it potentially serializes the loads to the same file more, but in
the process uses much less memory (since the ones waiting will not
have done any of the "load file contents and uncompress them"). So
it's a bit of a trade-off.

We could complicate things a bit, and let other callers return -EEXIST
a bit earlier, but I'm not convinced it really matters.

Honestly, taking too long because user space does something stupid and
wrong is not a kernel bug. Not booting because we use too much memory
- that's problematic. But booting slowly because udev does several
thousand unnecessary module loads is entirely on udev.

                 Linus
