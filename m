Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D5023AB8D
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 04:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760330916; cv=none; b=I78emwdW7nZRlPB2KnEKaAmVhNnxt6fgfu2wpIjhtQYErRJkIL4ZzVWYrlX7uK1eA5qJNse/Xeff882ZgBpIKOy0niE+s14hHJMtSKvMOUxrXrB1o/lipTn0BPf2AsgTBhvb0ZLIYSaYIaDNLGkFa+tuGhCeKSIHVhDusrEnPyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760330916; c=relaxed/simple;
	bh=w5flf0ZTD8FoZKNNJ44xzj8U9JvZaMG7ZVwuxSdM1qY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pHb4FS8G/GkENL04xJw8bEQyj/6f+H4OZ63zy18hYNWIbXEt0dqolCkjP0yTYpCR853+cl50d/fPQtwvKfEbwJxRulfKmxUwviBCPpwepyiE2oXIDfKwfyvGCm06+moBL7y27lYKfPLx34UOdTNcIb9NkQpLgY5HVSFeAbLmCA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HqD04XEK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HqD04XEK"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27ee41e0798so61567015ad.1
        for <patches@lists.linux.dev>; Sun, 12 Oct 2025 21:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760330914; x=1760935714; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+N1GbW5T01OcE9SjnTkQCqp4CEF9pzePEjEN9o9hnwo=;
        b=HqD04XEKxu5S0/thIGhB65bMWw03WhqqGfxoZagzkB6v2obn83arBvC1Ln1rjnkMBV
         WtMDhww7juQipNDb5zDImdpfuuvpk4i+GlvKbJbZOLeYDxtCD4uOYm4cI7RZofDnTlSQ
         JaULPsNEkozXlBHfK2AcNT5zA7f6VuXkx0fpm3PYwODUrVVbJZzLoMVDhsRLrF4zA71I
         JPqYTXHWNgb98m8m8GdRNxm8r7xyRB7naKblR5UI3NSbeFv0yIIDPB2TPlVsUqXnetu2
         /cqTc7VrowuPbPSqXLF+jAsFjvL9Z42IdFS1cl8idK/mmqkOzDJsdbPmlVBblnGD1/LZ
         anMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760330914; x=1760935714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+N1GbW5T01OcE9SjnTkQCqp4CEF9pzePEjEN9o9hnwo=;
        b=iSqTKXYzekI61QD+i93qcKUZfuoBs2IiYR2YuV4mLsSy7VOb4zcNGqML6eYeSFf9JW
         zdNK62AejqCS2tWdN9E3pjFLZ3PYcRupgnnZRmim8GYX15S7Gv7P0U3t8sivStpDtc5y
         ogMKJAXZj6YoVWYYtkkny8lFpqwb28fv1gr5ecp6zm/7byqPXgS5CxOdyzbOm6diD8hA
         ZEkx+iyAKK9NWju+1D6NRuz5sH4owb46sfPVtOH4rkpdrOSEAR7Zy5NSgnjbBkfNexMO
         uLmxF1lgjo9/lhz3Aujln0p94cC1V2+BZ/uBmMl8yuiijRRjlc3N37C9/A2z2k9j/lGy
         E9MQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoqorhcaVXZulOYH3phFkc/yRoi0O7QgAZ5mbJkCISfv+sjirrKvfNopViorW235lKydIjnYXG@lists.linux.dev
X-Gm-Message-State: AOJu0YyhXBJCFQpOH+9h4V3nFI3xQlhj+q04U33yz96ZzXjIYgTnd24L
	WgICv0GaE9EGtwgSk+Bz7IZlW018VvTU4GfP3h4dQUEVpFZLzAoNm0Bgpq10dqqK0EI=
X-Gm-Gg: ASbGnctOIRK5/kCOE29DZKVJ9PQlFZeRigZW64bM/7CjrL20lroFQwO8mgcvbb0URaU
	VFXYnpL7+ICsbaUU7ti2tld+a4rc5LrwwdPH1fEkiJDbcvsXaWgbdYAsf45o7YeSiTMbtYRNtCv
	8OhVnfOxKlXDQO4lU0/fxRxjN9rSA0sZX2HDGy3wDNNo4abUVM+j2uK0KRiwvHuxYFvm/rqvcir
	oRgiHiosrjk6NpapkjzuJPNeX8yFXDYnVev3iQ2n6hv1e+vMQSqke1sbtmnU5JTHANdFpgGXEnW
	W/5B87WiGN1WiZiPq2hrJpPbIfaoXA/OwiVfVm1Ogy7OTeXZw18myqa9B3aePx4NNQdjEqjOhac
	/dKIPiL8dY7mYPCihtHnStyvTsXpELUxKnuQu802zmcWXFWbVM5dGiQ8PLQ==
X-Google-Smtp-Source: AGHT+IEjf3zE4VC422TWXSW/Bnh5dRfTTAIjmK5mj1HsvRN7orBZtaN8hGr9+1lO1J8DEcWKyA4uXg==
X-Received: by 2002:a17:903:4b08:b0:27e:f005:7d0f with SMTP id d9443c01a7336-290273ffc50mr241023805ad.44.1760330913936;
        Sun, 12 Oct 2025 21:48:33 -0700 (PDT)
Received: from localhost ([122.172.87.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034cba155sm120234705ad.0.2025.10.12.21.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Oct 2025 21:48:33 -0700 (PDT)
Date: Mon, 13 Oct 2025 10:18:30 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Subject: Re: [PATCH 3/3] rust: cpufreq: fix formatting
Message-ID: <7equbjyprjv4s4sg46inaiggmmh4l2aatuoqfpgrj5dgvxgqy2@zo5vh7i5ywjj>
References: <20251010174351.948650-1-ojeda@kernel.org>
 <20251010174351.948650-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010174351.948650-4-ojeda@kernel.org>

On 10-10-25, 19:43, Miguel Ojeda wrote:
> We do our best to keep the repository `rustfmt`-clean, thus run the tool
> to fix the formatting issue.
> 
> Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formatting
> Link: https://rust-for-linux.com/contributing#submit-checklist-addendum
> Fixes: f97aef092e19 ("cpufreq: Make drivers using CPUFREQ_ETERNAL specify transition latency")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/cpufreq.rs | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
> index 21b5b9b8acc1..1a555fcb120a 100644
> --- a/rust/kernel/cpufreq.rs
> +++ b/rust/kernel/cpufreq.rs
> @@ -38,8 +38,7 @@
>  const CPUFREQ_NAME_LEN: usize = bindings::CPUFREQ_NAME_LEN as usize;
>  
>  /// Default transition latency value in nanoseconds.
> -pub const DEFAULT_TRANSITION_LATENCY_NS: u32 =
> -        bindings::CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
> +pub const DEFAULT_TRANSITION_LATENCY_NS: u32 = bindings::CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
>  
>  /// CPU frequency driver flags.
>  pub mod flags {

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
