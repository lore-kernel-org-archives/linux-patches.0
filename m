Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DE42FDC55
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 10:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165627; cv=none; b=M68gmCYz3U/wI9LvqswRyIoNs4VAoEyvDELki/UPb0rojSalNfX9PKXdX9gY1bsO2IsELPPFnMjcRTbUVEI/BsrH28vGKuo1w3SXEJ8dE92thk4Wcx7rsYDOqqJv5q6aUs0NiF4BB4Meqs1tCT+4VUJXL9xptqVW8Oy1Oip5pUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165627; c=relaxed/simple;
	bh=zeOd2iozLHY5E9/h0Dlh5Vw9vcim7rHAVynPoeVlDd8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=leB8DPM+3Wws3C8mZ36i2zwT74r3fYqSuN2ENdZ9agkoU0/qetc/LDDcFFf7KHJLgpRmNvisMy9/WsR2u7ZsbwEkXS8PvFju5+k0HCH/fvOVaTSOl+mKRwWphPmrwIIGTacIn5ufXHVXqzKeoLy7bkUj1ZVEgaxWQraFVK5cmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OCc8uWeT; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OCc8uWeT"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6409ba57320so1725562a12.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 02:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165622; x=1762770422; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wfDOrMXlo4clgAlmd0PnLLaSk5oU7JsCtleVfGyOwWI=;
        b=OCc8uWeTkWO/Jo778cZeaJOOy28j0ojBGXPsvQ7jtDVxIxjVVxVPVn8v2jjbeN1vb2
         jH4njawir38eSaw/e2DKr0PN6Xfe7WF/gg5hVATaHd+dzvhrigwWcE3qnGPH3rTI+ONu
         HglP1XLVE2O8FMjbqu5NpdgXVZfxkJ6VaBIvY2F+ffM84I1TY+Wqq8IRS4QeHAuTAHFv
         T5tZrSArOZ3jY0+CxwubVEOfz3g9uk+xue9zxWjedW49CzEzzl+ig5ZlKCfGroj1dNAk
         rzWGWX+zn0jKI46Gb0fAKkiozfE+HtNgqnNrGdjr2p34WATxuL6HD0TpzfMm7/WGMAs/
         ajKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165622; x=1762770422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wfDOrMXlo4clgAlmd0PnLLaSk5oU7JsCtleVfGyOwWI=;
        b=aeWllTcMkQSP6CPndqMrF+DJSgp0KYYVDlEHltFBKAjbqn3jWj47MuNsgZoe15K+5C
         iw8jRP8m8DmueITiRPx1+kAcJ77zwpsC6QlnKVyUb9h9gf54yOL3ELmyHtuwrtVaPxmo
         ZxjadZITjp+Q96k54ScIaRXlBLnp3PAz/E/+D8AVv6Mdl/xUQgj/XDAf8SCvKBeAcJg/
         jmsvwCANix8KsOWg5dt1oCx5vfAjTEPM7lMyAZ4bl14Ai/Pnj9va5dMrq8zqJP5F0Q2v
         qW7SfW6DbmysE1uxKbcHzFg6tV8hDOa+/tiPS2Ko6NKNje0deKfFzUs6uGoQ3pgtqyGu
         DsGA==
X-Forwarded-Encrypted: i=1; AJvYcCWcqfyHzohiRdAq9RBGFWxGbDZ+t51hk74ErIsuAisC01KaESzMqpiYzSGQkkyRgKz7WX4VKPr0@lists.linux.dev
X-Gm-Message-State: AOJu0YyohXDTPWMP5Z6NGbRvtHlasrM8SUCIDTtVJ6vPBruc6vk5QfOC
	fh4tWvH9Q42OcRHnKh8kpSBRPrvSNPNJ3EfhyczDLqXsKrFZi73UH6bJYBsydU5ScQf3wFl4oEi
	tnJ3++CSGooepTD7fzg==
X-Google-Smtp-Source: AGHT+IHA/3waiBho0mXu28WwEu1WqeXYiiwR6bIsXlP4vDe3/Ww+rW0qIjmyU+AvmPyU6HG0yyjcIpqx3mZy7js=
X-Received: from ednd3.prod.google.com ([2002:a50:f683:0:b0:640:9915:7946])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:42d2:b0:639:4c9:9c9e with SMTP id 4fb4d7f45d1cf-64076f745edmr9836758a12.10.1762165622423;
 Mon, 03 Nov 2025 02:27:02 -0800 (PST)
Date: Mon, 3 Nov 2025 10:27:01 +0000
In-Reply-To: <20251102212853.1505384-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251102212853.1505384-1-ojeda@kernel.org> <20251102212853.1505384-2-ojeda@kernel.org>
Message-ID: <aQiDdZvRNrBkrB-U@google.com>
Subject: Re: [PATCH 2/2] rust: kbuild: workaround `rustdoc` doctests modifier bug
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sun, Nov 02, 2025 at 10:28:53PM +0100, Miguel Ojeda wrote:
> The `rustdoc` modifiers bug [1] was fixed in Rust 1.90.0 [2], for which
> we added a workaround in commit abbf9a449441 ("rust: workaround `rustdoc`
> target modifiers bug").
> 
> However, `rustdoc`'s doctest generation still has a similar issue [3],
> being fixed at [4], which does not affect us because we apply the
> workaround to both, and now, starting with Rust 1.91.0 (released
> 2025-10-30), `-Zsanitizer` is a target modifier too [5], which means we
> fail with:
> 
>       RUSTDOC TK rust/kernel/lib.rs
>     error: mixing `-Zsanitizer` will cause an ABI mismatch in crate `kernel`
>      --> rust/kernel/lib.rs:3:1
>       |
>     3 | //! The `kernel` crate.
>       | ^
>       |
>       = help: the `-Zsanitizer` flag modifies the ABI so Rust crates compiled with different values of this flag cannot be used together safely
>       = note: unset `-Zsanitizer` in this crate is incompatible with `-Zsanitizer=kernel-address` in dependency `core`
>       = help: set `-Zsanitizer=kernel-address` in this crate or unset `-Zsanitizer` in `core`
>       = help: if you are sure this will not cause problems, you may use `-Cunsafe-allow-abi-mismatch=sanitizer` to silence this error
> 
> A simple way around is to add the sanitizer to the list in the existing
> workaround (especially if we had not started to pass the sanitizer
> flags in the previous commit, since in that case that would not be
> necessary). However, that still applies the workaround in more cases
> than necessary.
> 
> Instead, only modify the doctests flags to ignore the check for
> sanitizers, so that it is more local (and thus the compiler keeps checking
> it for us in the normal `rustdoc` calls). Since the previous commit
> already treated the `rustdoc` calls as kernel objects, this should allow
> us in the future to easily remove this workaround when the time comes.
> 
> By the way, the `-Cunsafe-allow-abi-mismatch` flag overwrites previous
> ones rather than appending, so it needs to be all done in the same flag.
> Moreover, unknown modifiers are rejected, and thus we have to gate based
> on the version too.

Ah .. we may want to file a bug for that.

> Finally, `-Zsanitizer-cfi-normalize-integers` is not affected, so it is
> not needed in the workaround.
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
> Link: https://github.com/rust-lang/rust/issues/144521 [1]
> Link: https://github.com/rust-lang/rust/pull/144523 [2]
> Link: https://github.com/rust-lang/rust/issues/146465 [3]
> Link: https://github.com/rust-lang/rust/pull/148068 [4]
> Link: https://github.com/rust-lang/rust/pull/138736 [5]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
