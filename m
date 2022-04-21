Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6BE1FCD
	for <patches@lists.linux.dev>; Thu, 21 Apr 2022 17:22:55 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id h27so9636771lfj.13
        for <patches@lists.linux.dev>; Thu, 21 Apr 2022 10:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/AfDMww0ycBxrjvRQwLCHmq5YuufUqn+uMvN5LmZDY=;
        b=eJ9tArgvEbb4NPhUtQvUKRhsT1d0d9SHze4TnuOVVIm+ZG8tDkcqYaIu03Fpl9hdOG
         I0dLGKvUNniBBsOcYBUNHpO2BcjoONm6oWxDq25iThwDJ5Nd3KFjFKinZ5BREBOgqn/7
         gZ5GmykMh/JFqZ17wisI6dOcFGCwNNv6dnJiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/AfDMww0ycBxrjvRQwLCHmq5YuufUqn+uMvN5LmZDY=;
        b=wisf5Z7f+CyNJQO5qGmYs/ZRQvIb0n/2RlGtTteoeyrdxFD+TTufiPriHmjoemrVGt
         Io3BWaLV+0aywlNyVF8JBEBsV9Ik/AF2zvu8w5EpO27G30EYzP+LcOz6Z4ei+MnANJck
         5xf5R/vTCLJPwimnP3MRvp4rRuFrd0OPP69PPR7fiRzavHYafDDIx82gIZmGCQZvu9JA
         qm0F2YeMHE4kOwv5Yyfbb1zvKmaY5WhcZ50TWXa/FzOaplfuKuMzQzQBKM5QMWAIPpJM
         Z0jowc2vG4Ft9TERnGxyRzlJu53EbEV/g7x9hLki7sbsopW9t7GM1hgmOg2B15lqypk0
         Bfhw==
X-Gm-Message-State: AOAM532SOdRusFhzvqlolBDkhJlD1yDX5HmiCGL1UV9KqfrCi99f3S8J
	UAzB1CzASmyjzabJ5N+rARWk5CWM3Xpy65j3Tto=
X-Google-Smtp-Source: ABdhPJyRWaRT2CydFTi4l7l9HSFRC6JWBAYt/6bLl24vCQvweenpqdAm4fkaKnZ/gSwrAXCPk2qrVQ==
X-Received: by 2002:a05:6512:c0c:b0:471:adb6:4d6d with SMTP id z12-20020a0565120c0c00b00471adb64d6dmr341879lfu.11.1650561773195;
        Thu, 21 Apr 2022 10:22:53 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id l3-20020a194943000000b0046b928d2795sm2242369lfj.67.2022.04.21.10.22.49
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 10:22:51 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id h27so9636403lfj.13
        for <patches@lists.linux.dev>; Thu, 21 Apr 2022 10:22:49 -0700 (PDT)
X-Received: by 2002:a05:6512:108b:b0:470:90b9:fb51 with SMTP id
 j11-20020a056512108b00b0047090b9fb51mr358743lfg.52.1650561768960; Thu, 21 Apr
 2022 10:22:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
In-Reply-To: <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Apr 2022 10:22:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
Message-ID: <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 21, 2022 at 9:50 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> where that "read(..) = 16" is the important part. It correctly figured
> out that it can only do 16 bytes (ok, 17, but we've always allowed the
> user accessor functions to block).

Bad choice of words - by "block" I meant "doing the accesses in
blocks", in this case 64-bit words.

Obviously the user accessors _also_ "block" in the sense of having to
wait for page faults and IO.

I think 'copy_{to,from}_user()' actually does go to the effort to try
to do byte-exact results, though.

In particular, see copy_user_handle_tail in arch/x86/lib/copy_user_64.S.

But I think that we long ago ended up deciding it really wasn't worth
doing it, and x86 ends up just going to unnecessary lengths for this
case.

               Linus
