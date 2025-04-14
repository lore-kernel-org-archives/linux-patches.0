Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280E8275867
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 14:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744639672; cv=none; b=G4wwARCr9KFOM/ej0O8NsPqYwrGBXHqkrcnqqoqScga/mBoUWVlRaYwxRIANXx2krlJ8A7PVPJtp0dOC+YUQaIZjVxvroBj+1ttVZ12jfxQ3++LMqqkA43ceO7o5p5GHlXYW2Xy1DPWdzumfYpLn65wBwMMob3y0MH7FXXWtftk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744639672; c=relaxed/simple;
	bh=AYWkkj9NyBWLE+vHeCXHgbQh4tX6WsCz2DwqzolPXQc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PCCwM3EndDMNbeIQmLqSFp1BpkkpeEyYZpxQvGnExjp86+Tha7r+dQ+opZwgXrBxJNUsQB+qoUpe+m8wyzhsW5pUiBEOQwv6A5L4aXgQnqGacs5utLhaHUM8qv3QB4uHUoXMdfMLROOAc8fwHQgJbdAz2zELUE9+ho2kL9tLUZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L8IAbPCa; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L8IAbPCa"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d0a037f97so27757885e9.2
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 07:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744639668; x=1745244468; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=99k4XkFNDnG3EsiHLB6vmh114esekQLkfPzps9wZH3s=;
        b=L8IAbPCaj64LmO91nwrYCvwwTjG63V1HVDc/bs+cWCLoMduk7beVc0DpfJaa/vcXsf
         1j5zTF+jW03/EMgFQaHnyA8pZPRss3Q17TXKEKi6c6MKHkMfk9K/q1BbIThKdEvmKzDl
         SF9p1p9iSmKjMnMUuVbiKwo287AbSeqsWSiRloOZ3PzGvP45plQN2B1i2cinNncYBIiD
         NICMlpaXysUjG2yv5/MMLJ9SMt5QYoKC5r98tieyx8FDf7E0YsDUw9W49RvgcrjjMH5b
         27zKyf+Nj/jhgvEySFNzErW0aRbNEuH86Nd4ScMQrW/kb8MLS/H5+Jez+b6D769teCSt
         5Lmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744639668; x=1745244468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99k4XkFNDnG3EsiHLB6vmh114esekQLkfPzps9wZH3s=;
        b=lzEZ/YK8O1Z6a+3dVYs7fIEhXq1cvjMIoYF+SHcn8pPx0BlOUNHPKb2ofplXnNjTtI
         ZY+56GVzcepDP2WCtFd2jTRZPHHWfKrdgYMDLRF1O/j7iqTnzEZjSj4am1cLvkfpm6O4
         q18JiXJkxMtT6iAVakQwNhqD/Nf+NXVvItsRjMJT6HFpkmQv4TeVKVNZErAGnmPNpqi8
         tM5AmsWc0U5KAQ3SjQMzkjIQ4//0TlVJlSZDoxslxoaoav/8841Fsl7kc0HXEOZPJLhd
         /+2GsTulbMjbejrHXDkkux9Sxe/IWREDX9o4CAAetRfS6Ysrj1HAfREWXskLvU4OWmhS
         KGCg==
X-Forwarded-Encrypted: i=1; AJvYcCUUsEo18E9EJztnM8R0AsGTIqbzhR3r8s5y53/GOCpFcmV0M5ACvlk++n0pxTIH74gvLNfiWTqH@lists.linux.dev
X-Gm-Message-State: AOJu0YwB9abCDdGdVWZanyj2/7uAv/9eh5iJlmBTmuT/IzpTIQo8ZhXs
	t+GDCWsl+pge7+Jn04WpEQi2+yb2lT1H3OgkWrkgRS/9n1rEMNl9kkP50Of7lBXqO2G9O9Wdzx5
	WlzCcN6HM3P84KQ==
X-Google-Smtp-Source: AGHT+IEN9Rftc6XcCDbvh31R9vqfEr61DrJmd3at5EtnCIlCs+9Wd11hNl1/CdDZ62/r1z3umTWHKnoW1ogWl8g=
X-Received: from wmbgz6.prod.google.com ([2002:a05:600c:8886:b0:43c:f517:ac4e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f94:b0:43b:ca39:6c7d with SMTP id 5b1f17b1804b1-43f3a925899mr111059205e9.3.1744639668562;
 Mon, 14 Apr 2025 07:07:48 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:07:46 +0000
In-Reply-To: <20250413002338.1741593-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250413002338.1741593-1-ojeda@kernel.org>
Message-ID: <Z_0WsnalDXDEmPdk@google.com>
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sun, Apr 13, 2025 at 02:23:38AM +0200, Miguel Ojeda wrote:
> Starting with Rust 1.86.0 (see upstream commit b151b513ba2b ("Insert null
> checks for pointer dereferences when debug assertions are enabled") [1]),
> under some kernel configurations with `CONFIG_RUST_DEBUG_ASSERTIONS=y`,
> one may trigger a new `objtool` warning:
> 
>     rust/kernel.o: warning: objtool: _R..._6kernel9workqueue6system()
>     falls through to next function _R...9workqueue14system_highpri()
> 
> due to a call to the `noreturn` symbol:
> 
>     core::panicking::panic_null_pointer_dereference
> 
> Thus add it to the list so that `objtool` knows it is actually `noreturn`.
> 
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
> Fixes: 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> Link: https://github.com/rust-lang/rust/commit/b151b513ba2b65c7506ec1a80f2712bbd09154d1 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
