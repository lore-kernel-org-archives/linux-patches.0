Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44491EA6
	for <patches@lists.linux.dev>; Wed, 25 May 2022 18:30:05 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id f21so29670150ejh.11
        for <patches@lists.linux.dev>; Wed, 25 May 2022 11:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DUPOWrnWYG2slQmT/3VeC1AcGFORkCFgaKQE4X/RHDA=;
        b=R6aB8fP9pXh4hwqOoBWTR2Xa0tql8u9D5G1OIwlU3BtL9xkcnR8mFdbDe1RUN8UGDB
         M8UZIi8F34PJnXVcdavCnLyCXg/7VaJk9hcDFEZi5+scJUn/33F/UiOadDpaBFNwoesD
         SjxHJejls7YoLiENznvp/43y/U1FCYBx+Ik/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DUPOWrnWYG2slQmT/3VeC1AcGFORkCFgaKQE4X/RHDA=;
        b=ZC6b25+cocGXBGpdJ4s5CEhUawTgWU8wfESQgMNtyPX+njIGyspjgTZSjjHxAJ8iSi
         zJKTHW4AUzsJWB6l0LWVCUW92RYawscmVYY2tPpogEkU1ue2kxzyidebab660YuetlAu
         y4vV6hH5NARli+8I8ZQtVrCm+YiQyesTQamLgYVtvCbLcqJsSlGSaUiYsq03qpxLyGiE
         P2yXPUn3H6mm1SgSg1+Vc1WSJ6Y5bF3jiM6lNT/N941YyCaGF0e/Rc0IuFcL3TXQ3dyt
         C1k7nG1yMgmQgCGmiedlH6DukIkq2FJt9fGaxoiK21U07poc+GI56jk8x/vMrahGuTlw
         m0cw==
X-Gm-Message-State: AOAM533vo+Z5uYcNsIA9neg3lZ178Lm8vFWcTQ1AZVBt7UfizqZrScNL
	6VK/iVZ1zFUdPJZ78s76fJins23x/GNgK+piU1A=
X-Google-Smtp-Source: ABdhPJxe4o/wPMV//d5uwYIZqHo3aeNotHi6qURVOkchom+KTpwnJDukdqCeO75hjY1DPgY+UGEgPw==
X-Received: by 2002:a17:907:9496:b0:6ff:1012:1b9c with SMTP id dm22-20020a170907949600b006ff10121b9cmr4556000ejc.457.1653503402897;
        Wed, 25 May 2022 11:30:02 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709064a0900b006fed85c1a8fsm3695952eju.202.2022.05.25.11.30.01
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 11:30:01 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id e28so30644869wra.10
        for <patches@lists.linux.dev>; Wed, 25 May 2022 11:30:01 -0700 (PDT)
X-Received: by 2002:a5d:59ac:0:b0:20e:6fd6:88c1 with SMTP id
 p12-20020a5d59ac000000b0020e6fd688c1mr25884560wrr.442.1653503401048; Wed, 25
 May 2022 11:30:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz>
In-Reply-To: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2022 11:29:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiztQWhEw4tLiH3t5gw=gKB7XtoTXC=S2bhxBxoxOVZLw@mail.gmail.com>
Message-ID: <CAHk-=wiztQWhEw4tLiH3t5gw=gKB7XtoTXC=S2bhxBxoxOVZLw@mail.gmail.com>
Subject: Re: [GIT PULL] slab for 5.19
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, May 23, 2022 at 2:54 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
>   The stackdepot conversion was already attempted last year but
>   reverted by ae14c63a9f20. The memory overhead (while not actually
>   enabled on boot) has been meanwhile solved by making the large
>   stackdepot allocation dynamic.

Why do I still see

  +config STACK_HASH_ORDER
  +       int "stack depot hash size (12 => 4KB, 20 => 1024KB)"
  +       range 12 20
  +       default 20

there then?

All that seems to have happened is that it's not a static allocation
any more, but it's still a big allocation very early at boot by
default.

The people who complained about this last time were on m68k machines
iirc, and 1MB there is not insignificant.

It's not at all clear to me why that allocation should be that kind of
fixed number, and if it's a fixed number, why it should be the maximum
one by default. That seems entirely broken.

I've pulled this, but considering that it got reverted once, I'm
really fed up with this kind of thing.  This needs to be fixed.

Because I'm _this_ close to just reverting it again, and saying "No,
you tried this crap already, didn't learn from the last time, and then
did the same thing all over again just in a different guise".

                    Linus
