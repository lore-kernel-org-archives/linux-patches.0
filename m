Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33947477
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 23:56:04 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso3250045pjk.0
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 16:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=4OrW2+v/meyruGyW+F7E0QxnRsOWY9DMbrVML0RCO4M=;
        b=SW70luAxBAxmWF0xbo0vvoN6D+BfN/5VNbgtgMfh2yWVHK27yb+gRXhrCitMsILst6
         gd/i/FD7DU/GC9P22lC3CrE9jHgYvTSOlzKpjrsH/HNz8kK2s0HOT1TWY2m3B/AFQ5mQ
         ZkPwYxipcmkEq6CmCLwOLx4fAHP1DCRj2y/aQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4OrW2+v/meyruGyW+F7E0QxnRsOWY9DMbrVML0RCO4M=;
        b=K5PJ/RwzWoALoPBmWJ9Vf0CirvOynikRv8tFG8jBbnryeNQxGRkrIA0T7k+Cck8zWE
         qjcqDzQNujNOmXhmWmQGq008AY5aVs1bbOdma1jvdNgQSYHBJu8oGiKalkcpOVtArIf/
         ZuGnhST1E7x67y6pEB1o8+eJaip1YwiguIdTje0+YjxNovqJ4taRz4L1eYb6KyppPRc6
         huAiv0L1tDmVNUcmh8nMayZYG5vs1RB7sPiozC2nIGS0olxTA/Ga3GAEVMKk3ky1kUHB
         YltT3zFUZlCRg1k1w1iozjvBm4N/VwEx8oZ6ZsB1O3YMdHfjefKD9wyiyumVfRMB+idM
         qRBA==
X-Gm-Message-State: ACgBeo2ZtzYn3gQod+SyU7+1er0FqCwMS0qyVmtIzpW/fX9CrVSx1+m6
	44aNvytfHG+yJwSyGAguuZYuJw==
X-Google-Smtp-Source: AA6agR5mOI6zoxv/758RIIcFtuybDEtU4eRZmif+vY/WesxknhjDFh5Um9NhlfbeGGrs65ev9k85OA==
X-Received: by 2002:a17:90a:1b6e:b0:1f5:1902:af92 with SMTP id q101-20020a17090a1b6e00b001f51902af92mr6148774pjq.238.1660780564166;
        Wed, 17 Aug 2022 16:56:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n1-20020a1709026a8100b0016d33b8a231sm459784plk.270.2022.08.17.16.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 16:56:03 -0700 (PDT)
Date: Wed, 17 Aug 2022 16:56:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Geoffrey Thomas <geofft@ldpreload.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Sven Van Asbroeck <thesven73@gmail.com>,
	Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
	Maciej Falkowski <m.falkowski@samsung.com>,
	Wei Liu <wei.liu@kernel.org>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v9 06/27] rust: add C helpers
Message-ID: <202208171653.6BAB91F35@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-7-ojeda@kernel.org>
 <202208171240.8B10053B9D@keescook>
 <CANiq72nR2eAeKrY6v=hnjUjvwfecMsSC6eXTwaei6ecnHjia8g@mail.gmail.com>
 <202208171331.FAACB5AD8@keescook>
 <CANiq72=6nzbMR1e=7HUAotPk-L00h0YO3-oYrtKy2BLcHVDTEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72=6nzbMR1e=7HUAotPk-L00h0YO3-oYrtKy2BLcHVDTEw@mail.gmail.com>

On Wed, Aug 17, 2022 at 11:44:53PM +0200, Miguel Ojeda wrote:
> On Wed, Aug 17, 2022 at 10:34 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > Gotcha -- it's for the implicit situations (e.g. -C overflow-checks=on),
> 
> Yeah, exactly.
> 
> > nothing is expected to explicitly call the Rust panic handler?
> 
> If by explicitly you mean calling `panic!()`, then in the `kernel`
> crate in the v9 patches there is none.

Perfect. It may be worth stating this explicitly with the helper. i.e.
"This is for handling any panic!() calls in core Rust, but should not
ever be used in the 'kernel' create; failures should be handled."

> Though we may want to call it in the future (we have 4 instances in
> the full code not submitted here, e.g. for mismatching an independent
> lock guard with its owner). They can be avoided depending on how we
> want the design to be and, I guess, what the "Rust panic" policy will
> finally be (i.e. `BUG()` or something softer).
> 
> Outside the `kernel` crate, there are also instances in proc macros
> and Rust hostprogs/scripts (compilation-time in the host), in the
> `alloc` crate (compiled-out) and in the `compiler_builtins` crate (for
> e.g. `u128` support that eventually we would like to not see
> compiled-in).

Sounds good!

-Kees

-- 
Kees Cook
