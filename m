Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFC946B4
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 18:14:56 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so16308531pjm.1
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 11:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=5CuhhpeecEhFdVDSwRfaaOshrTQhumle+WnVfsH8uAc=;
        b=D/tH1vduer9H5obsSHE4yCo6yQWyA5TAhekIWEghiTHEcuEU9ewwEUNQu2GsKZ1P5p
         oqXAVQDlkQsjEGzShYp3ADqa8qKhZnksOk7kjfN3W/NNnCDvOBLLmumlwASkvgn/tQfP
         pBqWt9bGicUOu1jiaI/FzYbQfqxgLVcpwj20s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5CuhhpeecEhFdVDSwRfaaOshrTQhumle+WnVfsH8uAc=;
        b=aQGasO8y6eK/mSiDmor1VpnNvrHXVw4nKQrcuYBwYcNva6i0KUULQS0L87qoDKhzl+
         H35VuDptiWslIapeRH3AOrckI4lmffhArSGhVkIssuElagFKmXOYXLjChmvKL9WHwnB/
         h2Uc8bu655v3k1DwTMM0bgSRbkjreYLHL89iYesm4LLPEvx9ZLuADkq9Vw3xfBtieop8
         kbSUOij+9p9uF5emmrkwYxLIAXwK4L4JhRcKYQY3fMDWbgxw7pZxazCQga00u0G9H60b
         h2jMF4j84ZIlCQeb2CGqfjaIe/bwnI+TZ0FaiGMIcIUkw6w0NtlRn2toW0cD2KOClgFk
         uFFw==
X-Gm-Message-State: ACrzQf3vgUjiLkxC+w6tzP7GVnEUGqLZG7PCtD8WsEMpdLjBQTmLGLAC
	Q2iAbYP5z/iFm/tWPP+P4QuRYg==
X-Google-Smtp-Source: AMsMyM5TmfTMGY9fR9CRAZVMmMunxbQdVXBknN1A9cjgrBKgnMu5b8X3YjRsJVIVx6XfA1AVPxyaIw==
X-Received: by 2002:a17:902:e2d3:b0:179:fe90:55bf with SMTP id l19-20020a170902e2d300b00179fe9055bfmr882904plc.161.1664302495744;
        Tue, 27 Sep 2022 11:14:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090322cf00b001641b2d61d4sm1893164plg.30.2022.09.27.11.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:14:55 -0700 (PDT)
Date: Tue, 27 Sep 2022 11:14:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Geert Stappers <stappers@stappers.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Maciej Falkowski <maciej.falkowski9@gmail.com>
Subject: Re: [PATCH v10 27/27] MAINTAINERS: Rust
Message-ID: <202209271111.689A2873@keescook>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-28-ojeda@kernel.org>
 <20220927141137.iovhhjufqdqcs6qn@gpm.stappers.nl>
 <202209270818.5BA5AA62@keescook>
 <YzMX91Kq6FzOL9g/@kroah.com>
 <CANiq72kyW-8Gzeex4UCMqQPCrYyPQni=8ZrRO1dQsUwDmAPedw@mail.gmail.com>
 <YzMnP73tv1PIGsu0@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzMnP73tv1PIGsu0@kroah.com>

On Tue, Sep 27, 2022 at 06:39:27PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 27, 2022 at 05:53:12PM +0200, Miguel Ojeda wrote:
> > On Tue, Sep 27, 2022 at 5:34 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > How about just fixing up the emails in these patches, which will keep us
> > > from having bouncing ones for those of us who do not use the .mailmap
> > > file.
> > 
> > Sorry about that...
> > 
> > One question: if somebody wants to keep the Signed-off-bys and/or Git
> > authorship information using the old email for the patches (except the
> > `MAINTAINERS` entry), is that OK? (e.g. maybe because they did most of
> > the work in their previous company).
> 
> For known-broken emails, it's a pain as later on invocations of
> scripts/get_maintainer.pl will use those emails.

FWIW, get_maintainer.pl does use .mailmap by default already.

> So please just use known-good addresses to start with.

Sure, that makes sense here too. I just sent the .mailmap patch because
Wedson does have other patches in the kernel too, so it wasn't just for
this case.

-- 
Kees Cook
