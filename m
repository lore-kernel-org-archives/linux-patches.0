Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36720D51F
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 19:49:41 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id f8so1897581qkg.3
        for <patches@lists.linux.dev>; Thu, 27 Oct 2022 12:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IZvmWLTFu1pJfxfIKPo4Qzw+QHUwqjXY5ckHaNck6Jc=;
        b=fTbxvhkB9Q+Fe33eN2TIiuiGsYcoayGZo/GVlgIPaPIi4E4PWHQg+tILioAu1pxy47
         SPB/HWIwL/rp1BPAalsZtvSEPPUlAgagvZZeBgnks/VLrKBeuDwVfjzxhCp8NrsMDPgH
         YqgIu238xCH5sedRqUOy5B71c+BZ22fWTQrb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IZvmWLTFu1pJfxfIKPo4Qzw+QHUwqjXY5ckHaNck6Jc=;
        b=2c79UejlVJ/P7aBMprZ3ppoVQwBKV+j0iQblRx9UUexcuOyDBzm5c+tabERpqrvIXh
         H02eT3T34iFVtyfIbkMGaot2MOeZDBBRVQbgOkK7wWUol9RCBqdszMmDvePYExyXcW36
         qV0OpShyeg70kAzq6uJkSiha41STPih4sEvGxOf6QuuaGy/gJTG5OOEF997oAkVKy22Y
         doUOPxIQ/zFi9BHlfSbmsgBsm6wMW8BWA/erw1GJBetQMooR9oQzE4kqRkBa5CSoE6IQ
         vnWapa8I/m6pwd6U6V6KPNxNViTjqClD6krviwbkTVyfHya4xFZGL6Cak2Yf3yGLeYHf
         nT5A==
X-Gm-Message-State: ACrzQf1E8ocqp5mmoJDochknVvfgDa8u/eI+SgL6gGyY+WzvRlw2Ta+g
	uspIqal5kYx66Pt95EhAiKFiFzaNbXEj8w==
X-Google-Smtp-Source: AMsMyM6qGSYFPnU8hdPAvlJ7wI3ASobZZ4v0qhTqisZLHipoVMy8HhEUJhjrPjFEcD+6sA7oCQXROA==
X-Received: by 2002:a05:620a:3708:b0:6ee:d16f:b780 with SMTP id de8-20020a05620a370800b006eed16fb780mr35923523qkb.144.1666900179716;
        Thu, 27 Oct 2022 12:49:39 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id c2-20020a05622a024200b0038b684a1642sm1369601qtx.32.2022.10.27.12.49.38
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 12:49:39 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-367cd2807f2so26994477b3.1
        for <patches@lists.linux.dev>; Thu, 27 Oct 2022 12:49:38 -0700 (PDT)
X-Received: by 2002:a81:d34c:0:b0:349:1e37:ce4e with SMTP id
 d12-20020a81d34c000000b003491e37ce4emr45951805ywl.112.1666900178558; Thu, 27
 Oct 2022 12:49:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221027165054.270676357@linuxfoundation.org> <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
 <Y1rbQqkdeliRrQPF@kroah.com> <20221027192744.GC11819@duo.ucw.cz>
In-Reply-To: <20221027192744.GC11819@duo.ucw.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Oct 2022 12:49:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgweH9GibJBzuEZNBGKbYPrs4NchT0YLuyxk1=N7gsWog@mail.gmail.com>
Message-ID: <CAHk-=wgweH9GibJBzuEZNBGKbYPrs4NchT0YLuyxk1=N7gsWog@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Guenter Roeck <linux@roeck-us.net>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 27, 2022 at 12:27 PM Pavel Machek <pavel@denx.de> wrote:
>
> Alternatively you can modify the caller to do /bin/sh /scripts/... so
> it does not need a +x bit...

Generally we should be doing both.

Make it have the proper +x bit to show clearly that it's an executable
script and have 'ls' and friends show it that way when people enable
colorization or whatever.

*And* make any Makefiles and tooling use an explicit "sh" or whatever
thing, because we've traditionally let people use tar-files and patch
to generate their trees, and various stupid tools exist and get it
wrong even when we get it right in our git tree.

So belt and suspenders.

But in this case, I think our tools already do the "run shell" part:

  Makefile:PAHOLE_FLAGS   = $(shell PAHOLE=$(PAHOLE)
$(srctree)/scripts/pahole-flags.sh)

no? And at least in my -git tree, it's already executable.

Maybe one of those "various stipid tools exists" is in the stable
tree. I didn't check.

           Linus
