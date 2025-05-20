Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC4B171D2
	for <patches@lists.linux.dev>; Tue, 20 May 2025 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747775598; cv=none; b=Yu2e4KQo0UjuECt600XF9uQPNzBe83bK1arosWcTijSP/UWgyKtaaiNkgDbA93psTCnccCXkLQBxYgNhj4V3NaONHX2NmesgHYLdaWEsEWDstrR2p6a3FR+OXHz/fQ9/khfxLfMbalLDeESOwJMGqmV17Hu0ijPfnXz/JQo2otE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747775598; c=relaxed/simple;
	bh=L7MRy5nZLEPp08rfjDttlaHLh2aLDq/Ts8Q00IzSj44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nIQHR5mVpJ9SGWct7u1//ySfvgWDrlf5ca6Vo5bbwjrmvyuigqdKP7pMJSfrzd9NYrjPZYy2G/ddWzInoCHpiC21ti3TJxwBmtj4y/oS2dL21OwVmfMJsh4MME+MPPpgNDdjkSHAaEZvfG+QmPnzq8rSgLfRDu8yFJ+uRBli8g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=guGq4cQ2; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="guGq4cQ2"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso32403805e9.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 14:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747775594; x=1748380394; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c6k8y43kbW69Cj6+ls8AarnJHecZRyEQvRb7E86pWzI=;
        b=guGq4cQ2PV3BkVLXsGKRYk4l2if00reoqff+4LrKaH+Zi9saKyZzslKyONJySiCecV
         oonPWlcBZYznNWg5rpjiO/hVwgHBTn+vgxtPigXkkP8uAGnRUmyygBd5Bdle8ctvvK4E
         E2OwTAiD8N7fQqiHfvB6lRUjztnkJn+VscXk2NkJpfhPV3hL28fO3IwXl6kZ6luaRbLC
         HQ81YsDW9U4tLRJA50nk+ayVzLHYNMLXVdOtk5NpjAWuInPATJDVv+JI2GBScry5mL1M
         +t0lrBzoFR2B8DrHy+vNRH/jizNgtC8BwDXE19bZBXjLw4/BgZ3BtoaqdyFVhhhX0dGu
         G2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747775594; x=1748380394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c6k8y43kbW69Cj6+ls8AarnJHecZRyEQvRb7E86pWzI=;
        b=PN7Yf/c2rSZ1AGVsgfaMV+YGi8bwWe76lyfv88W2023lhU6pLswfDLsk3B7mF0a3Rl
         tgea+kVt7Szgw4nYHgiSPHSlxU1OkGWFMNiGTQlluJFwEU+lJdn2qj14tQiSxukRXuNy
         krqdPXzax78HxPZqBxQ0p+57iLYATtHx/sF2NtOp2eafBgpqiqy8pQbLNWCn+pixZG/B
         jKFLOyWJ9mv+09UvjcoAc5So2OgHueqmYMg3L/JTT5eMBxZY+uvXf5XSXZGyirHVSbnK
         hBPRIe3vLNS8WbVHKMh4ZmYvItwxxEQnNj7G2Qo507E6rIx8Zn/PMMXIZEecEzhVXodB
         tmbw==
X-Forwarded-Encrypted: i=1; AJvYcCVkeA6qhI4oSMIyNqpOFO1015d+x89L6uejzF93K4HRay/e8/XDDXBLPm1OSZywJMdAAvY1utRJ@lists.linux.dev
X-Gm-Message-State: AOJu0YxvffzVKtKKZXMrM+Ht48aEIEo+bp9y1ZmfffkE24FlzHWC1rDH
	qLg8XBuNDnAqkUmN3C+/v3tX6I697TgTJBYwqbAZ5N8Cl5aY9KBp2dtjHmA/HYtQ/pWwDVvvV+V
	A5SbHu5HrN5OqMKTIbA==
X-Google-Smtp-Source: AGHT+IEYzt7HhRWU2PItDewLmZNHUanVmZTDkUbAcKrucWyR7kx299ej8ln1aBKPhh4PGh5FlDEsAD4HjFpbxro=
X-Received: from wmhu10.prod.google.com ([2002:a05:600c:a36a:b0:442:ff89:efb7])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3c82:b0:43c:fffc:7886 with SMTP id 5b1f17b1804b1-445229b431cmr98895075e9.8.1747775594095;
 Tue, 20 May 2025 14:13:14 -0700 (PDT)
Date: Tue, 20 May 2025 21:13:12 +0000
In-Reply-To: <20250520182125.806758-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520182125.806758-1-ojeda@kernel.org>
Message-ID: <aCzwaCkENAiaG-As@google.com>
Subject: Re: [PATCH] rust: remove unneeded Rust 1.87.0 `allow(clippy::ptr_eq)`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Tue, May 20, 2025 at 08:21:25PM +0200, Miguel Ojeda wrote:
> Before a change to relax the lint was backported to Rust 1.87.0 before
> its release, Clippy was expected to warn with:
> 
>     error: use `core::ptr::eq` when comparing raw pointers
>        --> rust/kernel/list.rs:438:12
>         |
>     438 |         if self.first == item {
>         |            ^^^^^^^^^^^^^^^^^^ help: try: `core::ptr::eq(self.first, item)`
>         |
>         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#ptr_eq
>         = note: `-D clippy::ptr-eq` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(clippy::ptr_eq)]`
> 
> The backported finally landed indeed, thus remove the `allow`s we added
> back then, which were added just in case the backport did not land
> in time.
> 
> See commit a39f30870927 ("rust: allow Rust 1.87.0's `clippy::ptr_eq`
> lint") for details.
> 
> Link: https://github.com/rust-lang/rust/pull/140859 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

This commit message is worded in a confusing manner, but the change
LGTM.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

