Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8BF238D32
	for <patches@lists.linux.dev>; Mon, 20 Oct 2025 08:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760948239; cv=none; b=SM/5+b7NYGC/ETYecelulktSlEOxkpz3NkMNja1oEttiPGO8cCsicsHsdxvedKnG9ppt8jxAMxynihMAhuJDHaxhvM+0cBe8AD4EtWrJdgkE1LxIAlwNkvTVnNcc5ugs/r2heNlCz/p6IevFFlzzpdFaMr2TbKmdihsmkWXFp9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760948239; c=relaxed/simple;
	bh=H0tga9DZv6zHPlXhb6ysF3xK2cSNnzfEhWaT6A6Prn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BDqd16QCX1JTZFwicuzan52zP27xkbUQxxgRRPhUNsKct0RK75+KsS1k8aCPJZqoLLJR4gTsS6yuDtuxU+rBDgNLZ4+ORGZgEuSyinGy2xoDvs3qI2im4L+8APGLPWNVC1RpeqR78Tx4m+dF9rhNdvXyOBfuPlKrBxF/vacQNUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iWxhFHmk; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iWxhFHmk"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e39567579so25385935e9.0
        for <patches@lists.linux.dev>; Mon, 20 Oct 2025 01:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760948236; x=1761553036; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LjMEk6mNBH8WSN8eHPXPJ3fCRbx/T8IK9tLp1EWYzkM=;
        b=iWxhFHmktgefbPRcBu4EwT25VfVgFufvP4GJaFWrq42EGK9RMRrrTFKh9IBshuhFMn
         CA8gdtZu/B7XgNmigM2IlV/vWD3TdYcVvNweqGAKLoWTvK8Fj149YMlKqtBK+p1n4EZr
         xoqLSx1OXagADsM5Txxal6aXOJMev9RYHGp+owrelSMgHnpIjTuwGqGgobvL6bMB/2HT
         8T2lzY6kf2W9XkXa6cmdXwDu6BPr3gQTqAA5q4Q99EM4evopgrdV6Xx2CBbdjjcA+qpp
         LIcDw77jmyaECeDaOdVMuBpDaP0z4Nkct0iNvdE4uhekGBHc3UgQNePzmSwyF8qVa1Fa
         jRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760948236; x=1761553036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LjMEk6mNBH8WSN8eHPXPJ3fCRbx/T8IK9tLp1EWYzkM=;
        b=BK0V96zn+HLylt6vqIpF4OHo0IqCdv0ePc2D+otwdhq+FIMgyNfcMu9+H6t+hMj2tt
         qUD3PN1qHguyxllIYphjvTV8gqO3OK6Rc81kfM0S/LYaTfat1tpwD91ZdOdnS5bggD+C
         PaR4m4jLrfuPHjz5AOR3qW2/3eCNGVzzI8j/u+L5AQzY9n1If50nO2CtHCoZj3SzVnT9
         HtBUk0EopVsqzg3G09YDRhyhyN5YZR1APRkiFhw77KiviRPI/njNpHxX/DiH/Tdy1LDL
         yUGJWnCmsBGGhIk0aaXvCLIrJ0mKSAmvtYNKyWtDnBQz+2L4aYG8iUOjx2sZgPLokacG
         7Y5g==
X-Forwarded-Encrypted: i=1; AJvYcCVcBYltbLW9TMEfQ2cs97jWQa96UKBZdjQD3tOmrtCUxsGkngfR5WO0breQDr+/COTcXa/mVMOs@lists.linux.dev
X-Gm-Message-State: AOJu0YxRyxe1A/oNkh9osXKEGGMylex8xq5qikfzSVjDkgC8m87SARS8
	uxYJotvfV6aeA2exRaTp8EvhTv8VgcjSmyobyWwL8CucJx5eLMcU9NqMkMJr4R2Ad75ghw8B/Hh
	9nbaXu5ZldWUrM6f0iA==
X-Google-Smtp-Source: AGHT+IFFA8Am2fnybv9rvlh//I4Iw/BUP5vE4Qrvs/2x2IMy3Yp6BBWo4VkpWJV7hHHYkfYEkHZgL37ArvDw8k0=
X-Received: from wmbdr13.prod.google.com ([2002:a05:600c:608d:b0:46f:aa50:d6ff])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:548a:b0:471:ff3:7514 with SMTP id 5b1f17b1804b1-47117877736mr89174955e9.12.1760948235873;
 Mon, 20 Oct 2025 01:17:15 -0700 (PDT)
Date: Mon, 20 Oct 2025 08:17:15 +0000
In-Reply-To: <20251020020714.2511718-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251020020714.2511718-1-ojeda@kernel.org>
Message-ID: <aPXwCwc4uevRO951@google.com>
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, Oct 20, 2025 at 04:07:14AM +0200, Miguel Ojeda wrote:
> Between Rust 1.79 and 1.86, under `CONFIG_RUST_KERNEL_DOCTESTS=y`,
> `objtool` may report:
> 
>     rust/doctests_kernel_generated.o: warning: objtool:
>     rust_doctest_kernel_alloc_kbox_rs_13() falls through to next
>     function rust_doctest_kernel_alloc_kvec_rs_0()
> 
> (as well as in rust_doctest_kernel_alloc_kvec_rs_0) due to calls to the
> `noreturn` symbol:
> 
>     core::option::expect_failed
> 
> from code added in commits 779db37373a3 ("rust: alloc: kvec: implement
> AsPageIter for VVec") and 671618432f46 ("rust: alloc: kbox: implement
> AsPageIter for VBox").
> 
> Thus add the mangled one to the list so that `objtool` knows it is
> actually `noreturn`.
> 
> This can be reproduced as well in other versions by tweaking the code,
> such as the latest stable Rust (1.90.0).
> 
> Stable does not have code that triggers this, but it could have it in
> the future. Downstream forks could too. Thus tag it for backport.
> 
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later.
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
