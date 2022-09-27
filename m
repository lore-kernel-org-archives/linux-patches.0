Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01313440E
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:36:20 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id d187so10048092vsd.6
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 08:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TUGMZoFYFoHDZJYWzaIuE6u06usrctQB8r3AoeeFKDk=;
        b=lYb4nELxXqmlc7EGzml+Eu3QkgdG8gCYbaYfSADphVKjQKUWjdiiBEuNR90lhN/sou
         VNISjYxkC/VQlbZUkEj32sI0PymuhWR3C5r/r7tNcHc/GDv7zhdtjH+hrgUwTU15bR7s
         S/wuQiNw2bszt+WguK8q1I73PmRtZpjls1GKHtdE8/yMzTnIBAWRu3TAyig95OC2vx2q
         Bn4slTdpyOi4lEYSQP3T78YJmrX6+ayRYr5qe1yxdwzFcNBLR0aFlmy2TRBsvZ0tvBrA
         6Exxs/xPGEmocwv4D2MLnwaOYtuvKgutzCG2gKPCVD/k0Kyt9qUKd2tJemQIoIgy/5fn
         22LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TUGMZoFYFoHDZJYWzaIuE6u06usrctQB8r3AoeeFKDk=;
        b=UpSGl25+ESjBzZCbnddokabx6Qbi1F2v8MC76O7W4narEH/uDamJhx5/tRImSyenPK
         3YcsiR6MFJbBWuSQjybIZ5HhbSvtSxS5BV6AuKBd8aFp+B6aBfYl7e+HShB2IrQcjfSv
         qKRfZvUe8oFWIBN9YXCchKuiEwudbeP++SKuCutluI6wFhJdP+6G6veMonrt610F4VUg
         iLGAILv4Vh9thP0F+f4A8fRV+4zH4mY7cU4mrMOzANUto1xusansCvnd9p8M2793knLT
         TIocud/Q0tJOYSJ0K/iqtEqPa817nYqZjl+yZevPDuh4FTHQxO07fbz/peIQ8Pen0T9c
         Gnwg==
X-Gm-Message-State: ACrzQf03uoloJ4QHTS0lyWEVLCzFJmeIVizVO3MeZquVXm+qufo1kZ2H
	4YMbDm9GIDsKS9a/M3pwC/vSZAh0Z1hVcIel+AI=
X-Google-Smtp-Source: AMsMyM4JbqyS7Au1A2OS5ukPgae3HmiQQlrlrFqB/B0i2xbbGYgaJjH0G4opluTkSfFVKEzgewSeceuVaimuAavWrGY=
X-Received: by 2002:a67:fc44:0:b0:398:30ac:1c95 with SMTP id
 p4-20020a67fc44000000b0039830ac1c95mr11484950vsq.16.1664292979806; Tue, 27
 Sep 2022 08:36:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-13-ojeda@kernel.org>
 <YzMVLkr3ZlbENMcG@kroah.com>
In-Reply-To: <YzMVLkr3ZlbENMcG@kroah.com>
From: Alex Gaynor <alex.gaynor@gmail.com>
Date: Tue, 27 Sep 2022 10:36:08 -0500
Message-ID: <CAFRnB2W2SjmN9Z5XqLncRz-Bs4XbUcw734oLx0u9wso0jZ-YEA@mail.gmail.com>
Subject: Re: [PATCH v10 12/27] rust: add `kernel` crate
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev, 
	Jarkko Sakkinen <jarkko@kernel.org>, Wedson Almeida Filho <wedsonaf@google.com>, 
	Geoffrey Thomas <geofft@ldpreload.com>, Finn Behrens <me@kloenk.de>, 
	Adam Bratschi-Kaye <ark.email@gmail.com>, Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boris-Chengbiao Zhou <bobo1239@web.de>, Boqun Feng <boqun.feng@gmail.com>, Fox Chen <foxhlchen@gmail.com>, 
	Viktor Garske <viktor@v-gar.de>, Dariusz Sosnowski <dsosnowski@dsosnowski.pl>, 
	=?UTF-8?Q?L=C3=A9o_Lanteri_Thauvin?= <leseulartichaut@gmail.com>, 
	Niklas Mohrin <dev@niklasmohrin.de>, Milan Landaverde <milan@mdaverde.com>, 
	Morgan Bartlett <mjmouse9999@gmail.com>, Maciej Falkowski <m.falkowski@samsung.com>, 
	=?UTF-8?B?TsOhbmRvciBJc3R2w6FuIEtyw6Fjc2Vy?= <bonifaido@gmail.com>, 
	David Gow <davidgow@google.com>, John Baublitz <john.m.baublitz@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 27, 2022 at 10:22 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 27, 2022 at 03:14:43PM +0200, Miguel Ojeda wrote:
> > +unsafe impl GlobalAlloc for KernelAllocator {
> > +    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
> > +        // `krealloc()` is used instead of `kmalloc()` because the latter is
> > +        // an inline function and cannot be bound to as a result.
> > +        unsafe { bindings::krealloc(ptr::null(), layout.size(), bindings::GFP_KERNEL) as *mut u8 }
>
> This feels "odd" to me.  Why not just use __kmalloc() instead of
> krealloc()?  I think that will get you the same kasan tracking, and
> should be a tiny bit faster (1-2 less function calls).
>

This may literally be the oldest code in the project :-). To the best
of my recollection, it's krealloc simply because that seemed like a
public API that worked. I don't think it even occurred to use to look
at __kmalloc.

> I guess it probably doesn't matter right now, just curious, and not a
> big deal at all.
>
> Other minor comments:
>
>
> > +/// Contains the C-compatible error codes.
> > +pub mod code {
> > +    /// Out of memory.
> > +    pub const ENOMEM: super::Error = super::Error(-(crate::bindings::ENOMEM as i32));
> > +}
>
> You'll be adding other error values here over time, right?
>

Yes -- this is the most minimal set that's needed for the initial
patch set. The full branch has every error constant bound.

>
> > +/// A [`Result`] with an [`Error`] error type.
> > +///
> > +/// To be used as the return type for functions that may fail.
> > +///
> > +/// # Error codes in C and Rust
> > +///
> > +/// In C, it is common that functions indicate success or failure through
> > +/// their return value; modifying or returning extra data through non-`const`
> > +/// pointer parameters. In particular, in the kernel, functions that may fail
> > +/// typically return an `int` that represents a generic error code. We model
> > +/// those as [`Error`].
> > +///
> > +/// In Rust, it is idiomatic to model functions that may fail as returning
> > +/// a [`Result`]. Since in the kernel many functions return an error code,
> > +/// [`Result`] is a type alias for a [`core::result::Result`] that uses
> > +/// [`Error`] as its error type.
> > +///
> > +/// Note that even if a function does not return anything when it succeeds,
> > +/// it should still be modeled as returning a `Result` rather than
> > +/// just an [`Error`].
> > +pub type Result<T = ()> = core::result::Result<T, Error>;
>
> What about functions that do have return functions of:
>         >= 0 number of bytes read/written/consumed/whatever
>         < 0  error code
>
> Would that use Result or Error as a type?  Or is it best just to not try
> to model that mess in Rust calls? :)
>

We'd model that as a `Result<usize>`. Negative values would become
`Err(EWHATEVER)` and non-negative values would be `Ok(n)`. Then at the
boundaries of Rust/C code we'd convert as appropriate.

> > +macro_rules! pr_info (
> > +    ($($arg:tt)*) => (
> > +        $crate::print_macro!($crate::print::format_strings::INFO, $($arg)*)
> > +    )
> > +);
>
> In the long run, using "raw" print macros like this is usually not the
> thing to do.  Drivers always have a device to reference the message to,
> and other things like filesystems and subsystems have a prefix to use as
> well.
>
> Hopefully not many will use these as-is and we can wrap them properly
> later on.
>
> Then there's the whole dynamic debug stuff, but that's a different
> topic.
>
> Anyway, all looks sane to me, sorry for the noise:
>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cheers,
Alex

-- 
All that is necessary for evil to succeed is for good people to do nothing.
