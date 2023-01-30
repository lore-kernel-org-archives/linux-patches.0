Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E017479F7
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 22:03:26 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id p24so13109140plw.11
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BQY9unmzOV7TCZ96aU2p1l97OntyBK2gZGuBkFiwM9A=;
        b=kQ5/LBE4EPmy0MTjOLRhc7F+4NC2emrrWOeOsFIdDMoM6TY4QMWar6RfJKJvMjsYxf
         5aGron06eS18nyIgvaYuvNjXzAW9psgcktCwJlm6XwmaTc2k/ECsXNAjasvPiENdvkMM
         8sWFPzniRelG8krBvqHTNtdpxdqNSjGrONOHCYImQ/iZHfiMly0NDoypeYmfSQqYs+Kd
         XE+DisN7vEDdePh/OQQ0v/6WCUY9QKF0yPRien8ylSn4Qu5UUYxciPC/mPumeOjcqHDc
         Zr3x8WTqi23teJmdjv3iwTSuCfbzkUgswKW1D/epr7IQYPSoPbVVYVXwRVkMzFUzNtp/
         nqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BQY9unmzOV7TCZ96aU2p1l97OntyBK2gZGuBkFiwM9A=;
        b=u+Pm1bYIg4OoJvL7MHK0iyW8iWTpTCl4nN76b3VLny7wBiYX11OX2wro3iaeEQsRfP
         PqzLwkUrSQy4CRCAyPe5yrMRq6MRtiyslRFyo/p1OpxJk7uQ9RzRHrl/rvfijiBmefJT
         eiUPrMde3BtYrSeArlwI6v94VhzKgC/Vu+c/ywUOgzQQQZSLST2HFinOtHRcQ5N2bvbm
         KC0m9gjsH0Q7FJIAzpBoEh48uTfVU7qZSD47ZRwSNi77CljpMRAvO2zYeTs3GcCUOXo0
         S6+o3ByMIS+jbgptrUt5XfClnu78CUKQ51OfoKQ577O26ncvX+XnYDOrbXtuP/bvmMWs
         AXgw==
X-Gm-Message-State: AO0yUKXa4VY+LLJmsuSjsW7I5ekfCbhRblIWqnXsTEG1iOxn9PuDnsLV
	Cd40+pLmhGZk5ixysHvxs6RK5oNSa0QMzzSxTs+N1w==
X-Google-Smtp-Source: AK7set/bVllA+pXLc5bfi4Hr1MjNdTVvmsxv0RI7/gPQMOGYUc7EXoUGxxPyg9Z429Lxw5P7MYpHCt7QsgZFWpVdr5U=
X-Received: by 2002:a17:90a:9c1:b0:22c:816f:3203 with SMTP id
 59-20020a17090a09c100b0022c816f3203mr1221685pjo.28.1675116206022; Mon, 30 Jan
 2023 14:03:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230118-v4-v4t-lld-16-v1-1-e3d9a00ae47c@kernel.org>
 <202301310149.euWWUSrD-lkp@intel.com> <a40df1e3-ed92-4662-bb9e-106becce63d7@app.fastmail.com>
In-Reply-To: <a40df1e3-ed92-4662-bb9e-106becce63d7@app.fastmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 30 Jan 2023 14:03:14 -0800
Message-ID: <CAKwvOd=GbixTFko8aGzPQiq8QBtDY0ZZncHKag-gjsgqUM_diA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Allow pre-ARMv5 builds with ld.lld 16.0.0 and newer
To: Arnd Bergmann <arnd@arndb.de>
Cc: kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Tom Rix <trix@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 30, 2023 at 10:19 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Jan 30, 2023, at 19:10, kernel test robot wrote:
> > Hi Nathan,
> >
> > I love your patch! Perhaps something to improve:
> >
> > [auto build test WARNING on 5dc4c995db9eb45f6373a956eb1f69460e69e6d4]
> >
> > url:
> > https://github.com/intel-lab-lkp/linux/commits/Nathan-Chancellor/ARM-Allow-pre-ARMv5-builds-with-ld-lld-16-0-0-and-newer/20230119-032402
> > base:   5dc4c995db9eb45f6373a956eb1f69460e69e6d4
> >>> arch/arm/mach-sa1100/pm.c:122:12: warning: no previous prototype for function 'sa11x0_pm_init' [-Wmissing-prototypes]
> >    int __init sa11x0_pm_init(void)
> >               ^
> >    arch/arm/mach-sa1100/pm.c:122:1: note: declare 'static' if the
> > function is not intended to be used outside of this translation unit
> >    int __init sa11x0_pm_init(void)
> >    ^
> >    static
> >    1 warning generated.
> > --
>
>
> For refernece, these are all known problems, the patch just allowed
> the code to be built by clang/lld when that was previously not
> possible.
>
> After the 6.3 merge window, we can probably go through the much
> smaller set of board files are address most of the W=1 warnings that
> were previously overwhelming.

Yeah! I've filed
https://github.com/ClangBuiltLinux/continuous-integration2/issues/509
too so that we can wire up an ARMv4 test in our CI as well.

>
>       Arnd



-- 
Thanks,
~Nick Desaulniers
