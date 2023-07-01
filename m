Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153451857
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 04:23:06 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-4fb7589b187so4239704e87.1
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 21:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688185384; x=1690777384;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ViFCqfiw9NC8hbaUDlyrBH6eii1s13MnpTkthHHGEXE=;
        b=ACV7XAyCVqAaBPNd+vSu/FV7OVAcONKkLsIThuTWcFsU+vFFJE8UGIfDFQ9syAqfBF
         UHhVf2ek1ZJtMlI1dLek6aI8vF62vW5SiqORp+TfAwaKEs8e3//gpSn8LzMzxLe8PJ+e
         fkz6qDz5S4RTJATaYWGRbVauPShNUyPDdt41U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688185384; x=1690777384;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ViFCqfiw9NC8hbaUDlyrBH6eii1s13MnpTkthHHGEXE=;
        b=g6BLT4l1o+8CDeO5vgbOvIJ9FB9RULAbeGag806ZcEU8NOd4bz/MqPeun0JNjFHZBi
         ldNtMkN3CbZX4ZFW8EmGRdkR+dDjA1I1Ybo/n7uZdwCKvUjb0LfjQPjzDRbOSM3r6xmQ
         ClRN9+adur/CFJGhT8qwW0QTtxoO/QfjJoYckJn3QfNePeRNAc/qd89xcAikrtpUekkx
         mfyW+jViN7LgAuMTjYeYFYTQpQTfZv0uSsM8n1rNyASv/RfS0lsYHhhNhu+jHVhkAb/J
         agov+QfgXPfByJwYelgcYnDndTmz5S38gk1iUPOTWyiveqUsVp4ioPRSJSHYRYLdVZ8+
         WbWA==
X-Gm-Message-State: ABy/qLbiQkReGObkzckZxplEUF8JN3+hIppLeSWygy3BtrlppvzjbIoM
	SzC0aosP+qbg68ZYAFhlFBEodBu8psbu/kPZtaYmWiCL
X-Google-Smtp-Source: APBJJlE5mjuAy/ot9WgBIMck4gtDzhoVdcdhF6QKRZ//erHtuOt5MnucAr/MAcHb1+d89PrX6rSqVA==
X-Received: by 2002:a05:6512:3ca3:b0:4fb:7381:4c69 with SMTP id h35-20020a0565123ca300b004fb73814c69mr4417380lfv.28.1688185384721;
        Fri, 30 Jun 2023 21:23:04 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id j20-20020ac24554000000b004fb74cb9664sm2554777lfm.94.2023.06.30.21.23.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 21:23:03 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2b5e7dba43cso42228431fa.1
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 21:23:03 -0700 (PDT)
X-Received: by 2002:a2e:888e:0:b0:2b5:9f54:e290 with SMTP id
 k14-20020a2e888e000000b002b59f54e290mr3104948lji.0.1688185382985; Fri, 30 Jun
 2023 21:23:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.888604958@linuxfoundation.org> <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net> <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
 <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com>
 <fb63ea7b-c44b-fb1b-2014-3d23794fa896@roeck-us.net> <CAHk-=whh_aUHYF6LCV36K9NYHR4ofEZ0gwcg0RY5hj=B7AT4YQ@mail.gmail.com>
 <e4dd115b-1a41-4859-bbeb-b3a6a75bf664@roeck-us.net>
In-Reply-To: <e4dd115b-1a41-4859-bbeb-b3a6a75bf664@roeck-us.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jun 2023 21:22:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgBAhFqD6aoD2rL0qws8S1erdbrvmQXuYi=ZFEUVNuVfg@mail.gmail.com>
Message-ID: <CAHk-=wgBAhFqD6aoD2rL0qws8S1erdbrvmQXuYi=ZFEUVNuVfg@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, linux-parisc <linux-parisc@vger.kernel.org>, 
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Jun 2023 at 19:50, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Yes, the patch below fixes the problem.
>
> Building xtensa:de212:kc705-nommu:nommu_kc705_defconfig ... running ......... passed

Thanks. Committed as

  d85a143b69ab ("xtensa: fix NOMMU build with lock_mm_and_find_vma()
conversion")

and pushed out.

                    Linus
