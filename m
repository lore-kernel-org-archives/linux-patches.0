Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9299E20E8
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 02:03:12 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id f10so19768943lfu.8
        for <patches@lists.linux.dev>; Fri, 11 Feb 2022 18:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VULwDL2bGuoLKw9ZH+vGy6WYNy7nasfTpVY6FmzciTc=;
        b=cvp4WIQfxJbqUzpc4x1MctGtDJsnAQI+zFPY+euY/iWSFPyPWCH5FYR3rldvhD/Yqw
         nE4Ci5yYJ0H6BlHVOPkE7nh5oKifeg4kPSTvsLIWowBUQtl0HRsrEqHhWLa9WkrMyHm3
         93gzHoiSVComNXupDSDiOrcTX/zXxfZPdUaGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VULwDL2bGuoLKw9ZH+vGy6WYNy7nasfTpVY6FmzciTc=;
        b=rZRmFk67/s215gTXGUMY5SohKjwGwJZUMayYzyxNVspgA9Ec/0zXlfM7CEkUso86NM
         c920hX2dROfvG9f1WziGgyQxy4bit+Jdn1CeeDLcP8PXoG5ogQKK26H+fFJwpwee+WLr
         5RL6oucRzBBIMCFUADEdELgHWYQffrmZatqCnvjw5YEvKarTuPf+9u3O7NKX14jonJMQ
         zfq5TyG/EtiKxXUMjin1ipuqr8SbyPT6MrqzIXMXYm2WVbn8+EnnxPy9cTqpIh57k7yE
         il+OItdGam+2Sr80kM36I5VOm7PaiaEo/rD3MuKXWewe7pte76GAkrFwO2DWDgnvD4Fr
         szEw==
X-Gm-Message-State: AOAM530lIAq+LCRoG4kzdpfvGUJNS3iunBvtpmX7lJP7FqWlbnzc1fUb
	htgWRgQqYy7+7r/Nw1NAPR4W+cCGrlj2rtCX2lk=
X-Google-Smtp-Source: ABdhPJzwdXGSriiCEiT74aLHk8RFIIHZF0jwVe3t7dH3IvwaZuXZj1u9YuNbQLhEBjVtxwvvRei6nQ==
X-Received: by 2002:a05:6512:239d:: with SMTP id c29mr3069691lfv.279.1644631390254;
        Fri, 11 Feb 2022 18:03:10 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id t13sm1599990lfe.237.2022.02.11.18.03.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 18:03:09 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id e17so14761881ljk.5
        for <patches@lists.linux.dev>; Fri, 11 Feb 2022 18:03:09 -0800 (PST)
X-Received: by 2002:a2e:a231:: with SMTP id i17mr2605893ljm.443.1644631389126;
 Fri, 11 Feb 2022 18:03:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 Feb 2022 18:02:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
Message-ID: <CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
Subject: Re: incoming
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 11, 2022 at 4:27 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 5 patches, based on f1baf68e1383f6ed93eb9cff2866d46562607a43.

So this *completely* flummoxed 'b4', because you first sent the wrong
series, and then sent the right one in the same thread.

I fetched the emails  manually, but honestly, this was confusing even
then, with two "[PATCH x/5]" series where the only way to tell the
right one was basically by date of email. They did arrive in the same
order in my mailbox, but even that wouldn't have been guaranteed if
there had been some mailer delays somewhere..

So next time when you mess up, resend it all as a completely new
series and completely new threading - so with a new header email too.
Please?

And since I'm here, let me just verify that yes, the series you
actually want me to apply is this one (as described by the head
email):

  Subject: [patch 1/5] fs/binfmt_elf: fix PT_LOAD p_align values ..
  Subject: [patch 2/5] fs/proc: task_mmu.c: don't read mapcount f..
  Subject: [patch 3/5] mm: vmscan: remove deadlock due to throttl..
  Subject: [patch 4/5] mm: memcg: synchronize objcg lists with a ..
  Subject: [patch 5/5] kfence: make test case compatible with run..

and not the other one with GUP patches?

             Linus
