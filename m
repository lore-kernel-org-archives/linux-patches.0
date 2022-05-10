Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0C2912
	for <patches@lists.linux.dev>; Tue, 10 May 2022 17:28:48 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id i19so34336845eja.11
        for <patches@lists.linux.dev>; Tue, 10 May 2022 10:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Mz7I1jn3xzDkkA1HCpKDXJNUAzdpv6ms7CIns60Dn4=;
        b=eft9x/Ewsct7cNwgh2+u9zvmAjY3Zq8s0S57BEeDFmQ3qM9TFDSLDaWMiAAbZsfrN6
         A+d1RrqdMKi9XMx1X4XPXtNoqp0dyVM5DUddPJY1pGuYaAzngJ3errQ4MUWrUCIh1Mag
         JVL6Xu16IeB/5p4peIuf19bhoX74Qqqre51Ak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Mz7I1jn3xzDkkA1HCpKDXJNUAzdpv6ms7CIns60Dn4=;
        b=eKFangHsFAziBQyDlBpHxyZiE//x8jYhpQDTxT1+P1vCmspG77TfTs1RmId1KLti3N
         eldcpIukwpfmgrqvMx1vay2vwTManef6UcTJxzuxdovlCot50ZYa5okYybk6/gcDA2I3
         UvY/wTzheSloobxo5KhshXN5ZF1np6V6Dhet4TbAgGoExbvJdimXU7y99OYBkGKXyt9r
         Rq9+hqNNf6xq8JnSwvFD4pA5Wr78h5cmzJ3SGV5uelFs8filayLYwWbHXboY0pPLec9U
         b0eEPfL4fQy3qibRzBCkfLCHf+25YmuWe/VXhzsA8DnXQc6gurxcGdv1T42/TmKzkhL7
         49IA==
X-Gm-Message-State: AOAM532Dv0uHzmz2eG6apTZRbGYHOvC/s5KFuS8wOivyDBsHylwXdd33
	IqL1tMnhHwqEoUETQxal1VNgBWcGWCtop6C81pw=
X-Google-Smtp-Source: ABdhPJwh8ptnDbOtMyvhqaF87Q7WaZBteR70Yiahhw12tTwf+V768Kgovyay+3GbFlS28BUuQeJJTQ==
X-Received: by 2002:a17:907:8a12:b0:6f4:a586:de8f with SMTP id sc18-20020a1709078a1200b006f4a586de8fmr20111626ejc.514.1652203726595;
        Tue, 10 May 2022 10:28:46 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id zd10-20020a17090698ca00b006f3ef214e4fsm6250573ejb.181.2022.05.10.10.28.44
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 10:28:45 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id k126so10626544wme.2
        for <patches@lists.linux.dev>; Tue, 10 May 2022 10:28:44 -0700 (PDT)
X-Received: by 2002:a05:600c:4f06:b0:394:836b:1552 with SMTP id
 l6-20020a05600c4f0600b00394836b1552mr998628wmq.145.1652203724417; Tue, 10 May
 2022 10:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
In-Reply-To: <Ynow8F3G8Kl6V3gu@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 May 2022 10:28:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
Message-ID: <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
Subject: Re: clear_user (was: [patch 02/14] tmpfs: fix regressions from wider
 use of ZERO_PAGE)
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, May 10, 2022 at 2:31 AM Borislav Petkov <bp@alien8.de> wrote:
>
> clear_user_original:
> Amean: 9219.71 (Sum: 6340154910, samples: 687674)
>
> fsrm:
> Amean: 8030.63 (Sum: 5522277720, samples: 687652)

Well, that's pretty conclusive.

I'm obviously very happy with fsrm. I've been pushing for that thing
for probably over two decades by now, because I absolutely detest
uarch optimizations for memset/memcpy that can never be done well in
software anyway (because it depends not just on cache organization,
but on cache sizes and dynamic cache hit/miss behavior of the load).

And one of the things I always wanted to do was to just have
memcpy/memset entirely inlined.

In fact, if you go back to the 0.01 linux kernel sources, you'll see
that they only compile with my bastardized version of gcc-1.40,
because I made the compiler inline those things with 'rep movs/stos',
and there was no other implementation of memcpy/memset at all.

That was a bit optimistic at the time, but here we are, 30+ years
later and it is finally looking possible, at least on some uarchs.

               Linus
