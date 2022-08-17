Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CB46D19
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:08:42 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id g18so4473973pju.0
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Brs/W4+fSTjZc3XGeUQqrjHBcxapIUBaWsMZSunKKfc=;
        b=YPNhOtLwlDb4HPD9RTZwy4oTOEH6iqB1SNfZ97TmEKQIH5TTutZ/SSFNGRDCBbP5Of
         Bh6ZHZ/KjIPj4nnturarCUbcM5TZ/vLn3xh/zw+KAx+Z3q8pIrH+Ursc7X87Eb0jJkpL
         98eh82JWIMNnm7/j4obeXbcQ3GNu9oC/WfZaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Brs/W4+fSTjZc3XGeUQqrjHBcxapIUBaWsMZSunKKfc=;
        b=uZffzPBxotuSpOCFj8SB3HZRZ8AubWktyIZGf+AAgIN9KKDnpBTEm4NmIG7Y7H/ceB
         YwnDAgmCrKHxG9AfQEf/805cXfRrSyD5Y8dXF01leFTWm4qqKlHs+LFQXP/DIERFOVwS
         eJG5pZVDLJ/QkytXOLMQim6UACVDuWd47rYY7YChBUdQt9ESSWX+yDFN7pO9zj71finq
         UgrqDFS+CIvUdlCiz7Rlag1lMxCCR+idNL6MFIPUf8KUdohi5QjVTmeyzFvF2tAN7YzP
         TvBpTqS/HI3NJee7WU5MJulJUAs+DGTh1epL9KG+8Dl8LeRzaYuQebL/saFqwbn2RpyQ
         f/xg==
X-Gm-Message-State: ACgBeo3Act/6kkREHoRdf0oWz7OqICGYUgLTyoLIZkUGhlFdiyFGt2RW
	Iw/MUGxsxkQXxhz0HXikKx8+UQ==
X-Google-Smtp-Source: AA6agR5SxPib9LetocQRNIM3FEcdqnApbWc6q3KkvlCH2okTt3qzIUM/nSw2U1GR+l5CPPgg4k9fMQ==
X-Received: by 2002:a17:902:f70a:b0:170:c5e7:874c with SMTP id h10-20020a170902f70a00b00170c5e7874cmr27577177plo.109.1660766921931;
        Wed, 17 Aug 2022 13:08:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b7-20020a17090a12c700b001fa9f86f20csm1943898pjg.49.2022.08.17.13.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:08:41 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:08:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Sven Van Asbroeck <thesven73@gmail.com>,
	Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v9 09/27] rust: add `compiler_builtins` crate
Message-ID: <202208171308.B9F3832496@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-10-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-10-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:41:54PM +0200, Miguel Ojeda wrote:
> Rust provides `compiler_builtins` as a port of LLVM's `compiler-rt`.
> Since we do not need the vast majority of them, we avoid the
> dependency by providing our own crate.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
