Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3B72D23A6
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 18:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764700388; cv=none; b=Zgrh9LFcx/LubmP3WUh9Jmbe6HHW3/3/CNi7TC/ftdR8bSpET+EnyMtV/s7K+LzkAFwDmny3XeOjwr/WP2BwBve1cYeRwiWqZjOyqvmlKsTv86CkhwZI/xyVJK9oCy5tAuFbBHB1cBbor1qlJNoqm2UMBWr8G5By0xlirvNuf5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764700388; c=relaxed/simple;
	bh=12EEgsoRMtf9F51vxy2vNepd5KjbBuzaWngoebihpEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fhtg5VAujDV4HlfRn4+9f7FnEKYZodz+vVbF4Fs9Jq8IfEddnn8/VLalVym0a2Wr6BJ8a8+SPAdXYAxquCb8h2hzmr3JHtkvgF6PQbQxA9yON0gnZpdbqThagnTpFEvGc8jBVtDN2VH2p9oW/roJjYgxtDL2dlKcHLV5KbaRPqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYKFlv/m; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYKFlv/m"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-641e942242cso5460098d50.1
        for <patches@lists.linux.dev>; Tue, 02 Dec 2025 10:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764700385; x=1765305185; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fx+vgxKEjmAmRBcQWngjnzb3HH/aeEsWQh1ReHY2Pk8=;
        b=RYKFlv/m4hSdOCcvMDlMNwN+lcXBTEzWcM3kpN8TN4yeosRUa++tOxrBwtDysZail9
         fDAVJDknctiWEQO67gIt/xBI7z9BYILckCTlca2rtyWfRgDUT0Hopwj8T2nxl43j6LR5
         ywm5VhIuukafUXJLWOfpyIKfQuSsQOrLFj9eMvvdNoJ10+BrxeVAiKfCMGYFz2MPReXF
         6wXTKwX2XIK7OsYYB+EnP7dWafftQFTzwUGx6ek17NGhmDza6bHPWOq2CD462gQCZUY/
         FKt20NJPd1ZulSqKATlpvqqBRYzLfUZflwVvNAO0F+QKeseufcId0TBPVCZgdgXdjwlM
         PL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764700385; x=1765305185;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fx+vgxKEjmAmRBcQWngjnzb3HH/aeEsWQh1ReHY2Pk8=;
        b=RPh1vu4f41VmYQY8HiHuIEm420ZqGkgJtE/Lmt6j2tuQD871fFYPwoBsfGnXwLGDte
         pdv7+KgfLSqx4F8/S3lwbuaeiTC0cTz1XtHFv9GIr6gxe/Rec9Y/6viQ4ruMlc2FwzXR
         /qSTzLUSCf2poFPsqomJMfqySeISXtkI8+MokN9sml78antAeUoqIf00Oiybimrve9oh
         XEpn4lx/Lt1p461cgCb7++W5G/sZPJU0x39HUOPWComTqvMXSaeQiDsyjqAKwKZcjnzL
         D3apdUOYyRT/WXDq2UsEqUkV1Z1PERNnbjRs9hMi0YarfGJ1KaeGXgKgc/0vvWcIzk7f
         3WqA==
X-Forwarded-Encrypted: i=1; AJvYcCWfVNadFkHdq4c2uEeTjvJE6V9MEuaJdiJu+qfxhWjP0+pm/kwzjmO+kJl6sdGgnXzI7YTSrwMG@lists.linux.dev
X-Gm-Message-State: AOJu0YzHb/G9S/KrN0DaxMSDqzTYBOBRn7V+eVmQaMM5na8ZmQTBCq3D
	1PRNp64RFfOh38rMQtrj0BLyrRaKd7czR3Qa9COkMCbPsPr7jBhCx7a0
X-Gm-Gg: ASbGncvscflgaussIqD4kuSLcXWDc8nFXWODTvcVeCpmL8IgGIyD/nqkG65zG/zr2Ge
	n/eyPtlHpEqquGEZdT4XNE0eMzKE0j9n9D77mfTbwN9K2FnCZ9L1Zldvb8SxnfCVHYxSeIWkMvD
	vqkfnkg7KCcpIT/Z/Z4f9clWAhPtnHzcMantMVYsB3fpOdhkYytza7yZ02/2dJrG8v7i2KRhoul
	3xmWYOKX1WdRTschafu8atrEy8EXkCss02kUjv+z4BHyScxq5hNQhCBmsxyjZKfv+OPePY+B3m+
	Ttk+qQ+CnO95UoeiDONWco69gFMYs0TxpovnWCfROo+/cslhXGZM2sNnmOz1FNEZMl6UzRGQ7bW
	aImu5fJrIuU4pIKCmK/Yc7tUfBjCepwNfSraELYwJxw45Ubc3bLwAoTCTs51Mm5dKhjA3wocgLH
	2JrmZM2fufi/j0YJTE
X-Google-Smtp-Source: AGHT+IGOp5HU/6nmu601KlnOIw05JZHAueFK3GC0mnlmpUg0as6msbGwNFG0svNv0+Ued/h6vQr5CA==
X-Received: by 2002:a05:690e:12cb:b0:640:d009:e998 with SMTP id 956f58d0204a3-64435281c1emr281829d50.12.1764700385322;
        Tue, 02 Dec 2025 10:33:05 -0800 (PST)
Received: from localhost ([2601:346:0:79bd:2e1:7f9a:ed50:e29e])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c497707sm6415723d50.24.2025.12.02.10.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 10:33:05 -0800 (PST)
Date: Tue, 2 Dec 2025 13:33:04 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>, Burak Emir <bqe@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: id_pool: fix example
Message-ID: <aS8w4FHhIVQUFTEY@yury>
References: <20251201000949.1626363-1-ojeda@kernel.org>
 <aS3seTNRum3ZXMom@yury>
 <CANiq72=1ipov2pV9pSQwGh9WMA4NvQRV_cBCO0hhChVg=c-Njw@mail.gmail.com>
 <aS7aHIJbi3DlaUcc@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aS7aHIJbi3DlaUcc@google.com>

On Tue, Dec 02, 2025 at 12:22:52PM +0000, Alice Ryhl wrote:
> On Tue, Dec 02, 2025 at 12:13:33AM +0100, Miguel Ojeda wrote:
> > On Mon, Dec 1, 2025 at 8:29 PM Yury Norov <yury.norov@gmail.com> wrote:
> > >
> > > Thanks Miguel,
> > >
> > > I applied this, but the fact that you've sent a second fix to
> > > documentation that actually is a build fix, raises the questions.
> > >
> > > Because Rust documentation bears compilable chunks of code, I think
> > > we need to enable rustdoc tests target by default, so that developers
> > > will not send broken tests.
> > 
> > You're welcome!
> > 
> > This one is a Kconfig in the normal build, i.e.
> > `CONFIG_RUST_KERNEL_DOCTESTS` (it is true that the other patch was for
> > a different target).
> > 
> > If you mean enabling that by Kconfig default, then I don't think we
> > can do that -- KUnit on its own (which this uses) is not meant for
> > normal builds. Perhaps we could have something that just checks the
> > build, but people should really run the doctests anyway, since they
> > typically contain `assert!`s and so on that can be wrong.
> > 
> > If you mean enabling it in Intel's kernel test robot, then I think
> > they do it (or at least I told them about it long ago). But maybe
> > something is missing.
> > 
> > In our P entry in `MAINTAINERS` ("Subsystem Profile document") we ask
> > people to run them among other things, so I would perhaps suggest
> > having something like that too (or linking to ours if you prefer):
> > 
> >     https://rust-for-linux.com/contributing#submit-checklist-addendum
> > 
> > Of course new contributors will miss that initially, but actually
> > people find the doctests quite useful, so generally people get to run
> > them. At the end of the day, maintainers should test these too before
> > applying and otherwise someone will notice sooner or later.

No. Maintainers are not handy testers at your convenience.
 
> Yeah sorry I forgot to check the docs this time. I usually do run them,
> but there are so many targets to check that sometimes I forget some of
> them.

Don't be sorry, it's not your fault. The problem is that bearing
tests smeared among comments is a terrible idea, and now you reap
the benefits of someone else's bad design.

(Did I warn about it? Yes I did.)

The other problem is that Miguel replied in great details about how
well rust process is designed, and even attached an external link,
but didn't answer my question: how to enable rustdoc by default?

I followed this link by the way. It doesn't mention that rustdoc step
is mandatory. It doesn't provide steps for careful testing. It only
says:

        When submitting changes to Rust code documentation, please
        render them using the rustdoc target and ensure the result
        looks as expected. The Rust code documentation gets rendered
        at https://rust.docs.kernel.org.

Does it sound like:

        Rustdoc is a MANDATORY step! You MUST run rustdoc every single
        time, otherwise the build will get BROKEN. Even if you don't
        touch comments!

No, it does not. So, I wasted an hour just to find nothing. But there
are some good news: during that hour, I received an LKP email about
your error:

https://lore.kernel.org/oe-kbuild-all/202512020552.NejH5iaK-lkp@intel.com/

It's good that I started receiving such a traffic at all. But it's
especially good because I was on my way to submit a PR to Linus, and
that hour saved me a broken request. Andrew Morton on the previous
cycle wasn't that lucky, didn't he?

So, what's next. 

1. I will merge-fold Miguel's fixes into your patches and send my
   PR by the end of this week, not early the week as I usually do.
   Hopefully, no objections.

2. I will stop taking any rust patches unless the author explicitly
   mentions that he ran rustdoc on them.

3. I encourage rust community to spend this cycle on reviewing the
   development and submitting process. You guys decided to sprinkle
   compilable code across the comments, and you advocate it. Now
   please find a way for everyone to compile your comments (huh)
   during a routine development. And please make that knowledge
   very sound.

Thanks,
Yury
