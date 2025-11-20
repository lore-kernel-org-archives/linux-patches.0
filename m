Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093A130F542
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 09:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763632774; cv=none; b=ROVkw30zLpcUxhYJ/ZIhlO11unGtey6ngteN3efVuKMWi69IPbZaBw8sImVPzTDcOiASJOKFt3dE+QL7VrAEGRWbxiD7/puckrutQ7Qi9uOX+G0RvinvNG1FIU5HDMZP+0TLPoA8JRnHtMrYLFD/9vtA6+LxPRCfxPX6AtMg3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763632774; c=relaxed/simple;
	bh=ebkAz8idP/5kWsCMCA9Et9EJ9cCNttzJgavkMh49SLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W2uKiu4fblxfGcDxA1wgw4g5WlJPzku4HKqGkmh1rb3BxsKYw5DN12FqiCjDM5WD7snSdc8/YeBqAHCyylyBhWGJfbXDoqJVRszgqlDNwLtCtx6lA6O3HBU8yl98E+qKECN25PZxLMkDOLuSALEQnWiTwAc2NTCRQ2CI+oGkz7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fXyeOO0Z; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fXyeOO0Z"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779393221aso3986975e9.2
        for <patches@lists.linux.dev>; Thu, 20 Nov 2025 01:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763632770; x=1764237570; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rKhkvz9RkKrz0nh0wD2ZjaTl6jF91MXKlXmQggVVFBw=;
        b=fXyeOO0ZxWLnNYDFiU9531oLjtbDub5tzfP1GxLtHQeo+wS8sGLF7B+nz1z973RDnU
         aK5RD8T7w8GQbeL5GV2nC+IZSHvc+g0QaeD/TrxQGvSvGsjzOzFeQFyF9yn00cQf4soh
         s96loucCp7myZu35I7WvzHo1QwIOCE9PshztrPZZtVjRUFZZsUnrIpSshFxCkREoKwU+
         wBBMHveDgt4NsZLDA84pPYDdngJLikwVOxuJszK4vg2Q8XFWSuQeGp5gaq1TLm/pdjxJ
         RlrKdHwPxQquX46+WlzkYtquENjzGYRmg755FXfHAZQUHauhJFK72GQX9m3vwTi2OO6T
         GpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763632770; x=1764237570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rKhkvz9RkKrz0nh0wD2ZjaTl6jF91MXKlXmQggVVFBw=;
        b=oKnkgrAerx5zZgtOkxid2RuVidIdrHYwap1hfoBP/OClbClaYbGGGl/KK2LyePpEUn
         kajM5AS0EknGUISbL7WVFXJszY9+iWeYQfsIBNwAL//9OCSGwvWeKzDblkFYzyEluYBY
         6UdPGoVIAuokHbfU/pXp5FHmXpBttv6mc+cew7EQf1f0asDxhwjgwc/HcYlyiXD+jVyY
         24Fd+JpmJnQgX+oUS1WZZAICyCaducZ2mi2Ic3Lr/mJqYzmb+H6VgMDpZoRqZAy7mqTr
         59xpYZ3rOKVWxn7bFAbEC0dDacgjdLzbTCopUpLP3ItJi+b9oOKgqxIq0FZFKczeruX4
         z/cA==
X-Forwarded-Encrypted: i=1; AJvYcCWQho3cw5pFy80xJS4r1twQAnfYeDBNiL1NfUV1L+F9tW8wxJnOR43imJjNxB1myc0g0TGmik/w@lists.linux.dev
X-Gm-Message-State: AOJu0Yxpk+jPYBxx8roptZs9XH6hjNLOk/JDvP9v2pHziFJD2BdGhgqq
	vJLdhThIwTEIYjXB+98ih+s6IkUzz2huGT0i61y/ZJf1TthEW+ypJmv4kfTzGLd98VMiGJm0DdZ
	LKa1rySAxxza3c8C+gA==
X-Google-Smtp-Source: AGHT+IEKKD/BmbPlgMBpPggaAQdc02UN5hstoI3MhFvEktRwsM27SKW5fgN95go6FNLuZRUl6xabBr5bc6/w7Gw=
X-Received: from wmfr22.prod.google.com ([2002:a05:600c:1596:b0:477:632b:1238])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc5:b0:477:97ca:b727 with SMTP id 5b1f17b1804b1-477bac0d06amr14368825e9.19.1763632770470;
 Thu, 20 Nov 2025 01:59:30 -0800 (PST)
Date: Thu, 20 Nov 2025 09:59:29 +0000
In-Reply-To: <DED5D81TXPCO.3FK81IGE9KR0O@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251119185125.1411151-1-ojeda@kernel.org> <DED5D81TXPCO.3FK81IGE9KR0O@nvidia.com>
Message-ID: <aR7mgRgG8fKhgD__@google.com>
Subject: Re: [PATCH] rust: slice: fix broken intra-doc links
From: Alice Ryhl <aliceryhl@google.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Thu, Nov 20, 2025 at 10:56:29AM +0900, Alexandre Courbot wrote:
> On Thu Nov 20, 2025 at 3:51 AM JST, Miguel Ojeda wrote:
> > In older versions of Rust, the compiler doesn't know about the newer
> > `as_flattened*` methods, thus `rustdoc` complains about the intra-doc
> > links, e.g.
> >
> >      error: unresolved link to `slice::as_flattened`
> >       --> rust/kernel/slice.rs:19:23
> >        |
> >     19 | /// [`as_flattened`]: slice::as_flattened
> >        |                       ^^^^^^^^^^^^^^^^^^^ the primitive type `slice` has no associated item named `as_flattened`
> >        |
> >        = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
> >        = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> >
> > Thus fix them by using an URL instead.
> >
> > Fixes: 88622323dde3 ("rust: enable slice_flatten feature and provide it through an extension trait")
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> > I have seen this in -next -- please feel free to take it or rebase if
> > preferred etc., of course. Thanks!
> 
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> Alice, I guess we will want to take this into drm-rust-next or
> drm-rust-fixes since that's where the patch introducing this originates
> from?

Yes, it goes in drm-rust-next:

	After -rc6, the branch is open for fixing bugs introduced by
	patches queued up in drm-rust-next for the upcoming merge window
	only.

I will take the patch.

Alice
