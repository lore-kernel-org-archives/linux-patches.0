Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED613200BC
	for <patches@lists.linux.dev>; Tue, 30 May 2023 22:17:51 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-970056276acso781054766b.2
        for <patches@lists.linux.dev>; Tue, 30 May 2023 15:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685485070; x=1688077070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5DUvOnBbNjICLS8rqmJBzZV+nxJEkq4dfwQCNKJREU=;
        b=UfeedNdeoLrVx4A/HM6fQhmzFaQnWlmLcx/7ycZv+F9FLOUPPvvWAyy+mvDqCyIbjW
         1V6GG20aa8VsCIlIyny1+5Cxnk2S+E34VwhES2uMpNt9uBP2s3uUyQVLwZ9nuz3B1PYQ
         NuMigSOVoEz9S3s7MLyMFb0Sce2wPUmkaBLuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685485070; x=1688077070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5DUvOnBbNjICLS8rqmJBzZV+nxJEkq4dfwQCNKJREU=;
        b=WZlPKrWbwLggPT+gNwyZkiSoWkdqL0Eqwg6xg0t+pa9FNqLna9XpuSSr4dMlfrWvCc
         xoLS3FG0DsLFJdb2rOQ9L8qf00ZjayKQVH+jlc5VwDQQkryNSg1t0/YSBIq8sfP+8CA8
         fM4r8DL3hOq1WNdDUTGZYZbZ89jjMDUQ1PuG7f8oFCFR3W+78MjUN6cMITti4CP5L8CN
         gNfFcqPSHb2ymlAvuvJ2LoWYpq4sBVKhE+uCtnbLg9N4B+UjPZ9xk1JQym1m/PMLAqDG
         nBmDBCLYyN8zJZpN/Q4zJqwecqQrQJR2mz+vC5FT1pbZ/qZZcaXIXcN+CE4BltRc3ffg
         0ONw==
X-Gm-Message-State: AC+VfDxIWfCYO50c1XKAPUuPmKeuHJUcF5UIaOGZd6sSHtMszOWWeBdq
	R9NseP/FtB+d2R/DZws+3dvrovCwd66aT7DvYzFCiYXh
X-Google-Smtp-Source: ACHHUZ6ossZz3OntCDpSKiK2NUvbblYizWjYHJUAjjvgLy7+K5epF10IMUHI5y0IfiHLhaZlRXvLKg==
X-Received: by 2002:a17:907:3d94:b0:96f:71bc:9d9e with SMTP id he20-20020a1709073d9400b0096f71bc9d9emr3618109ejc.28.1685485069996;
        Tue, 30 May 2023 15:17:49 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id j11-20020a170906410b00b0096f689848desm7868553ejk.195.2023.05.30.15.17.49
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 15:17:49 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-30959c0dfd6so5205528f8f.3
        for <patches@lists.linux.dev>; Tue, 30 May 2023 15:17:49 -0700 (PDT)
X-Received: by 2002:a17:906:7945:b0:965:6d21:48bc with SMTP id
 l5-20020a170906794500b009656d2148bcmr3770717ejo.75.1685485048586; Tue, 30 May
 2023 15:17:28 -0700 (PDT)
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
 <ZHYitt7P7W+8ZlSB@bombadil.infradead.org> <bav73qu5khl2dxkwpvy2hq34lyi56jn6yp7h5qlennka65kre3@zwwmrr55d2by>
 <ZHZRaFWvLEvkoCMA@bombadil.infradead.org>
In-Reply-To: <ZHZRaFWvLEvkoCMA@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 30 May 2023 18:17:11 -0400
X-Gmail-Original-Message-ID: <CAHk-=wicgDftP9ogSagxiRNvVTm7+YfQpEBuEsoRbkWzsw=EZw@mail.gmail.com>
Message-ID: <CAHk-=wicgDftP9ogSagxiRNvVTm7+YfQpEBuEsoRbkWzsw=EZw@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>, Johan Hovold <johan@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org, rafael@kernel.org, 
	song@kernel.org, lucas.de.marchi@gmail.com, christophe.leroy@csgroup.eu, 
	peterz@infradead.org, rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, 
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com, 
	colin.i.king@gmail.com, jim.cromie@gmail.com, catalin.marinas@arm.com, 
	jbaron@akamai.com, rick.p.edgecombe@intel.com, yujie.liu@intel.com, 
	david@redhat.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 30, 2023 at 3:41=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> OK thanks! So just to confirm, it seems fine to return the same error
> code if duplicates wait, or do you prefer for some reason for there to
> be an exception and return -EEXIST if the module did succeed in the
> duplicate case?

I think either should be fine, since either was possible before.

By definition, these are module loads being done in parallel, and so
any of them "could" have been the first, and returned success before.

And by extension, any of them could have been not first, and returned
-EEXIST if somebody else loaded the same module first.

So that "somebody else did a load" code:

        if (idempotent(&idem, file_inode(f))) {
                wait_for_completion(&idem.complete);
                return idem.ret;
        }

could certainly have made the return value be something like

        return idem.ret ? : -EEXIST;

instead of that "return idem.ret".

But it does seem simpler - and more in line with the conceptual
"loading the same module is an idempotent operation" of the patch -
to just always return the success value to all of them.

After all, they all did in some sense succeed to get that module
loaded, even if it was a communal effort, and some threads did more
than others...

As mentioned, I don't think it can matter either way, since any of the
callers might as well have been the successful one, and they would
basically have to act the same way regardless (ie "somebody else
succeeded" and "you succeeded" are basically equivalent return
values). If the module was a prerequisite for another module being
loaded, either -EEXIST or 0 _is_ a success case.

             Linus
