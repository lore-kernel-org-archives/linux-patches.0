Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B54AA7
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 16:21:48 +0000 (UTC)
Received: by mail-ua1-f45.google.com with SMTP id v5so4510518uam.3
        for <patches@lists.linux.dev>; Fri, 18 Feb 2022 08:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MBFxmlsp+Ppol0M03sVOJPvD0cRtLe1wxV7SG8UW4lw=;
        b=MOS0ZKbjI8xl7ER0rzl/N7TIG//ZghuPB3+myCtK980sjjNtXfoG68cs7DQ3UmiurJ
         53FT/TZbLegmZ6S3INVntv8MYtcjmRCufuqBSeNGO4tBI/mAkEOicmpJju5Oe03jW8Q3
         IZ+mtwdUX19fa/ja86NtCvIPTxzgXmdOV5ZDF3iWcT0TIL8RySDfJ/Ra3IZqTG4ensmo
         6pU2bUhI8mOK3cmAcp/y//7nAQNcX2n94uC9SwYW/AUne1MkBgwDWqIzDt7EIEmn8IU0
         Hut28l0qhkrkAJCkwXqKGivrwsHPIICRZiVECgMaEzCvmpF7lllWCS7EihA5nEGZfIoQ
         vSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MBFxmlsp+Ppol0M03sVOJPvD0cRtLe1wxV7SG8UW4lw=;
        b=mAFexo8I8Fsv2JZqqXjOzAqNTz1TPSQPWCv+U6/Wn3f8MDEOfTBGQgG2Sah7mKEQ3K
         LA6rIpyRqHXSraaOY/JieJLkv/ED854MucTRUnPu/TO3vIGF02gJAp3mEEnVKjQTu4Gv
         lkVUS0OmdoKS9ZmmoLTnezPKDTMxsf3bdY5KFgdvxADWZgbJX9A2zGHyZEYvNClpW690
         VjXimKF3pI0tYqTeqIlrCZ3dOBldvZyQYeduPwLnIa6PnSCx7HocnLPMw9NyEUREsuDd
         7DwBepQ2A5zjRBn8HKC2+KfSDwk/OyHTGWqDOidlZYOZSQACwwCo60dyCgR61EpYTBkQ
         Gd7A==
X-Gm-Message-State: AOAM532c5Iy7hyt1sUIztubLh7zRA1I7rHmNyfF5idTUN4zN2S1ImGOZ
	jspPZ5i+lMzBxkHt84kpvIzx1nBgxEDlHOiQ/A4FkQ==
X-Google-Smtp-Source: ABdhPJzAl3cdYfXDoi8IHapaMBToDE190zn9xog31chAYhWjAgGvCYxbQV9awiWUVLoK9PNPXBPYF9Eig5kuZXLh/Ok=
X-Received: by 2002:ab0:60b1:0:b0:341:543e:c388 with SMTP id
 f17-20020ab060b1000000b00341543ec388mr3270571uam.80.1645201307736; Fri, 18
 Feb 2022 08:21:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yg54nse5qNQO3sbW@zn.tnic> <20220218013209.2436006-1-juew@google.com>
 <Yg+2Hc78nfSRmh/j@zn.tnic> <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>
 <Yg/FyrvLWhZHB/UC@zn.tnic>
In-Reply-To: <Yg/FyrvLWhZHB/UC@zn.tnic>
From: Jue Wang <juew@google.com>
Date: Fri, 18 Feb 2022 08:21:36 -0800
Message-ID: <CAPcxDJ72dMOpbKXxyb__OeMaEyjYSPtsL_ubVsKOuRXefAQ3_w@mail.gmail.com>
Subject: Re: [PATCH v2] x86/mce: work around an erratum on fast string copy instructions.
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 18, 2022 at 8:14 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Feb 18, 2022 at 08:03:24AM -0800, Jue Wang wrote:
> > Since MSR_IA32_MISC_ENABLE is not a MCA register, I wonder if we want
> > to mix its read/write with the injected MCE code.
> >
> > I was a bit concerned about potential race with mce-inject and the
> > read/write to MSR_IA32_MISC_ENABLE.
>
> It won't inject anything:
>
>                 offset = msr_to_offset(msr);
>                 if (offset < 0)
>                         ret = 0;
>
Thanks.

My concern was that here returns 0 instead the value read from the msr.

Maybe this cannot happen?
>
> Besides, you need to use those routines due to EX_TYPE_{RD,WR}MSR_IN_MCE
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
