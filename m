Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72770176AB9
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 07:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721979683; cv=none; b=Jhf5a1Xoig8x36cenL3UOcoA0yWBDZE0nu1E/YtyIKRQZKuQhYdvJcoPIoEQ+j8PqpDaYh4dXGLR/2I6B7CHxywbXn88hqZ8AfBn0evTmQP9CwjV59n61MJraydNSw00vQke60v/ogPdpdf14k9v53xFfEtYh3LILbKbNdyBPUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721979683; c=relaxed/simple;
	bh=MqAset8Nc45mgIXZhKbsEINkaYQKExHjMptHz97Z1lM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzBN0IpEpIh+ojsvp4WkgV15Dd0di+K584p+MDt45HC79cXNRjKV6QhvbVrCqyD7XYSTIv7Y45uEd+0h/O/WzsqgmjF510yAyEEgnK4k1Pt7J3GsW09Uj6gvlDFeNHyzoIwqtywSiScPmAn59bWVvJ9EXevm2y0U1gwT0yjXNYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qMrmK2jq; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qMrmK2jq"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3683f56b9bdso987116f8f.1
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 00:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721979680; x=1722584480; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGuZ9gW9s8hbzxTk97NuO72bufoRV/MO+7ZPtq4qR3Y=;
        b=qMrmK2jqg7MnsUN/+kMzE71PIDP+BX7wqJlj1YffMWNK7lO2QdQuSB5PYc3fwABV/p
         Vg1nJl0LHaiBFQdQyR4vvpOLKzQF+tcPC0nXXHYF2mHKljUubSYEzD/sXQ/7cbneuenj
         5YI5zbfXBkzZRDRyP44fsY/Vc7C011R0wURsOMwnTWu5bo+0O23k9U8Q0oUMGnepclMy
         4QoO4BPmKHDxaJkrtgjMQnmKQ2ICwL2kmW14vnyS1TKiyXgrmRHcsbfCeCjjG7WAQKy1
         WhzgH/POFroBIWoLoDABv29M+3H563xWXw4ixtQI3J8YbFI1RgNRAk1YTU1u5xMgkaV+
         EhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721979680; x=1722584480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGuZ9gW9s8hbzxTk97NuO72bufoRV/MO+7ZPtq4qR3Y=;
        b=tM5LfdL/G7YeVAAc3d0IxigCP6hGOxIH29WLwdhGjwF4fQxo0lTOdf7UrwZ/Yf+sJk
         lFCvv5AmbAFVV/WWyozyYruSjglKP6jn1rAEaeTT+ScHvM+tntoxyzj4KMZcEVRNhpLv
         CS0hZt01ifzEeeJkWljBJW4F0KNASaJyYckozC4ZgAPExfVjqLxlCu12nKq/+JUnAwfk
         EctF0X8PehWdUcpm3ed0jCHkqPHOB/o2iwxsfHbkilZl50aq0nIsbQwJC1BV/kUV8yJB
         KlM6TkFq20pB6mCtbuDJkjZApa00bK9SAQH+9aCE0S+zYx0PeBBM7I/pcopy5fhHGZ8X
         +5pg==
X-Forwarded-Encrypted: i=1; AJvYcCUS/WlJCZWhKVA7Agctf1zOab1VK9Yb0tJB8Pwnu3m6bCQjXgM6u2eT1dTGFKcPYKf93y50wcIW/Lhydcycvsl7JkH0NSgp0g==
X-Gm-Message-State: AOJu0YzG8RKaaxN+N4Tc1bIdrGqWrAydjGZP52fxqUhaDSSOkCEhSGUT
	x3JOG8vx1l1gl219I4uA5anGX3kszcb4bEOBygF4lv8HSi7ix5S4zgKC4998VRaeiRptiqrkAGa
	z39CeerzwFVhbHCi3WOLEDpD3vEMLnxgYQPa5
X-Google-Smtp-Source: AGHT+IGVZMl8k8xJUMNdGuAqO6mUXeTU9uHBwsDRosmfkRv3V8tmsmQD2SxE1zeG5jOc3UIamFGu5cu1XFJeRldXWMY=
X-Received: by 2002:adf:f642:0:b0:368:4e38:790c with SMTP id
 ffacd0b85a97d-36b319deb2dmr3199790f8f.14.1721979679422; Fri, 26 Jul 2024
 00:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725183325.122827-1-ojeda@kernel.org> <20240725183325.122827-6-ojeda@kernel.org>
In-Reply-To: <20240725183325.122827-6-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 26 Jul 2024 09:41:05 +0200
Message-ID: <CAH5fLgi9xN2igQK4Y8ZCU+iPVMH2RaWGQ7OO2OV-XROJba_2fw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] objtool/rust: list `noreturn` Rust functions
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 8:35=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust functions may be `noreturn` (i.e. diverging) by returning the
> "never" type, `!`, e.g.
>
>     fn f() -> ! {
>         loop {}
>     }
>
> Thus list the known `noreturn` functions to avoid such warnings.
>
> Without this, `objtool` would complain if enabled for Rust, e.g.:
>
>     rust/core.o: warning: objtool:
>     _R...9panic_fmt() falls through to next function _R...18panic_nounwin=
d_fmt()
>
>     rust/alloc.o: warning: objtool:
>     .text: unexpected end of section
>
> In order to do so, we cannot match symbols' names exactly, for two
> reasons:
>
>   - Rust mangling scheme [1] contains disambiguators [2] which we
>     cannot predict (e.g. they may vary depending on the compiler version)=
.
>
>     One possibility to solve this would be to parse v0 and ignore/zero
>     those before comparison.
>
>   - Some of the diverging functions come from `core`, i.e. the Rust
>     standard library, which may change with each compiler version
>     since they are implementation details (e.g. `panic_internals`).
>
> Thus, to workaround both issues, only part of the symbols are matched,
> instead of using the `NORETURN` macro in `noreturns.h`.
>
> Ideally, just like for the C side, we should have a better solution. For
> instance, the compiler could give us the list via something like:
>
>     $ rustc --emit=3Dnoreturns ...
>
> Link: https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.=
html [1]
> Link: https://doc.rust-lang.org/rustc/symbol-mangling/v0.html#disambiguat=
or [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Tested-by: Alice Ryhl <aliceryhl@google.com>
