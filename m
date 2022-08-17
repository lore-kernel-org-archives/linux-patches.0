Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E75D7460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:26:14 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id bf22so12828pjb.4
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=voGEdX63KoW+ZibFVnZJzdsesBOjZP2It8KT+faXmbQ=;
        b=Cl+T9KLC4EJmcz1MyKRqJ76dq4omiP8QcIYqcj9jXcpGW1Oj9XAbG0YqZGHvjN3feL
         DEZk0TIvBJiJlgBQY/wa5KrN3ksWyFi6If4yOSjmSNPXnL+a2luAQmTKADLXOJC7Ssb2
         owbs/RFNuCJUTsb6vTH7Fhkx4YGcwAZOVIpsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=voGEdX63KoW+ZibFVnZJzdsesBOjZP2It8KT+faXmbQ=;
        b=X2XV6AJQghtlv5o08H6J7kiVl9RlTV3M5S72tsJhAZK+WmADjWTjTGGsm4oILyPWij
         lKlRRffGNw3GDvrajNO6HBvTcJGMMLKr1CrUDemQJdPDprD54OJJVdG+GFvT8ERrhCKq
         L19eifZLndUO1ydM/by31E8XbWtlp4RDR80FV4UQGb+l4aYHth/H4RjkTfHHpEDAKA3m
         jO10iHAUekqnHvUDfjATk2eJXIylwmDb05gv3tEQ3z/rq8veEKDiwmDW4w2M8Oem4yOV
         +umm3G5LyA4sCZJ+BhwrrDBDXrQ4jE1hJIoTiUrWFZ1si/Cm/bsVgnKukZC5cCj85R8C
         UCJQ==
X-Gm-Message-State: ACgBeo2aNjzG616gKI6oCA4hfoSAEHmCWH4Yl0/KlJYYcvTdZwpb7QKX
	B4k26lKPTKvY6d3zj2/BWne6uQ==
X-Google-Smtp-Source: AA6agR7DmWypmAe26bnZT4xLDkF12MzBgKNyqwHl8eKku2vWvA2CYPpAgoCIiRzzcwD8rH6xOts1Vg==
X-Received: by 2002:a17:90b:4c4b:b0:1f7:11f:8e8e with SMTP id np11-20020a17090b4c4b00b001f7011f8e8emr5362650pjb.98.1660767973734;
        Wed, 17 Aug 2022 13:26:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h8-20020a17090a2ec800b001f2fa09786asm1956585pjs.19.2022.08.17.13.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:26:13 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:26:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>,
	Adam Bratschi-Kaye <ark.email@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sven Van Asbroeck <thesven73@gmail.com>,
	Gary Guo <gary@garyguo.net>, Boris-Chengbiao Zhou <bobo1239@web.de>,
	Boqun Feng <boqun.feng@gmail.com>, Douglas Su <d0u9.su@outlook.com>,
	Dariusz Sosnowski <dsosnowski@dsosnowski.pl>,
	Antonio Terceiro <antonio.terceiro@linaro.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Nick Desaulniers <ndesaulniers@google.com>,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v9 23/27] Kbuild: add Rust support
Message-ID: <202208171324.FB04837@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-24-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220805154231.31257-24-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:08PM +0200, Miguel Ojeda wrote:
> Having most of the new files in place, we now enable Rust support
> in the build system, including `Kconfig` entries related to Rust,
> the Rust configuration printer and a few other bits.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Finn Behrens <me@kloenk.de>
> Signed-off-by: Finn Behrens <me@kloenk.de>
> Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Co-developed-by: Sven Van Asbroeck <thesven73@gmail.com>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Boris-Chengbiao Zhou <bobo1239@web.de>
> Signed-off-by: Boris-Chengbiao Zhou <bobo1239@web.de>
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Douglas Su <d0u9.su@outlook.com>
> Signed-off-by: Douglas Su <d0u9.su@outlook.com>
> Co-developed-by: Dariusz Sosnowski <dsosnowski@dsosnowski.pl>
> Signed-off-by: Dariusz Sosnowski <dsosnowski@dsosnowski.pl>
> Co-developed-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Signed-off-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Co-developed-by: Daniel Xu <dxu@dxuuu.xyz>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> Co-developed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
> Signed-off-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
> Co-developed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

It'd be nice to split this up into maybe per-target patches, but given
how long this has been getting developed, I'd prefer to avoid blocking
on that, and just get this series landed so we can move to incremental
fixes/additions.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
