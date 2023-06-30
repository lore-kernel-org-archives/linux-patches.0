Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A692846D
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:47:23 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-51d946d2634so1633900a12.3
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688107642; x=1690699642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zlchbRYXZ2GmgikakdfRkYq9RUe43aExK7E5sqwL0Bw=;
        b=A4gTuuMIMizRixVdblSqw5SYKt+QwmRPLuUK4f4z0K2+yGZIDExa8f4XopC4/kPs9+
         YzKW+teF6Fq1kkS60487u5rbCRcCXk4xGumtHwFgLTCGDMvPXB2M0Q7nYK2m8trH5hCD
         kzCPDL3NWtWTtGWdXIfTVqxyXjmpZ+rgAJiSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688107642; x=1690699642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zlchbRYXZ2GmgikakdfRkYq9RUe43aExK7E5sqwL0Bw=;
        b=e5qHXS4qJOPd95SGhuLKXnZXPA/MhYedwJXceiS3P3hnL58t2QbRsw89exL/QpMPDQ
         iWme9Q8pZ06AR4BqDWSiHVfJuyiqNvVYjUc/ugfJgJoUalKMF20+98fsztBSC7dPcubb
         HlhDXOw40MdaQXpbMDokNxXrT0PwS1aIB30sehKDuspjaiVdqwRFL53/gPp9XymtgiGM
         Zbft4oQhSeF7gBCCC92o4JxosrDau3hr0QBFDqTJvw4ZZzzNRWUhk0j+4Ug/EONjQEKl
         IOCZonLv2cgPcihOXrMa8IBMuuXNxQmptCpVPAKjFcyBvbZrv0YmbTMf3ogHVR4AYD3O
         rWJQ==
X-Gm-Message-State: ABy/qLZiR8Hn0POmjJe8IyAJwni5sz9QC8Agt53yfVMZmhzz0RF2izTT
	ZShlA5/Hm486FiX9pmyECJJ/iCY7hx8Hxjb/RZxquukJ
X-Google-Smtp-Source: ACHHUZ589jzu0CzdUS7XuToG/j2cDPlS1XlLG7dbyA3N4JbJvR7On3cvGua3LIK/o+HilzS7VTwSTg==
X-Received: by 2002:a17:906:3659:b0:991:7874:ef69 with SMTP id r25-20020a170906365900b009917874ef69mr1139974ejb.24.1688107642165;
        Thu, 29 Jun 2023 23:47:22 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id kt19-20020a170906aad300b00989828a42e8sm7654155ejb.154.2023.06.29.23.47.21
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 23:47:22 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-51d9123a8abso1625883a12.2
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:47:21 -0700 (PDT)
X-Received: by 2002:a05:6402:217:b0:51d:7ed9:c65 with SMTP id
 t23-20020a056402021700b0051d7ed90c65mr915784edv.21.1688107641560; Thu, 29 Jun
 2023 23:47:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.888604958@linuxfoundation.org> <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net> <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
In-Reply-To: <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Jun 2023 23:47:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com>
Message-ID: <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, linux-parisc <linux-parisc@vger.kernel.org>, 
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Jun 2023 at 23:33, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oh well.  We'll get them all. Eventually. Let me go fix up that csky case.

It's commit e55e5df193d2 ("csky: fix up lock_mm_and_find_vma() conversion").

Let's hope all the problems are these kinds of silly - but obvious -
naming differences between different architectures.

Because as long as they cause build errors, they may be embarrassing,
but easy to find and notice.

I may not have cared enough about some of these architectures, and it
shows. sparc32. parisc. csky...

             Linus
