Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7815B1F8921
	for <patches@lists.linux.dev>; Tue, 11 Feb 2025 11:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739272252; cv=none; b=P4Z8xLg9Vu3/I+ZHTTtmWIv70CBIpqsffnMPDLDqJMe5xSw3M2K6urGz77vUTubGdj/tp4tk9xZjlCopwSmYVDi6tZuVBkpEZtVFMyYGCOuIpShCk0K160FQIm9w5kdfyBzxhj0wuHbSArCseCjHU6h4NVFCwfTJ2U4oIxMaegc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739272252; c=relaxed/simple;
	bh=WPb2ORZc/9ZZ6+gHNdJlvp8bilbLUMvl7JnfNtvGfEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G1xvD29p26DcE0j/hG54lggr9tmuW/AHk5BlugpUulhtd4LJXzF5XEp7ShmU3WIWH4w3dlxvrzOOYPa+jWXGpevVKhVSoVlRY6twJrXtA0NWj5SPj2+jIEl24JNJH70YYD5L0gcMkNC0CeMGmA/ZIahbBK/6JnbwNzO+KYx/ybE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=HfDdMkLd; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="HfDdMkLd"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e5b4d615267so2969073276.1
        for <patches@lists.linux.dev>; Tue, 11 Feb 2025 03:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1739272249; x=1739877049; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPNCIgpBAFQQZU10UukFXE6nijs336odSMhelfSJ0j4=;
        b=HfDdMkLdXqAeeX0+ZVb7/TmKtoI3Rhtj5gnXUH/0ES+X2gzcstDT9TFD4rsn06ibwS
         dyEpEwwVC16zj6ui/7ukaDt2he0vzkaj/a8rnBMcbwgDQSAS8ksYO8Bf8kJqI0bcGpqR
         8aeeck9nTszqbGAXjqCDMHyrTUiamhvBhOuIAzp2RV3hNxTAsEObMMO82YUEhs7evDxz
         D57B44dz+0HP3NWKWIBeTksBCgOxUG4CTjlScGuHBttWI5fcms4tcnd+w7GBX+mw7yDz
         Ld2hiSUmwqBNoyUYQgKQHVsG5AItdxzOJYaVn4N+t+S6mJWaywA6mWywezG0ilXgLXiI
         RSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739272249; x=1739877049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPNCIgpBAFQQZU10UukFXE6nijs336odSMhelfSJ0j4=;
        b=OrQYKk6FM9FwREBE87kU38EpeACKSsXsJ2OG7SCa5m6Cqp7aYAyXowhvL+j4i1aR/K
         MEkzbJBLl4sQ0jrVQygiz2FRQKXyNKzCRO4AJ/e1+89Lwo0CG/mxxcqbZ8aJ1QEfdp/P
         DGjhJqSLSzc16Xm2HJG3Osi4QCl3eeGi8gt9p6WKNtYXfOhkWXa/mR5GV3nARpfmrgil
         aAP26PKyNOMAvbJIdG6XIr2s22Bf2xgYpYLT62RctcgQCX09dr9ed/k2adbnec0OlcbV
         U0VDAjzNKC8Whif5G7M8iWTtCyoKUQzU8PH8E+xHHLMXvse3GDjYCopC/wXCbgkQklvI
         LUkg==
X-Forwarded-Encrypted: i=1; AJvYcCVtoTIkFRPppqIz8gsOv7TyQvD2T+K+fnGTE0vI6iUUOahivGfffPZ3KNJ1VNW/CIm4HwAdMVoI@lists.linux.dev
X-Gm-Message-State: AOJu0YwHAI15SqVXXc2faB0WekKKJ0bEQdvlBMp1z+PP9kUdw3oRpwGd
	zkYoJlEiL6TiPflCODszJVvJlVw997MIDmy6jYGjTE2ny/BLs51dkKDxpi8f6CXkD5m5iXJBNmj
	17gJ+zQYRpkNRlyC5fy4L4t8N7gBgJI0hgl/e1A==
X-Gm-Gg: ASbGncvoHoiBmFn7nIJekodNsDgJsuvOvx0bNgELk7G2gS+qRMCZx07YqAJdPxXKs3t
	G0WbFOvCA+HQ1R1VRJCD8OBPZycPtf873BDbaA9n6iMH8dTlmX14pxKcPu+zycgVtS10AyT0Y
X-Google-Smtp-Source: AGHT+IGwcyBsYc46RWArEeADU77H8bXfVzk3irEgxqL38ZDIwj53ttNaZ+UD3iPTNd+DjLbLMEDFzT6kErsvcr/dhMw=
X-Received: by 2002:a05:6902:27c8:b0:e58:7aa:7de4 with SMTP id
 3f1490d57ef6-e5b462c2b38mr14587566276.45.1739272249457; Tue, 11 Feb 2025
 03:10:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210163732.281786-1-ojeda@kernel.org>
In-Reply-To: <20250210163732.281786-1-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Tue, 11 Feb 2025 05:10:38 -0600
X-Gm-Features: AWEUYZn351_k4v10MDh5azMViiAdx98NkshCWwsinZSeHh9hCB6x5oVItn12a_Q
Message-ID: <CALNs47uBcyTmBdTBAPXiBcAkE0-4tih9j=VAv1rRcTcf_c2yTg@mail.gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat target
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Matthew Maurer <mmaurer@google.com>, Ralf Jung <post@ralfj.de>, 
	Jubilee Young <workingjubilee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2025 at 10:38=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
> [1] about disabling neon in the aarch64 hardfloat target:
>
>     warning: target feature `neon` cannot be toggled with
>              `-Ctarget-feature`: unsound on hard-float targets
>              because it changes float ABI
>       |
>       =3D note: this was previously accepted by the compiler but
>               is being phased out; it will become a hard error
>               in a future release!
>       =3D note: for more information, see issue #116344
>               <https://github.com/rust-lang/rust/issues/116344>
>
> Thus, instead, use the softfloat target instead.
>
> While trying it out, I found that the kernel sanitizers were not enabled
> for that built-in target [2]. Upstream Rust agreed to backport
> the enablement for the current beta so that it is ready for
> the 1.85.0 release [3] -- thanks!
>
> However, that still means that before Rust 1.85.0, we cannot switch
> since sanitizers could be in use. Thus conditionally do so.
>
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is =
pinned in older LTSs).
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Matthew Maurer <mmaurer@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Ralf Jung <post@ralfj.de>
> Cc: Jubilee Young <workingjubilee@gmail.com>
> Link: https://github.com/rust-lang/rust/pull/133417 [1]
> Link: https://rust-lang.zulipchat.com/#narrow/channel/131828-t-compiler/t=
opic/arm64.20neon.20.60-Ctarget-feature.60.20warning/near/495358442 [2]
> Link: https://github.com/rust-lang/rust/pull/135905 [3]
> Link: https://github.com/rust-lang/rust/issues/116344
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

This is consistent with what has been discussed for a while on the Rust sid=
e.

Reviewed-by: Trevor Gross <tmgross@umich.edu>
