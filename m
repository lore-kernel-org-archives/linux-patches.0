Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C6F3009ED
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760458915; cv=none; b=CFUIyOOwLgZFHBeB0qLtu39ym0jyFbvTO079Yz6si+fAO1I3ALfSapgT1qdsmVaeZ0rqAR+nO8Wi7HdbOkcx+35mFa8kzpieL+tAR6BvTxydvS6gPEk42mDihf38b9NZSGq7r5sCvv8f1r+KuK0WuwvvP5+s8VSBGle3WuJkxWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760458915; c=relaxed/simple;
	bh=1ockt3UvGLECOAaQWH6tVkRd0+TsZ62TiYm4MpBPTSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BwGGSYQSjQmtxz8dyQZ+l7UtZNu2zHoWrmeF7UuKfzlnLgESvg8tkmCDBM+Mt7spmb2+eXgorHBT4Wr7UaYFN4SzT9OR633WZiU5ICdKuYClVQjcPpjGpIMNDiY3aFuwf+Jo1qobP9+y8SoRJqIqu5UxX/lEOWzP+v/tC9AB+UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJUXdgb6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJUXdgb6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so60498645e9.2
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 09:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760458912; x=1761063712; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LGEZTXFiD8LOPaMPJT+QP3xsnmMASODltHyOui+E240=;
        b=pJUXdgb6V7a8gdcxEDrh3uAn3XSTPVhDdAdC0j+x4J9R0+yR28PwG1GN34u/sYISsK
         0rKNQOe8JI5Tm+8yS8/ib873mbxa1gJRLqgnezFw4bLsJG7d/UBaKlNbIU7EWSpLt5j6
         nv8RhdrqFx2XPBoJVt82TAREb56XA0rYyAyz9PYjUo81rLr+H1irMbBU1SwjSkQRCDqv
         50+7MpoiSpRlx/yaPvOIgR1yLNTmqQIaaBx4zyVdgkG3tDHNqdALD3ixfRH2yT0UPmyg
         qnJqobujtTqhO/rBoZrRKtUOzHZDU5lIuGfnSO/BdmH+kjlSncCiqycRrK3T2Ty1raai
         Jrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760458912; x=1761063712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LGEZTXFiD8LOPaMPJT+QP3xsnmMASODltHyOui+E240=;
        b=GuAiCncgU5X08i1r60QNiRvZ2kNiVcnPdVWyepCXzWOhiHYgFijg9OpovU4uGZ3/vJ
         nCeuKft3kwxwqFOG2AGZyiNtTMUOkO5+qJ2kvkc0UcdqTtI7+pbVUf1dYqIDUD5aDPT0
         IykI3hXQBSmPy6i+vErKv3z2zFgmvgmF0/OtPEDQLIrVFKWDb5nDu5ccl7tY7V2fTtQG
         pZJdWg5+xNN7b7aHDvx9JBIAeGPAEtcAc1j2GhwKWLBYen2AaPeePpCkq6zq/m42cjal
         l3IQ4YRn+PUy9SZhMnVdW/0TZi7KLcrS10FfpmugdfJup52HwtqQCO+e2VaanfwoGnqL
         RIPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqyCaxUQib/bgd7mngJJuK4f0LlOVnf+YZfemBm7EwP9jZGKCLyq59bVE9Dp6b0pOGOOMufFzP@lists.linux.dev
X-Gm-Message-State: AOJu0YyNMkmf7u03y/+ZsmjP6g3iyzxAjQmsAikyF0Ez4mXyayPKvwXE
	r/sphEgLA6NgWF3TAYq8KbGaDY7Wz3MMF6G1S2GagsBeooiF1Ym+HDsyC+rvIq5m/4t9D3+SF6c
	UjbgV4vo+z5tIxJuczQ==
X-Google-Smtp-Source: AGHT+IHoAjuapMOgn96BGUuObSLekFaVbtcXEvLwM5YNydoj7wu3jFNwPTugPL0JpzleSqoLJxGWun+sdMDP8cE=
X-Received: from wmvw16.prod.google.com ([2002:a05:600d:42d0:b0:46f:aa50:d714])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4688:b0:46e:5df4:6f16 with SMTP id 5b1f17b1804b1-46fa9b1788amr171616585e9.35.1760458912468;
 Tue, 14 Oct 2025 09:21:52 -0700 (PDT)
Date: Tue, 14 Oct 2025 16:21:51 +0000
In-Reply-To: <aO51pV5WSmqnT4rL@yury>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013001422.1168581-1-ojeda@kernel.org> <aOzET46lagm-p8go@google.com>
 <aO51pV5WSmqnT4rL@yury>
Message-ID: <aO54nxGil6a5hLQN@google.com>
Subject: Re: [PATCH] rust: bitmap: clean Rust 1.92.0 `unused_unsafe` warning
From: Alice Ryhl <aliceryhl@google.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Burak Emir <bqe@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Tue, Oct 14, 2025 at 12:09:09PM -0400, Yury Norov wrote:
> On Mon, Oct 13, 2025 at 09:20:15AM +0000, Alice Ryhl wrote:
> > On Mon, Oct 13, 2025 at 02:14:22AM +0200, Miguel Ojeda wrote:
> > > Starting with Rust 1.92.0 (expected 2025-12-11), Rust allows to safely
> > > take the address of a union field [1][2]:
> > > 
> > >       CLIPPY L rust/kernel.o
> > >     error: unnecessary `unsafe` block
> > >        --> rust/kernel/bitmap.rs:169:13
> > >         |
> > >     169 |             unsafe { core::ptr::addr_of!(self.repr.bitmap) }
> > >         |             ^^^^^^ unnecessary `unsafe` block
> > >         |
> > >         = note: `-D unused-unsafe` implied by `-D warnings`
> > >         = help: to override `-D warnings` add `#[allow(unused_unsafe)]`
> > > 
> > >     error: unnecessary `unsafe` block
> > >        --> rust/kernel/bitmap.rs:185:13
> > >         |
> > >     185 |             unsafe { core::ptr::addr_of_mut!(self.repr.bitmap) }
> > >         |             ^^^^^^ unnecessary `unsafe` block
> > > 
> > > Thus allow both instances to clean the warning in newer compilers.
> > > 
> > > Link: https://github.com/rust-lang/rust/issues/141264 [1]
> > > Link: https://github.com/rust-lang/rust/pull/141469 [2]
> > > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > 
> > Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> 
> Added in bitmap-for-next.

Is there any possibility of landing this for an -rc of 6.18 instead of
for 6.19-rc1? That way, the warning won't be present when compiling 6.18
with rustc 1.92.0 and newer.

Alice
