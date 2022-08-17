Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5057E7463
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 21:45:05 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id z13so7547408ilq.9
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 14:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hqPY2bWNSe1h3tWbXlYngNPrG0p/kfGLsCdfVK78MFI=;
        b=cGqW6rVasObtQsUV/c8llXl8xfXdgIHgRbk7MNRkRT8n9qvUBbsfy4TX9iSWzcLy1S
         m405YSVexBQ1hZJokK9RFBTjm4PdSpGeeqgElviaVDL61mgH8XfgnQnhfS0y5YX887ER
         xwLJ/2prnfwUOO7qCIXpmGM9DHhwYNr9b83/hfNiejVZuWrL/KZv0+Lm3tFBalqThEIx
         x0+klab/reQmAgFujuTX7RE0wLeZl8aHRPNgHfBIQTshWakYBLl4o7CetX/dgWw69MlG
         pIKRsqSIxOIx+/5/jTA/dN/TJBYU1FWYVCCOkWAJXjaV58c1RVGewpXTymCTK7rf3mBp
         PjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hqPY2bWNSe1h3tWbXlYngNPrG0p/kfGLsCdfVK78MFI=;
        b=fkh6HOC/UUHRc3ak2D5lyNTP9gRMnFRtdgIjlqSjpEt/eLDlDlgrgAhd4d13U+1lNM
         /F89TjIdGVg/e/I3VfSdxlkshHocry1jPAm0Cilci9/vC/FHy1IFVqrDsM3pPeCrkNUc
         9FiPJNXW4+9V8WSmngnogyvhWUJBadSm3nwhxcqhPj3IXlrXD7qNymknR/x89azppfXf
         y9zvWGozef2iJ2YnEEJeoDpP81SrvRJktp3lRw9WyNKlDBOrtmJ95S0bBqjudJjE4IkE
         wUBTyGl1bDHoKXrrz7siesLuaCUWbgS2fNKfD0AecCzXF+qCiN9LzgosHucjK8Hl8AUY
         QjrA==
X-Gm-Message-State: ACgBeo2pUTppv/TaRCTgdKvdrJJWLdd/aJgqvr1U7f0NOBrS79w/+SKq
	mnlDt535ODeoimRGsiHUDYZjCTH27J8S6mUzogA=
X-Google-Smtp-Source: AA6agR4XEXjy1xaMB0ItJfvW2/aWI6G4ET12/EM3Wr/bjN5BL+UqmTKR50jgK9cAknp8bCs96oNZz1olMLXEHdRWNlU=
X-Received: by 2002:a05:6e02:1c26:b0:2e0:d8eb:22d6 with SMTP id
 m6-20020a056e021c2600b002e0d8eb22d6mr56869ilh.151.1660772704425; Wed, 17 Aug
 2022 14:45:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-7-ojeda@kernel.org>
 <202208171240.8B10053B9D@keescook> <CANiq72nR2eAeKrY6v=hnjUjvwfecMsSC6eXTwaei6ecnHjia8g@mail.gmail.com>
 <202208171331.FAACB5AD8@keescook>
In-Reply-To: <202208171331.FAACB5AD8@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Aug 2022 23:44:53 +0200
Message-ID: <CANiq72=6nzbMR1e=7HUAotPk-L00h0YO3-oYrtKy2BLcHVDTEw@mail.gmail.com>
Subject: Re: [PATCH v9 06/27] rust: add C helpers
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Geoffrey Thomas <geofft@ldpreload.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boqun Feng <boqun.feng@gmail.com>, Maciej Falkowski <m.falkowski@samsung.com>, 
	Wei Liu <wei.liu@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 17, 2022 at 10:34 PM Kees Cook <keescook@chromium.org> wrote:
>
> Gotcha -- it's for the implicit situations (e.g. -C overflow-checks=on),

Yeah, exactly.

> nothing is expected to explicitly call the Rust panic handler?

If by explicitly you mean calling `panic!()`, then in the `kernel`
crate in the v9 patches there is none.

Though we may want to call it in the future (we have 4 instances in
the full code not submitted here, e.g. for mismatching an independent
lock guard with its owner). They can be avoided depending on how we
want the design to be and, I guess, what the "Rust panic" policy will
finally be (i.e. `BUG()` or something softer).

Outside the `kernel` crate, there are also instances in proc macros
and Rust hostprogs/scripts (compilation-time in the host), in the
`alloc` crate (compiled-out) and in the `compiler_builtins` crate (for
e.g. `u128` support that eventually we would like to not see
compiled-in).

Cheers,
Miguel
