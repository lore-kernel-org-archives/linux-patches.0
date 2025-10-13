Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5332FD1C6
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760347176; cv=none; b=Y50bGKFDdBoQd08vNaUlOYrEEiBfaK/OEiNk60CvUYIitjacio200MYQlF7OKyONHuw8JxOPHGI1XbMyBuNHICZHusLHP1dKk0DAXhDl3qwtnWS9+arpS8h7iNU5/FxEffoeP7ugU/3IWkP2RrA3lQMAxOCviYspB0ab07ESfUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760347176; c=relaxed/simple;
	bh=7e11H1Sl1fNF6/Pen2WxGe/Xr1qM6aJthuzJAA0/Mog=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JRfhQPdqXGpwrWJkYAUaVn91Hg5BPwLX0sDso85EgL99zB3oHZvED2T//G3Nchty4W//O8Yt92CMXwhpbTJopcdqS2VwJ2+V+tlkEgZaytnzSJbRss3xsbKdv7Sg3WqUTQDoiG4ft9fg6zWeokwP99Pi4JTeob8dciqt5UTGUWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jc8xiefv; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jc8xiefv"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e473e577eso26945595e9.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 02:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760347173; x=1760951973; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q8mp6Sl5lpIMsBMcZe0Dwu/oRU1yIEVK7dE0nvjB0QA=;
        b=Jc8xiefvaNUiOfrrx5AzyWnS7iTn6Zqwx4WGypK/4V6q2yQTuFq86u74V/CriCGWXl
         MusYhDq0L1RWe6ZdAP4XZw6LqCF0zIqU1HZN6/fTDYvL1ymgn3C903J6S5xUxix8WdcO
         JC1JYkBRID86WAQdN1GFFRbGmM+hh4ah7bVMGw2x9+BjK3UAIstEnp2O1v58xwKey8W2
         1w31GiarP0Svq4FzeWNQSIrWJXUOOJOPYUm7cokcdLodN+rTA1FXz7yTYqJXbEtknU6G
         MJHavfqpcntNk0cvHtIyDnveJgoQFhhef4hWooVZq1wIWf6UJzvvZr6hF/ZmtBztiFIU
         NJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760347173; x=1760951973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8mp6Sl5lpIMsBMcZe0Dwu/oRU1yIEVK7dE0nvjB0QA=;
        b=QYi8Xeig9s7YBmFv7aMgfOjaYPQkFq7JI0ONgcy05Knarsv2S7jpZHs+8U5MnIPJ9K
         zRzJFkcggWZY4o1fKIm7vMiQGy3oMVLTbHCWsKy9BYonKalBl327tLf4Y21fAFIX3rke
         Fo+uxB+IA7vtV4diKSKLoDGmS0ghYRPvcGdgWKl3kd39Vu2VgTwkbb7/abP9ilrIXZ2l
         SFFkxxnDuHRT98QTQMtHYmcrfWZ97e59FPSkXR1XdX9k4ROBdooTlV5eBq/5AB5qN85R
         fW9C6yjmiAdLYbUDqCAn1a/Y2Ww600ajVTl0hIGldnx0/DiE0OyLsa19uA6wO+axnAqA
         9Inw==
X-Forwarded-Encrypted: i=1; AJvYcCVFGJu03Inzcl+wQxDVayCeBn1lnP8TLqu85eLeQEgudRgx0DUo9OVtyrhc+4Qd6wdSoiCJVN5G@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2KmaYtKTye/bs7fgqGl7ivCeGBEXdTD5j3wkPJ+FXdVKOZAy0
	61SKjn9t5eu6i7PDkApntrXTMPTLnFR2s4Wfc0lolZE6A9EpacixzGIpL2bKHqmnqG7FjL6F+QJ
	tFn+anZVdHIkAmJWuhA==
X-Google-Smtp-Source: AGHT+IGyE1/ItkqoGr313xqMor1adj+/d0l73A5B2xL0EAcjYPfGXqLNzPt25q8he9xrFaEgiN5RRjL9JA9wkiQ=
X-Received: from wmcn14.prod.google.com ([2002:a05:600c:c0ce:b0:46e:2897:9c17])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83ce:b0:46e:394b:49b7 with SMTP id 5b1f17b1804b1-46fa9b16597mr144514005e9.37.1760347173573;
 Mon, 13 Oct 2025 02:19:33 -0700 (PDT)
Date: Mon, 13 Oct 2025 09:19:32 +0000
In-Reply-To: <20251012213230.1139674-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251012213230.1139674-1-ojeda@kernel.org>
Message-ID: <aOzEJAdNHatrW_Gz@google.com>
Subject: Re: [PATCH] rust_binder: clean Clippy `mem-replace-with-default` warning
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Christian Brauner <christian@brauner.io>, 
	Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Sun, Oct 12, 2025 at 11:32:30PM +0200, Miguel Ojeda wrote:
> Starting with Rust 1.87.0, Clippy reports:
> 
>       CLIPPY     drivers/android/binder/rust_binder_main.o
>     error: replacing a value of type `T` with `T::default()` is better expressed using `core::mem::take`
>        --> drivers/android/binder/node.rs:690:32
>         |
>     690 |             _unused_capacity = mem::replace(&mut inner.freeze_list, KVVec::new());
>         |                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: consider using: `core::mem::take(&mut inner.freeze_list)`
>         |
>         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#mem_replace_with_default
>         = note: `-D clippy::mem-replace-with-default` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(clippy::mem_replace_with_default)]`
> 
> Thus clean it up as suggested.
> 
> Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks. I guess I never got around to making use of commit 47d8101924b5
("rust: vec: impl Default for Vec with any allocator").

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

