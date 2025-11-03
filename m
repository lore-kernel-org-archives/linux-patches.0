Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814032FD7BC
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 10:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165651; cv=none; b=rJEYtf+Fa7cJkBSSYaMC/xPnTks2PLvi+7qJJpVoU26/SbWKuLeErPFi21707RoSpL6Wa+NeWp8eISdkKhH9319K8sGh4su0Jb4yJU9kz5/HVcBen8n7HMXfxhbJhKjGKBH7SEZNa2klYN8lGWQOBls14fMfVetW4CKoYBSsYso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165651; c=relaxed/simple;
	bh=7d+yejdsrlH3QQoIfQu3T9oGfryOAb9jPCpBbY/QV74=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kpzvR6E5P3Ay7gofa/0Iu51wJjRq9aJivBkOmSLD4YY8mg6fcysrcg0G7IsOZHyaM9ZZuq5gJudVo1vbmY8qWZC3xeIy1hsfMD2jCTm6Vwm6xlJ0+reu4foOFsaFP5Nk57MekX+TvRnTCRYvu0k1pW0BATAhO0ZBAj4rs18PwHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bpFX99SF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bpFX99SF"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4774836c376so6570205e9.2
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 02:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165647; x=1762770447; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4JHB89kHBneKoONN1Bve8Z56wcJWNGQNkd4dI7+uRh8=;
        b=bpFX99SFRBn9MUIWvd4I+kZOUoFM9XqN+7DNzMWSCTWPZ5WOBtG7dRlpJo/1zBKMKE
         yKcAGbx4YkEQSxziQ/QWR9PwX5zcLrvbWPR0HSMSMuEfUTeCRpPufb5rPWSDpWaGI0af
         970O7TyjjzmkRxJQF073b8Kb2EBQ12CMe6r62RJaaO4LjrLZy+Ax61FWfetdKhJGYh/v
         la796IRxuQi8V6vfFnxgShvCrGTxxEHguNEx5F6rR9Mkc1+5h6SV55dAE1eTfbTB1kv5
         p42R/13+XF+vrrzxczuuMZJ14NweyNsQs2y6OMH0A+svEMapbCedxwxjdKXU3xWMeZze
         yZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165647; x=1762770447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4JHB89kHBneKoONN1Bve8Z56wcJWNGQNkd4dI7+uRh8=;
        b=KPRxU7J/wdLUvu2VQ6AG+FLPjo+ZcQ3SSCVjM5UkdlqgOmY+PvLKmUfCPTT4GwNFFY
         Hof5asum7e5hldjmhVxruV97h+WIp3Sc3f8EkD73uoLMQoCTRF5e9bCGCFYeCrWz+56F
         zOGrbZKCobEZv6egsveBw9kIb297XrUkuSHk/gKV9ZDHgsbp7Xr/uS5vlFQSUejqlR8T
         nDB3zAquruUkSYprYGrrhjnn8FcaqZpMGhJuAE4GShdeHrmZDVDJ4MHO2G7V1yp/naj/
         ZZeaM33zASCtQ/vZnTzqPfA2mG945OacYeCSxL5Hqa1CyDndQcQlsLSuKY2WFHFL2Gbv
         mLbg==
X-Forwarded-Encrypted: i=1; AJvYcCUD5dTvFqdHNmBtEsi+sLOzBc/hgBomb+arjwTKsnLBdFGpnb0WuLk0UVjWFcbdKugd3fDiS8ta@lists.linux.dev
X-Gm-Message-State: AOJu0YzDMsxyTKLHQSjdx9JJfKtLCQlM0z+LR3W244vOzP6bwTpOHc5W
	R5zPloxlyUN+ITbnkcGukag6xvCwo5NBrbejxrSykmzds9U48Ue6WqaaR5h5wv3bmF9hTnJhvxe
	eFef9XJ4M9We2mp4gBg==
X-Google-Smtp-Source: AGHT+IEOG3seXsKMf1FLja+ssKrdPSGK1FgK6Bcd/d5/Kurpa+pvamoJuJNwVwnI8+e1f24CsMe+Xpt2EsZzMZQ=
X-Received: from wmlf12.prod.google.com ([2002:a7b:c8cc:0:b0:477:d21:4a92])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:538e:b0:46e:33b2:c8da with SMTP id 5b1f17b1804b1-47730890e99mr120076125e9.32.1762165647584;
 Mon, 03 Nov 2025 02:27:27 -0800 (PST)
Date: Mon, 3 Nov 2025 10:27:26 +0000
In-Reply-To: <20251102212853.1505384-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251102212853.1505384-1-ojeda@kernel.org>
Message-ID: <aQiDjuHK0qpgmj1J@google.com>
Subject: Re: [PATCH 1/2] rust: kbuild: treat `build_error` and `rustdoc` as
 kernel objects
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sun, Nov 02, 2025 at 10:28:52PM +0100, Miguel Ojeda wrote:
> Even if normally `build_error` isn't a kernel object, it should still
> be treated as such so that we pass the same flags. Similarly, `rustdoc`
> targets are never kernel objects, but we need to treat them as such.
> 
> Otherwise, starting with Rust 1.91.0 (released 2025-10-30), `rustc`
> will complain about missing sanitizer flags since `-Zsanitizer` is a
> target modifier too [1]:
> 
>     error: mixing `-Zsanitizer` will cause an ABI mismatch in crate `build_error`
>      --> rust/build_error.rs:3:1
>       |
>     3 | //! Build-time error.
>       | ^
>       |
>       = help: the `-Zsanitizer` flag modifies the ABI so Rust crates compiled with different values of this flag cannot be used together safely
>       = note: unset `-Zsanitizer` in this crate is incompatible with `-Zsanitizer=kernel-address` in dependency `core`
>       = help: set `-Zsanitizer=kernel-address` in this crate or unset `-Zsanitizer` in `core`
>       = help: if you are sure this will not cause problems, you may use `-Cunsafe-allow-abi-mismatch=sanitizer` to silence this error
> 
> Thus explicitly mark them as kernel objects.
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
> Link: https://github.com/rust-lang/rust/pull/138736 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
