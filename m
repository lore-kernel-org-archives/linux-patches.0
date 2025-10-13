Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535BC2FD1BC
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 09:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760347220; cv=none; b=NnZAJLuKgPEyqVuIWH34cRqrdt+3ezKdLK+uVoTcdV2N9E46bcuZw5WxSHTazFRjDvD8eXTjmHKrIra/KA04E0vAH1Thv82iXhvsOUpkWJ0SOS/BQbrh0K35EAzYsJho95URmPq6ueAOwkAWfQ5s+8kb6tb0RWGdUays32gALr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760347220; c=relaxed/simple;
	bh=QauuifBIivV0CnP0lZumGXahaU8WwHf1ZmuHKkcj6i0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Djr9ompPcVlXKPm1qk3Y8m4PZy43I/SdfUcVkcyuhzBLfWTeviCGBIuFX7UY4SPQLIBkn+g2JUc4eiPBNn+AkBilYiiLp/3OGH8/X10k2U0h823b8T1+bN3ffJB9UK76l3e94RQWSDCzsF9bQskP5FgGoZAb7VxdH9+0v+CYqgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HxtfaWpw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HxtfaWpw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso27902205e9.3
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 02:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760347217; x=1760952017; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/YLIXxu3r1bT61bpUEMmybN5f7kCfaViovXYFbL3SjM=;
        b=HxtfaWpw+BqwCw1Gi5J0Zv5u+7/VIdxJAam15Wak+erAIWysxcKV+/7XhXHrZN408D
         9lKGfVBkuk5Svm9lqvL0d/bEBbxIOFALQW/d1sxtIdi1f+L52WTrDx2mrB+OaseJrCrY
         aQxjLBjVy+H0Ugn9lVKYbZEwzbKlTvv1Az02TuBzeUt0MPIfuZU7PID1c5FyfV95Bfh/
         KKMncPo8Dtef5lhVR+LF3RiFc8zxjoHl/uKtGR3hWfnPTKiIoFT+BwTt240VyBkjwHpv
         ITLvAOKAmJu1UrOiD7eAXSYQUKaPV8oHNIP4i+CxIgtVHRBVsiuA8qNtppISvs3kd/Ip
         TKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760347217; x=1760952017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/YLIXxu3r1bT61bpUEMmybN5f7kCfaViovXYFbL3SjM=;
        b=B7tQYvTMjfG4Q8ylyNFUhRhKr6qOeWyP0MsZNm+azn7bEgOuuTc/uKmL1I0My75bvF
         6PTb4cQwu9OdW/FK/AsjisOqK9Dt/qzKpSbKu+fj9fKNYpFvfqAdJzc0KhQKK6BgyLuX
         ny/x1IuRJDr+Go/hFjH22PMe5mJF70rqJwg59rM6sY2YIiiB59GoiBDE0M12h2foDUBr
         7Ry8NBNZLz5xMt0nBuGg4kLPezIMcWyXdnRdvqxhZsyi+g+Z3LUZRnR1NdmY/kzpuIUo
         /gZpkx7XVkRiPP/nacYp8KqyRqyLt0yr5n5t7KMqJMzo41nqvFJTeEJWXBYOlZIYLWJ9
         zDJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO/dkjzvS8uLfa8DlnUSUkx/c7wFRKh7NVUcuOSbqgwhjg1D+ykDTiaORSyZwVG0D6tbQRHUFj@lists.linux.dev
X-Gm-Message-State: AOJu0YzqLeXJCeo765xN/QNa7f+F7XDO94TfPDmZqR7CYXL6Gt0GgLuX
	b9P3PQ83y8J8WOIeiGgjt3zIS4E9c7OJTiYMzFI/Rh/HxlTkGKlHt9N7aiBuH2sVz4rJIqwPsPN
	Fi2h+RgUNqV4kkmqPCA==
X-Google-Smtp-Source: AGHT+IHb6VBFw+s5vLpdfRpV683e8ptVQHwXIXwalC0rZp9VrZA2JvEvy5kZ5UvL/xduE9r47vW5HXPH+BxtecY=
X-Received: from wmlu17.prod.google.com ([2002:a05:600c:2111:b0:46e:2eb4:38d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4510:b0:46d:d949:daba with SMTP id 5b1f17b1804b1-46fa9a8f275mr139441695e9.4.1760347216682;
 Mon, 13 Oct 2025 02:20:16 -0700 (PDT)
Date: Mon, 13 Oct 2025 09:20:15 +0000
In-Reply-To: <20251013001422.1168581-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013001422.1168581-1-ojeda@kernel.org>
Message-ID: <aOzET46lagm-p8go@google.com>
Subject: Re: [PATCH] rust: bitmap: clean Rust 1.92.0 `unused_unsafe` warning
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Burak Emir <bqe@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Oct 13, 2025 at 02:14:22AM +0200, Miguel Ojeda wrote:
> Starting with Rust 1.92.0 (expected 2025-12-11), Rust allows to safely
> take the address of a union field [1][2]:
> 
>       CLIPPY L rust/kernel.o
>     error: unnecessary `unsafe` block
>        --> rust/kernel/bitmap.rs:169:13
>         |
>     169 |             unsafe { core::ptr::addr_of!(self.repr.bitmap) }
>         |             ^^^^^^ unnecessary `unsafe` block
>         |
>         = note: `-D unused-unsafe` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(unused_unsafe)]`
> 
>     error: unnecessary `unsafe` block
>        --> rust/kernel/bitmap.rs:185:13
>         |
>     185 |             unsafe { core::ptr::addr_of_mut!(self.repr.bitmap) }
>         |             ^^^^^^ unnecessary `unsafe` block
> 
> Thus allow both instances to clean the warning in newer compilers.
> 
> Link: https://github.com/rust-lang/rust/issues/141264 [1]
> Link: https://github.com/rust-lang/rust/pull/141469 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

