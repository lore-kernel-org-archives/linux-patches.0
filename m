Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF77A7470
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 23:05:44 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2478485fd76so3539789a91.2
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 16:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682377544; x=1684969544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQ8sFzZ9vlAXommM0w2/PXvGSOKBNi6JzIA9K33bVAU=;
        b=WD+ceziX6bq4nghbfbXLNklOmtmN9i6mL4/A14bPp9VINUyoFGGw8A0p3dQ34YR+WV
         V9UR0Cc1hxLra/AnBrIM2gSUcmRFtrM5vgBmxBXyH5v7k/iTTDcarBsO+NVHuUmNRLqk
         dSPFhIKxc3ozN6inFnMIifOSp0RHJ/2bfCVGkAJqyAaWeKXijbsqYI4AwyageV940smm
         vD8mw7+iTiazzzJQjSbKJtwtb48sO7QbkT+1hYFzC/8SxrZf/CzoX0kZPwM3nS41A+6/
         q+e/CJ8lPeZJCI19Jmmuvmazx2ljqsBXJIf6qkom4c4wGxwyamVIDb5oE81/KJI0NGbi
         vljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377544; x=1684969544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQ8sFzZ9vlAXommM0w2/PXvGSOKBNi6JzIA9K33bVAU=;
        b=WeIh6CgiM9tWHgEZEx1undQsuTeysuBtbUelRPdIFytoJZ8cvrynfPw2D4O8juQLhV
         nAEagJLVqj3VWXSebnQGfsTbpJNg+ZDztEB+IMg/8RhZB7GRmqahzFzhmnjyqne1t+ZV
         jM/5sHw7COlbxKiZUcHgY0x7ojzRZT7t13Gf88LTc34h62WSuy5Jp+pKcUiZbms9NfCf
         EmpHr/2DaaNytXZfBoyeuK1pmMPDIQEmO6xEXgp0AMR9vOBsXC9tc0rzsNDjTJwwxpE6
         v3p0wfhqmoPZeF2nwXQeOxom9soGCmFr3Qe6Tt2UETS5byJFbH3TE5MXANus366kzIw4
         FWzg==
X-Gm-Message-State: AAQBX9fxb/2lK7c805sOiJN4mR/beJJWkwOQHTwE4Kr3o2DMgR8k8ab/
	PW7F9QRLMpZGZXPsQWSc68domzJMl8HFw4Fn044=
X-Google-Smtp-Source: AKy350YiJuL4duFP78n+ItNB+lUpN4w+zRdMWcrBiJgXD2Qk753AS4CLImpFJFw1UHLIr+HVloJCI3jyLWK4zIDEzVY=
X-Received: by 2002:a17:90a:fd17:b0:247:1de8:8263 with SMTP id
 cv23-20020a17090afd1700b002471de88263mr16233416pjb.4.1682377544182; Mon, 24
 Apr 2023 16:05:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230421214400.2836131-1-mcgrof@kernel.org> <20230421214400.2836131-3-mcgrof@kernel.org>
 <ZEMRbcHSQqyek8Ov@casper.infradead.org> <ZENO4vZzmN8lJocK@bombadil.infradead.org>
 <CAHbLzkoEAJhz8GG91MSM9+wCYVqseSFzBQdVAP78W5WPq26GHQ@mail.gmail.com> <ZEb2eYX5btfLrUtQ@casper.infradead.org>
In-Reply-To: <ZEb2eYX5btfLrUtQ@casper.infradead.org>
From: Yang Shi <shy828301@gmail.com>
Date: Mon, 24 Apr 2023 16:05:32 -0700
Message-ID: <CAHbLzkqk2+woBTHEdkYcae6No40S6QXFPQk6hE+_C=7UHbe+Zg@mail.gmail.com>
Subject: Re: [RFC 2/8] shmem: convert to use folio_test_hwpoison()
To: Matthew Wilcox <willy@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, hughd@google.com, akpm@linux-foundation.org, 
	brauner@kernel.org, djwong@kernel.org, p.raghav@samsung.com, 
	da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net, 
	yosryahmed@google.com, keescook@chromium.org, hare@suse.de, kbusch@kernel.org, 
	patches@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 2:37=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Mon, Apr 24, 2023 at 02:17:12PM -0700, Yang Shi wrote:
> > On Fri, Apr 21, 2023 at 8:05=E2=80=AFPM Luis Chamberlain <mcgrof@kernel=
.org> wrote:
> > >
> > > On Fri, Apr 21, 2023 at 11:42:53PM +0100, Matthew Wilcox wrote:
> > > > On Fri, Apr 21, 2023 at 02:43:54PM -0700, Luis Chamberlain wrote:
> > > > > The PageHWPoison() call can be converted over to the respective f=
olio call
> > > > > folio_test_hwpoison(). This introduces no functional changes.
> > > >
> > > > Um, no.  Nobody should use folio_test_hwpoison(), it's a nonsense.
> > > >
> > > > Individual pages are hwpoisoned.  You're only testing the head page
> > > > if you use folio_test_hwpoison().  There's folio_has_hwpoisoned() t=
o
> > > > test if _any_ page in the folio is poisoned.  But blindly convertin=
g
> > > > PageHWPoison to folio_test_hwpoison() is wrong.
> > >
> > > Thanks! I don't see folio_has_hwpoisoned() though.
> >
> > We do have PageHasHWPoisoned(), which indicates at least one subpage
> > is hwpoisoned in the huge page.
> >
> > You may need to add a folio variant.
>
> PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
>         TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
>
> That generates folio_has_hwpoisoned() along with
> folio_set_has_hwpoisoned(), folio_clear_has_hwpoisoned(),
> folio_test_set_has_hwpoisoned() and folio_test_clear_has_hwpoisoned().

Oh, yeah, I missed that part. Thanks.
