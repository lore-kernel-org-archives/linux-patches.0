Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0268835
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 16:24:14 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id er13so37691533edb.9
        for <patches@lists.linux.dev>; Thu, 30 Mar 2023 09:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680193452; x=1682785452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGpUIuNkSWwlblo4NAnZsLgXHjXX1OX/SqTfrwIswRg=;
        b=Vt1jJXWHVCXspZt4UBd0at0O6A0NFdKZNHpURG50seAAUVmBpgqXWJ56Y5P1PT3pWY
         Or+YQK6FskI7TrePqBwBz9kXW/lEpy51ig3chB/4dsgT9vzyOJe4Y4SQJcb69BsWIlef
         AYKfFVfzRKE1zkJvLVb7b+MJaz/HE9E2XXxyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680193452; x=1682785452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGpUIuNkSWwlblo4NAnZsLgXHjXX1OX/SqTfrwIswRg=;
        b=Sps4rOSf4G31O8TkGvCnijh/9Uw9s4NiGnwYwcFT5Bv431C8sdA46bBSONmqyp3I4H
         4ODYUzT0J0/A2x7kp3cV1ik2sV66Oa2IyYu1hwGPpWphY71MYXTl5nQb0YdrhtCYLm/r
         vIkd38jfuMm/mG+LSJeOL/eL8+rmc2JSlXGzAjvqB1obfeMn+ZdAoYNWA8T9tf9JXZHV
         j73CWFkSRFd195d1Lak9Ec6mc1T0+gAdipPoZDCk6o1Kfi8YbG5bCthLt5SD+vm0vDGc
         bfNeP+zBbHyvyY5TTd8S7MOCzgndLJKtFKl/xnieXsVbOrK3veRdS77c8PoI2x3KGM8P
         uOIA==
X-Gm-Message-State: AAQBX9cFdXM8CcrfBZaPxhAr8hw3C2YIbukg2r69H9dyfJrgQ8jq1iV6
	ggGtaU57mOGaFCPN49UhmMiApmZ0vAXS5XLTx/HSklua
X-Google-Smtp-Source: AKy350YkfW6QVKpnBgrfYLPQcTOZlU8Q7ypj+mR/LV30E87EGlq/8hO5g0liPESFHWQtU0uDSw1Exg==
X-Received: by 2002:a17:907:72c8:b0:946:fa69:cb0 with SMTP id du8-20020a17090772c800b00946fa690cb0mr8521085ejc.29.1680193452347;
        Thu, 30 Mar 2023 09:24:12 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id l20-20020a17090612d400b00947740a4373sm9669ejb.81.2023.03.30.09.24.11
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 09:24:11 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id r11so78710491edd.5
        for <patches@lists.linux.dev>; Thu, 30 Mar 2023 09:24:11 -0700 (PDT)
X-Received: by 2002:a05:6402:4306:b0:4af:6e95:85e9 with SMTP id
 m6-20020a056402430600b004af6e9585e9mr4039473edc.4.1680193450898; Thu, 30 Mar
 2023 09:24:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230329053149.3976378-1-mcgrof@kernel.org> <20230329053149.3976378-5-mcgrof@kernel.org>
 <20230329072112.GG4253@hirez.programming.kicks-ass.net> <ZCPuFLDgU5fBFtug@bombadil.infradead.org>
 <20230329091935.GP4253@hirez.programming.kicks-ass.net> <CAHk-=whF6Ta_KcJP2eC78+Mstv+vAku8ATRMbv98sf9VhdvySQ@mail.gmail.com>
 <20230330115626.GA124812@hirez.programming.kicks-ass.net>
In-Reply-To: <20230330115626.GA124812@hirez.programming.kicks-ass.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Mar 2023 09:23:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgF34MkhZnM_Kc1zggTWCAQ=BzEgAaAbE5wDM07bWiYeg@mail.gmail.com>
Message-ID: <CAHk-=wgF34MkhZnM_Kc1zggTWCAQ=BzEgAaAbE5wDM07bWiYeg@mail.gmail.com>
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
To: Peter Zijlstra <peterz@infradead.org>, Petr Mladek <pmladek@suse.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, david@redhat.com, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, petr.pavlu@suse.com, prarit@redhat.com, 
	gregkh@linuxfoundation.org, rafael@kernel.org, christophe.leroy@csgroup.eu, 
	tglx@linutronix.de, song@kernel.org, rppt@kernel.org, willy@infradead.org, 
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30, 2023 at 4:56=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> Sure thing; still completely untested...

Seems obvious enough.

Looking at the people who use a semaphore as a mutex, one core user stands =
out:

>  kernel/printk/printk.c                                        |    2 +-

.. and I'm not entirely sure why that uses a semaphore. It may be
*entirely* legacy, and should just be changed to be a mutex.

But it may also be that the 'console_sem' has some subtle reason why
it wants to be a semaphore, and why it then plays games with lockdep
(which doesn't support counting semaphores) and does things like

  #define down_console_sem() do { \
        down(&console_sem);\
        mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);\
  } while (0)

Anyway, I think your patch is obviously safe as-is, and I think it's
long overdue to make it clear that the only real reason to use
semaphores rather than mutexes is if you do need the counting thing.

Of course, there is the thing about lockdep, and also about how
semaphores these days have no architecture-specific parts, so if
anybody wants to play deep games with their locking, that may be a
reason for using them.

Although we also do have some other issues - I think down_trylock() is
ok in irq contexts, but mutex_trylock() is not. Maybe that's why
printk uses semaphores? I forget.

                Linus
