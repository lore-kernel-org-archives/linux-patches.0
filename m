Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F802F3A
	for <patches@lists.linux.dev>; Wed,  4 May 2022 20:40:27 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id s27so3180322ljd.2
        for <patches@lists.linux.dev>; Wed, 04 May 2022 13:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n5f7afkXUKTo3IPWzmlyI8gr9ELiri6KDY4jDCLAwqk=;
        b=hxZbDwh249V8ZWvJvHgV8HOAuCwzitlpmdUaF1aBT2GoF1r95NpNwyDzyBX4DdfW4t
         S+439ChsQrTcSauZNdL3zxMoiHfb+9og+70XrhkoRCXDijiIGEY4j8RIp1HfceEd4Ycx
         YfSmJLaV8W0hI8BFv1q8CTPECn1nKJl+L25HM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n5f7afkXUKTo3IPWzmlyI8gr9ELiri6KDY4jDCLAwqk=;
        b=kBqdD3AShnIU2aDazFAXcib8O6H2QlurX/dzoetMGgQN+9ve2wX3wn52H5tNhaX3iI
         2QkOfKDB2L7mDN0vRoXWazN27ZyUuKMFe77+bTMbmGUMyRSe8y28vOmrEGTXiAQbJ3vM
         1uAH7ePn5HYXtWwH8SUnruqrHWyP2gsVAk7vOWqmBdGnupgTUCx0yCKrB/acj4yHIzsz
         CnZ8tRyNQ3JabEKWeXkFXGh/rE3tWLGZzP7Lo99UbkO+5oqtxILgXXshX5CWsMtJFfJX
         oKck0xeT6/auNngI52AK2lk8s4Y5KgTTItzXlDOga/mJ1RsY/JENWU3lg2VOC7wuWibr
         cp/A==
X-Gm-Message-State: AOAM5312TvMcVU+KWvYdgazKM15cdjXwoZ+fFgHcPGnnk3GtroPYucIl
	3vnalnLeB1s2vp2is/sbwM7lSj9qWkOTd/kEOGs=
X-Google-Smtp-Source: ABdhPJwMOPucxvRjs2IQiL2sUZ2EdSynGjxqwXkNRsQETWNBJaAaB2FTe/oP4PTzXBv5Irs1DeE6LQ==
X-Received: by 2002:a05:651c:505:b0:24f:5248:3018 with SMTP id o5-20020a05651c050500b0024f52483018mr10461941ljp.45.1651696825181;
        Wed, 04 May 2022 13:40:25 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id f7-20020a056512092700b0047255d21108sm1292171lft.55.2022.05.04.13.40.23
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 13:40:24 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id p12so4325873lfs.5
        for <patches@lists.linux.dev>; Wed, 04 May 2022 13:40:23 -0700 (PDT)
X-Received: by 2002:a05:6512:3a4:b0:473:b9ea:7673 with SMTP id
 v4-20020a05651203a400b00473b9ea7673mr3445886lfp.687.1651696823645; Wed, 04
 May 2022 13:40:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
In-Reply-To: <YnLfl6lupN2nq7+t@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 13:40:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
Message-ID: <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 4, 2022 at 1:18 PM Borislav Petkov <bp@alien8.de> wrote:
>
> Zen3 has FSRM.

Sadly, I'm on Zen2 with my 3970X, and the Zen 3 threadrippers seem to
be basically impossible to get.

> So below's the git test suite with clear_user on Zen3. It creates a lot
> of processes so we get to clear_user a bunch and that's the inlined rep
> movsb.

Oh, the clear_user() in the ELF loader? I wouldn't have expected that
to be noticeable.

Now, clear_page() is *very* noticeable, but that has its own special
magic and doesn't use clear_user().

Maybe there is some other clear_user() case I never thought of. My dim
memories of profiles definitely had copy_to_user, clear_page and
copy_page being some of the top copy loops.

                   Linus
