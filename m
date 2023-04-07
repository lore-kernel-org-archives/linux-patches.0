Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D92582
	for <patches@lists.linux.dev>; Fri,  7 Apr 2023 20:53:00 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id 18so10812990ejo.13
        for <patches@lists.linux.dev>; Fri, 07 Apr 2023 13:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680900778; x=1683492778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8xM6r6/rOzbRR11rE4PPyc0SA/I8K68bLshe2lzvT4=;
        b=AYFrTpg1m87JjskjlUbD3Y540rAQROTwgYO8jaDYgMlWEXVBLkfRSn/upu13hQpwOs
         0L9q74bZd4i3Si7TeWIMNU+0St5PYlcxrnH7KFZsrsGgGaLe3++g6B8rSj1j5f1LlhPn
         NOjnmhfCdyA6EY1gRVqkmJjPxqYHrJP1A6T9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680900778; x=1683492778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g8xM6r6/rOzbRR11rE4PPyc0SA/I8K68bLshe2lzvT4=;
        b=TzO3f2eIi9sQrv87qLk0Ih+idqTW3ccRh06DDpQ6EWY3Z+Fn8bIlpjCwQiTS2Zw29L
         8Dq+hni2qIjxuiKnU2UbW4+Peyzlr5rMxyse1pYRZ88pgbDpGkP05BWTLmQfOcTywiix
         BYc2NIt9agN5ghJP1IIPa3PTFmsnvxfiwNauRQcWNaEaDxSD338gM0PYhTPnWib2TbB6
         UoLyblJRzTdYHt1QLIs/4y0wdhrdGgAdneSxf79bGzBQ90m//fttQJfHWNKJtbvT6CU2
         GOUCdPF1Sdza+CwxNoh/mMAXhEcFZFqAejJiBM73iuNu2miqdc6Mj70pdEedRjAmWe6n
         tZOg==
X-Gm-Message-State: AAQBX9flgXW0FjTUj72uEu4LSSa1wleUlePady9HN02itHSt7/o4bYpy
	YJ2WpODNYwhI814/n4ygCdfi0qUtoIv37obF9XDOZw==
X-Google-Smtp-Source: AKy350Z7GmYyGMAxsRCrQ9QtSdau1Xfyo6EDRsGpz53wHPAKTL2UC9u0Xomc3st8+Fnh9KQr5DABIQ==
X-Received: by 2002:a17:906:f6ce:b0:92b:eca6:43fc with SMTP id jo14-20020a170906f6ce00b0092beca643fcmr567199ejb.64.1680900778102;
        Fri, 07 Apr 2023 13:52:58 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id x5-20020a170906804500b008def483cf79sm2367946ejw.168.2023.04.07.13.52.56
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 13:52:57 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id n21so10816917ejz.4
        for <patches@lists.linux.dev>; Fri, 07 Apr 2023 13:52:56 -0700 (PDT)
X-Received: by 2002:a17:907:b687:b0:947:72cd:9325 with SMTP id
 vm7-20020a170907b68700b0094772cd9325mr310007ejc.15.1680900776633; Fri, 07 Apr
 2023 13:52:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405203505.1343562-1-mcgrof@kernel.org> <20230405203505.1343562-2-mcgrof@kernel.org>
 <ZDB+zn3X4sac9DFU@casper.infradead.org>
In-Reply-To: <ZDB+zn3X4sac9DFU@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Apr 2023 13:52:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgYFGyy9jBmwEJHtdtdaEbqiyFn7GtMN6jP2ZFw92zYDA@mail.gmail.com>
Message-ID: <CAHk-=wgYFGyy9jBmwEJHtdtdaEbqiyFn7GtMN6jP2ZFw92zYDA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Change DEFINE_SEMAPHORE() to take a number argument
To: Matthew Wilcox <willy@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, david@redhat.com, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com, 
	prarit@redhat.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	christophe.leroy@csgroup.eu, tglx@linutronix.de, peterz@infradead.org, 
	song@kernel.org, rppt@kernel.org, dave@stgolabs.net, vbabka@suse.cz, 
	mhocko@suse.com, dave.hansen@linux.intel.com, colin.i.king@gmail.com, 
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 7, 2023 at 1:37=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> I'd like to mention completions as an alternative to semaphores, but
> can't figure out a nice way to fit that in.

I'm personally a bit sorry completions ever became a thing.

There's a real reason for having them, but they have been used and
mis-used in so many confusing ways that I am worried every time I see
a completion. We've had some nasty use of 'init_completion()' in
particular.

There are many obvious uses of completions, and they have nice strict
semantics wrt last-use etc (so that you can put them on the stack and
know that you're the last user when you return, which is not
necessarily true of locking in general).

But there are several less-than-obvious uses too, and any use of
reinit_completion() ends up just making me go "Uhh".  The
serialization needed for that to actually work right often means that
you might as well have used a "wait_event()" with a
"smp_store_release()" variable instead and made the code more obvious.

I dunno. I might have had a few bad experiences and it's just rare
enough to be one of those things that I feel wasn't worth the
abstraction cost.

And I can't even blame anybody else. I think I'm to blame for that horror.

              Linus
