Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB10C320A
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 14:29:17 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id z128so1890620vsb.3
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 06:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+Yy00juT6YLJ5oWGMT9Wza1I0KabYl3KuXLE2Ym30r8=;
        b=hqu1WUIKQ7nelxjitmtslt7P2HWICJ6UQhItkE1DxGc9pYkqGv2Z3jzXfiUQ7oN+jD
         woMH988I6TyAfP/DcKz8zY/EqQvJsbpUwPmosnHsPhhtYjp/+7T4/iB5/v0fZx5jhews
         EgJ65v8od4MS0eHGmvOkk88QhVj1ogj0TwlYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Yy00juT6YLJ5oWGMT9Wza1I0KabYl3KuXLE2Ym30r8=;
        b=zvpdY649wH1lbaVFSQzq+0RxkYmsmWmF4n61XCzYZP8gjXzx+C6kEdYS6bFXzv/ay2
         j67acuyrmmxz0h6y4dHYCOY/NSBpvucWlckoATxbICinyHgaE1rbmVOD7jqC3hCUiqjd
         PZmOMyjvuuvf1fMRYVFnhtWbNacU8u9WnH1A+vBwvErvHrq/t3ynCHCfh2o7CoLYs1o0
         F3Gv3DAXgJjSYplBfP5Kqjl+PlVZNy4NZu4uzAD8N53guVPJ9eXdaYFfoiBWVkFNgyJn
         b6VGe3gEv/vrt1E37jcAfpOYw2Bl4HGOyPMicOiUkzc9JJLCh93cLv4dt/d5fGpXCKSN
         44cw==
X-Gm-Message-State: AFqh2kqmtZgOTRVcfnK9r0DmQrOmdv178YCntT25/qqN3c7H3DGBzBwd
	+1yWkVjRnX5JpQ0B7QIGs0ZDupzNsRafZV6lvuU=
X-Google-Smtp-Source: AMrXdXt1yea4Anv4oYkvFbt4D7nN0mp2LVJ/4dklNps5me+fKatiPGtiEOPsY6qeT3741fIl7uwiAw==
X-Received: by 2002:a05:6102:3d0c:b0:3c9:77f:3e27 with SMTP id i12-20020a0561023d0c00b003c9077f3e27mr31126701vsv.31.1673274556478;
        Mon, 09 Jan 2023 06:29:16 -0800 (PST)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com. [209.85.222.169])
        by smtp.gmail.com with ESMTPSA id y2-20020a05620a44c200b006f87d28ea3asm5396843qkp.54.2023.01.09.06.29.14
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 06:29:14 -0800 (PST)
Received: by mail-qk1-f169.google.com with SMTP id e6so4224457qkl.4
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 06:29:14 -0800 (PST)
X-Received: by 2002:ae9:ef49:0:b0:6fe:d4a6:dcef with SMTP id
 d70-20020ae9ef49000000b006fed4a6dcefmr3220519qkg.594.1673274554214; Mon, 09
 Jan 2023 06:29:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <874jt0kndq.fsf@oldenburg.str.redhat.com>
In-Reply-To: <874jt0kndq.fsf@oldenburg.str.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2023 08:28:58 -0600
X-Gmail-Original-Message-ID: <CAHk-=wg7vMC2VmSBdVw7EKV+7UDiftQEg3L+3Rc0rcjjfsvs5A@mail.gmail.com>
Message-ID: <CAHk-=wg7vMC2VmSBdVw7EKV+7UDiftQEg3L+3Rc0rcjjfsvs5A@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: Florian Weimer <fweimer@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, Christian Brauner <brauner@kernel.org>, 
	linux-mm@kvack.org, mlichvar@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 4:34 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> We did these changes on the glibc side because Jason sounded very
> confident that he's able to deliver vDSO acceleration for getrandom.  If
> that fails to materialize, we'll just have to add back userspace
> buffering in glibc.

My whole argument has been that user-space buffering is the sane thing
to do. Most definitely for something like glibc.

The number of people who go "oh, no, my buffer or randomness could be
exposed by insert-odd-situation-here" is approximately zero, and then
the onus should be on *them* to do something special.

Because *they* are special. Precious little snowflake special.

             Linus
