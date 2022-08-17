Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A3C7460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:28:12 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso2874126pjl.1
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=hT1mtmbXceJ51lQvB4DLzgKYpjDNa0L4N/kK3oT5iSo=;
        b=Alg7m2vCIvNQH6u/5J92QO95fXKnwPm0c54ozf9T/TnSTEtENcRnf6hhUF8VDUPvX/
         m5u/gYEuiJ2nuHA3Dd7NCs4rUZSiR3my0SvXT66bhA+TtPKi9iFc5a8eTQR+Y0algK19
         9IFXyqQCtfBgfsapNbx90XVFNDVhOjytnRgRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hT1mtmbXceJ51lQvB4DLzgKYpjDNa0L4N/kK3oT5iSo=;
        b=kGpzS9+odFQrR1NccHCn/dRJfULxJkhxtigoAoXqyRgrW/lnrM6L8NN+rWNY57Hyaj
         8YBERc/JYNhpRfGRH6HGx7N0T+UrR6VdvK2h2uZghvA0kXz038sU9Akw5ZEsLyLpSVYp
         bT/EPgwNxljy3b1NahW3qjiynnLkR3UxxymojmsDxOzg5ioRDyxwATPWFjtZkI0OU7bQ
         bUURDEnUn1kinAYb8LmXgeCodQFyqey1j/ikV6RGnmW8rqj6BxKnGQtSW34Hamf5NG6r
         +EKDe4Vt0USrDJ7dDcwBgvOyonxQrrWlX8Sm9YfUcoR5T+Vj8AxrTuFYxzflGiltWJJz
         d9VA==
X-Gm-Message-State: ACgBeo2YH/XpxCVYaXu7Hta7sxEZb2sMnAz5pQlT7M826VnLky+x8GhE
	0/aCbwpHv8AdR5TQFN3n/dhfrg==
X-Google-Smtp-Source: AA6agR5lm+SAcceTecvESsUi3A+nQ2mXl4Fx0wTRiYvIuUCLBGgHZKgPMytipREue+HPDcXtmsKPNw==
X-Received: by 2002:a17:90a:dc15:b0:1fa:c517:7f14 with SMTP id i21-20020a17090adc1500b001fac5177f14mr964231pjv.117.1660768092268;
        Wed, 17 Aug 2022 13:28:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902f34100b001636d95fe59sm326452ple.172.2022.08.17.13.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:28:11 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:28:10 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Milan Landaverde <milan@mdaverde.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v9 26/27] samples: add first Rust examples
Message-ID: <202208171328.E0DC29D0D@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-27-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-27-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:11PM +0200, Miguel Ojeda wrote:
> The beginning of a set of Rust modules that showcase how Rust
> modules look like and how to use the abstracted kernel features.
> 
> It also includes an example of a Rust host program with
> several modules.
> 
> These samples also double as tests in the CI.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
