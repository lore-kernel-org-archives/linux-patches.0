Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBA04A32
	for <patches@lists.linux.dev>; Mon, 22 Aug 2022 20:09:15 +0000 (UTC)
Received: by mail-lj1-f171.google.com with SMTP id q18so10649982ljg.12
        for <patches@lists.linux.dev>; Mon, 22 Aug 2022 13:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=rNzR9QGqS5j6oh3cxSooKBs5Da2aEIBjVibuQ7PJyY4=;
        b=G/6rnW2WngFu3z8GJAnZAfCOkh68V/JUVcL67bXj8QU16wKXhMja1mBmCXbTmoik81
         fdRO9yziSI1qyn3ZnU+Tk/b2sF7XsdQ1NnwKRVBovYFK8jKlmTE25Tnqpl1OShRVgFuO
         55GLEFueyqTzyirsTbo9dhWM7XcEyTrXvQVeN7iSuin+N1GEYFmw/DH+NkSO6W3GV6HO
         R/542Kyg5z5z+fF28YqBPucnTKR8rFd39QVkbJ7+94RLIRv3/IdPNOPUYxR2rtFLJJo/
         akYDrVLMQ3gXaiXiwyvOoGY3I0ZKHhZmxqg1es9/wRFbkicvNSHP3X7Q6cUSaREYuQyd
         HxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=rNzR9QGqS5j6oh3cxSooKBs5Da2aEIBjVibuQ7PJyY4=;
        b=flqRY86kj1J864dSJ9qr0YASfoqRvW5OBfafcLr0Yba2WtfZ/ecJjoeP//iEqTdGFx
         k6uE5l8IHuWLRoZSX2JGi2jPK1Xz2FRUvs/wb3+53tQe6JorphpwUhZqFUh0sogKNj79
         H9pAmbHHOCdqr8yXwsyJgapw7TCUoTtIDXcxD7C0W05nmcl+Iv7ndlbF2jYujbIebd2O
         cKzz+O0qzMduukQoEXYYp/5F0ExS3geiPmmQtowXTR6GbHXDwX7C+VwflZgfzJcHbL21
         0AIy8OgMgTCu+wzafDOnU0KWjTwdiT7S1Q9Q4kqricQ0JZuF2fOGtsh01JVCQqligjlR
         qZ4Q==
X-Gm-Message-State: ACgBeo1Az1zeyQ4rIstKosc9+H6CiJmnYgxVBCSEDhxXEfcpPHL9STOp
	5AreCwmfVU5hpBgIJ3xgOdWtWBUOJadSEUo4jbNZbQ==
X-Google-Smtp-Source: AA6agR59okDv54Jbyi23A1nS9MzE8+afV+r+Jcam4JHKwd+90O+ezON9z+HSSTGcj+W/yIAHzcTIOm3wlGcNWGs75oc=
X-Received: by 2002:a05:651c:4d4:b0:261:cbe7:e62f with SMTP id
 e20-20020a05651c04d400b00261cbe7e62fmr2347049lji.295.1661198952956; Mon, 22
 Aug 2022 13:09:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-21-ojeda@kernel.org>
In-Reply-To: <20220805154231.31257-21-ojeda@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 22 Aug 2022 13:09:00 -0700
Message-ID: <CAKwvOdndYxQ+KgVhC8F3vWnHDT8pD3px8cKjinu-khn25_FSYw@mail.gmail.com>
Subject: Re: [PATCH v9 20/27] scripts: add `rust_is_available.sh`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Finn Behrens <me@kloenk.de>, 
	Miguel Cano <macanroj@gmail.com>, Tiago Lam <tiagolam@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 5, 2022 at 8:46 AM Miguel Ojeda <ojeda@kernel.org> wrote:
>
> This script tests whether the Rust toolchain requirements are in place
> to enable Rust support.

With this, I get:

$ make LLVM=1 rustavailable
***
*** libclang (used by the Rust bindings generator 'bindgen')
*** version does not match Clang's. This may be a problem.
***   libclang version: 15.0.0
***   Clang version:    16.0.0
***
Rust is available!

because I'm using clang built from source from ToT.  Is this supposed
to mean that I can't use clang-16, clang-14, clang-13, clang-12, or
clang-11 (in the kernel we support clang-11+) in order to use rust?
I'm guessing that's going to hinder adoption.  Is there a way to
specify which libclang version bindgen should be using?

I have libclang built in my clang sources,
llvm-project/llvm/build/lib/libclang.so.  I also tried:

$ CLANG_PATH=/android0/llvm-project/llvm/build/lib/libclang.so.15 make
LLVM=1 -j72 rustavailable
$ CLANG_PATH=/android0/llvm-project/llvm/build/lib/libclang.so make
LLVM=1 -j72 rustavailable

-- 
Thanks,
~Nick Desaulniers
