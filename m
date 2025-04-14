Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630F129A78
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744639790; cv=none; b=XV1/d44X0voMsOmR4fMkX9fZhtRqh0hiVQyqjUOQsz3yipKpxnqN4+hIoOUCbDyCOkH1jgeuWUWTXsxbatxzldw2RELf2Sw21Nfd3ZhcPsCReyXDfHdaarK6VUJrLo0BZRlXG37dB7DGkPc6MBL92yY0I8DwYtmBcgSWG9K44gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744639790; c=relaxed/simple;
	bh=5dBTRx2JIjm9+LihM7UA5L0oIoK5vg/QFSo98pV/tvw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZLbZ8detq2eSQ6AwTLRZCuC7fujT4CXn8A6jPK+HO9hbp+pPPUROv+TXAxG0jW7YZEtz3g7hIn14tISLUm/3ba0MmnuLWiPFJxrqxtBfXG/FKYwXwIetbiorUeIe/xcBtuONFL5BkcsmsKhsNKBfY1BgRuUYA1/saSxHLYvJB+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l6dSk9Ee; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l6dSk9Ee"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cec217977so26680405e9.0
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 07:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744639787; x=1745244587; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V1x1VwM+BJyXyNpGH07RBkzI8imHg185uo9CLrDLxwA=;
        b=l6dSk9Ee2EfrSxUZskS7/vK0YCHTl0T3oHhR0UurvDOGf7VdEEvxJzHfxTmqisWr1J
         BDZb1jW5UgFuf8LIo5d81Tqhbia93dHKP/D/BpxnTOpH37wh07FOvTKZP+IbLWi2k0bN
         5SjMJ3mBa0Hfik6hCvhfyhKGou13Z/M4hNZj4bQToctcfJMtkREWab9OCtYIsxoj9tzs
         zha4uM+QEPbrXiYEujQ0I8ElOMmWvtluMImXORvKs1wtVPtc7e9vY32BhuXjPM4f91me
         kl8qoKgLWVs2QjlaQVAx4VtpQxvbxQGj84mqnOTm7xgNrfgZ7ojcnF5Ua4hcoBcuUzff
         d5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744639787; x=1745244587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1x1VwM+BJyXyNpGH07RBkzI8imHg185uo9CLrDLxwA=;
        b=rdDMr7uF8CjA35KhLCViPKqoDq/8tIUmqX7ue/9oCpAXBLfVvAEPGrpvkVHAfggCa0
         igU4Fz3lUrsr+oQ7uoFxJBxxMHf8SHfgCpTUmZpQCpGZbM9J1Nb/IJ2tLGgJId4Vhn3R
         09rcnZ79jMTCEIMXXwgD0Qams7vN6fbOr0jioZWnkbDwHhSr3HeUmBx30lHC6d5uhj8D
         BTY1mO6CtLwOk8uKGOK07+v41yUqE5drukpHPUEfoCOiscb+iSkt+6D4pKoAoDTOq45B
         XQ5owszqUmPkl1IXSvoxqU46bPvVb/j3lwGUchybNpGg07qtJb31L3L+b45JQt2eh0qj
         x2BQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+ECPXpdTHCxdP3I6/ywBvMilxqQdwjgaKU3qCUoCySE6tVJm3tdrD33IeMGqdI4qUMstq+Ehx@lists.linux.dev
X-Gm-Message-State: AOJu0YynOc8AcIOlCG4oUpp3iST2ddoKVBkfYoxvz2Q2b7r+4L12mu8Y
	RgYJpPFQJ6dtthd7RtegpirVTUIP/s9rHl/ID4DPOD814kqNfNdZ9XiQPQ9o/ImYGRUKwh8ZIcE
	WsUglZF+1yImMXA==
X-Google-Smtp-Source: AGHT+IEgLd19E5nBP06l0bJPxMy3VssHMtCjQBP0qyE6H94W9oIzvjooWRxUxI4LOc3bY/vqSQTc4RQzGe+DuOg=
X-Received: from wmbay32.prod.google.com ([2002:a05:600c:1e20:b0:43d:4038:9229])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3113:b0:43d:fa5d:9315 with SMTP id 5b1f17b1804b1-43f3a9b159emr92766275e9.33.1744639787648;
 Mon, 14 Apr 2025 07:09:47 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:09:45 +0000
In-Reply-To: <20250403163805.67770-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250403163805.67770-1-ojeda@kernel.org>
Message-ID: <Z_0XKfAMnWElZDzU@google.com>
Subject: Re: [PATCH] rust: disable `clippy::needless_continue`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Tamir Duberstein <tamird@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Thu, Apr 03, 2025 at 06:38:05PM +0200, Miguel Ojeda wrote:
> Starting with Rust 1.86.0, Clippy's `needless_continue` lint complains
> about the last statement of a loop [1], including cases like:
> 
>     while ... {
>         match ... {
>             ... if ... => {
>                 ...
>                 return ...;
>             }
>             _ => continue,
>         }
>     }
> 
> as well as nested `match`es in a loop.
> 
> One solution is changing `continue` for `()` [2], but arguably using
> `continue` shows the intent better when it is alone in an arm like that.
> 
> Moreover, I am not sure we want to force people to try to find other
> ways to write the code either, in cases when that applies.
> 
> In addition, the help text does not really apply in the new cases the
> lint has introduced, e.g. here one cannot simply "drop" the expression:
> 
>     warning: this `continue` expression is redundant
>       --> rust/macros/helpers.rs:85:18
>        |
>     85 |             _ => continue,
>        |                  ^^^^^^^^
>        |
>        = help: consider dropping the `continue` expression
>        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_continue
>        = note: requested on the command line with `-W clippy::needless-continue`
> 
> The examples in the documentation do not show a case like this, either,
> so the second "help" line does not help.
> 
> In addition, locally disabling the lint is not possible with `expect`,
> since the behavior differs across versions. Using `allow` would be
> possible, but, even then, an extra line just for this is a bit too much,
> especially if there are other ways to satisfy the lint.
> 
> Finally, the lint is still in the "pedantic" category and disabled by
> default by Clippy.
> 
> Thus disable the lint, at least for the time being.
> 
> Feedback was submitted to upstream Clippy, in case this can be improved
> or perhaps the lint split into several [3].
> 
> Link: https://github.com/rust-lang/rust-clippy/pull/13891 [1]
> Link: https://lore.kernel.org/rust-for-linux/20250401221205.52381-1-ojeda@kernel.org/ [2]
> Link: https://github.com/rust-lang/rust-clippy/issues/14536 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
