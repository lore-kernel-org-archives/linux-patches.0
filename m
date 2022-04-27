Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9227B
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 16:00:56 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id p12so3950209lfs.5
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 09:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f86HljRdWHz/mbjYe5zQP1uXjxkFKfJygzPgkJmoMVk=;
        b=Jlr52u75tjiUlJGnxg5Xo0MF63HPxETIuoZHnTdCRIjmiHitYd5Ks2EY8BuItM/J7d
         gR7eBpn6GwNGZT01SDRKTXwBHHYrFWQN4mjks3PrCeOKK2CN+3+tzCTLedjw1U7bpnh6
         92iB5aeArNJpCipv26I2S+O3N7mDDnOOupAYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f86HljRdWHz/mbjYe5zQP1uXjxkFKfJygzPgkJmoMVk=;
        b=rVq/PgzH5GYpHn5Q+nD3uHOWX1nTFwdUr4iEbrGfJfkxcoZgIcmg/a0cm7iXtQ0KKR
         ADFSHzr3UhjRjaIx/gBivLqhzT40zf5A85ci6wbfsFa2R+hozvCbAF/ZDC7nfQJXcKnk
         y7Vj5NZkkVSVG8FY/LnjrzJM+GFM4GHHeOJgi05+4zHsQLxAGr8NfcWpSQaGH7oCpawF
         AlwtxYREbW3+XRpkeSoSVNyo8EP7NFDVFbzBJ+DD+UbSAKCIL2aZ41EiEWNI4Lj8dPQU
         WUPTS+7/93nu44sMhO2C9bFNhKltGvzVLfUGKRNEbfSaTCQfJEzhlsFfIHuthwmJnWUU
         YbfQ==
X-Gm-Message-State: AOAM530NdSg6TVrHe6ElTB2x4RFEozEIg1nnpEvuWGUNPBkzwQpw5t3h
	OZPDN7BsAIrvyahlT/zRZhP4gf+UkXR9zPIAWoA=
X-Google-Smtp-Source: ABdhPJw+JKKO6kU5BCqr0hryenpp9urpe0UQB4E4GhY7ROTT5DMGEK3+RDCjutlJI4CESdbi+wkKWA==
X-Received: by 2002:a05:6512:1694:b0:448:3fd4:c7a9 with SMTP id bu20-20020a056512169400b004483fd4c7a9mr21795079lfb.29.1651075254341;
        Wed, 27 Apr 2022 09:00:54 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id z25-20020a19e219000000b00472230888a5sm428161lfg.121.2022.04.27.09.00.52
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:00:52 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id s27so3275854ljd.2
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 09:00:52 -0700 (PDT)
X-Received: by 2002:a2e:934b:0:b0:24f:cce:5501 with SMTP id
 m11-20020a2e934b000000b0024f0cce5501mr12651353ljh.443.1651075251987; Wed, 27
 Apr 2022 09:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic>
In-Reply-To: <YmkdxaKdc2w/3I7o@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Apr 2022 09:00:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
Message-ID: <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 27, 2022 at 3:41 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Any particular reason for the explicit "q" suffix? The register already
> denotes the opsize and the generated opcode is the same.

No, I just added the 'q' prefix to distinguish it from the 'l'
instruction working on the same register one line earlier.

And then I wasn't consistent throughout, because it was really just
about me thinking about that "here we can use 32-bit ops, and here we
are working with the full possible 64-bit range".

So take that code as what it is - an untested and slightly edited
version of the code you sent me, meant for "how about like this"
purposes rather than anything else.

                   Linus
