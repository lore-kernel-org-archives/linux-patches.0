Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B208D1F9F47
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 09:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322237; cv=none; b=k5xUbL6PZvfGKivz914YNgXJMTnncDk9SqH4Nb/Tm+YFijGQv/7iQrAGvBUCgmsNqCH/zDaLH2nT5gUVtuE2RuqmTI52krYx1F9x2jNDSp422wzGziqi23AH+duUGunt2+wB2Bk1gSskEDP0cn1lEKAH56YPgYUtIWYjhfolu5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322237; c=relaxed/simple;
	bh=pAMrBYxNmrnMV98dzPQqgoD/IlNSmr/b6Kg/ue8CGis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PyW7vhD17CbeptOz6MTPUr5gZKU9rJ7hZCtZiR7ziIGbQD4wBPqDIJj22fEtAmSKpJqTcGsRIY8nbNPFSNKV0yB5B3RmIj55L/unGZFhdmMGQQFJ5J39IpF5fXQJeSqIu1c+Whxm+gdUsfJAi2E+IO7uxUOzxGRgS7zf7x850r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=agW2snuf; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="agW2snuf"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779393221aso9097625e9.2
        for <patches@lists.linux.dev>; Fri, 28 Nov 2025 01:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764322234; x=1764927034; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w0sEyeS2wsRbXXsmS9a3/+EZd+2aP5K9jDzOEbDWnKY=;
        b=agW2snufkm4kNYB86P682n70STjpEtSf/CE1hxyYmFDn15ClsplKxZM6MRyOc7SofU
         v5oFYR9OsIYySkMZrbtCTYz/tvCCnX197/canG5reR7jMLuosK+Gj+xKxdEcvB93Nxdb
         GZy9vXgGG0v23b4IBJgIsu8Ldk8VFz0UGkf7XzTK7VnNDeyFAltDXW21uu2yVeW8XDjD
         zq1wjo1a5FtMdNANxeKyIvlUlJgkOs8qd0cfTT6g5nf1Yx1vd5rgBpe0Je6wfw3oBGUO
         AzjXyP91+uI5MXoE0gIAyv9SFxW1csd5Dc54cMnOMDinIjarHBoBAuouBFWt0tOYPgqT
         kcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764322234; x=1764927034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0sEyeS2wsRbXXsmS9a3/+EZd+2aP5K9jDzOEbDWnKY=;
        b=v/jxwG7aVmm17ziyFolEsZmM3wkPTFMdxPXW4FPcsqQwMQwZjh3yUZlHTAmHoX/B6N
         X5QMht448M4AMsHv6ZgAS6Dh1Xj/W4HDrMQpxrDI3PWdBE17C7yeucySM5vcybbYfqFR
         JURVCeaXfv9sxeFKBx97IYpvYZL3WQfPPKTPQCrqvE59FrqMOE1Lpc35IuO7ZY+pzHtb
         tYjmzpqITaaI0JY6+R3HM1AXOMmGfeyYdjgQPsMbLpw4h/lNe3TKXMaey+5gMettxmor
         Ia2sEu+2y976Wlpr6Eh60LNjaKX9osciH8x1Z1nWtY+YCxBvesP5T2hBGYiaVtaPpJGu
         1wuA==
X-Forwarded-Encrypted: i=1; AJvYcCWEzOpyuXDiZL1tA0v4h2pN3zLXneqRB6qeWxYHoHvYhgbvNuFI0CZmax+BN+LuAhNLQ/vej4jp@lists.linux.dev
X-Gm-Message-State: AOJu0YzC0FuidOaRNefMXs4EhkQ8c1tDYgQQ79ss2JxNDt/z/xpeihzP
	pbiyhdXMYT5y4kn/BpME6n/zOpk0iUp8L56KY7Vi7AJ1Gn2ujA2EPXGvnfoKoCCCrnmUnpKHbXB
	P0ovcCqgSLw1kzJHY2Q==
X-Google-Smtp-Source: AGHT+IGfhLSTnEFnCpRI/99DlfZCgPSs9n/gklXmDBNxjOIzEo2RBOo/FCdKr4hcgOlG2K2eX/wvEjRfRqywvDk=
X-Received: from wmlu12.prod.google.com ([2002:a05:600c:210c:b0:477:165e:7e2a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3146:b0:477:df7:b020 with SMTP id 5b1f17b1804b1-477c01b2211mr273239085e9.18.1764322233436;
 Fri, 28 Nov 2025 01:30:33 -0800 (PST)
Date: Fri, 28 Nov 2025 09:30:32 +0000
In-Reply-To: <20251127213340.180090-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251127213340.180090-1-ojeda@kernel.org>
Message-ID: <aSlruDTopYyy3yeR@google.com>
Subject: Re: [PATCH] rust: id_pool: fix broken intra-doc link
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Burak Emir <bqe@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Yury Norov <yury.norov@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Thu, Nov 27, 2025 at 10:33:40PM +0100, Miguel Ojeda wrote:
> `rustdoc` detects a broken intra-doc link:
> 
>     error: unresolved link to `BitmapVec::NO_ALLOC_MAX_LEN`
>        --> rust/kernel/id_pool.rs:100:31
>         |
>     100 |     /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
>         |                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^ the struct `BitmapVec` has no field or associated item named `NO_ALLOC_MAX_LEN`
>         |
>         = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> 
> Thus fix it.
> 
> It was a missed rename in v5 of the patch series adding this [1].
> 
> Fixes: feb3fdf1239a ("rust: id_pool: do not supply starting capacity")
> Link: https://lore.kernel.org/all/20251112-binder-bitmap-v5-0-8b9d7c7eca82@google.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!
Reviewed-by: Alice Ryhl <aliceryhl@google.com>

