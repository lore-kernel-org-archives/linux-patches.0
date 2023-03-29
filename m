Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767CE7E5
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 16:51:00 +0000 (UTC)
Received: by mail-ed1-f41.google.com with SMTP id t10so65791385edd.12
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680108658; x=1682700658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuabhBI/cJhvDusEUPo+YOaR3W7tGSIZ44NN+9mu0w0=;
        b=WPU7CQZXsHT2W6o+O27Wpj5VLxahEGVYuFGJ09lWVVUb6Uog7j2W3oCfdskI6i1Ubk
         gOKt3sOlvhKigmmF1pAoCh6e/zApTuFMSDe/1Ogb06wgZ5eTbVWDjmqb/YOcqB8hVtud
         n9GOwJeinQ3x7aNVLHZ7ZSgZ/qGs4xL/xImVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680108658; x=1682700658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fuabhBI/cJhvDusEUPo+YOaR3W7tGSIZ44NN+9mu0w0=;
        b=LxduCGOa4aMXulzJP61hFpqjmEYPmJVwu1u3htl9/ilPyh1eBudOlfU932p6leoMoJ
         d07PbCSkJeoSKb9DbbZJw/fteIhhcUXYorpKlT/qrybvn70ttB3vcrowd1pMSImBIQYb
         jEJ5ynpliIQRaUzDbemiZlNJsOnesakagVBe5t6XoeHTyXcR86WCzpgAK1KZkcjvsbgN
         PESXzkzbKR4fd6c/7zJHaijvaGjvr40nWdbaTPlhBZ71mpuhOPQ/Lbfm4RbZQpJMOHeB
         IdottQ6IzqqKlEM2xqzBG/59+vJSOTegMmi/CXe3D6WyBWhFMjSEjOuArnrGy9HP7Zej
         XC1g==
X-Gm-Message-State: AAQBX9f3NdtKRfSY+wFCpCXF+cr1TTh/+ciyqrdx+dimnaO597EbURpr
	vQF6scd0IqgWzdrfhyE8UL3Nu0Y5keESpUpM6B/AAA==
X-Google-Smtp-Source: AKy350bidbYJ4w7Db0HBn0FzrUvPdt1uzKfpicugFpewBCla4qqkReMpEykMHrcInJb3fB5z7UBFag==
X-Received: by 2002:aa7:c248:0:b0:4fb:5fe1:bc3b with SMTP id y8-20020aa7c248000000b004fb5fe1bc3bmr3041190edo.0.1680108658363;
        Wed, 29 Mar 2023 09:50:58 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id b44-20020a509f2f000000b004c09527d62dsm17233041edf.30.2023.03.29.09.50.56
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 09:50:56 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id i5so66153937eda.0
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 09:50:56 -0700 (PDT)
X-Received: by 2002:a17:906:eec7:b0:93e:186f:ea0d with SMTP id
 wu7-20020a170906eec700b0093e186fea0dmr9808123ejb.15.1680108655974; Wed, 29
 Mar 2023 09:50:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230329053149.3976378-1-mcgrof@kernel.org> <20230329053149.3976378-5-mcgrof@kernel.org>
 <20230329072112.GG4253@hirez.programming.kicks-ass.net> <ZCPuFLDgU5fBFtug@bombadil.infradead.org>
 <20230329091935.GP4253@hirez.programming.kicks-ass.net>
In-Reply-To: <20230329091935.GP4253@hirez.programming.kicks-ass.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Mar 2023 09:50:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=whF6Ta_KcJP2eC78+Mstv+vAku8ATRMbv98sf9VhdvySQ@mail.gmail.com>
Message-ID: <CAHk-=whF6Ta_KcJP2eC78+Mstv+vAku8ATRMbv98sf9VhdvySQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
To: Peter Zijlstra <peterz@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, david@redhat.com, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com, 
	prarit@redhat.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	christophe.leroy@csgroup.eu, tglx@linutronix.de, song@kernel.org, 
	rppt@kernel.org, willy@infradead.org, vbabka@suse.cz, mhocko@suse.com, 
	dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 29, 2023 at 2:19=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> Arguably DEFINE_SEMAPHORE() should have the argument, as binary
> semaphores are a special case, but then we gotta go and fix up all
> users.

Using semaphores for just pure mutual exclusion used to be *the* most
common use of it, which is why we didn't have an argument.

Then we got the mutexes, and now semaphores are almost entirely a legacy th=
ing.

I think we should just make DEFINE_SEMAPHORE() take the number, and
people who want a mutex should either put in the "1", or they should
just use a mutex.

> /me git-greps a little.. Hmm, not too bad.
>
> How's this?

I'd actually prefer to not have that DEFINE_BINARY_SEMAPHORE() at all.
It really shouldn't exist in this day and age.

It's not even less typing, ie

    static DEFINE_SEMAPHORE(efivars_lock, 1);

is actually shorter than

    static DEFINE_BINARY_SEMAPHORE(efivars_lock);

And what you actually *want* is

    static DEFINE_MUTEX(efivars_lock);

and converting the up/down to mutex_unlock/mutex_lock.

So let's just make it clear that the only reason to use semaphores
these days is for counting semaphores, and just make
DEFINE_SEMAPHORE() take the number.

Strangely, sema_init() already does that, but I guess that's because
some people really *do* use semaphores for concurrency control (ie I
see things like

        sema_init(&dc->in_flight, 64);

which is clearly using a semaphore in that very traditional way).

So ack on your patch, but don't bother with DEFINE_BINARY_SEMAPHORE().

               Linus
